import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import nivel1.*
import nivelB.*
import nivelW.*
import nivelBel.*
import nivelL.*
import creativo.*

class Nivel {
	
	var property siguienteNivel
	
	const duplicador=1
	method listaCajas()
	
	method cargarObjetos(objeto) = objeto.forEach{ unObjeto => game.addVisual(unObjeto)}
	
	method dibujarMuros(objeto) = game.addVisual(objeto)

	method bordearVerticalmente(yInicial,yFinal,xCoordenada,stringObjeto){
		const lista=[]
		new Range(start = yInicial, end =yFinal , step = duplicador).forEach({ n => lista.add( new Position( x=xCoordenada, y=n))})
		lista.forEach { p => self.dibujarMuros(new MuroVisible(position = p, image=stringObjeto))}
	}
	
	method bordearHorizontalmente(xInicial,xFinal,yCordenada,stringObjeto){
		const lista=[]
		new Range(start = xInicial, end =xFinal , step = duplicador).forEach({ n => lista.add( new Position( x=n, y=yCordenada))}) 	
		lista.forEach { p => self.dibujarMuros(new MuroVisible(position = p, image=stringObjeto))}	
	}

	method verificarMetas() {
		const verificador = self.listaCajas().all({ unaCaja => unaCaja.llegoMeta() })
		if (verificador) {
			sonidoObjeto.emitirSonido("victoriaFem.mp3") // es temporal
			game.say(configuraciones.elJugador(), "ganaste!")
			configuraciones.configStopMusic()
			game.schedule(1200,{self.cambiarNivel()})
		}
	}
	
	method cambiarNivel(){
		self.reiniciarNivel()
		game.clear()
		siguienteNivel.cargarNivel()
	}
	
	method reiniciarNivel(){
		configuraciones.nivelActual().listaCajas().forEach{ objeto => objeto.posicioninicial()}
		configuraciones.elJugador().posicioninicial()	
	}
	
	
	method configNivel(personaje){
		duplicaDireccion.direccionDuplicador(duplicador)
		configuraciones.configTeclas(personaje)
		configuraciones.configColisiones(personaje)
	}
	
	method soyUnNivelCreativo()=false
}

object menu inherits Nivel(siguienteNivel = nivel1, duplicador = 2){
	
	const jugador1 = new Jugador(position = game.at(11, 5) ,resolucion="mayorResolucion",nombreJugador = "jugador1")
	
	method cargarNivel(){
		
		configuraciones.configMusic("menu.mp3")
		game.addVisual(self)
		game.addVisual(new Checkpoint(position = game.at(9,1), image = "mayorResolucion/invisible.png", siguienteNivel = nivel1))
		game.addVisual(new Checkpoint(position = game.at(11,1), image = "mayorResolucion/invisible.png", siguienteNivel = nivel1))
		game.addVisual(new Checkpoint(position = game.at(13,1), image = "mayorResolucion/invisible.png", siguienteNivel = nivel1))
		
		game.addVisual(new CheckpointSalir(position = game.at(17,5), image = "mayorResolucion/invisible.png", siguienteNivel = nivel0))
		game.addVisual(new CheckpointSalir(position = game.at(19,5), image = "mayorResolucion/invisible.png", siguienteNivel = nivel0))
		
		/*
		game.addVisual(new CheckpointSalir(position = game.at(3,5), image = "mayorResolucion/invisible.png", siguienteNivel = nivelCreativo))
		game.addVisual(new CheckpointSalir(position = game.at(5,5), image = "mayorResolucion/invisible.png", siguienteNivel = nivelCreativo))
		Al ingresar al mapa creativo desde menu se cierra
		*/
		
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)
		self.configNivel(jugador1)
		self.generarMuros()
	}
	
	method generarMuros(){
		
		const muroInvisible = "menorResolucion/invisible.png"
		
		self.bordearHorizontalmente(-1,25,-1,muroInvisible)
		self.bordearHorizontalmente(-1,25,11,muroInvisible)
		self.bordearVerticalmente(-1,11,-1,muroInvisible)
		self.bordearVerticalmente(-1,11,25,muroInvisible)
	}
	
	override method listaCajas() = []
	
	method image() = "oscuro.png"
	method position()= game.at(0,0)
}

object nivel0 inherits Nivel (siguienteNivel = pasadizo){
	var property sonido = "hogar1.mp3"
	var property image = "nivel0/map3.png"
	const jugador1 = new Jugador(position = game.at(3, 1) ,resolucion="menorResolucion",nombreJugador = "jugador1")
	const listaCajas=[]
	const listaMeta =[]
	const listaSombras=[
		new CheckpointDeSombras(position=game.at(7,5),sombraDeReferencia=sombraHab1),
		new CheckpointDeSombras(position=game.at(10,5),sombraDeReferencia=sombraHab2),
		new CheckpointDeSombras(position=game.at(7,3),sombraDeReferencia=pasadizo2),
		new CheckpointDeSombras(position=game.at(10,3),sombraDeReferencia=pasadizo4),

		new CheckpointDeSombras(position=game.at(6,2),sombraDeReferencia=sombra1),
		new CheckpointDeSombras(position=game.at(12,2),sombraDeReferencia=sombra2),
		new CheckpointDeSombras(position=game.at(18,2 ),sombraDeReferencia=sombra3)
	]
	
