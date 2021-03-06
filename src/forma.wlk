import wollok.game.*
import color.*
import bloque.*
import extras.*

/**
 * Forma Class.
 * Collection of blocks that form Tetrominos and behave in a similar way to each other.
 */
class Forma {
	/**
	 *	Attributtes for manipulating the shape or Tetromino.
	 */
	var property bloques		//The first Tetromino in the list should be the central block.
	var estancado = false		//block stagnant flag
	
	/**
	 *	Forma class Constructor. 
	 */
	constructor(){}
	
	/**
	 *	Specify the Tetromino's color.
	 */
	method color() = azul
	
	/**
	 *	Returns the Tetromino's center block.
	 */
	method bloqueCentral() = bloques.first()
	
	/**
	 *	Rotate the tetromino to the right or left.
	 */
	method rotar(_direction){/*Metodo para rotar la pieza*/
		if((self.calculaPosRotacion(_direction)).any({pos => not self.hayOtroObjetoEn(pos)}))
			return 0
		
		if(self.puedeRotar(_direction)){
			_direction.rotar(self)
			return 0
		}
		
		const desplazamiento = self.calcularDesplazamientoEnRotacion(_direction)
		bloques.forEach{ _bloque => _bloque.mover(_direction, desplazamiento) }
		
		return self.rotar(_direction)
	}
	
	/**
	 *	Determines the direction of displacement of the Tetromino if can't rotate.
	 */
	method calcularDesplazamientoEnRotacion(_direction) =
		if(self.verificarDesplazamientoEnRotacion(_direction)) 1
		else -1
	
	/**
	 *	Check if the tetromino can rotate.
	 */
	method verificarDesplazamientoEnRotacion(_direction) =
		_direction.equals(derecha) and bloques.any({bloque => bloque.position().x() <= 0})   or
		_direction.equals(derecha) and bloques.all({bloque => bloque.position().x() == 1})   or
		_direction.equals(izquierda) and bloques.any({bloque => bloque.position().x() >= 8})
	
	/**
	 *	Return a list with the positions of the blocks .
	 */
	 method calculaPosRotacion(_direction) {
	 	return bloques.map({
	 		bloque => _direction.proximaPosRotacion(bloque.position(), self.bloqueCentral().position())
	 	})
	 }
	 
	 /**
	 *	Return if the Tetromino can rotate to axis x.
	 */
	 method puedeRotarX(_direction) =
	 			self.calculaPosRotacion(_direction).all{pos => pos.x().between(0, 9)}
	 
	 /**
	 *	Return if the Tetromino can rotate to axis y.
	 */
	 method puedeRotarY(_direction) {
	 	if((self.calculaPosRotacion(_direction)).all({pos => pos.y() >= 0}))
	 		return true
	 	bloques.forEach{_bloque => arriba.mover(_bloque)}
	 	return self.puedeRotarY(_direction)
	 }
	
	/**
	 *	Return if the Tetromino can rotate to the right or left.
	 */
	method puedeRotar(_direction) {
		return self.puedeRotarX(_direction) and self.puedeRotarY(_direction)
	}
	
	/**
	 *	Move to the right the tetromino if it can.
	 */
	method moverDerecha(){
		if(not self.colisionaConPared(derecha))
			bloques.forEach{_bloque => _bloque.irDerecha()}
	}
	
	/**
	 *	Move to the left the tetromino if it can.
	 */
	method moverIzquierda(){
		if(not self.colisionaConPared(izquierda))
			bloques.forEach{_bloque => _bloque.irIzquierda()}
	}
	
	/**
	 *	  Move down the tetromino if it can.
	 */
	method bajar(){
		if(not self.colisionaConPiso())
			bloques.forEach{_bloque => _bloque.bajar()}
		else self.estancar()
	}
	
	/**
	 *	Drop the Tetromino until it collides with the ground.
	 */
	method caer(){
		new Range(start = 0, end = 22, step = 1).forEach{_r => 
			if(self.colisionaConPiso()){
				self.estancar()	
				return 0
			} self.bajar()
		}
	}
	
	/**
	 *	Move the Tetromino to another position on the map, _pos is the center block position
	 */
	method posicionar(_pos){
		const deltaX = _pos.x() - self.bloqueCentral().position().x()
    	const deltaY = _pos.y() - self.bloqueCentral().position().y()
    	bloques.forEach{_bloque => _bloque.mover(derecha,deltaX)}
		bloques.forEach{_bloque => _bloque.mover(arriba,deltaY)}	
	}
	
	/**
	 *	Stall the tetromino in its current position.
	 */
	method estancar(){ estancado = true }
	
	/**
	 *	Return if the Tetrimonio is stalled
	 */
	method estaEstancado() = estancado
	
