import wollok.game.*
import direcciones.*
import configuraciones.*
import niveles.*
import jugador.*
import sonido.*
import nivelB.*
import objetos.*
import creativo.*


class CajaEstatica inherits  Caja{ //sta caja no cambia de color cuando llega a su meta. Ganamos mucho rendimiento si el pre calculo de la imagen es lo menos complicado posible. Estas cajas solo son usadas en el nivel creativo 
	var property flag=true
	var property imagen = resolucion + "/" + stringDeObjeto
	
	override method image() =imagen


	method imagenARetornar()=  if (self.llegoMeta()) {resolucion + "/" + cajaEnMeta} else {	resolucion + "/" + stringDeObjeto}
	
	method reiniciarImagen(){
		imagen=resolucion + "/" + stringDeObjeto
	}

	override method cambiarPosicion(direccion) {
		const siguienteUbicacion = direccion.moverse(self)
		ultimaDireccion = direccion
		if (self.proximaUbicacionLibre(siguienteUbicacion)) {
			self.position(direccion.moverse(self))
			self.activarVerificador()
		} else {
			configuraciones.elJugador().retroceder(direccion)
		}
		sonidoObjeto.emitirSonido(sonido)
	}

	method activarVerificador() {
		if (self.llegoMeta()) {
			if (flag) {
				configuraciones.nivelActual().cajasEnMeta(self)
				imagen= resolucion + "/" + cajaEnMeta
				flag = false
			}
			configuraciones.nivelActual().verificarMetas()
		} else {
			configuraciones.nivelActual().cajasEnMetaRemover(self)
			imagen=resolucion + "/" + stringDeObjeto
			flag = true
		}
	}

}
object ui inherits Pisable(position=game.at(10,0),image="menorResolucion/doblehud39.png") {
	override method modoCreativoBorrarVisual(){}
}
object contadorDeCajas inherits Pisable(position=game.at(0,12)){
	method text ()= nivelCreativo.listaCajas().size().toString() +"/" + nivelCreativo.numeroDeCajasEnLaMeta().toString()
	method textColor() = paleta.verde()
	override method modoCreativoBorrarVisual(){}
}


object posicionInicialDelConstructor inherits Posicion(modoCreativo_soyUnPuntoDeReinicio=true){
	var property tipo =0
	
	method image()="menorResolucion/pos00.png"
	override method hacerAlgo(direccion) {
		
	}	
	override method cambiarPosicion(nuevaPosicion){
		var guardarPosicion
		self.position(nuevaPosicion)
		guardarPosicion=self.position()
		self.position(game.center())
		self.position(guardarPosicion)
	}
	method esPisable()=true
	
	override method modoCreativoBorrarVisual(){
		
	}
}

class JugadorDelNivelCreado inherits Jugador{
	method TeclasAdicionales(){
		keyboard.enter().onPressDo{nivelCreativoJugar.cambiarNivel()}
	}	
	
	override method text() =""
}

class JugadorConstructor inherits Jugador{
	
	var property  elJugadorNoPudoAvanzar=false
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
    
    override method cambiarPosicion(direccion) {
	 	ultimaDireccion=direccion
		self.position(direccion.moverse(self))
		sonidoObjeto.emitirSonido("pasosf.mp3")
	}

	method posicionActual()=self.position()

	method TeclasAdicionales(){

	//Se podria usar Self.position, osea la posicion del jugador pero por razones que desconosco da un rendimiento MUY POBRE!! Los frames bajan mucho!
		
		keyboard.f().onPressDo{nivelCreativo.formatearNivel()}
		keyboard.num1().onPressDo{self.generarUnaCaja(new CajaEstatica(position =game.at(self.coordenadaX(),self.coordenadaY()),stringDeObjeto=caja1,cajaEnMeta=cajaMeta1,tipo=1))}
		keyboard.num2().onPressDo{self.generarUnaCaja(new CajaEstatica(position =game.at(self.coordenadaX(),self.coordenadaY()),stringDeObjeto=caja2,cajaEnMeta=cajaMeta2,tipo=2))}
		keyboard.num3().onPressDo{self.generarUnaMeta( new Meta(position =game.at(self.coordenadaX(),self.coordenadaY()),image=meta1,modoCreativo_soyMeta=true))}
		keyboard.num4().onPressDo{self.generarUnaMeta( new Meta(position =game.at(self.coordenadaX(),self.coordenadaY()),image=meta2,tipo=2,modoCreativo_soyMeta=true))}
	    keyboard.space().onPressDo{self.generarUnMuro( new MuroVisible(position =game.at(self.coordenadaX(),self.coordenadaY()),image="menorResolucion/muro3.png",modoCreativo_soyUnMuro=true))}
	    keyboard.alt().onPressDo{self.generarUnMuro( new MuroVisible(position =game.at(self.coordenadaX(),self.coordenadaY()),image="menorResolucion/muro2.png",modoCreativo_soyUnMuro=true))}
	    
	    keyboard.shift().onPressDo{self.eliminarObjeto()}
		keyboard.control().onPressDo{self.generarPuntoDeReinicio()}
		keyboard.enter().onPressDo{nivelCreativo.jugarNivelCreado()}
		keyboard.backspace().onPressDo{nivelCreativo.salirDelNivel()}
	}

