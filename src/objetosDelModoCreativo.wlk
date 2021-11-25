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
	override method image() = resolucion + "/" + stringDeObjeto	
}

object posicionInicialDelConstructor inherits Posicion{
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
		self.validarObjetoPisable()
		nivelCreativo.agregarNuevaCajaAlaLista(unObjeto)
	}
	method generarUnaMeta(unObjeto){
		self.validadLibreMovimiento()
		self. validacionDeMetas()
		nivelCreativo.agregarNuevaMetaAlaLista(unObjeto)
	}
	method generarUnMuro(unObjeto){
		self.validadLibreMovimiento()
		self.validarObjetoPisable()
		nivelCreativo.agregarNuevoMuroAlaLista(unObjeto)	
	}
	method generarPuntoDeReinicio(){
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
	
	method validarObjetoPisable(){
		if(self.verificarQueExisteUnObjeto()){
			self.elObjetoSeraPisable()
		}
	}
	method elObjetoSeraPisable(){
		if(!self.verificarQueTodosLosObjetosSeanPisables()){
			self.error("No puedes agregar este objeto aqui")
		}	
	}
	
	method  validacionDeMetas(){
		if( self.ValidacionDobleMETA()){
			self.error("Ya existe una meta en esta posicion!!")
		}	
		if(self.validacionMetaYmuro()){
			self.error("No tiene sentido agregar una meta aqui!")
		}
	}
	method validacionMetaYmuro()=self.objetosConElQueElConstructorEstaColisionando().any({unObjeto=>unObjeto.modoCreativo_soyUnMuro()})
	
	method verificarQueTodosLosObjetosSeanPisables()=self.objetosConElQueElConstructorEstaColisionando().all({unObjeto=>unObjeto.esPisable()})
	
	method ValidacionDobleMETA()=self.objetosConElQueElConstructorEstaColisionando().any({unObjeto=>unObjeto.modoCreativo_soyMeta()})
	
	override method posicioninicial() {
		sonidoObjeto.emitirSonido("reinicio.mp3")
		self.position(posicionInicialDelConstructor.position())
	}
		
	
}