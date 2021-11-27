import wollok.game.*
import jugador.*
import objetos.*
import objetosDelModoCreativo.*

object izquierda{
	
	method moverse(unObjeto) = unObjeto.position().left(duplicaDireccion.direccionDuplicador()) //
	method dirOpuesto(unObjeto) = unObjeto.position().right(duplicaDireccion.direccionDuplicador())
	method cambiarCoordenada(){
		laPosicion.cambiarValorDeX(-1)
	}
	method cambiarCoordenadaOpuesto(){
		laPosicion.cambiarValorDeX(1)
	}
}
object derecha{
	
	method moverse(unObjeto) = unObjeto.position().right(duplicaDireccion.direccionDuplicador())
	method dirOpuesto(unObjeto) = unObjeto.position().left(duplicaDireccion.direccionDuplicador())
	method cambiarCoordenada(){
		laPosicion.cambiarValorDeX(1)
	}
	method cambiarCoordenadaOpuesto(){
		laPosicion.cambiarValorDeX(-1)
	}
}
object abajo{

	method moverse(unObjeto) = unObjeto.position().down(duplicaDireccion.direccionDuplicador())
	method dirOpuesto(unObjeto) = unObjeto.position().up(duplicaDireccion.direccionDuplicador())
	method cambiarCoordenada(){
		laPosicion.cambiarValorDeY(-1)
	}
	method cambiarCoordenadaOpuesto(){
		laPosicion.cambiarValorDeY(1)
	}
}
object arriba{	
	
	method moverse(unObjeto) = unObjeto.position().up(duplicaDireccion.direccionDuplicador())
	method dirOpuesto(unObjeto) = unObjeto.position().down(duplicaDireccion.direccionDuplicador())
	method cambiarCoordenada(){
		laPosicion.cambiarValorDeY(1)
	}
	method cambiarCoordenadaOpuesto(){
		laPosicion.cambiarValorDeY(-1)
	}
} 

object duplicaDireccion{
	var property direccionDuplicador = 1 

}

object laPosicion{

	var property flagPermitirSumarUnaUnidad=true
	var property flagPermitirRestarSoloUnaVez=true
	var xGuardar=0
	var xAcumulativo=0
	var property x=posicionInicialDelConstructor.coordenadaX()
	var property y=posicionInicialDelConstructor.coordenadaY()
	var property position=game.origin()
	
	method cambiarValorDeX(unValor){
	
			x=x+unValor
	
	}
	method cambiarValorDeY(unValor){
		
			y=y+unValor

	
	}
	method text() =self.x().toString() +"," + self.y().toString() 
	
	method reiniciarPosiciones(){
		x=posicionInicialDelConstructor.coordenadaX()
		y=posicionInicialDelConstructor.coordenadaY()
	}
	method hacerAlgo(nada){
		
	}

}