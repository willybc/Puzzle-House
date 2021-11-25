import wollok.game.*
import direcciones.*
import configuraciones.*
import niveles.*
import jugador.*
import sonido.*
import nivelB.*
import objetos.*
import creativo.*


class CajaEstatica inherits  Caja{ //Esta caja no cambia de color cuando llega a su meta. Ganamos mucho rendimiento si el pre calculo de la imagen es lo menos complicado posible. Estas cajas solo son usadas en el nivel creativo 

	override method image() =if(!configuraciones.nivelActual().soyUnNivelCreativo()){self.imagenARetornar()}else{resolucion + "/" + stringDeObjeto}

	method imagenARetornar()=  if (self.llegoMeta()) {resolucion + "/" + cajaEnMeta} else {	resolucion + "/" + stringDeObjeto}

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

	method activarVerificador(){
		if(configuraciones.nivelActual().soyUnNivelCreativo()){
			configuraciones.nivelActual().verificarMetas()
		}
	}
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

/* 
class PosicionInicialDelConstructor inherits Posicion{
	
	method image()="menorResolucion/checkpoint.png"
	override method hacerAlgo(direccion) {	
	}
	
}
*/

class JugadorConstructor inherits Jugador{
	
	

	method posicionActual()=self.position()
	
	method TeclasDelConstructor(){

		keyboard.num1().onPressDo{self.generarUnaCaja(new CajaEstatica(position =self.position(),stringDeObjeto="caja1.png",cajaEnMeta="caja_ok.png",tipo=1))}
		keyboard.num2().onPressDo{self.generarUnaCaja(new CajaEstatica(position =self.position(),stringDeObjeto="caja2.png",cajaEnMeta="caja_ok2.png",tipo=2))}
		keyboard.num3().onPressDo{self.generarUnaMeta( new Meta(position =self.position(),image="menorResolucion/meta1.png",modoCreativo_soyMeta=true))}
		keyboard.num4().onPressDo{self.generarUnaMeta( new Meta(position =self.position(),image="menorResolucion/meta2.png",tipo=2,modoCreativo_soyMeta=true))}
	    keyboard.num5().onPressDo{self.generarUnMuro( new MuroVisible(position =self.position(),image="menorResolucion/muro3.png",modoCreativo_soyUnMuro=true))}
	    keyboard.num6().onPressDo{self.generarUnMuro( new MuroVisible(position =self.position(),image="menorResolucion/muro2.png",modoCreativo_soyUnMuro=true))}
	    keyboard.shift().onPressDo{self.eliminarObjeto()}
		keyboard.control().onPressDo{self.generarPuntoDeReinicio()}
		keyboard.e().onPressDo{nivelCreativo.salirDelNivel()}
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
		self.validadLibreMovimiento()
		/* 
		if(!self.verificarQueExisteUnObjeto()){
			
			self.error("No hay nada que eliminar aqui")
		}
		*/
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

}
object nivelCreativoJugar inherits Nivel (siguienteNivel = nivelCreativo){
	
	const jugador1 = new Jugador(position = game.at(10, 10 ) , resolucion="menorResolucion",nombreJugador = "jugadora1")
	
	const listaMeta =[ ]
	const listaCajas=[  ]

	method cargarNivel(){
		
		configuraciones.configMusic("niveL.mp3")
		game.addVisual(self)
		self.cargarObjetos(listaMeta)
		self.cargarObjetos(listaCajas)
		self.generarMuros()
		game.addVisual(jugador1)
		configuraciones.nivelActual(self)	
		self.configNivel(jugador1)
	
	}
	
	method generarMuros(){
		
		
	}
	
	method image() = "menorResolucion/modoLibre.png"
	method position()=game.at(0,0)
	
	override method listaCajas() = listaCajas

 	method listaMeta()= listaMeta

}