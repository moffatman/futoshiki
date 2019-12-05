import 'package:flutter/material.dart';
import 'package:futoshiki/game/move.dart';

import '../game/board.dart';

import 'constraint.dart';
import 'tile.dart';

class _NoOverscrollGlowScrollBehavior extends ScrollBehavior {
	@override
	Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
		return child;
	}
}

class GameBoardUI extends StatelessWidget {
	final GameBoard board;
	final int widgetSize;
	final void Function({int x, int y, int value, GameMoveType type}) onChoose;

	GameBoardUI({this.board, this.onChoose}) : widgetSize = ((2 * board.size) - 1);

	@override
	Widget build(BuildContext context) {
		return ScrollConfiguration(
			behavior: _NoOverscrollGlowScrollBehavior(),
			child: GridView.count(
				crossAxisCount: widgetSize,
				shrinkWrap: true,
				children: List<Widget>.generate(widgetSize * widgetSize, (i) {
					int layoutRow = i ~/ widgetSize;
					int layoutColumn = i % widgetSize;
					int gameRow = layoutRow ~/ 2;
					int gameColumn = layoutColumn ~/ 2;
					if (layoutRow % 2 == 0) {
						// tile row
						if (layoutColumn % 2 == 0) {
							return GameTileUI(tile: board.tiles[gameRow][gameColumn], size: board.size, onChoose: ({int value, GameMoveType type}) {
								onChoose(x: gameColumn, y: gameRow, value: value, type: type);
							});
						}
						else {
							return (board.horizontalConstraints[gameRow][gameColumn] != null) ? GameHorizontalConstraintUI(board.horizontalConstraints[gameRow][gameColumn]) : Container();
						}
					}
					else {
						// constraint row
						if (layoutColumn % 2 == 0) {
							return (board.verticalConstraints[gameRow][gameColumn] != null) ? GameVerticalConstraintUI(board.verticalConstraints[gameRow][gameColumn]) : Container();
						}
						else {
							return Container();
						}
					}
				})
			)
		);
	}
}