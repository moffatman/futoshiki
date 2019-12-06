import 'package:futoshiki/game/board.dart';
import 'package:futoshiki/game/constraint.dart';
import 'package:futoshiki/game/tile.dart';

enum GameSolvabilityClassification {
	NoSolution,
	OneSolution,
	ManySolutions
}

GameSolvabilityClassification classifyBoard(GameBoard board, List<GameAppliedConstraint> constraints) {
	final b = GameBoard.from(board);
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
		print("Classification iteration $i");

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
		if (impossibleTiles.isNotEmpty) {
			return GameSolvabilityClassification.NoSolution;
		}
		final obviousTiles = allTiles.where((tile) => (tile.value == 0) && (tile.notes.length == 1));
		if (obviousTiles.isEmpty) {
			return GameSolvabilityClassification.ManySolutions;
		}

		// Play obvious tiles
		obviousTiles.forEach((tile) {
			tile.value = tile.notes.first;
		});

		if (allTiles.where((tile) => tile.value == 0).isEmpty) {
			return GameSolvabilityClassification.OneSolution;
		}
	}
}