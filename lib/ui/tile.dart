import 'package:flutter/material.dart';

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

class GameTileUI extends StatefulWidget {
	final GameTile tile;
	final int size;

	GameTileUI({
		this.tile,
		this.size
	});

	@override
	State<GameTileUI> createState() => _GameTileUIState();
}

class _GameTileUIState extends State<GameTileUI> {
	bool _chooserShown = false;
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
			onTapDown: (TapDownDetails details) {
				print("tap down");
			},
			onTapUp: (TapUpDetails detail) {
				print("tap up");
			},
			onTap: () {
				if (_chooserShown) {
					_chooserOverlay.remove();
				}
				else {
					_chooserOverlay = _createChooserOverlay(context);
					Overlay.of(context).insert(_chooserOverlay);
				}
				_chooserShown = !_chooserShown;
			}
		);
	}

	OverlayEntry _createChooserOverlay(BuildContext context) {
		  RenderBox renderBox = context.findRenderObject();
		  final size = renderBox.size;
		  final offset = renderBox.localToGlobal(Offset.zero);

		  return OverlayEntry(
			  builder: (context) => Positioned(
				  left: offset.dx - size.width,
				  top: offset.dy,
				  width: size.width,
				  child: Material(
					  elevation: 4.0,
					  child: Text("asdfxDDD lm,ao")
				  )
			  )
		  );
	  }
}