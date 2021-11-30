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
		configuraciones.configMusic("pasadizo.mp3")
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
	const jugador1 = new Jugador(position = game.at(0, 3) ,resolucion="menorResolucion",nombreJugador = "chara3")
	
	const meta1 = "menorResolucion/meta_bonus11.png"
	const meta2 = "menorResolucion/meta_bonus22.png"
	const meta3 = "menorResolucion/meta_bonus33.png"
	const meta4 = "menorResolucion/meta_bonus44.png"
	const resolucionCaja = "menorResolucion"
	const caja1 = "oveja"
	const caja2 = "oveja2"
	const caballo2="caballo2"
	const caballo1="caballo"
	const sonidoOveja="oveja1a.mp3"
	const sonidoOveja2="oveja2a.mp3"
	

	const listaMeta =[   new Meta(position = game.at(11,3), image= meta1)/*  ,
						 new Meta(position = game.at(10,1),image= meta2,tipo=2),
						 new Meta(position = game.at(7,2), image= meta2,tipo=2),
						 new Meta(position = game.at(7,3), image= meta1),
						 new Meta(position = game.at(7,4), image= meta1),
						 new Meta(position = game.at(7,5), image= meta2,tipo=2),
						 new Meta(position = game.at(8,3), image= meta1),
						 new Meta(position = game.at(8,4), image= meta1),
						 new Meta(position = game.at(8,5), image= meta1),
						
						 new Meta(position = game.at(17,3), image= meta4,tipo=4),	
						  new Meta(position = game.at(17,2), image= meta3,tipo=3)	*/			
		
	]
	const listaCajas=[   
		
		
						 new Oveja(position = game.at(13,3),resolucion=resolucionCaja,stringDeObjeto=caja1,tipo=1,sonido=sonidoOveja,ultimaDireccion=arriba)/* ,
						 new Oveja(position = game.at(12,9),resolucion=resolucionCaja,stringDeObjeto=caja1,tipo=1,sonido=sonidoOveja,ultimaDireccion=abajo),
						 new Oveja(position = game.at(10,5),resolucion=resolucionCaja,stringDeObjeto=caja1,tipo=1,sonido=sonidoOveja,ultimaDireccion=izquierda),
						 new Oveja(position = game.at(11,2),resolucion=resolucionCaja,stringDeObjeto=caja1,tipo=1,sonido=sonidoOveja,ultimaDireccion=derecha),
						 new Oveja(position = game.at(13,6),resolucion=resolucionCaja,stringDeObjeto=caja1,tipo=1,sonido=sonidoOveja,ultimaDireccion=derecha),
						 new Oveja(position = game.at(11,7),resolucion=resolucionCaja,stringDeObjeto=caja1,tipo=1,sonido=sonidoOveja,ultimaDireccion=izquierda),
					
						 new Oveja(position = game.at(13,9),resolucion=resolucionCaja,stringDeObjeto=caja2,tipo=2,sonido=sonidoOveja2,ultimaDireccion=abajo),
						 new Oveja(position = game.at(9,9),resolucion=resolucionCaja,stringDeObjeto=caja2,tipo=2,sonido=sonidoOveja2,ultimaDireccion=derecha),
						
						 new Caballo(position = game.at(8,4),resolucion=resolucionCaja,stringDeObjeto=caballo1,tipo=4,sonido="caballo1.mp3",ultimaDireccion=abajo),
					   
						 new Caballo(position = game.at(11,9),resolucion=resolucionCaja,stringDeObjeto=caballo2,tipo=3,sonido="caballo2.mp3",ultimaDireccion=arriba),
						 new Oveja(position = game.at(13,1),resolucion=resolucionCaja,stringDeObjeto=caja2,tipo=2,sonido=sonidoOveja2,ultimaDireccion=arriba)*/	    
	]

	method cargarNivel(){
		
		configuraciones.configMusic("nivelBonusb.mp3")
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
		

		
		/* Vallas Horizontales */
		self.bordearHorizontalmente(7,20,1,vallaH)
		self.bordearHorizontalmente(7,20,11,vallaH)
		
		/* Vallas Verticales */
		self.bordearVerticalmente(2,10,21,vallaV)
		self.bordearVerticalmente(4,10,6,vallaV)
		self.bordearVerticalmente(2,2,6,vallaV)

		
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