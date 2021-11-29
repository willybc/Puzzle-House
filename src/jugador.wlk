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
		self.verificarColisionConMuro(direccion)
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
	
	method moverse(direccion) {
		ultimaDireccion=direccion
		self.position(direccion.moverse(self))
		sonidoObjeto.emitirSonido("pasosf.mp3")
	}
	
	method verificarColisionConMuro(direccion) { // 29/11/2021 El muro tiene un metodo llamado  cambiarPosicion  que lo que haces es que cuando un jugador colisiona con un muro este ultimo hace retroceder al jugador una posicion hacia atras, impidiendo de esta forma atravesar paredes al jugador !!  sin embargo si apretabamos por ejemplo arriba y derecha muchas veces cuando estamos al lado de un muro
		//era posible atravesarlos (BUG) y por lo tanto hacer tramapa...  un familiar mio probando el juego descubrio este fallo que nosotros callabamos y lo empezo a utilizar para terminar los puzzles, la verdad no me gusto para nada  y me dio a entender que cualquiera que juegue al juego sin ayuda tarde o temprano descubre el bug por efecto de desesperacion de mover
		//al jugador lo mas rapido posible y mover al jugador de esa forma aumenta muchisimo la posibilidad de que alguien descubra ese BUG.
		//Este metodo Soluciona eso basicamente ya que el metodo moverse unicamente se ejecuta si se cumple varias condiciones. Uno podria pensar que se esta matando el polimorfismo cambiarPosicion del muro ya que queda inutil pero no es asi. El metodo verificarColisionConMuro no existe
		//en el jugadorConstructor del modo creativo!! Ya que ahi no nos interesa si el jugador buguea el juego ya que existe la Z que basicamente desactiva las colisiones ¿Tiene sentido hacer trampa ahi? Aun asi cuando ejecutamos el puzzle que creamos en el modo creativo ahi si nuevamente verificarColisionConMuro cobra importancia
		//ya que ahi dejamos de controlar al jugadorConstructor y pasamos a controla a una nueva clase de jugador llamado JugadorDelNivelCreado
		if (self.verificarQueNoHayaUnMuroAdelante()) {
			self.verificarSiElModoLibreEstaActivado(direccion)
		} else {
			self.moverse(direccion)
		}
	}
	method verificarSiElModoLibreEstaActivado(direccion){
		if (configuraciones.libreMoviento()) {
				self.moverse(direccion)
		}
	}
	//Se va achicar la cantidad de ifs antes de entregar el juego al CONCURSO!!
	
	method verificarQueNoHayaUnMuroAdelante()=game.colliders(self).any({unObjeto=>unObjeto.modoCreativo_soyUnMuro()}) //29/11/2021 REUTILIZAMOS UN ATRIBUTO Del modo creativo para no crear uno nuevo que haga basicamente lo mismo
	
	
}

	