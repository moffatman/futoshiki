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
}