	/**
	 *	Returns if there is another object in a position that is not part of our Tetromino.
	 */									
	method hayOtroObjetoEn(pos) =
			game.getObjectsIn(pos).isEmpty() or
			bloques.contains(game.getObjectsIn(pos).first())
	
	/**
	 *	Returns if the tetromino can move to the left or right without collide with a wall or another object.
	 */
	method colisionaConPared(_lado) =
			not bloques.all{ _bloque => (_bloque.position().x() + _lado.alLado()).between(0,9) and
										self.hayOtroObjetoEn(_bloque.position().right(_lado.alLado())) }
	
	/**
	 *	Returns if the tetromino can go down without collide with the ground or with another blocks in the ground or another object
	 */
	method colisionaConPiso() =
			not bloques.all{ _bloque => _bloque.position().y() != 0 and
										self.hayOtroObjetoEn(_bloque.position().down(1)) }
	
	//wollok game
	/**
	 *	Create the image and appear in the specified position for that Tetromino.
	 */
	method aparecer(){ 
		self.crearForma()
		bloques.forEach{_bloque => game.addVisual(_bloque)}
	}
	
	/**
	 *	Method to create the Tetrominos by positioning each block in its initial position.
	 */
	method crearForma(){} //It is not an abstract method cause we use Forma class for tests.
}

//---------------------------------------------------------------------------------------------
//------Different Tetrominos-------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
/**
 * FormaI Class.
 * Stick Tetromino, light blue.
 */
class FormaI inherits Forma{
	override method color() = celeste
	
	override method crearForma(){
		bloques = [	new Bloque(position = game.at(4,20)),
				  	new Bloque(position = game.at(5,20)),
				  	new Bloque(position = game.at(3,20)),
				  	new Bloque(position = game.at(6,20))]
		bloques.forEach{_bloque => _bloque.color(self.color())}
	}
}

/**
 * FormaJ Class.
 * J character Tetromino, blue.
 */
class FormaJ inherits Forma{
	override method crearForma(){
		bloques = [	new Bloque(position = game.at(4,20)),
				  	new Bloque(position = game.at(5,20)),
				  	new Bloque(position = game.at(3,20)),
				  	new Bloque(position = game.at(3,21))]
		bloques.forEach{_bloque => _bloque.color(self.color())}
	}
}

/**
 * FormaL Class.
 * L character Tetromino, orange.
 */
class FormaL inherits Forma{
	override method color() = naranja
	
	override method crearForma(){
		bloques = [	new Bloque(position = game.at(4,20)),
				  	new Bloque(position = game.at(5,21)),
				  	new Bloque(position = game.at(5,20)),
				  	new Bloque(position = game.at(3,20))]
		bloques.forEach{_bloque => _bloque.color(self.color())}
	}
}

/**
 * FormaO Class.
 * Square Tetromino, yellow.
 */
class FormaO inherits Forma{
	override method color() = amarillo
	
	override method rotar(_direction) = false 
	override method crearForma(){
		bloques = [	new Bloque(position = game.at(4,20)),
				  	new Bloque(position = game.at(5,20)),
				  	new Bloque(position = game.at(4,19)),
				  	new Bloque(position = game.at(5,19))]
		bloques.forEach{_bloque => _bloque.color(self.color())}
	}
}

/**
 * FormaS Class.
 * S character Tetromino, green.
 */
class FormaS inherits Forma{
	override method color() = verde

	override method crearForma(){
		bloques = [	new Bloque(position = game.at(4,20)),
				  	new Bloque(position = game.at(3,20)),
				  	new Bloque(position = game.at(4,21)),
				  	new Bloque(position = game.at(5,21))]
		bloques.forEach{_bloque => _bloque.color(self.color())}
	}
}

/**
 * FormaT Class.
 * T character Tetromino, purple.
 */
class FormaT inherits Forma{
	override method color() = violeta
	
	override method crearForma(){
		bloques = [	new Bloque(position = game.at(4,20)),
				  	new Bloque(position = game.at(5,20)),
				  	new Bloque(position = game.at(3,20)),
				  	new Bloque(position = game.at(4,21))]
		bloques.forEach{_bloque => _bloque.color(self.color())}
	}
}

/**
 * FormaZ Class.
 * Z character Tetromino, red.
 */
class FormaZ inherits Forma{
	override method color() = rojo

	override method crearForma(){
		bloques = [	new Bloque(position = game.at(4,20)),
				  	new Bloque(position = game.at(5,20)),
				  	new Bloque(position = game.at(4,21)),
				  	new Bloque(position = game.at(3,21))]
		bloques.forEach{_bloque => _bloque.color(self.color())}
	}
}
