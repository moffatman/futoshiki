import 'dart:math';

import 'package:flutter/material.dart';
import 'package:futoshiki/game/move.dart';

import '../game/tile.dart';

const Map<GameTileStatus, Color> tileTextColors = {
	GameTileStatus.OK: Colors.black,
	GameTileStatus.Wrong: Colors.red,
	GameTileStatus.WrongDependency: Colors.yellow
};

const Map<int, List<int>> notesLayout = {
	2: [2],
	3: [3],
	4: [2, 2],
	5: [3, 2],
	6: [3, 3],
	7: [4, 3],
	8: [4, 4],
	9: [3, 3, 3]
};

const chooserOverlaySize = 75.0;

class GameTileUI extends StatefulWidget {
	final GameTile tile;
	final int boardSize;
	final double elementSize;
	final void Function({int value, GameMoveType type}) onChoose;

	GameTileUI({
		@required this.tile,
		@required this.boardSize,
		@required this.elementSize,
		@required this.onChoose
	});

	@override
	State<GameTileUI> createState() => _GameTileUIState();
}

class _GameTileUIState extends State<GameTileUI> {
	OverlayEntry _chooserOverlay;
	bool overlayActive = false;

	Widget _buildBigNumber() {
		return Center(
			child: Text(widget.tile.value.toString(), style: TextStyle(color: tileTextColors[widget.tile.status], fontSize: widget.elementSize / 2.0))
		);
	}

	Widget _buildNotes() {
		int number = 0;
		return Column(
			mainAxisSize: MainAxisSize.min,
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			children: List<Row>.generate(notesLayout[widget.boardSize].length, (row) {
				return Row(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: List<Text>.generate(notesLayout[widget.boardSize][row], (column) {
						number++;
						return Text(widget.tile.notes.contains(number) ? number.toString() : " ");
					})
				);
			})
		);
	}

	Widget _build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				border: Border.all(
					color: Colors.black
				),
				color: widget.tile.locked ? Colors.grey : Colors.white
			),
			width: widget.elementSize,
			height: widget.elementSize,
			child: widget.tile.value > 0 ? _buildBigNumber() : _buildNotes()
		);
	}

	@override
	Widget build(BuildContext context) {
		return widget.tile.locked ? _build(context) : GestureDetector(
			child: _build(context),
			onTap: () {
				if (!overlayActive) {
					_chooserOverlay = _createChooserOverlay(context, GameMoveType.Play);
					Overlay.of(context).insert(_chooserOverlay);
					overlayActive = true;
				}
			}
		);
	}

	OverlayEntry _createChooserOverlay(BuildContext context, GameMoveType type) {
		RenderBox renderBox = context.findRenderObject();
		final size = renderBox.size;
		final offset = renderBox.localToGlobal(Offset.zero);
		final overlayWidth = chooserOverlaySize * notesLayout[widget.boardSize].reduce(max);
		final maximumLeft = MediaQuery.of(context).size.width - overlayWidth;

		return OverlayEntry(
			builder: (context) {
				int number = 0;
				return Positioned(
					left: min(maximumLeft, offset.dx - size.width),
					top: offset.dy - size.height,
					width: overlayWidth,
					child: Material(
						elevation: 4,
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: List<Row>.generate(notesLayout[widget.boardSize].length, (row) {
								return Row(
									mainAxisSize: MainAxisSize.min,
									children: List<ChooserOverlayNumberTile>.generate(notesLayout[widget.boardSize][row], (column) {
										number++;
										return ChooserOverlayNumberTile(value: number, onChoose: _onChoose, type: type);
									})
								);
							})
						)
					)
				);
			}
		);
	}

	void _onChoose({int value, GameMoveType type}) {
		_chooserOverlay.remove();
		overlayActive = false;
		widget.onChoose(value: value, type: type);
	}
}

class ChooserOverlayNumberTile extends StatelessWidget {
	final int value;
	final void Function({int value, GameMoveType type}) onChoose;
	final GameMoveType type;

	ChooserOverlayNumberTile({this.value, this.onChoose, this.type});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			behavior: HitTestBehavior.translucent,
			child: Container(
				height: chooserOverlaySize,
				width: chooserOverlaySize,
				child: Center(
					child: Text(value.toString(), style: TextStyle(fontSize: 18, fontStyle: type == GameMoveType.Play ? FontStyle.normal : FontStyle.italic))
				)
			),
			onTap: () {
				onChoose(value: value, type: type);
			}
		);
	}
}