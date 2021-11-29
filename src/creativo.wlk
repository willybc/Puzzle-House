import wollok.game.*
import objetos.*
import direcciones.*
import configuraciones.*
import timeline.*
import jugador.*
import niveles.*
import objetosDelModoCreativo.*


class Creativo inherits Nivel{
	
}

object nivelCreativo inherits Nivel (siguienteNivel = menu) {
	const property modoCreativo_soyMeta = false
	const property modoCreativo_soyUnMuro = false
	const property modoCreativo_soyUnPuntoDeReinicio = false
	const property tipo=100
	
	
	
	const jugador1 = new JugadorConstructor (position = game.center() , resolucion="menorResolucion",nombreJugador = "jugador1" ,tipo=66)
	
	const listaMeta =[]
	const listaCajas=[]
	const listaMuros=[]
	const cajasEnMeta=[]

	const conjuntoDeListas=[listaMeta,listaCajas,listaMuros]
	method modoCreativoBorrarVisual(){}
	method esPisable()=true
	override method reiniciarNivel(){
		configuraciones.nivelActual().listaCajas().forEach{ objeto => objeto.posicioninicial()}
		configuraciones.elJugador().posicioninicial()
		cajasEnMeta.forEach({unaCaja=>unaCaja.flag(true)})
		cajasEnMeta.forEach({unaCaja=>unaCaja.reiniciarImagen()})
		cajasEnMeta.clear()
	}
	
	method cajasEnMetaBorrar(objeto){
		cajasEnMeta.removeAll(objeto)
		
	}
	method formatearNivel(){
		conjuntoDeListas.flatten().forEach({unObjeto=>unObjeto.modoCreativoBorrarVisual()})
		conjuntoDeListas.forEach({lista=>lista.clear()})
		cajasEnMeta.clear()
	}
	
	
	method retornarJugador()=jugador1

	method borrarObjetos(objeto) = objeto.forEach{ unObjeto => game.removeVisual(unObjeto)}

	method cargarNivel(){
		//configuraciones.configMusic("niveL.mp3")
		
		game.addVisual(self)
		
		game.addVisual(posicionInicialDelConstructor)
		game.addVisual(jugador1)
		game.addVisual(contadorDeCajas)
		
		configuraciones.nivelActual(self)
		self.configNivel(jugador1)
		jugador1.TeclasAdicionales()
		game.addVisual(ui)
		self.ordenarVisuales()
		nivel0.posicionInitial(game.at(21,3))	
		game.say(jugador1,"presiona ENTER para probar el nivel creado!!")
		
	}
 	
	override method verificarMetas() {
		
		const verificador = self.listaCajas().size()==cajasEnMeta.size()
		
		if (verificador) {
			sonidoObjeto.emitirSonido("ok.mp3") // es temporal
			game.say(configuraciones.elJugador(), "BIEN!!! Este puzzle se puede RESOLVER! ")
		}		
	}
	
	method numeroDeCajasEnLaMeta(){
		return cajasEnMeta.size()
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
		game.removeVisual(posicionInicialDelConstructor)
		game.removeVisual(ui)
		game.removeVisual(contadorDeCajas)
		self.habilitarLaAdicionDeLosObjetosAlTablero()
		self.agregarObjetosAlTablero()
		game.addVisual(posicionInicialDelConstructor)
		game.addVisual(jugador1)
		game.addVisual(ui)
		game.addVisual(contadorDeCajas)
		

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
		cajasEnMeta.clear()
		game.schedule(20,{self.volverAlMenu()})
	}
	method volverAlMenu(){
		game.clear()	
		siguienteNivel.cargarNivel()	
		
	}
	
	
	
	method borrarObjetosDeLaLista(listaDeObjetos){
		conjuntoDeListas.forEach({unaLista=>unaLista.removeAll(listaDeObjetos)})
		listaDeObjetos.forEach({unObjeto=>unObjeto.modoCreativoBorrarVisual()})
	}
	
