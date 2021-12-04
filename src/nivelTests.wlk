import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*

object nivelTest inherits Nivel (siguienteNivel = nivel0){
	const unContadorDePasos = new ContadorDePasos(position=game.at(11,11))
	const unContadorDeEmpujes = new ContadorDePasos(texto="Pushes : ",position=game.at(14,11))
	const jugador1 = new Jugador(position = game.at(9,6 ) , resolucion="menorResolucion",nombreJugador = "jugador1")
	const meta1 = "menorResolucion/meta1.png"

	const resolucionCaja = "menorResolucion"
	const caja1 = "caja1.png"
	
	const cajaMeta1 = "caja_ok.png"
	
	const listaMeta =[ 
						 
						 new Meta(position = game.at(11,6),image= meta1)  
					
	]
	const listaCajas=[  
						 new Caja(position = game.at(13,6),resolucion=resolucionCaja,stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1) 
				
	
	]
	
	override method verificarMetas() {
		const verificador = self.listaCajas().all({ unaCaja => unaCaja.estoyEnMeta() })
		if (verificador) {
			sonidoObjeto.emitirSonido("victoriaFem.mp3") // es temporal
		
			game.schedule(300,{self.reiniciarNivel()})
		}
	}



	method cargarNivel(){
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
		self.configNivel(jugador1)
		nivel0.posicionInitial(game.at(21,3))
		nivel0.agregarNivelCompletado(self)
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

}