import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*

object nivelTest inherits Nivel (siguienteNivel = nivel0,soyUnNivelCronometro=true){
	const unContadorDePasos = new ContadorDePasos(position=game.at(11,11))
	const unContadorDeEmpujes = new ContadorDePasos(texto="Pudshes : ",position=game.at(14,11))
	const jugador1 = new Jugador(position = game.at(9,6 ) , resolucion="menorResolucion",nombreJugador = "jugador1")
	const meta1 = "menorResolucion/meta1.png"
	const unCronometro=new Cronometro()


	





	const resolucionCaja = "menorResolucion"
	const caja1 = "caja1.png"
	
	const cajaMeta1 = "caja_ok.png"
	
	const listaMeta =[ 
						 
						 new Meta(position = game.at(10,6),image= meta1)  ,
						 new Meta(position = game.at(11,6),image= meta1)  ,
						 new Meta(position = game.at(12,6),image= meta1)  ,
						 new Meta(position = game.at(13,6),image= meta1)  
					
	]
	const listaCajas=[  
						 new Caja(position = game.at(13,5),resolucion=resolucionCaja,stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1), 
						 new Caja(position = game.at(14,5),resolucion=resolucionCaja,stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1) ,
						 new Caja(position = game.at(15,5),resolucion=resolucionCaja,stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1),
						 new Caja(position = game.at(16,5),resolucion=resolucionCaja,stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1) 
	
	]
	
	
	override method reiniciarNivel(){
		configuraciones.nivelActual().listaCajas().forEach{ objeto => objeto.posicioninicial()}
		configuraciones.nivelActual().listaCajas().forEach{ objeto => objeto.estoyEnMeta(false)}
		configuraciones.elJugador().posicioninicial()
		if(self.soyUnNivelPuzzle()){
			configuraciones.elcontadorDePasos().reset()
			configuraciones.contadorDeEmpujes().reset()
		}
		if(self.soyUnNivelCronometro()){
			configuraciones.nivelActual().listaCajas().forEach{ objeto => objeto.yaEstubeEnMeta(false)}
			unCronometro.reset()
		}
		
		
	}
		
	
	
	
	override method verificarMetas() {
		const verificador = self.listaCajas().all({ unaCaja => unaCaja.estoyEnMeta() })
		if (verificador) {
			sonidoObjeto.emitirSonido("victoriaFem.mp3") // es temporal
			unCronometro.desactivarCronometro()
			game.say(configuraciones.elJugador(),"LO LOGRASTE!")
		}
	}



	method cargarNivel(){
		configuraciones.configMusic("NivelBelCronometro.mp3")
		unContadorDePasos.reset()
		
		
		configuraciones.elcontadorDePasos(unContadorDePasos)
		configuraciones.contadorDeEmpujes(unContadorDeEmpujes)
		game.addVisual(self)
		game.addVisual(unContadorDePasos)
		game.addVisual(unContadorDeEmpujes)
		self.cargarObjetos(listaMeta)
		self.cargarObjetos(listaCajas)
		
		unCronometro.activarCronometro()
		self.generarMuros()
		
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)	
		self.configNivel(jugador1)
		nivel0.posicionInitial(game.at(21,3))
		nivel0.agregarNivelCompletado(self)
		game.addVisual(unCronometro)
	}
	
	method generarMuros(){
		const muro = "menorResolucion/muro2.png"
		self.bordearHorizontalmente(0,24,0,muro)
		self.bordearHorizontalmente(1,24,12,muro)
		
		self.bordearVerticalmente(1,12,0,muro)
		self.bordearVerticalmente(1,12,24,muro)
		

				
	}
	
	method image() = "oscuro1.png"
	
	
	override method listaCajas() = listaCajas

 	method listaMeta()= listaMeta
 	
 	method cronometro()=unCronometro

}
class NivelBel2 inherits Nivel(siguienteNivel = nivel0,soyUnNivelHardcoreTime=true){
	const unContadorDePasos = new ContadorDePasos(position=game.at(1,6))
	const unContadorDeEmpujes = new ContadorDePasos(texto="Pushes : ",position=game.at(1,5))
	const jugador1 = new Jugador(position = game.at(17,10) , resolucion="menorResolucion",nombreJugador = "jugadora2")
	const meta1 = "menorResolucion/meta1.png"
	const meta2=  "menorResolucion/meta2.png"
	const resolucionCaja = "menorResolucion"
	const unCronometro=new Cronometro()
	const listaMeta =[   new Meta(position = game.at(17,2), image= meta1) ,
						 new Meta(position = game.at(7,1), image= meta2,tipo=2),
						 new Meta(position = game.at(7,10), image= meta2,tipo=2),
						 new Meta(position = game.at(15,1), image= meta2,tipo=2),
						 new Meta(position = game.at(12,10), image= meta2,tipo=2),
						 new Meta(position = game.at(11,10), image= meta1),
						 new Meta(position = game.at(7,9), image = meta1),
						 new Meta(position = game.at(14,1), image = meta1),
						 new Meta(position = game.at(8,3), image= meta1)
						 ]
						 
