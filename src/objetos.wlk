import wollok.game.*
import direcciones.*
import configuraciones.*
import niveles.*
import jugador.*
import sonido.*
import nivelB.*
import objetosDelModoCreativo.*

object sonidoObjeto {

	method emitirSonido(unSonido) {
		const sonido = soundProducer.sound(unSonido) // game.sound(unSonido)
		sonido.volume(0.3)
		sonido.play()
	}
}
class Posicion {

	var property ultimaDireccion = abajo
	var property position = game.center()
	var property posicionInicial = position
	const property modoCreativo_soyMeta = false
	const property modoCreativo_soyUnMuro = false
	const property modoCreativo_soyUnPuntoDeReinicio = false
	const property soyUnaCaja=false //agregado el 3/12/2021 para el contador de movimientos
	var property quieroAgregarAlTablero = true
	var property estaBloqueado=false

	method posicioninicial() {
		sonidoObjeto.emitirSonido("reinicio.mp3")
		self.position(posicionInicial)
	}

	method hacerAlgo(direccion) {
		if (!configuraciones.libreMoviento() or configuraciones.nivelActual().soyUnNivelCreativo()) {
			self.cambiarPosicion(direccion)
		}
	}

	method cambiarPosicion(direccion)

	method modoCreativoAgregarVisual() {
		if (quieroAgregarAlTablero) {
			game.addVisual(self)
			quieroAgregarAlTablero = false
		}
	}

	method modoCreativoBorrarVisual() {
		game.removeVisual(self)
	}
	
	

}

class Caja inherits Posicion (soyUnaCaja=true){
	
	const resolucion = "menorResolucion"
	const stringDeObjeto = "caja1.png"
	const cajaEnMeta = "caja_ok.png"
	const property tipo = 1
	var property elCaballoSeTrabo = false
	const sonido = "caja_mover2.mp3"
	var mensaje="no bloqueado"
	
	method texto ()= mensaje
	
	method esPisable() = false

	method image() = if (self.llegoMeta()) {resolucion + "/" + cajaEnMeta} else {	resolucion + "/" + stringDeObjeto}

	override method cambiarPosicion(direccion) {
		var siguienteUbicacion = direccion.moverse(self)
		ultimaDireccion = direccion
		if (self.proximaUbicacionLibre(siguienteUbicacion)) {
			self.position(direccion.moverse(self))
			self.contador()
			configuraciones.nivelActual().verificarMetas()
			siguienteUbicacion=direccion.moverse(self)
			
			
			
		} else {
			configuraciones.elJugador().retroceder(direccion)
			
			
		}
		sonidoObjeto.emitirSonido(sonido)
	}
	method proximaUbicacionLibre(direccion) = game.getObjectsIn(direccion).all{ unObj => unObj.esPisable() }
	
	method llegoMeta() = game.colliders(self).any{ unaMeta => unaMeta.position() == self.position() && unaMeta.tipo() == self.tipo() } // configuraciones.nivelActual().listaMeta().any{ unaMeta => unaMeta.position() == self.position() && unaMeta.tipo() == self.tipo() }
	
	method contador(){
		if(configuraciones.nivelActual().soyUnNivelPuzzle())
		configuraciones.elcontadorDePasos().incrementar()
		configuraciones.contadorDeEmpujes().incrementar()
	}

	
}
class Oveja inherits Caja {
	override method image() = if (!self.llegoMeta()) {resolucion + "/" + stringDeObjeto + self.ultimaDireccion().toString() + ".png"} else {resolucion + "/" + stringDeObjeto + "Ok.png"}
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
class MuroVisible inherits Posicion(modoCreativo_soyUnMuro=true) {

	const property tipo = 0
	var property image = "menorResolucion/muro.png"
	
	method esPisable() = false

	override method cambiarPosicion(direccion) {
	game.say(self,"colision")
	//configuraciones.elJugador().retroceder(direccion)  //29-11-2021 Con el el metodo antiBug del jugador uno pensaria que este metodo quedo inservible pero no es asi, EN el modo creativo esto se sigue usando ya que en el jugador
	//constructor no existe el metodo antibug por lo que el jugador puede empujar una caja incluso si esta arriba de un muro (para lograr eso hay que apretar la Z obviamente)
	}
}
class Pisable inherits Posicion { 

	var property image = "menorResolucion/invisible.png"

	method esPisable() = true

	override method hacerAlgo(direccion) {
	}
	override method cambiarPosicion(unaDireccion){}
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
	override method  cambiarPosicion(direccion){
		
	}
}

object paleta {

	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"

}

class CheckpointBonus inherits Posicion (position = game.at(16, 4)) {
	var property nivelBase
	var property bonus

	override method hacerAlgo(direccion) {
		if (!nivelBase.nivelBonusHabilitado()) {
			self.error("No puedes pasar si no terminas todos los puzzles!!")
		}
		configuraciones.configStopMusic()
		game.clear()
		bonus.cargarNivel()
	}
	override method  cambiarPosicion(direccion){}

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
class ContadorDePasos inherits Posicion(position=game.at(12,5)){
	var property texto ="Moves : "
	const colorTexto="FF0000FF"

	
	var numeroDePasos=0
	
	method incrementar(){
		if(configuraciones.habilitarConteo()){
			numeroDePasos=numeroDePasos+1
		}
		
	}
	method reset(){
		numeroDePasos=0
	}
	method text()=texto+numeroDePasos.toString()
	
	method textColor()=colorTexto
	override method cambiarPosicion(direccion){	
	}
	override method hacerAlgo(direccion) {
	}
	
}
