import wollok.game.*
import direcciones.*
import configuraciones.*
import niveles.*
import objetos.*
import sonido.*
import creativo.*

class Jugador inherits Posicion{

	var property nombreJugador
	
	var property resolucion
	var property tipo =99
	

	
	method image() = resolucion + "/" + nombreJugador.toString() + ultimaDireccion.toString() + ".png"
	
	override method cambiarPosicion(direccion) {
	
		ultimaDireccion = direccion
		self.position(direccion.moverse(self))
		sonidoObjeto.emitirSonido("pasosf.mp3")	
	
	}	
	method victoria(){
		sonidoObjeto.emitirSonido("victoriaFem.mp3")
	}							
	
	method text() = if (!configuraciones.libreMoviento()) {	""} else {"[ " + position.x().toString() + " , " + position.y().toString() + " ]"}

	method textColor() = paleta.verde()
	
	method esPisable() = false
	
	method llegoCheckpoint(){
		configuraciones.nivelActual().avanzarA()
	}
	override method hacerAlgo(direccion){
		configuraciones.elJugador().position(direccion.dirOpuesto(configuraciones.elJugador()))
		game.say(self,"¿Qué sucede?")
	}
	
	method retroceder(direccion){
		self.position(direccion.dirOpuesto(configuraciones.elJugador()))	
	}

}

class JugadorConstructor inherits Jugador{
	

	method posicionActual()=self.position()
	
	method TeclasDelConstructor(){
	/* 
		keyboard.num1().onPressDo{self.generarUnaCaja(new CajaEstatica(position =self.position(),stringDeObjeto="caja1.png",cajaEnMeta="caja_ok.png",tipo=1))}
		keyboard.num2().onPressDo{self.generarUnaCaja(new CajaEstatica(position =self.position(),stringDeObjeto="caja2.png",cajaEnMeta="caja_ok2.png",tipo=2))}
		keyboard.num3().onPressDo{self.generarUnaMeta( new Meta(position =self.position(),image="menorResolucion/meta1.png"))}
		keyboard.num4().onPressDo{self.generarUnaMeta( new Meta(position =self.position(),image="menorResolucion/meta2.png",tipo=2))}
	    keyboard.num5().onPressDo{self.generarUnMuro( new MuroVisible(position =self.position(),image="menorResolucion/muro3.png"))}
		keyboard.e().onPressDo{nivelCreativo.salirDelNivel()}
		* 
		*/
	}
	method validadLibreMovimiento(){
		if(!configuraciones.libreMoviento()){
			self.error("Presiona la Z primero")
		}
	}
/* 
	method agregarAlTablero(unObjeto){
		game.removeVisual(self)
		game.addVisual(unObjeto)
		game.addVisual(self) //esto es para que el jugador siempre se superponga a la caja
		
	}
	 */
	method generarUnaCaja(unObjeto){
		self.validadLibreMovimiento()
		nivelCreativo.agregarNuevaCajaAlaLista(unObjeto)
	}
	method generarUnaMeta(unObjeto){
		self.validadLibreMovimiento()
		nivelCreativo.agregarNuevaMetaAlaLista(unObjeto)
	}
	method generarUnMuro(unObjeto){
		self.validadLibreMovimiento()
		nivelCreativo.agregarNuevoMuroAlaLista(unObjeto)
		
	}
	
}
	