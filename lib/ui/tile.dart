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

class GameTileUI extends StatelessWidget {
	final GameTile tile;
	final int size;

	GameTileUI({
		this.tile,
		this.size
	});

	Widget _buildBigNumber() {
		return Center(
			child: Text(tile.value.toString(), style: tileTextStyles[tile.status])
		);
	}

	Widget _buildNotes() {
		int number = 0;
		return Column(
			mainAxisSize: MainAxisSize.min,
			mainAxisAlignment: MainAxisAlignment.spaceEvenly,
			children: List<Row>.generate(notesLayout[size].length, (row) {
				return Row(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: List<Text>.generate(notesLayout[size][row], (column) {
						number++;
						return Text(tile.notes.contains(number) ? number.toString() : " ");
					})
				);
			})
			
			/*[
				Row(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						tile.notes.contains(1) ? Text("1") : Text(" "),
						tile.notes.contains(2) ? Text("2") : Text(" "),
						tile.notes.contains(3) ? Text("3") : Text(" ")
					]
				),
				Row(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						tile.notes.contains(4) ? Text("4") : Text(" "),
						tile.notes.contains(5) ? Text("5") : Text(" "),
						tile.notes.contains(6) ? Text("6") : Text(" ")
					]
				),
				Row(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.spaceEvenly,
					children: [
						tile.notes.contains(7) ? Text("7") : Text(" "),
						tile.notes.contains(8) ? Text("8") : Text(" "),
						tile.notes.contains(9) ? Text("9") : Text(" ")
					]
				)
			]*/
		);
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			decoration: BoxDecoration(
				border: Border.all(
					color: Colors.black
				),
				color: tile.locked ? Colors.grey : Colors.white
			),
			child: tile.value > 0 ? _buildBigNumber() : _buildNotes()
		);
	}
}