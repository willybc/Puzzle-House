import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*
import nivelDream.*

object pasadizoDream inherits Nivel(siguienteNivel = nivelDream, duplicador = 2){
	
	var property vestimenta = "chara3"

	method cargarNivel(){
		const jugador1 = new Jugador(position = game.at(2, 3) ,resolucion="mayorResolucion",nombreJugador = "chara3")
		//configuraciones.configMusic("pasadizo.mp3")
		game.addVisual(self)
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)
		self.configNivel(jugador1)
		game.addVisual(new CambiarRopa(position=game.at(6,5),vestimenta="chara2") )
		game.addVisual(new CambiarRopa(position=game.at(16,5),vestimenta="chara3") )
		game.addVisual(new Checkpoint(position = game.at(24,3), image = "mayorResolucion/invisible.png", siguienteNivel = nivel_bonus))
		
		self.generarMuros()	
		
	}
	
	override method listaCajas() = []
	
	method generarMuros(){
		
		const muroInvisible = "menorResolucion/invisible.png"
		
		self.bordearHorizontalmente(-2,0,3,muroInvisible)
		
		
		self.bordearHorizontalmente(0,4,5,muroInvisible)
		self.bordearHorizontalmente(8,14,5,muroInvisible)
		self.bordearHorizontalmente(18,24,5,muroInvisible)
		self.bordearHorizontalmente(0,22,1,muroInvisible)
	}
	
	method image() = "nivelBonus/pasadizoDream.png"
	method position()=game.at(0,0)


	
}

object nivel_bonus inherits Nivel (siguienteNivel = nivel0){
	
	//const jugador1 = new Jugador(position = game.at(15, 3) , resolucion="menorResolucion",nombreJugador = pasadizoDream.vestimenta())
	const jugador1 = new Jugador(position = game.at(0, 4) ,resolucion="menorResolucion",nombreJugador = "chara3")
	
	const meta1 = "menorResolucion/vagoneta1.png"
	const meta2 = "menorResolucion/vagoneta2.png"
	
	const caja1 = "diamante.png"
	const caja2 = "rubi.png"
	
	const cajaMeta1 = "vagoneta_ok1.png"
	const cajaMeta2 = "vagoneta_ok2.png"
	
	const resolucionCaja = "menorResolucion"

	//const sonidoOveja="oveja1a.mp3"
	//const sonidoOveja2="oveja2a.mp3"
	

	const listaMeta =[   new Meta(position = game.at(19,8), image= meta1),
						 new Meta(position = game.at(19,2), image= meta2,tipo=2)		
					]
					
	const listaCajas=[	new Caja(position = game.at(14,8),resolucion=resolucionCaja,stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1),
						new Caja(position = game.at(14,2),resolucion=resolucionCaja,stringDeObjeto=caja2,cajaEnMeta=cajaMeta2,tipo=2)
					]

	method cargarNivel(){
		
		//configuraciones.configMusic("nivelBonusb.mp3")
		game.addVisual(self)
		self.cargarObjetos(listaMeta)
		//self.cargarObjetos(listaCajas)
		self.generarMuros()
		self.cargarObjetos(listaCajas)
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)	
		self.configNivel(jugador1)
		nivel0.posicionInitial(game.at(17,4))
		nivel0.image("nivel0/map2.png")
		nivel0.sonido("fin.mp3")
	}
	
	method generarMuros(){
		const vallaH = "menorResolucion/paredH1.png"
		const vallaV = "menorResolucion/paredV1.png"
		const arbusto = "menorResolucion/arbusto2.png"
		const muroInvisible = "menorResolucion/invisible.png"
		

		
		/* Vallas Horizontales 
		self.bordearHorizontalmente(7,20,1,vallaH)
		self.bordearHorizontalmente(7,20,11,vallaH)
		*/
		
		/* Vallas Verticales 
		self.bordearVerticalmente(2,10,21,vallaV)
		self.bordearVerticalmente(4,10,6,vallaV)
		self.bordearVerticalmente(2,2,6,vallaV)
		*/

		
		/* Muros invisibles 
		self.bordearVerticalmente(1,2,16,muroInvisible)
		self.bordearVerticalmente(7,7,14,muroInvisible)
		self.bordearVerticalmente(5,5,15,muroInvisible)
		self.bordearVerticalmente(6,6,9,muroInvisible)
		self.bordearVerticalmente(8,8,9,muroInvisible)
		*/
		
	}
	
	method image() = "nivelBonus/map_dream.png"
	method position()=game.at(0,0)
	
	override method listaCajas() = listaCajas

 	method listaMeta()= listaMeta
	
}