import 'dart:async';
import 'dart:math';

import 'package:futoshiki/game/solver.dart';

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
		print('_playMove: [${move.x}, ${move.y}], ${move.value}');
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
				tile.locked = false;
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
				_board.tiles[move.y][move.x].locked = move.locked;
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
		print('AddConstraint: [${constraint.ax}, ${constraint.ay}], ${constraint.direction}, ${constraint.type}');
		if (constraint.ax > (size - 1)) {
			throw Exception("addConstraint called with too high 'ax' value: ${constraint.ax}");
		}
		if (constraint.ay > (size - 1)) {
			throw Exception("addConstraint called with too high 'ay' value : ${constraint.ay}");
		}
		if (constraint.direction == GameConstraintDirection.Horizontal) {
			if (constraint.ax > (size - 2)) {
				throw Exception("addConstraint called with too high 'ax' value: ${constraint.ax}");
			}
			if (_board.horizontalConstraints[constraint.ay][constraint.ax] != null) {
				print("Duplicate horizontal constraint at [${constraint.ax}, ${constraint.ay}]");
				print(constraints);
				constraints.removeWhere((otherConstraint) => (otherConstraint.ax == constraint.ax) && (otherConstraint.ay == constraint.ay));
				print(constraints);
			}
			_board.horizontalConstraints[constraint.ay][constraint.ax] = GameConstraint(constraint.type);
		}
		else if (constraint.direction == GameConstraintDirection.Vertical) {
			if (constraint.ay > (size - 2)) {
				throw Exception("addConstraint called with too high 'ay' value : ${constraint.ay}");
			}
			if (_board.verticalConstraints[constraint.ay][constraint.ax] != null) {
				print("Duplicate vertical constraint at [${constraint.ax}, ${constraint.ay}]");
				print(constraints);
				constraints.removeWhere((otherConstraint) => (otherConstraint.ax == constraint.ax) && (otherConstraint.ay == constraint.ay));
				print(constraints);
			}
			_board.verticalConstraints[constraint.ay][constraint.ax] = GameConstraint(constraint.type);
		}
		constraints.add(constraint);
		_boardController.add(_board);
	}

	void _checkConstraints() {
		constraints.forEach((constraint) {
			if (constraint.direction == GameConstraintDirection.Horizontal) {
				_board.horizontalConstraints[constraint.ay][constraint.ax].status = constraint.check(_board.tiles[constraint.ay][constraint.ax].value, _board.tiles[constraint.ay][constraint.ax + 1].value);
			}
			else if (constraint.direction == GameConstraintDirection.Vertical) {
				_board.verticalConstraints[constraint.ay][constraint.ax].status = constraint.check(_board.tiles[constraint.ay][constraint.ax].value, _board.tiles[constraint.ay + 1][constraint.ax].value);
			}
		});
	}

	void generateBoard() {
		Random random = Random();
		for (int i = 0; i < 10000; i++) {
			print("Iteration $i");
			final addConstraintNow = random.nextInt(10) < 4;
			if (addConstraintNow) {
				if (random.nextBool()) {
					// horizontal
					final x = random.nextInt(size - 1);
					final y = random.nextInt(size);
					if (random.nextBool()) {
						addConstraint(GameConstraintGreaterThan(ax: x, ay: y, direction: GameConstraintDirection.Horizontal));
					}
					else {
						addConstraint(GameConstraintLessThan(ax: x, ay: y, direction: GameConstraintDirection.Horizontal));
					}

					final classification = classifyBoard(_board, constraints);
					print(classification);
					if (classification == GameSolvabilityClassification.NoSolution) {
						_board.horizontalConstraints[y][x] = null;
						constraints.removeLast();
					}
					else if (classification == GameSolvabilityClassification.OneSolution) {
						break;
					}
				}
				else {
					// vertical
					final x = random.nextInt(size);
					final y = random.nextInt(size - 1);
					if (random.nextBool()) {
						addConstraint(GameConstraintGreaterThan(ax: x, ay: y, direction: GameConstraintDirection.Vertical));
					}
					else {
						addConstraint(GameConstraintLessThan(ax: x, ay: y, direction: GameConstraintDirection.Vertical));
					}

					final classification = classifyBoard(_board, constraints);
					print(classification);
					if (classification == GameSolvabilityClassification.NoSolution) {
						_board.verticalConstraints[y][x] = null;
						constraints.removeLast();
					}
					else if (classification == GameSolvabilityClassification.OneSolution) {
						break;
					}
				}
			}
			else {
				final move = GameMove(
					type: GameMoveType.Play,
					x: random.nextInt(size),
					y: random.nextInt(size),
					value: random.nextInt(size) + 1,
					locked: true
				);
				moves.add(move);
				_playMove(move);
				final classification = classifyBoard(_board, constraints);
				print(classification);
				if (classification == GameSolvabilityClassification.NoSolution) {
					_playMove(move);
				}
				else if (classification == GameSolvabilityClassification.OneSolution) {
					break;
				}
			}
		}
		_boardController.add(_board);
	}
}