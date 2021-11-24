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

class JugadorConstructor inherits Jugador{
	

	method posicionActual()=self.position()
	
	method TeclasDelConstructor(){

		keyboard.num1().onPressDo{self.generarUnaCaja(new CajaEstatica(position =self.position(),stringDeObjeto="caja1.png",cajaEnMeta="caja_ok.png",tipo=1))}
		keyboard.num2().onPressDo{self.generarUnaCaja(new CajaEstatica(position =self.position(),stringDeObjeto="caja2.png",cajaEnMeta="caja_ok2.png",tipo=2))}
		keyboard.num3().onPressDo{self.generarUnaMeta( new Meta(position =self.position(),image="menorResolucion/meta1.png"))}
		keyboard.num4().onPressDo{self.generarUnaMeta( new Meta(position =self.position(),image="menorResolucion/meta2.png",tipo=2))}
	    keyboard.num5().onPressDo{self.generarUnMuro( new MuroVisible(position =self.position(),image="menorResolucion/muro3.png"))}
	    keyboard.num6().onPressDo{self.generarUnMuro( new MuroVisible(position =self.position(),image="menorResolucion/muro2.png"))}
	    keyboard.shift().onPressDo{self.eliminarObjeto()}
		
		keyboard.e().onPressDo{nivelCreativo.salirDelNivel()}
	}
	method validadLibreMovimiento(){
		if(!configuraciones.libreMoviento()){
			self.error("Presiona la Z primero")
		}
	}
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
	method eliminarObjeto(){
		if(!self.verificarQueExisteUnObjetoEliminable()){
			self.validadLibreMovimiento()
			self.error("No hay nada que eliminar aqui")
		}
		game.say(self,self.elObjetoAEliminar().toString())
		nivelCreativo.borrarUnaCajaEnParticular(self.elObjetoAEliminar())
		self.elObjetoAEliminar().modoCreativoBorrarVisual()
		
		
	}
	method verificarQueExisteUnObjetoEliminable(){
		return game.colliders(self).size()>0
	}
	method elObjetoAEliminar(){
		return game.uniqueCollider(self)
	}
	
}