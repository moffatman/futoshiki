import 'package:futoshiki/game/board.dart';
import 'package:futoshiki/game/constraint.dart';
import 'package:futoshiki/game/tile.dart';

enum GameSolvabilityClassification {
	NoSolution,
	OneSolution,
	ManySolutions
}

GameSolvabilityClassification classifyBoard(GameBoard board, List<GameAppliedConstraint> constraints, bool editOriginal) {
	final b = editOriginal ? board : GameBoard.from(board);
	final allNumbers = List<int>.generate(board.size, (i) => i + 1);
	final rows = b.tiles;
	final columns = List<List<GameTile>>.generate(board.size, (x) => rows.map((row) => row[x]).toList());
	final allTiles = rows.expand((i) => (i));

	// Fill notes of empty squares
	allTiles.forEach((tile) {
		if (tile.value == 0) {
			tile.notes.addAll(allNumbers);
		}
	});

	for (int i = 0; i < 9999; i++) {
		// Detect easy mistakes
		final rowDuplicate = rows.any((row) => allNumbers.any((number) => row.where((tile) => tile.value == number).length > 1));
		final columnDuplicate = columns.any((column) => allNumbers.any((number) => column.where((tile) => tile.value == number).length > 1));
		final constraintError = constraints.any((constraint) {
			final tile = rows[constraint.ay][constraint.ax];
			final otherTile = (constraint.direction == GameConstraintDirection.Horizontal) ? rows[constraint.ay][constraint.ax + 1] : rows[constraint.ay + 1][constraint.ax];
			return constraint.check(tile.value, otherTile.value) == GameConstraintStatus.Wrong;
		});
		if (rowDuplicate || columnDuplicate || constraintError) {
			return GameSolvabilityClassification.NoSolution;
		}

		// Correct row notes
		rows.forEach((row) {
			final numbersInRow = row.map((tile) => tile.value).toSet();
			row.forEach((tile) => tile.notes.removeAll(numbersInRow));
		});

		// Correct column notes
		columns.forEach((column) {
			final numbersInColumn = column.map((tile) => tile.value).toSet();
			column.forEach((tile) => tile.notes.removeAll(numbersInColumn));
		});

		// Correct for constraints
		constraints.forEach((constraint) {
			final tile = rows[constraint.ay][constraint.ax];
			final otherTile = (constraint.direction == GameConstraintDirection.Horizontal) ? rows[constraint.ay][constraint.ax + 1] : rows[constraint.ay + 1][constraint.ax];
			tile.notes.removeWhere((value) => otherTile.notes.every((otherValue) => constraint.check(value, otherValue) == GameConstraintStatus.Wrong));
			otherTile.notes.removeWhere((otherValue) => tile.notes.every((value) => constraint.check(value, otherValue) == GameConstraintStatus.Wrong));
		});

		final impossibleTiles = allTiles.where((tile) => (tile.value == 0) && (tile.notes.length == 0));
		final impossibleRows = rows.where((row) => allNumbers.any((number) => row.every((tile) => (tile.value != number) && (!tile.notes.contains(number)))));
		final impossibleColumns = columns.where((column) => allNumbers.any((number) => column.every((tile) => (tile.value != number) && (!tile.notes.contains(number)))));
		if (impossibleTiles.isNotEmpty || impossibleRows.isNotEmpty || impossibleColumns.isNotEmpty) {
			return GameSolvabilityClassification.NoSolution;
		}

		int movesMade = 0;

		// Play obvious tiles
		allTiles.where((tile) => (tile.value == 0) && (tile.notes.length == 1)).forEach((tile) {
			tile.value = tile.notes.first;
			movesMade++;
		});

		rows.forEach((row) {
			allNumbers.forEach((number) {
				final matchingTiles = row.where((tile) => (tile.value == 0) && tile.notes.contains(number));
				if (matchingTiles.length == 1) {
					matchingTiles.first.value = number;
					movesMade++;
				}
			});
		});

		columns.forEach((column) {
			allNumbers.forEach((number) {
				final matchingTiles = column.where((tile) => (tile.value == 0) && tile.notes.contains(number));
				if (matchingTiles.length == 1) {
					matchingTiles.first.value = number;
					movesMade++;
				}
			});
		});

		final emptyTiles = allTiles.where((tile) => tile.value == 0);
		if (emptyTiles.isEmpty) {
			print(rows[0][0]);
			return GameSolvabilityClassification.OneSolution;
		}
		else if (movesMade == 0) {
			emptyTiles.toList().sort((a, b) => a.notes.length - b.notes.length);
			final tileWithLeastPossibilities = emptyTiles.first;
			for (final possibility in tileWithLeastPossibilities.notes) {
				tileWithLeastPossibilities.value = possibility;
				final classification = classifyBoard(b, constraints, false);
				if (classification == GameSolvabilityClassification.OneSolution) {
					if (editOriginal) {
						classifyBoard(b, constraints, true);
					}
					return (tileWithLeastPossibilities.notes.length > 2) ? GameSolvabilityClassification.ManySolutions : GameSolvabilityClassification.OneSolution;
				}
				else {
					tileWithLeastPossibilities.value = 0;
				}
			}
			return GameSolvabilityClassification.NoSolution;
		}
	}
	return GameSolvabilityClassification.NoSolution;
}