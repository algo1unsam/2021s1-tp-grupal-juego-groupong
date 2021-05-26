import wollok.game.*
import gestionDelJuego.*

/**
 * Direction Objects.
 */
object derecha{
	const property alLado = 1
	method mover(_objeto){ _objeto.position(_objeto.position().right(1)) }
	method mover(_objeto,_cant){ _objeto.position(_objeto.position().right(_cant)) }
	
	method proximaPosRotacion(_posBloque, _posPrimerBloque) {
		const desplazamiento = game.at((_posPrimerBloque.x() - _posBloque.x()), (_posPrimerBloque.y() - _posBloque.y()))
		return game.at((-desplazamiento.y() + _posPrimerBloque.x()), (desplazamiento.x()  + _posPrimerBloque.y()))	
	}
	
	method rotar(_objeto){ 
		(_objeto.bloques()).forEach({bloque =>
			const nuevaPos = self.proximaPosRotacion(bloque.position(), _objeto.bloqueCentral().position()) 
			bloque.position(nuevaPos)
		})
	}
}

object izquierda{
	const property alLado = -1
	method mover(_objeto){ _objeto.position(_objeto.position().left(1)) }
	method mover(_objeto,_cant){ _objeto.position(_objeto.position().left(_cant)) }
	
	method proximaPosRotacion(_posBloque, _posPrimerBloque) {
		const desplazamiento = game.at((_posBloque.x() - _posPrimerBloque.x()), (_posBloque.y() - _posPrimerBloque.y()))
		return game.at((-desplazamiento.y() + _posPrimerBloque.x()), (desplazamiento.x()  + _posPrimerBloque.y()))	
	}
	
	method rotar(_objeto){ 
		(_objeto.bloques()).forEach({bloque =>
			const nuevaPos = self.proximaPosRotacion(bloque.position(), _objeto.bloqueCentral().position()) 
			bloque.position(nuevaPos)
		})
	}
}

object arriba{
	method mover(_objeto){ _objeto.position(_objeto.position().up(1)) }
	method mover(_objeto,_cant){ _objeto.position(_objeto.position().up(_cant)) }
}

object abajo{
	method mover(_objeto){ _objeto.position(_objeto.position().down(1)) }
	method mover(_objeto,_cant){ _objeto.position(_objeto.position().down(_cant)) }
}

/**
 * Configuration of game, keyboard, collisions, timers, etc...
 */
object configuracion{
	/**
	 *	Configure the keys for focus the block.
	 */
	/*
	method configurarTeclasPara(_tetromino) { // Configuracion de las teclas 
		keyboard.up().onPressDo		{_tetromino.rotar(derecha)	}		//Up Arrow
		keyboard.down().onPressDo	{_tetromino.bajar()			}		//Down Arrow
		keyboard.right().onPressDo	{_tetromino.moverDerecha()	}		//Right Arrow
		keyboard.left().onPressDo	{_tetromino.moverIzquierda()}		//Left Arrow
		keyboard.space().onPressDo	{_tetromino.caer()			}		//Space
		keyboard.z().onPressDo		{_tetromino.rotar(izquierda)}		//z
	}*/
	
	method configurarTeclasPara(_manipulador) { // Configuracion de las teclas 
		keyboard.up().onPressDo		{_manipulador.rotar(derecha)	}		//Up Arrow
		keyboard.down().onPressDo	{_manipulador.bajar()			}		//Down Arrow
		keyboard.right().onPressDo	{_manipulador.moverDerecha()	}		//Right Arrow
		keyboard.left().onPressDo	{_manipulador.moverIzquierda()}		//Left Arrow
		keyboard.space().onPressDo	{_manipulador.caer()			}		//Space
		keyboard.z().onPressDo		{_manipulador.rotar(izquierda)}		//z
		keyboard.r().onPressDo		{gestionDelJuego.resetear()}
	}
	
	method desConfigurarTeclasPara(_tetromino) { /* Configuracion de las teclas */
		keyboard.up().onPressDo{}		//Up Arrow
		keyboard.down().onPressDo{}		//Down Arrow
		keyboard.right().onPressDo{}	//Right Arrow
		keyboard.left().onPressDo{}		//Left Arrow
		keyboard.space().onPressDo{}	//Space
		keyboard.z().onPressDo{}		//z
	}
	
	method configurarMusica(_music){
		const music = game.sound(_music)
		music.shouldLoop(true)
		music.volume(0.2)
		game.onTick(100, "MUSICA", {
			if(not music.played())
				music.play()
		})
	}
}