	method validadLibreMovimiento(){
		if(!configuraciones.libreMoviento()){
			self.error("Presiona la Z primero")
		}
	}
	method generarUnaCaja(unObjeto){
		self.validadLibreMovimiento()
		self.validarObjetoPisable("No puedes generar una caja aqui")
		self.validacionPuntoDeReinicio()
		nivelCreativo.agregarNuevaCajaAlaLista(unObjeto)
	}
	method generarUnaMeta(unObjeto){
		self.validadLibreMovimiento()
		self.validacionDeMetas()
		nivelCreativo.agregarNuevaMetaAlaLista(unObjeto)
	}
	method generarUnMuro(unObjeto){
		self.validacionPuntoDeReinicio()
		self.validadLibreMovimiento()
		self.validarObjetoPisable("No puedes generar un muro aqui")
		self.validacionDeMetas()
		nivelCreativo.agregarNuevoMuroAlaLista(unObjeto)	
	}
	method generarPuntoDeReinicio(){
		
		self.validarObjetoPisable("No puedes generar un punto de reinicio del jugador  aqui")
		
		posicionInicialDelConstructor.cambiarPosicion(self.position())
	}
	method eliminarObjeto(){
		nivelCreativo.cajasEnMetaBorrar(self.objetosConElQueElConstructorEstaColisionando()) //agregado el 29/11/2021 luego de que se descubrio un bug que aparece cuando borramos  una caja y una meta a la vez
		nivelCreativo.borrarObjetosDeLaLista(self.objetosConElQueElConstructorEstaColisionando())
		
	
	}
	

	
	method objetosConElQueElConstructorEstaColisionando(){
		return game.colliders(self)
	}

	method verificarQueExisteUnObjeto(){
		return game.colliders(self).size()>0
	}
	
	
	method validarObjetoPisable(unMensaje){
		if(self.verificarQueExisteUnObjeto()){
			self.elObjetoSeraPisable(unMensaje)
		}
	}
	method elObjetoSeraPisable(unMensaje){
		if(!self.verificarQueTodosLosObjetosSeanPisables()){
			//self.error("No puedes agregar este objeto aqui") //"No puedes agregar este objeto aqui"
			self.error(unMensaje)
		}	
	}
	
	method  validacionDeMetas(){
		if( self.ValidacionMetaExistente()){
			self.error("Ya existe una meta en esta posicion!!")
		}	
		if(self.validacionMetaYmuro()){
			self.error("No tiene sentido agregar una meta aqui!")
		}
	}
	method validacionPuntoDeReinicio(){
		if(self.verificarPuntoDeReinicioExistente()){
			self.error("no puedes agregar este objeto aqui si existe un punto de reinicio del personaje")
		}
	
	}

	method validacionMetaYmuro()=self.objetosConElQueElConstructorEstaColisionando().any({unObjeto=>unObjeto.modoCreativo_soyUnMuro()})
	
	method verificarQueTodosLosObjetosSeanPisables()=self.objetosConElQueElConstructorEstaColisionando().all({unObjeto=>unObjeto.esPisable()})
	
	method ValidacionMetaExistente()=self.objetosConElQueElConstructorEstaColisionando().any({unObjeto=>unObjeto.modoCreativo_soyMeta()})
	
	override method posicioninicial() {
		sonidoObjeto.emitirSonido("reinicio.mp3")
		self.position(posicionInicialDelConstructor.position())
	}
	method verificarPuntoDeReinicioExistente()=self.objetosConElQueElConstructorEstaColisionando().any({unObjeto=>unObjeto.modoCreativo_soyUnPuntoDeReinicio()})
	
	method coordenadaX()=position.x()
	method coordenadaY()=position.y()	
}