	method image() = "menorResolucion/modoCreativo.png"
	method position()=game.at(0,0)
	
	method hacerAlgo(direccion){
	}
	method jugarNivelCreado(){
		var numeroDeCajasEnTotal=0
		self.reiniciarNivel()
		numeroDeCajasEnTotal=self.numeroDeCajas()
		nivelCreativoJugar.numeroDeCajasTotales(numeroDeCajasEnTotal)
		self.habilitarLaAdicionDeLosObjetosAlTablero()
		cajasEnMeta.clear()
		game.clear()
		nivelCreativoJugar.preCargar()
	
	}
	method numeroDeCajas()=listaCajas.size()
		
	

	method listaMuros()=listaMuros
	
	method cajasEnMeta()=unaCaja
	
	
	method cajasEnMeta(unaCaja){
		cajasEnMeta.add(unaCaja)
	}
	method cajasEnMetaRemover(unaCaja){
		cajasEnMeta.remove(unaCaja)
	}
	
	
	override method listaCajas() = listaCajas

 	method listaMeta()= listaMeta
}


object nivelCreativoJugar inherits Nivel (siguienteNivel = nivelCreativo){
	
	const jugador1 = new JugadorDelNivelCreado(position =posicionInicialDelConstructor.position() , resolucion="menorResolucion",nombreJugador = "jugador1")
	
	var listaMeta =[]
	var listaCajas=[]
	var listaMuros=[]
	var property numeroDeCajasTotales=0
	const cajasEnMeta=[]

	override method reiniciarNivel(){
		configuraciones.nivelActual().listaCajas().forEach{ objeto => objeto.posicioninicial()}
		configuraciones.elJugador().posicioninicial()
		cajasEnMeta.forEach({unaCaja=>unaCaja.flag(true)})
		cajasEnMeta.forEach({unaCaja=>unaCaja.reiniciarImagen()})
		cajasEnMeta.clear()
	}

	override method verificarMetas() {
		
		const verificador = self.numeroDeCajasTotales()==cajasEnMeta.size()
		
		
		if (verificador) {
			sonidoObjeto.emitirSonido("nivelPruebaOk.mp3") // es temporal
			game.say(configuraciones.elJugador(), "ganaste!")
			configuraciones.configStopMusic()
			game.schedule(1500,{self.cambiarNivel()})
		}
		
	}
	method cajasEnMeta()=unaCaja
	
	
	method cajasEnMeta(unaCaja){
		
		cajasEnMeta.add(unaCaja)
		
	}
	method cajasEnMetaRemover(unaCaja){
		cajasEnMeta.remove(unaCaja)
	}
	
	method preCargar(){
		listaMeta=nivelCreativo.listaMeta()
		listaCajas=nivelCreativo.listaCajas()
		listaMuros=nivelCreativo.listaMuros()
		self.cargarNivel()
	}

	method cargarNivel(){
		configuraciones.nivelActual(self)	
		configuraciones.configMusic("niveL.mp3")
		game.addVisual(self)
		self.cargarObjetos(listaMeta)
		self.cargarObjetos(listaCajas)
		self.cargarObjetos(listaMuros)
		jugador1.position(posicionInicialDelConstructor.position())
		jugador1.posicionInicial(posicionInicialDelConstructor.position())
		game.addVisual(jugador1)
		game.say(jugador1,"Presiona ENTER para volver al modo creativo")
		self.configNivel(jugador1)
		jugador1.TeclasAdicionales()
	
	}
	
	override method  cambiarNivel(){
		configuraciones.configStopMusic()
		self.reiniciarNivel()
		game.schedule(10,{self.transicion()})
	
	}
	method transicion(){
		game.clear()
		siguienteNivel.cargarNivel()
	}

	method image() = "menorResolucion/modoLibre.png"
	method position()=game.at(0,0)
	
	override method listaCajas() = listaCajas

 	method listaMeta()= listaMeta
 	
 	override method soyUnNivelCreativo()=true
}

