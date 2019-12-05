import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'ui/board.dart';
import 'game/controller.dart';
import 'game/board.dart';
import 'game/move.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
	  		title: 'Futoshiki',
	  		theme: ThemeData(
				primarySwatch: Colors.blue,
	  		),
	  		home: MyHomePage(title: 'Flutter Demo Home Page'),
		);
  	}
}

class MyHomePage extends StatefulWidget {
  	MyHomePage({Key key, this.title}) : super(key: key);
	final String title;

  	@override
  	_MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
	GameController controller;
	Random random;

	@override
	void initState() {
		super.initState();
		controller = GameController(4);
		random = Random(0);
	}
	@override
  	Widget build(BuildContext context) {
		return Scaffold(
	  		appBar: AppBar(
				title: Text(widget.title),
			),
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						Text(
							'You have pushed the button this many times:',
						),
						Expanded(
							child: StreamBuilder(
								stream: controller.board,
								builder: (BuildContext context, AsyncSnapshot<GameBoard> snapshot) {
									if (snapshot.hasData) {
										return GameBoardUI(snapshot.data);
									}
									else {
										return CircularProgressIndicator();
									}
								}
							)
						)
					],
				),
			),
			floatingActionButton: FloatingActionButton(
				onPressed: () {
					controller.playMove(GameMove(
						x: random.nextInt(controller.size),
						y: random.nextInt(controller.size),
						type: GameMoveType.Play,
						value: random.nextInt(controller.size) + 1
					));
				}
			),
		);
  	}
}
