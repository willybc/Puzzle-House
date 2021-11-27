import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*
import ghost.*
import nivelB2.*

object nivelDream inherits Nivel (siguienteNivel = nivel0){
	var property sonido = "dreams.mp3"
	//var property image = "nivel0/map3.png"
	var property image = "nivel0/dream.png"
	const jugador1 = new Jugador(position = game.at(13, 11) ,resolucion="menorResolucion",nombreJugador = "chara")
	const listaCajas=[]
	const listaMeta =[]
	const listaSombras=[
		new CheckpointDeSombras(position=game.at(1,7),sombraDeReferencia=sombraHab1Dream),
		new CheckpointDeSombras(position=game.at(1,5),sombraDeReferencia=pasadizo1Dream),
		
		new CheckpointDeSombras(position=game.at(5,2),sombraDeReferencia=sombraHab2Dream),
		//new CheckpointDeSombras(position=game.at(9,3),sombraDeReferencia=pasadizo2Dream),
		
		new CheckpointDeSombras(position=game.at(22,7),sombraDeReferencia=sombraHab3Dream),
		new CheckpointDeSombras(position=game.at(22,5),sombraDeReferencia=pasadizo3Dream),
		
		new CheckpointDeSombras(position=game.at(9,6),sombraDeReferencia=sombra1),
		new CheckpointDeSombras(position=game.at(12,2),sombraDeReferencia=sombra2),
		new CheckpointDeSombras(position=game.at(18,2 ),sombraDeReferencia=sombra3)
	]
	
	const listaDeNivelesCompletados=[]
	
	var property posicionInitial = game.at(13,11)
		method cargarNivel(){		
		
		//configuraciones.configMusic(self.sonido())
		game.addVisual(self)
		
		//Bonus
		const bonus = new CheckpointBonus( nivelBase = self, bonus=pasadizoDream)
		game.addVisual(bonus)
		
		self.generarMuros()
		
		//Esposo
		jugador1.position(posicionInitial)
		game.addVisual(jugador1)
		self.configNivel(jugador1)
		
		//Ghost level 1
		const ghost1 = new Ghost(position = game.at(18, 11) ,resolucion="menorResolucion", nombreJugador = "ghost1", siguienteNivel=nivelG1)
		game.addVisual(ghost1)
		
		//Ghost level 2
		const ghost2 = new Ghost(position = game.at(5, 10) ,resolucion="menorResolucion", nombreJugador = "ghost2", siguienteNivel=nivelG2, ms1='Querés un verdadero reto?', ms2='Estas seguro?', ms3='Bueno, bueno, tu lo decidiste.')
		game.addVisual(ghost2)
		
		//Despertar
		nivel0.posicionInitial(game.at(15,10))
		game.addVisual(new Checkpoint(position = game.at(14,11), image = "menorResolucion/invisible.png", siguienteNivel = nivel0))
		
			
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
	method nivelBonusHabilitado() =self.listaDeNivelesCompletados().asSet().size()==2
	
	override method listaCajas() = listaCajas

    method listaMeta()= listaMeta
	
	method generarMuros(){
		
		const muroInvisible = "menorResolucion/invisible.png"
		
		self.bordearHorizontalmente(20,22,3,muroInvisible)
		self.bordearHorizontalmente(20,22,2,muroInvisible)
		
		self.bordearHorizontalmente(0,5,0,muroInvisible)
		self.bordearHorizontalmente(2,5,5,muroInvisible)
		self.bordearHorizontalmente(6,12,1,muroInvisible)
		self.bordearHorizontalmente(6,8,3,muroInvisible)
		self.bordearHorizontalmente(10,12,3,muroInvisible)
		self.bordearHorizontalmente(13,17,5,muroInvisible)
		self.bordearHorizontalmente(13,17,0,muroInvisible)
		self.bordearHorizontalmente(19,23,0,muroInvisible)
		self.bordearHorizontalmente(19,21,5,muroInvisible)
		self.bordearHorizontalmente(23,23,5,muroInvisible)
		self.bordearHorizontalmente(2,5,7,muroInvisible)
		self.bordearHorizontalmente(1,5,11,muroInvisible)
		self.bordearHorizontalmente(11,14,7,muroInvisible)
		self.bordearHorizontalmente(17,20,7,muroInvisible)
		self.bordearHorizontalmente(17,22,12,muroInvisible)
		self.bordearHorizontalmente(9,14,12,muroInvisible)
		self.bordearHorizontalmente(14,16,3,muroInvisible)
		self.bordearHorizontalmente(14,15,4,muroInvisible)
		
		self.bordearVerticalmente(1,11,0,muroInvisible)
		self.bordearVerticalmente(6,6,2,muroInvisible)
		self.bordearVerticalmente(4,4,6,muroInvisible)
		self.bordearVerticalmente(6,11,6,muroInvisible)
		self.bordearVerticalmente(4,4,12,muroInvisible)
		self.bordearVerticalmente(1,1,18,muroInvisible)
		self.bordearVerticalmente(3,4,18,muroInvisible)
		self.bordearVerticalmente(1,4,24,muroInvisible)
		self.bordearVerticalmente(6,7,21,muroInvisible)
		self.bordearVerticalmente(6,11,23,muroInvisible)
		self.bordearVerticalmente(8,11,16,muroInvisible)
		self.bordearVerticalmente(4,11,8,muroInvisible)
		self.bordearVerticalmente(4,7,10,muroInvisible)
		self.bordearVerticalmente(8,11,15,muroInvisible)
	}
	
	method position()=game.at(0,0)
}


object nivelG1 inherits Nivel (siguienteNivel = nivelDream){
	
