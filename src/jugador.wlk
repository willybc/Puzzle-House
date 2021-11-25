import wollok.game.*
import direcciones.*
import configuraciones.*
import niveles.*
import objetos.*
import sonido.*
import creativo.*
import objetosDelModoCreativo.*

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
		game.say(self, 'Qué sucede?')
	}
	
	method retroceder(direccion){
		self.position(direccion.dirOpuesto(configuraciones.elJugador()))	
	}
	
	method impedirCaidaDeFPS() {
		self.position(posicionInicial)
	}
}