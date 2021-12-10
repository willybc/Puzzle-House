import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*
import nivelB.*

object nivelTest inherits Nivel (siguienteNivel = nivel0,soyUnNivelHardcoreTime=true){
	const unContadorDePasos = new ContadorDePasos(position=game.at(11,11))
	const unContadorDeEmpujes = new ContadorDePasos(texto="Pudshes : ",position=game.at(14,11))
	const jugador1 = new Jugador(position = game.at(9,6 ) , resolucion="menorResolucion",nombreJugador = "jugador1")
	const meta1 = "menorResolucion/meta1.png"
	const unCronometro=new Cronometro()
	const readyGo=new ReadyYGO()

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
		if(self.soyUnNivelHardcoreTime()){
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
		configuraciones.configMusic("hardTimerBelRemix.mp3")
		unContadorDePasos.reset()
		
		
		configuraciones.elcontadorDePasos(unContadorDePasos)
		configuraciones.contadorDeEmpujes(unContadorDeEmpujes)
		game.addVisual(self)
		game.addVisual(unContadorDePasos)
		game.addVisual(unContadorDeEmpujes)
		self.cargarObjetos(listaMeta)
		self.cargarObjetos(listaCajas)
		
		
		self.generarMuros()
		
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)

		nivel0.posicionInitial(game.at(21,3))
		nivel0.agregarNivelCompletado(self)
		game.addVisual(unCronometro)
		
		game.schedule(1800,{readyGo.iniciarReady()})
		
		
		
		
	}
	
	
	method Comenzar(){
		
		self.configNivel(jugador1)
		unCronometro.activarCronometro()
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


object pasadizoTest inherits Nivel(siguienteNivel = nivel0, duplicador = 2,soyUnNivelPuzzle=false){
	
	var property vestimenta = "jugador1"
	const jugador1 = new Jugador(position = game.at(2, 3) ,resolucion="mayorResolucion",nombreJugador = self.vestimenta())
	method cargarNivel(){
		

		game.addVisual(new Checkpoint(position = game.at(0,3), image = "menorResolucion/invisible.png", siguienteNivel = nivel0))
		configuraciones.configMusic("pasadizo.mp3")
		game.addVisual(self)
		jugador1.position(game.at(2, 3) )//denuevo para evitar un bug
		
		
		configuraciones.nivelActual(self)
		
		game.addVisual(new CambiarRopa(position=game.at(22,5),vestimenta="jugador1") )
		game.addVisual(new CambiarRopa(position=game.at(20,5),vestimenta="jugador1") )
		game.addVisual(new CambiarRopa(position=game.at(18,5),vestimenta="jugador1") )
		game.addVisual(new CambiarRopa(position=game.at(10,5),vestimenta="jugador1") )
		game.addVisual(new CambiarRopa(position=game.at(6,5),vestimenta="jugador1") )
		game.addVisual(new CambiarRopa(position=game.at(2,5),vestimenta="jugador1") )
		game.addVisual(new CambiarRopa(position=game.at(14,5),vestimenta="jugadorGranja") )
		game.addVisual(new Checkpoint(position = game.at(24,3), image = "mayorResolucion/invisible.png", siguienteNivel = nivel_bonus))
		nivel0.posicionInitial(game.at(17,4))
		self.generarMuros()	
		game.addVisual(jugador1)
		self.configNivel(jugador1)
		
	}
	
	override method listaCajas() = []
	
	method generarMuros(){
		
		const muroInvisible = "menorResolucion/invisible.png"
		self.duplicador(4)
		self.bordearHorizontalmente(0,22,5,muroInvisible)
		self.duplicador(2)
		self.bordearHorizontalmente(0,22,1,muroInvisible)
		self.bordearHorizontalmente(0,22,7,muroInvisible)
	}
	
	method image() = "nivelBonus/pasadizo-map4.png"
	
	override method abandonarNivel(){
		game.say(configuraciones.elJugador(),"Sube las escaleras para volver!")
	}

	
}
