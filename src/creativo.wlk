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
	
	const jugador1 = new JugadorConstructor (position = game.center() , resolucion="menorResolucion",nombreJugador = "jugador1" ,tipo=66)
	
	const listaMeta =[]
	const listaCajas=[]
	const listaMuros=[]
	var cajasEnMeta=[]

	const conjuntoDeListas=[listaMeta,listaCajas,listaMuros]


	override method reiniciarNivel(){
		configuraciones.nivelActual().listaCajas().forEach{ objeto => objeto.posicioninicial()}
		configuraciones.elJugador().posicioninicial()
		cajasEnMeta.forEach({unaCaja=>unaCaja.flag(true)})
		cajasEnMeta.clear()
	}
	method retornarJugador()=jugador1

	method borrarObjetos(objeto) = objeto.forEach{ unObjeto => game.removeVisual(unObjeto)}

	method cargarNivel(){
		//configuraciones.configMusic("niveL.mp3")
		
		game.addVisual(self)
		
		game.addVisual(posicionInicialDelConstructor)
		game.addVisual(jugador1)
		
		
		configuraciones.nivelActual(self)
		self.configNivel(jugador1)
		jugador1.TeclasAdicionales()
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
		
		self.habilitarLaAdicionDeLosObjetosAlTablero()
		self.agregarObjetosAlTablero()
		game.addVisual(posicionInicialDelConstructor)
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
		cajasEnMeta.clear()
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
	const meta1 = "menorResolucion/meta1.png"
	const meta2 = "menorResolucion/meta2.png"
	const meta3=  "menorResolucion/meta3.png"
	const meta4=  "menorResolucion/meta4.png"
	const meta5=  "menorResolucion/meta5.png"
	const resolucionCaja = "menorResolucion"
	const caja1 = "caja1.png"
	const caja2 = "caja2.png"
	const caja3 = "caja3.png"
	const caja4 = "caja4.png"
	const caja5 = "caja5.png"
	const cajaMeta1 = "caja_ok.png"
	const cajaMeta2 = "caja_ok2.png"
	const cajaMeta3 = "caja3_ok.png"
	const cajaMeta4 = "caja4_ok.png"
    const cajaMeta5 = "caja5_ok.png"
	var listaMeta =[]
	var listaCajas=[]
	var listaMuros=[]
	var property numeroDeCajasTotales=0
	var cajasEnMeta=[]
	var	numeroDeCajasEnMetas=0
	var numeroDeCajas=0
	override method reiniciarNivel(){
		configuraciones.nivelActual().listaCajas().forEach{ objeto => objeto.posicioninicial()}
		configuraciones.elJugador().posicioninicial()
		cajasEnMeta.forEach({unaCaja=>unaCaja.flag(true)})
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
