import 'constraint.dart';
import 'tile.dart';

class GameBoard {
	final int size;
	List<List<GameTile>> tiles;
	List<List<GameConstraint>> horizontalConstraints;
	List<List<GameConstraint>> verticalConstraints;

	GameBoard(this.size) {
		tiles = List.generate(size, (i) => List<GameTile>.generate(size, (i) => GameTile()));
		horizontalConstraints = List.generate(size, (i) => List<GameConstraint>.generate(size - 1, (i) => null));
		verticalConstraints = List.generate(size - 1, (i) => List<GameConstraint>.generate(size, (i) => null));
	}

	GameBoard.from(GameBoard other) : size = other.size {
		tiles = List.generate(size, (y) => List<GameTile>.generate(size, (x) => GameTile.from(other.tiles[y][x])));
		horizontalConstraints = List.generate(size, (y) => List<GameConstraint>.generate(size - 1, (x) => GameConstraint.from(other.horizontalConstraints[y][x])));
		verticalConstraints = List.generate(size, (y) => List<GameConstraint>.generate(size - 1, (x) => GameConstraint.from(other.verticalConstraints[y][x])));
	}
}