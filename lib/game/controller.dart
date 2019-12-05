import 'dart:async';

import 'move.dart';
import 'board.dart';
import 'constraint.dart';

class GameController {
	final int size;
	List<GameMove> moves = List<GameMove>();
	List<GameAppliedConstraint> constraints = List<GameAppliedConstraint>();
	Stream<GameBoard> board;
	StreamController<GameBoard> _boardController;
	GameBoard _board;
	
	GameController(this.size) {
		_boardController = StreamController<GameBoard>();
		board = _boardController.stream;
		_regenerateBoard();
		_boardController.add(_board);
	}

	void _regenerateBoard() {
		_board = GameBoard(size);
		moves.forEach(_playMove);
	}

	bool get canUndo {
		return (moves.last != null) && !moves.last.locked;
	}

	void undo() {
		moves.removeLast();
		_regenerateBoard();
	}

	void _playMove(GameMove move) {
		final tile = _board.tiles[move.y][move.x];
		if (move.type == GameMoveType.Play) {
			tile.errorChildren.forEach((childTile) {
				childTile.errorParents.remove(tile);
			});
			tile.errorChildren.clear();
			tile.errorParents.forEach((parentTile) {
				parentTile.errorChildren.remove(tile);
			});
			tile.errorParents.clear();
			if (tile.value == move.value) {
				tile.value = 0;
				_checkConstraints();
			}
			else {
				// check constraints
				final rowDuplicates = _board.tiles[move.y].where((otherTile) => otherTile.value == move.value);
				if (rowDuplicates.length > 0) {
					final list = rowDuplicates.toList();
					list.sort((a, b) => a.errorParents.length - b.errorParents.length);
					list.first.errorChildren.add(tile);
					tile.errorParents.add(list.first);
				}
				final columnDuplicates = _board.tiles.map((row) => row[move.x]).where((otherTile) => otherTile.value == move.value);
				if (columnDuplicates.length > 0) {
					final list = columnDuplicates.toList();
					list.sort((a, b) => a.errorParents.length - b.errorParents.length);
					list.first.errorChildren.add(tile);
					tile.errorParents.add(list.first);
				}
				_board.tiles[move.y][move.x].value = move.value;
				_checkConstraints();
			}
		}
		else {
			if (tile.notes.contains(move.value)) {
				tile.notes.remove(move.value);
			}
			else {
				tile.notes.add(move.value);
			}
		}
	}

	void playMove(GameMove move) {
		moves.add(move);
		_playMove(move);
		_boardController.add(_board);
	}

	void addConstraint(GameAppliedConstraint constraint) {
		if (constraint.ax > (size - 2)) {
			throw Exception("addConstraint called with too high 'ax' value");
		}
		if (constraint.ay > (size - 2)) {
			throw Exception("addConstraint called with too high 'ay' value");
		}
		constraints.add(constraint);
		if (constraint.direction == GameConstraintDirection.Horizontal) {
			_board.horizontalConstraints[constraint.ay][constraint.ax] = GameConstraint(constraint.type);
		}
		else if (constraint.direction == GameConstraintDirection.Vertical) {
			_board.verticalConstraints[constraint.ay][constraint.ax] = GameConstraint(constraint.type);
		}
	}

	void _checkConstraints() {
		constraints.forEach((constraint) {
			final tile = _board.tiles[constraint.ay][constraint.ax];
			if (tile.value > 0) {
				if (constraint.direction == GameConstraintDirection.Horizontal) {
					_board.horizontalConstraints[constraint.ax][constraint.ay].status = constraint.check(tile.value, _board.tiles[constraint.ay][constraint.ax + 1].value);
				}
				else if (constraint.direction == GameConstraintDirection.Vertical) {
					_board.verticalConstraints[constraint.ax][constraint.ay].status = constraint.check(tile.value, _board.tiles[constraint.ay + 1][constraint.ax].value);
				}
			}
		});
	}
}