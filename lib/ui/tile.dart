import 'dart:math';

import 'package:flutter/material.dart';
import 'package:futoshiki/game/move.dart';

import '../game/tile.dart';

const Map<GameTileStatus, TextStyle> tileTextStyles = {
	GameTileStatus.OK: TextStyle(fontSize: 18, color: Colors.black),
	GameTileStatus.Wrong: TextStyle(fontSize: 18, color: Colors.red),
	GameTileStatus.WrongDependency: TextStyle(fontSize: 18, color: Colors.yellow)
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
	final int size;
	final void Function({int value, GameMoveType type}) onChoose;

	GameTileUI({
		this.tile,
		this.size,
		this.onChoose
	});

	@override
	State<GameTileUI> createState() => _GameTileUIState();
}

class _GameTileUIState extends State<GameTileUI> {
	OverlayEntry _chooserOverlay;

	Widget _buildBigNumber() {
		return Center(
			child: Text(widget.tile.value.toString(), style: tileTextStyles[widget.tile.status])
		);
	}

	Widget _buildNotes() {
		int number = 0;
		return Column(
			mainAxisSize: MainAxisSize.min,
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			children: List<Row>.generate(notesLayout[widget.size].length, (row) {
				return Row(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: List<Text>.generate(notesLayout[widget.size][row], (column) {
						number++;
						return Text(widget.tile.notes.contains(number) ? number.toString() : " ");
					})
				);
			})
		);
	}

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			child: Container(
				decoration: BoxDecoration(
					border: Border.all(
						color: Colors.black
					),
					color: widget.tile.locked ? Colors.grey : Colors.white
				),
				child: widget.tile.value > 0 ? _buildBigNumber() : _buildNotes()
			),
			onTap: () {
				_chooserOverlay = _createChooserOverlay(context, GameMoveType.Play);
				Overlay.of(context).insert(_chooserOverlay);
			},
			onDoubleTap: () {
				_chooserOverlay = _createChooserOverlay(context, GameMoveType.Note);
				Overlay.of(context).insert(_chooserOverlay);
			}
		);
	}

	OverlayEntry _createChooserOverlay(BuildContext context, GameMoveType type) {
		RenderBox renderBox = context.findRenderObject();
		 final size = renderBox.size;
		final offset = renderBox.localToGlobal(Offset.zero);

		return OverlayEntry(
			builder: (context) {
				int number = 0;
				return Positioned(
					left: offset.dx - size.width,
					top: offset.dy - size.height,
					width: chooserOverlaySize * notesLayout[widget.size].reduce(max),
					child: Material(
						elevation: 4,
						child: Column(
							mainAxisSize: MainAxisSize.min,
							children: List<Row>.generate(notesLayout[widget.size].length, (row) {
								return Row(
									mainAxisSize: MainAxisSize.min,
									children: List<ChooserOverlayNumberTile>.generate(notesLayout[widget.size][row], (column) {
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