	const jugador1 = new Jugador(position = game.at(19, 0) , resolucion="menorResolucion",nombreJugador = "chara")
	const meta1 = "menorResolucion/meta1.png"
	const meta2 = "menorResolucion/meta2.png"
	const resolucionCaja = "menorResolucion"
	const caja1 = "caja1.png"
	const caja2 = "caja2.png"
	const cajaMeta1 = "caja_ok.png"
	const cajaMeta2 = "caja_ok2.png"

	const listaMeta =[   new Meta(position = game.at(5,2), image= meta1, tipo=1)
	]
	
	const listaCajas=[  new Caja(position = game.at(6,2),resolucion=resolucionCaja,stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1)
	]

	method cargarNivel(){
		
		configuraciones.configMusic("nivelW-D.mp3")
		game.addVisual(self)
		self.cargarObjetos(listaMeta)
		self.cargarObjetos(listaCajas)
		self.generarMuros()
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)	
		self.configNivel(jugador1)
		nivelDream.posicionInitial(game.at(19,10))
		nivelDream.agregarNivelCompletado(self)
	}
	
	method generarMuros(){
		const muro2 = "menorResolucion/muro2.png"
		
		/* Bordes */
		self.bordearHorizontalmente(4,17,1,muro2)
		self.bordearHorizontalmente(4,20,11,muro2)
		self.bordearVerticalmente(2,4,4,muro2)
		self.bordearVerticalmente(7,10,4,muro2)
		self.bordearVerticalmente(0,4,20,muro2)
		self.bordearVerticalmente(7,10,20,muro2)
		self.bordearVerticalmente(0,0,17,muro2)
	
		self.bordearHorizontalmente(5,11,4,muro2)
		self.bordearHorizontalmente(13,19,4,muro2)
		self.bordearVerticalmente(5,6,5,muro2)
		self.bordearVerticalmente(5,6,11,muro2)
		self.bordearVerticalmente(5,6,13,muro2)
		self.bordearVerticalmente(5,6,19,muro2)
		self.bordearHorizontalmente(9,10,6,muro2)
		self.bordearHorizontalmente(14,15,6,muro2)
		self.bordearHorizontalmente(5,6,7,muro2)
		self.bordearHorizontalmente(18,19,7,muro2)
		self.bordearVerticalmente(8,10,8,muro2)
		self.bordearVerticalmente(8,10,16,muro2)
		
		self.bordearHorizontalmente(12,12,10,muro2)
		self.bordearHorizontalmente(10,10,9,muro2)
		self.bordearHorizontalmente(14,14,9,muro2)
		
		self.bordearHorizontalmente(18,19,-1,muro2)
	}
	
	method image() = "menorResolucion/mapG1.png"
	method position()=game.at(0,0)
	
	override method listaCajas() = listaCajas
	
 	method listaMeta()= listaMeta
}

object nivelG2 inherits Nivel (siguienteNivel = nivelDream){
	
	const jugador1 = new Jugador(position = game.at(19, 0) , resolucion="menorResolucion",nombreJugador = "chara")
	const meta1 = "menorResolucion/meta1.png"
	const meta2 = "menorResolucion/meta2.png"
	const resolucionCaja = "menorResolucion"
	const caja1 = "caja1.png"
	const caja2 = "caja2.png"
	const cajaMeta1 = "caja_ok.png"
	const cajaMeta2 = "caja_ok2.png"

	const listaMeta =[   new Meta(position = game.at(5,2), image= meta1, tipo=1)
	]
	
	const listaCajas=[  new Caja(position = game.at(6,2),resolucion=resolucionCaja,stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1)
	]

	method cargarNivel(){
		
		configuraciones.configMusic("nivelW-D.mp3")
		game.addVisual(self)
		self.cargarObjetos(listaMeta)
		self.cargarObjetos(listaCajas)
		self.generarMuros()
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)	
		self.configNivel(jugador1)
		nivelDream.posicionInitial(game.at(4,10))
		nivelDream.agregarNivelCompletado(self)
	}
	
	method generarMuros(){
		const muro2 = "menorResolucion/muro2.png"
		
		/* Bordes */
		self.bordearHorizontalmente(4,17,1,muro2)
		self.bordearHorizontalmente(4,20,11,muro2)
		self.bordearVerticalmente(2,4,4,muro2)
		self.bordearVerticalmente(7,10,4,muro2)
		self.bordearVerticalmente(0,4,20,muro2)
		self.bordearVerticalmente(7,10,20,muro2)
		self.bordearVerticalmente(0,0,17,muro2)
	
		self.bordearHorizontalmente(5,11,4,muro2)
		self.bordearHorizontalmente(13,19,4,muro2)
		self.bordearVerticalmente(5,6,5,muro2)
		self.bordearVerticalmente(5,6,11,muro2)
		self.bordearVerticalmente(5,6,13,muro2)
		self.bordearVerticalmente(5,6,19,muro2)
		self.bordearHorizontalmente(9,10,6,muro2)
		self.bordearHorizontalmente(14,15,6,muro2)
		self.bordearHorizontalmente(5,6,7,muro2)
		self.bordearHorizontalmente(18,19,7,muro2)
		self.bordearVerticalmente(8,10,8,muro2)
		self.bordearVerticalmente(8,10,16,muro2)
		
		self.bordearHorizontalmente(12,12,10,muro2)
		self.bordearHorizontalmente(10,10,9,muro2)
		self.bordearHorizontalmente(14,14,9,muro2)
		
		self.bordearHorizontalmente(18,19,-1,muro2)
	}
	
	//method image() = "menorResolucion/mapG2.png"
	method image() = "menorResolucion/mapW.png"
	method position()=game.at(0,0)
	
	override method listaCajas() = listaCajas
	
 	method listaMeta()= listaMeta
}
