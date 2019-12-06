import 'package:flutter/material.dart';
import 'package:futoshiki/game/board.dart';
import 'package:futoshiki/game/constraint.dart';
import 'package:futoshiki/game/controller.dart';
import 'package:futoshiki/game/move.dart';

import 'board.dart';

class PuzzlePage extends StatefulWidget {
	final int size;

	PuzzlePage({this.size});

  	@override
  	_PuzzlePageState createState() => _PuzzlePageState();
}


const Map<GameMoveType, IconData> moveTypeIcons = {
	GameMoveType.Play: Icons.check_box,
	GameMoveType.Note: Icons.edit
};

class _PuzzlePageState extends State<PuzzlePage> {
	GameController controller;
	GameMoveType moveType = GameMoveType.Play;

	@override
	void initState() {
		super.initState();
		controller = GameController(widget.size);
	}
	@override
  	Widget build(BuildContext context) {
		return Scaffold(
	  		appBar: AppBar(
				title: Text("${widget.size}x${widget.size} puzzle"),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text('Timer here'),
						Container(
							margin: EdgeInsets.all(24),
							child: StreamBuilder(
								stream: controller.board,
								builder: (BuildContext context, AsyncSnapshot<GameBoard> snapshot) {
									if (snapshot.hasData) {
										return GameBoardUI(board: snapshot.data, onChoose: ({int x, int y, int value, GameMoveType type}) {
											controller.playMove(GameMove(x: x, y: y, type: type, value: value));
										});
									}
									else {
										return CircularProgressIndicator();
									}
								}
							)
						),
					],
				),
			),
			floatingActionButton: FloatingActionButton(
				child: Icon(moveTypeIcons[moveType]),
				onPressed: () {
					if (moveType == GameMoveType.Note) {
						setState(() {
							moveType = GameMoveType.Play;
						});
					}
					else if (moveType == GameMoveType.Play) {
						setState(() {
							moveType = GameMoveType.Note;
						});
					}
				}
			),
		);
  	}
}
