import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*
import objetosDelModoCreativo.*

object posicionInicialConstructor{
	
	
}

object nivelCreativo inherits Nivel (siguienteNivel = menu) {
	
	const jugador1 = new JugadorConstructor (position = game.center() , resolucion="menorResolucion",nombreJugador = "jugador1" ,tipo=66)
	
	const listaMeta =[]
	const listaCajas=[]
	const listaMuros=[]
	
	const conjuntoDeListas=[listaMeta,listaCajas,listaMuros]
	/* 
	const listaCajas1=[]
	const listaCajas2=[]
	const listaCajas3=[]
	
	const listaMetas1=[]
	const listaMetas2=[]
	const listaMetas3=[]
	*/
	method borrarObjetos(objeto) = objeto.forEach{ unObjeto => game.removeVisual(unObjeto)}

	method cargarNivel(){
		//configuraciones.configMusic("niveL.mp3")
		
		game.addVisual(self)
		game.addVisual(posicionInicialDelConstructor)
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
		
		self.agregarObjetosAlTablero()
		self.borrarObjetosDelTableroTemporalmente()
		game.removeVisual(jugador1)
		self.habilitarLaAdicionDeLosObjetosAlTablero()
		self.ordenarCajasPorTipo()
		self.agregarObjetosAlTablero()
		game.addVisual(jugador1)
	}
	method agregarObjetosAlTablero(){
		conjuntoDeListas.flatten().forEach({unObjeto=>unObjeto.modoCreativoAgregarVisual()})
	}
	method borrarObjetosDelTableroTemporalmente(){
		conjuntoDeListas.flatten().forEach({unObjeto=>unObjeto.modoCreativoBorrarVisual()})
	}
	method habilitarLaAdicionDeLosObjetosAlTablero(){
		conjuntoDeListas.flatten().forEach({unObjeto=>unObjeto.quieroAgregarAlTablero(true)})
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
	method borrarObjetosDeLaLista(listaDeObjetos){
		conjuntoDeListas.forEach({unaLista=>unaLista.removeAll(listaDeObjetos)})
		listaDeObjetos.forEach({unObjeto=>unObjeto.modoCreativoBorrarVisual()})
	}
	
	method image() = "menorResolucion/modoLibre.png"
	method position()=game.at(0,0)
	
	method hacerAlgo(direccion){
	}

}