	const listaCajas=[   
						 new Caja(position = game.at(14,9),resolucion=resolucionCaja,stringDeObjeto="caja1.png",cajaEnMeta="caja_ok.png",tipo=1),
						 new Caja(position = game.at(8,8),resolucion=resolucionCaja,stringDeObjeto="caja1.png",cajaEnMeta="caja_ok.png",tipo=1) ,
						 new Caja(position = game.at(16,7),resolucion=resolucionCaja,stringDeObjeto="caja2.png",cajaEnMeta="caja_ok2.png",tipo=2),
						 new Caja(position = game.at(16,6),resolucion=resolucionCaja,stringDeObjeto="caja2.png",cajaEnMeta="caja_ok2.png",tipo=2),
						 new Caja(position = game.at(16,3),resolucion=resolucionCaja,stringDeObjeto="caja2.png",cajaEnMeta="caja_ok2.png",tipo=2),
						 new Caja(position = game.at(13,2),resolucion=resolucionCaja,stringDeObjeto="caja1.png",cajaEnMeta="caja_ok.png",tipo=1),
						 new Caja(position= game.at(11,4),resolucion=resolucionCaja,stringDeObjeto ="caja1.png", cajaEnMeta="caja_ok.png",tipo=1),
						 new Caja(position = game.at(10,2),resolucion=resolucionCaja,stringDeObjeto= "caja1.png", cajaEnMeta = "caja_ok.png",tipo=1),
						 new Caja(position = game.at(11,6),resolucion=resolucionCaja,stringDeObjeto= "caja2.png", cajaEnMeta = "caja_ok2.png",tipo=2)
						
						 ]

	method cargarNivel(){
	
		configuraciones.configMusic("NivelBelCronometro.mp3")
		
		game.addVisual(self)
		unCronometro.activarCronometro()
		configuraciones.elcontadorDePasos(unContadorDePasos)
		configuraciones.contadorDeEmpujes(unContadorDeEmpujes)
		game.addVisual(unContadorDePasos)
		game.addVisual(unContadorDeEmpujes)	
		self.cargarObjetos(listaMeta)
		self.cargarObjetos(listaCajas)
		self.generarMuros()
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)	
		self.configNivel(jugador1)
		nivel0.posicionInitial(game.at(12,10))
		game.addVisual(unCronometro)
		
		
	}
	
	method generarMuros(){
		const muroVisible = "menorResolucion/muro3.png"
			
		/* Muros Horizontales */
		self.bordearHorizontalmente(11,13,9,muroVisible)
		self.bordearHorizontalmente(10,11,5,muroVisible)
		self.bordearHorizontalmente(14,15,2,muroVisible)
		self.bordearHorizontalmente(15,17,9,muroVisible)
		self.bordearHorizontalmente(13,13,10,muroVisible)
		self.bordearHorizontalmente(13,13,8,muroVisible)
		self.bordearHorizontalmente(9,9,7,muroVisible)
		
		/*Muros Verticales */
		self.bordearVerticalmente(9,10,8,muroVisible)
		self.bordearVerticalmente(4,5,8,muroVisible)
		self.bordearVerticalmente(2,2,8,muroVisible)
		self.bordearVerticalmente(2,5,7,muroVisible)
		self.bordearVerticalmente(1,3,11,muroVisible)
		self.bordearVerticalmente(5,6,13,muroVisible)
		
		/*Muros invisibles */
		self.bordearVerticalmente(0,2,16,muroVisible)
		self.bordearVerticalmente(0,11,18,muroVisible)
		self.bordearVerticalmente(0,11,6,muroVisible)
		self.bordearHorizontalmente(6,18,0,muroVisible)
		self.bordearHorizontalmente(6,18,11,muroVisible)
		self.bordearHorizontalmente(17,17,1,muroVisible)
		self.bordearHorizontalmente(15,18,5,muroVisible)
	}
	
	method image() = "menorResolucion/mapBel2.png"
	
	
	override method listaCajas() = listaCajas

 	method listaMeta()= listaMeta
 	method cronometro()=unCronometro
}