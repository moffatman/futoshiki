import 'package:flutter/material.dart';

import '../game/tile.dart';

class GameTileUI extends StatelessWidget {
	final GameTile tile;

	GameTileUI(this.tile);

	@override
	Widget build(BuildContext context) {
		if (tile.value > 0) {
			// show number
			return Text(tile.value.toString(), style: TextStyle(color: tile.status == GameTileStatus.OK ? Colors.black : Colors.red));
		}
		else {
			// show notes
			return Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							tile.notes.contains(1) ? Text("1") : Spacer(),
							tile.notes.contains(2) ? Text("2") : Spacer(),
							tile.notes.contains(3) ? Text("3") : Spacer()
						]
					),
					Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							tile.notes.contains(4) ? Text("4") : Spacer(),
							tile.notes.contains(5) ? Text("5") : Spacer(),
							tile.notes.contains(6) ? Text("6") : Spacer()
						]
					),
					Row(
						mainAxisSize: MainAxisSize.min,
						children: [
							tile.notes.contains(7) ? Text("7") : Spacer(),
							tile.notes.contains(8) ? Text("8") : Spacer(),
							tile.notes.contains(9) ? Text("9") : Spacer()
						]
					)
				]
			);
		}
	}
}