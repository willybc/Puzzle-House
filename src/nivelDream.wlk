import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*

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
		
		//  configuraciones.configMusic(self.sonido())
		game.addVisual(self)
		
		game.addVisual(checkpointBonus)
		self.generarMuros()
		
		//Esposo
		jugador1.position(posicionInitial)
		game.addVisual(jugador1)
		self.configNivel(jugador1)
		
		//game.addVisual(new Checkpoint(position = game.at(7,11), image = "menorResolucion/invisible.png", siguienteNivel = nivelW))
		//game.addVisual(new Checkpoint(position = game.at(10,11), image = "menorResolucion/invisible.png", siguienteNivel = nivelBel))		
		//game.addVisual(new Checkpoint(position = game.at(23,4), image = "menorResolucion/invisible.png", siguienteNivel = nivelL))	
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
