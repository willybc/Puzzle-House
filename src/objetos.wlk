import wollok.game.*
import direcciones.*
import configuraciones.*
import niveles.*
import jugador.*
import sonido.*
import nivelB.*

object sonidoObjeto {

	method emitirSonido(unSonido) {
		const sonido = soundProducer.sound(unSonido) // game.sound(unSonido)
		sonido.volume(0.3)
		sonido.play()
	}
}
class Posicion {
	var property quieroAgregarAlTablero=true
	var property ultimaDireccion = abajo
	var property position
	const property posicionInicial = position

	method posicioninicial() {
		sonidoObjeto.emitirSonido("reinicio.mp3")
		self.position(posicionInicial)
	}

	method hacerAlgo(direccion) {
		if (!configuraciones.libreMoviento()){
		self.cambiarPosicion(direccion)
		}	
	}

	method cambiarPosicion(direccion)
	
	method modoCreativoAgregarVisual(){
		if(quieroAgregarAlTablero){
			game.addVisual(self)
			quieroAgregarAlTablero=false
			//quieroAgregarAlTablero=false
		}	
	}
	method modoCreativoBorrarVisual(){
			game.removeVisual(self)			
	}
	
}

class Caja inherits Posicion {
	
	const resolucion = "menorResolucion"
	const stringDeObjeto = "caja1.png"
	const cajaEnMeta = "caja_ok.png"
	const property tipo = 1
	var property elCaballoSeTrabo = false
	const sonido = "caja_mover2.mp3"
	
	
	
	method esPisable() = false

	method image() = if (self.llegoMeta()) {
		resolucion + "/" + cajaEnMeta
	} else {
		resolucion + "/" + stringDeObjeto
	}

	override method cambiarPosicion(direccion) {
		const siguienteUbicacion = direccion.moverse(self)
		ultimaDireccion = direccion
		if (self.proximaUbicacionLibre(siguienteUbicacion)) {
			self.position(direccion.moverse(self))
			configuraciones.nivelActual().verificarMetas()
		} else {
			configuraciones.elJugador().retroceder(direccion)
		}
		sonidoObjeto.emitirSonido(sonido)
	}

	method proximaUbicacionLibre(direccion) = game.getObjectsIn(direccion).all{ unObj => unObj.esPisable() }

	method llegoMeta() = game.colliders(self).any{ unaMeta => unaMeta.position() == self.position() && unaMeta.tipo() == self.tipo() } // configuraciones.nivelActual().listaMeta().any{ unaMeta => unaMeta.position() == self.position() && unaMeta.tipo() == self.tipo() }

	
}

class CajaEstatica inherits  Caja{ //Esta caja no cambia de color cuando llega a su meta. Ganamos mucho rendimiento si el pre calculo de la imagen es lo menos complicado posible. Estas cajas solo son usados en el nivel creativo 
	override method image() = resolucion + "/" + stringDeObjeto
}

class Oveja inherits Caja {

	override method image() = if (!self.llegoMeta()) {
		resolucion + "/" + stringDeObjeto + self.ultimaDireccion().toString() + ".png"
	} else {
		resolucion + "/" + stringDeObjeto + "Ok.png"
	}

}

class Caballo inherits Oveja {

	var seTrabo = false

	override method cambiarPosicion(direccion) {
		2.times({ i => self.moverCaballo(direccion)})
		if (seTrabo) {
			configuraciones.elJugador().retroceder(direccion)
		}
		sonidoObjeto.emitirSonido(sonido)
	}

	method moverCaballo(direccion) {
		const siguienteUbicacion = direccion.moverse(self)
		ultimaDireccion = direccion
		if (self.proximaUbicacionLibre(siguienteUbicacion)) {
			self.position(direccion.moverse(self))
			configuraciones.nivelActual().verificarMetas()
			seTrabo = false
		} else {
			seTrabo = true
		}
	}
}
class MuroVisible inherits Posicion {

	const property tipo = 6
	var property image = "menorResolucion/muro.png"
	
	method esPisable() = false

	override method cambiarPosicion(direccion) {
		configuraciones.elJugador().retroceder(direccion)
	}
	
	
}
class Pisable { // inherits Posicion 

	var property position
	var property image

	method esPisable() = true
	
	method hacerAlgo(direccion){
		
	}
	/* 
	override method hacerAlgo(direccion) {
	}
	override method cambiarPosicion(unaDireccion){}
	*/
}
class Checkpoint inherits Pisable {

	var property siguienteNivel
	const property tipo = 6

	override method hacerAlgo(direccion) {
		configuraciones.configStopMusic()
		game.clear()
		siguienteNivel.cargarNivel()
	}
}
class Meta inherits Pisable {
	var property tipo = 1
 	


}

class CheckpointSalir inherits Checkpoint {

	override method hacerAlgo(direccion) {
		game.clear()
		game.stop()
	}
}

object paleta {

	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"

}

object checkpointBonus {

	method position() = game.at(16, 4)

	method hacerAlgo(direccion) {
		if (!nivel0.nivelBonusHabilitado()) {
			self.error("No puedes pasar si no terminas todos los puzzles!!")
		}
		configuraciones.configStopMusic()
		game.clear()
		pasadizo.cargarNivel()
	}

}
class CambiarRopa {

	var property position = game.at(6, 5)
	var vestimenta

	method hacerAlgo(direccion) {
		configuraciones.elJugador().nombreJugador(vestimenta)
		configuraciones.elJugador().retroceder(direccion)
		pasadizo.vestimenta(vestimenta)
	}

}
