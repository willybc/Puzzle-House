import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*



object nivelCreativo inherits Nivel (siguienteNivel = menu) {
	
	const jugador1 = new JugadorConstructor (position = game.center() , resolucion="menorResolucion",nombreJugador = "jugador1" ,tipo=66)
	
	const listaMeta =[]
	const listaCajas=[]
	const listaMuros=[]
	
	method borrarObjetos(objeto) = objeto.forEach{ unObjeto => game.removeVisual(unObjeto)}

	method cargarNivel(){
		
		//configuraciones.configMusic("niveL.mp3")
		game.addVisual(self)
		
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)
		
		self.configNivel(jugador1)
		jugador1.TeclasDelConstructor()
		nivel0.posicionInitial(game.at(21,3))
			
	}

	override method listaCajas() = listaCajas

 	method listaMeta()= listaMeta
	
	override method verificarMetas() {
		const verificador = self.listaCajas().all({ unaCaja => unaCaja.llegoMeta() })
		if (verificador) {
			sonidoObjeto.emitirSonido("victoriaFem.mp3") // es temporal
			game.say(configuraciones.elJugador(), "ganaste!")
			game.schedule(1200,{self.reiniciarNivel()})
		}
	}
	method agregarNuevaCajaAlaLista(unaCaja){
		listaCajas.add(unaCaja)
		self.ordenarVisuales()
		
	}
	method agregarNuevaMetaAlaLista(unaMeta){
		listaMeta.add(unaMeta)
		self.ordenarVisuales()
	}
	method agregarNuevoMuroAlaLista(unMuro){
		listaMuros.add(unMuro)
		self.ordenarVisuales()
		
	}
	
	method ordenarVisuales(){

		listaMeta.forEach({unaMeta=>unaMeta.modoCreativoAgregarVisual()})
		listaCajas.forEach({unaCaja=>unaCaja.modoCreativoAgregarVisual()})
		listaMuros.forEach({unMuro=>unMuro.modoCreativoAgregarVisual()})
		
		
		listaMeta.forEach({unaMeta=>unaMeta.modoCreativoBorrarVisual()})
		listaCajas.forEach({unaCaja=>unaCaja.modoCreativoBorrarVisual()})
		listaMuros.forEach({unMuro=>unMuro.modoCreativoBorrarVisual()})
		game.removeVisual(jugador1)
		
		listaMeta.forEach({unaMeta=>unaMeta.quieroAgregarAlTablero(true)}) 
		listaCajas.forEach({unaCaja=>unaCaja.quieroAgregarAlTablero(true)}) 
		listaMuros.forEach({unMuro=>unMuro.quieroAgregarAlTablero(true)}) 
		
		self.ordenarCajasPorTipo()
		
		listaMeta.forEach({unaMeta=>unaMeta.modoCreativoAgregarVisual()})
		listaMuros.forEach({unMuro=>unMuro.modoCreativoAgregarVisual()})
		listaCajas.forEach({unaCaja=>unaCaja.modoCreativoAgregarVisual()})
		game.addVisual(jugador1)
		
	}
	
	method ordenarCajasPorTipo(){
		listaCajas.sortedBy{ a, b => b.tipo() > a.tipo()}
		
	}
	
	method salirDelNivel(){
		listaMeta.clear()
		listaMuros.clear()
		listaCajas.clear()
		
		game.clear()
		siguienteNivel.cargarNivel()
		
	}
	
	method image() = "menorResolucion/modoLibre.png"
	method position()=game.at(0,0)
	
	method hacerAlgo(direccion){
	}
}