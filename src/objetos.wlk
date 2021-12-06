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
class Estatico inherits Posicion {
	override method cambiarPosicion(direccion){	
	}
	override method hacerAlgo(direccion) {
	}
}
class Posicion {
	var property ultimaDireccion = abajo
	var property position = game.origin()
	var property posicionInicial = position
	const property modoCreativo_soyMeta = false
	const property modoCreativo_soyUnMuro = false
	const property modoCreativo_soyUnPuntoDeReinicio = false
	const property soyUnaCaja=false //agregado el 3/12/2021 para el contador de movimientos
	var property quieroAgregarAlTablero = true
	var property estaBloqueado=false
	var property tipo=100

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
	var property yaEstubeEnMeta=false
	const resolucion = "menorResolucion"
	const stringDeObjeto = "caja1.png"
	const cajaEnMeta = "caja_ok.png"
	
	var property elCaballoSeTrabo = false
	const sonido = "caja_mover2.mp3"
	
	var property estoyEnMeta=false

	method esPisable() = false

	method image() = if (self.estoyEnMeta()) {resolucion + "/" + cajaEnMeta} else {	resolucion + "/" + stringDeObjeto}

	override method cambiarPosicion(direccion) {
		const siguienteUbicacion = direccion.moverse(self)
		ultimaDireccion = direccion
		if (self.proximaUbicacionLibre(siguienteUbicacion)) {
			self.position(direccion.moverse(self))
			self.contador()
			self.activarVerificador()
		} else {
			configuraciones.elJugador().retroceder(direccion)
			
			
		}
		sonidoObjeto.emitirSonido(sonido)
	}
	
	method activarVerificador(){
		
		if(self.llegoMeta()){
				estoyEnMeta=true
				configuraciones.nivelActual().verificarMetas()
				if(configuraciones.nivelActual().soyUnNivelHardcoreTime()){self.modoCronometro()}
			}
			else{
				
				estoyEnMeta=false
			}
		
	}
	
	method modoCronometro(){
		
		if(!self.yaEstubeEnMeta()){
					configuraciones.nivelActual().cronometro().sumarSegundos()
					yaEstubeEnMeta=true
		}
		
		
		
	}
	
	method proximaUbicacionLibre(direccion) = game.getObjectsIn(direccion).all{ unObj => unObj.esPisable() }
	
	method coordenadaX()=position.x()
	method coordenadaY()=position.y()

	method llegoMeta() = game.colliders(self).any{ unaMeta => unaMeta.position() == self.position() && unaMeta.tipo() == self.tipo() } // configuraciones.nivelActual().listaMeta().any{ unaMeta => unaMeta.position() == self.position() && unaMeta.tipo() == self.tipo() }
	
	method contador(){
		if(configuraciones.nivelActual().soyUnNivelPuzzle())
		configuraciones.elcontadorDePasos().incrementar()
		configuraciones.contadorDeEmpujes().incrementar()
	}

}







class Oveja inherits Caja {
	override method image() = if (!self.estoyEnMeta()) {resolucion + "/" + stringDeObjeto + self.ultimaDireccion().toString() + ".png"} else {resolucion + "/" + stringDeObjeto + "Ok.png"}
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
			self.contador()
			self.activarVerificador()
			seTrabo = false
		} else {
			seTrabo = true
		}
	}

}
class MuroVisible inherits Posicion(modoCreativo_soyUnMuro=true) {

	
	var property image = "menorResolucion/muro.png"
	
	method esPisable() = false

	override method cambiarPosicion(direccion) {
	
	configuraciones.elJugador().retroceder(direccion)  //29-11-2021 Con el el metodo antiBug del jugador uno pensaria que este metodo quedo inservible pero no es asi, EN el modo creativo esto se sigue usando ya que en el jugador
	//constructor no existe el metodo antibug por lo que el jugador puede empujar una caja incluso si esta arriba de un muro (para lograr eso hay que apretar la Z obviamente)
	}
}
class Pisable inherits Estatico { 

	var property image = "menorResolucion/invisible.png"

	method esPisable() = true

	
}
class Checkpoint inherits Pisable {

	var property siguienteNivel
	

	override method hacerAlgo(direccion) {
		configuraciones.configStopMusic()
		game.clear()
		siguienteNivel.cargarNivel()
	}
}
class Meta inherits Pisable(tipo=1) {
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

class CheckpointBonus inherits Estatico (position = game.at(16, 4)) {
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
	

}
class CambiarRopa  inherits Estatico(position = game.at(6, 5)){

	var vestimenta
	override method hacerAlgo(direccion) {
		configuraciones.elJugador().nombreJugador(vestimenta)
		configuraciones.elJugador().retroceder(direccion)
		pasadizo.vestimenta(vestimenta)
	}
	
}
class ContadorDePasos inherits Estatico(position=game.at(12,5)){
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
	
	
	
	
}
class Cronometro inherits Estatico(position=game.at(1,3)){
	var property segundos=8
	var property nivelCompletado=false
	var property segundoDeReset=8
	var property bonificacionDeSegundos=7
	//method image()="menorResolucion/reloj.png"
	
	method descontar(){
		if(segundos>0){
			segundos=segundos-1
		}
		else{
			self.reset()
			configuraciones.nivelActual().reiniciarNivel()
		}		
	}
	
	method sumarSegundos(){
		segundos=segundos+bonificacionDeSegundos
	}
	
	method reset(){
		segundos=segundoDeReset
	}
	
	method text()=if(!self.nivelCompletado()){self.segundos().toString()}else{"FELICITACIONES"}
	
	method activarCronometro(){
		game.onTick(1000,"Cronometro",{self.descontar()})
	}
	
	method desactivarCronometro(){
		game.removeTickEvent("Cronometro")
		nivelCompletado=true
	}
	
	method esPisable()=true
	
}

