import 'package:flutter/material.dart';
import 'package:futoshiki/game/move.dart';

import '../game/board.dart';

import 'constraint.dart';
import 'tile.dart';

class GameBoardUI extends StatelessWidget {
	final GameBoard board;
	final int widgetSize;
	final void Function({int x, int y, int value, GameMoveType type}) onChoose;

	GameBoardUI({this.board, this.onChoose}) : widgetSize = ((2 * board.size) - 1);

	Widget _makeConstraintSpacer(double elementSize) {
		return SizedBox(
			width: elementSize / 2,
			height: elementSize / 2
		);
	}

	@override
	Widget build(BuildContext context) {
		final elementSize = MediaQuery.of(context).size.width / (2 * board.size);
		return Column(
			mainAxisSize: MainAxisSize.min,
			children: List<Row>.generate(widgetSize, (layoutRow) => Row(
				mainAxisSize: MainAxisSize.max,
				mainAxisAlignment: MainAxisAlignment.spaceEvenly,
				children: List<Widget>.generate(widgetSize, (layoutColumn) {
					int gameRow = layoutRow ~/ 2;
					int gameColumn = layoutColumn ~/ 2;
					if (layoutRow % 2 == 0) {
						// tile row
						if (layoutColumn % 2 == 0) {
							return GameTileUI(tile: board.tiles[gameRow][gameColumn], boardSize: board.size, elementSize: elementSize, onChoose: ({int value, GameMoveType type}) {
								onChoose(x: gameColumn, y: gameRow, value: value, type: type);
							});
						}
						else {
							return (board.horizontalConstraints[gameRow][gameColumn] != null) ? GameHorizontalConstraintUI(constraint: board.horizontalConstraints[gameRow][gameColumn], elementSize: elementSize) :_makeConstraintSpacer(elementSize);
						}
					}
					else {
						// constraint row
						if (layoutColumn % 2 == 0) {
							return (board.verticalConstraints[gameRow][gameColumn] != null) ? GameVerticalConstraintUI(constraint: board.verticalConstraints[gameRow][gameColumn], elementSize: elementSize) : _makeConstraintSpacer(elementSize);
						}
						else {
							return _makeConstraintSpacer(elementSize);
						}
					}
				})
			))
		);
	}
}