import 'package:flutter/material.dart';

import '../game/board.dart';

import 'constraint.dart';
import 'tile.dart';

class GameBoardUI extends StatelessWidget {
	final GameBoard board;
	final int widgetSize;

	GameBoardUI(this.board) : widgetSize = ((2 * board.size) - 1);

	@override
	Widget build(BuildContext context) {
		return GridView.count(
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
						return GameTileUI(tile: board.tiles[gameColumn][gameRow], size: board.size);
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
		);
	}
}