	const listaDeNivelesCompletados=[]
	
	var property posicionInitial = game.at(3,1)
		method cargarNivel(){		
		
		configuraciones.configMusic(self.sonido())
		game.addVisual(self)
		
		//Habitación hijo
		const hijo = new Jugador(position = game.at(7, 11) ,resolucion="menorResolucion" ,nombreJugador = "hijo")
		game.addVisual(hijo)
		
		
		//Habitación hija
		const hija = new Jugador(position = game.at(10, 11) ,resolucion="menorResolucion", nombreJugador = "hija")
		game.addVisual(hija)
		
		
		//Esposa
		const jugadora1 = new Jugador(position = game.at(23, 4) ,resolucion="menorResolucion", nombreJugador = "jugadora1")
		game.addVisual(jugadora1)	
		
		//Bonus
		const bonus = new CheckpointBonus( nivelBase = self, bonus=pasadizo)
		game.addVisual(bonus)
		
		self.generarMuros()
		
		//Esposo
		jugador1.position(posicionInitial)
		game.addVisual(jugador1)
		self.configNivel(jugador1)
		
		game.addVisual(new Checkpoint(position = game.at(7,11), image = "menorResolucion/invisible.png", siguienteNivel = nivelW))
		game.addVisual(new Checkpoint(position = game.at(10,11), image = "menorResolucion/invisible.png", siguienteNivel = nivelBel))		
		game.addVisual(new Checkpoint(position = game.at(23,4), image = "menorResolucion/invisible.png", siguienteNivel = nivelL))	
		self.cargarObjetos(listaSombras)
		self.listaSombrasNoAtravesadas().forEach({unaSombra=>unaSombra.agregarSombra()})
	
	}	
		override method configNivel(personaje1){
		duplicaDireccion.direccionDuplicador(duplicador)
		configuraciones.configTeclas(personaje1)
		configuraciones.configColisiones(personaje1)
		configuraciones.nivelActual(self)

	}
	
	method listaSombras()=listaSombras
	method listaSombrasNoAtravesadas()=self.listaSombras().filter({unaSombra=>!unaSombra.seAtraveso()})
	method agregarNivelCompletado(unNivel){
		listaDeNivelesCompletados.add(unNivel)
	}
	method listaDeNivelesCompletados()=listaDeNivelesCompletados
	method nivelBonusHabilitado() =self.listaDeNivelesCompletados().asSet().size()==3
	
	override method listaCajas() = listaCajas

    method listaMeta()= listaMeta
	
	method generarMuros(){
		
		const muroInvisible = "menorResolucion/invisible.png"
		
		self.bordearHorizontalmente(0,2,0,muroInvisible)
		self.bordearHorizontalmente(4,5,0,muroInvisible)
		self.bordearHorizontalmente(3,3,-1,muroInvisible)
		self.bordearHorizontalmente(13,17,0,muroInvisible)
		self.bordearVerticalmente(0,1,18,muroInvisible)
		self.bordearHorizontalmente(19,24,0,muroInvisible)
		self.bordearVerticalmente(1,5,24,muroInvisible)
		self.bordearVerticalmente(3,4,18,muroInvisible)
		self.bordearHorizontalmente(12,23,5,muroInvisible)
		self.bordearHorizontalmente(14,16,3,muroInvisible)
		self.bordearHorizontalmente(14,15,4,muroInvisible)
		self.bordearHorizontalmente(6,12,1,muroInvisible)
		self.bordearVerticalmente(3,4,12,muroInvisible)
		self.bordearVerticalmente(3,7,11,muroInvisible)
		self.bordearVerticalmente(3,11,9,muroInvisible)
		self.bordearVerticalmente(3,11,8,muroInvisible)
		self.bordearVerticalmente(3,7,6,muroInvisible)
		self.bordearHorizontalmente(0,16,12,muroInvisible)
		self.bordearHorizontalmente(0,5,7,muroInvisible)
		self.bordearHorizontalmente(12,17,7,muroInvisible)
		self.bordearVerticalmente(8,11,17,muroInvisible)
		self.bordearVerticalmente(8,11,0,muroInvisible)
		self.bordearVerticalmente(1,5,0,muroInvisible)
		self.bordearHorizontalmente(1,5,5,muroInvisible)
		self.bordearVerticalmente(1,2,23,muroInvisible)
		self.bordearHorizontalmente(16,16,11,muroInvisible)
		self.bordearVerticalmente(8,9,16,muroInvisible)
		self.bordearVerticalmente(8,9,1,muroInvisible)
		self.bordearHorizontalmente(1,1,11,muroInvisible)
	}
	
	method position()=game.at(0,0)


}
 