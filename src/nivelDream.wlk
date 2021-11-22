import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*

object nivelDream inherits Nivel (siguienteNivel = nivel0){
	var property sonido = "hogar1.mp3"
	//var property image = "nivel0/map3.png"
	var property image = "nivel0/dream.png"
	const jugador1 = new Jugador(position = game.at(3, 1) ,resolucion="menorResolucion",nombreJugador = "jugador1")
	const listaCajas=[]
	const listaMeta =[]
	const listaSombras=[
		new CheckpointDeSombras(position=game.at(1,7),sombraDeReferencia=sombraHab1Dream),
		new CheckpointDeSombras(position=game.at(1,5),sombraDeReferencia=pasadizo1Dream),
		
		new CheckpointDeSombras(position=game.at(9,5),sombraDeReferencia=sombraHab2Dream),
		new CheckpointDeSombras(position=game.at(9,3),sombraDeReferencia=pasadizo2Dream),
		
		new CheckpointDeSombras(position=game.at(22,7),sombraDeReferencia=sombraHab3Dream),
		new CheckpointDeSombras(position=game.at(22,5),sombraDeReferencia=pasadizo3Dream),
		
		new CheckpointDeSombras(position=game.at(6,2),sombraDeReferencia=sombra1),
		new CheckpointDeSombras(position=game.at(12,2),sombraDeReferencia=sombra2),
		new CheckpointDeSombras(position=game.at(18,2 ),sombraDeReferencia=sombra3)
	]
	
	const listaDeNivelesCompletados=[]
	
	var property posicionInitial = game.at(3,1)
		method cargarNivel(){		
		
		configuraciones.configMusic(self.sonido())
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
		
		/*
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
		* 
		*/
	}
	
	method position()=game.at(0,0)


}
