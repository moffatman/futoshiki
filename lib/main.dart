import 'dart:math';

import 'package:flutter/material.dart';
import 'package:futoshiki/game/constraint.dart';
import 'package:futoshiki/ui/page_puzzle.dart';
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
				backgroundColor: Colors.white
	  		),
	  		home: MyHomePage(title: 'Futoshiki'),
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
	@override
	void initState() {
		super.initState();
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
					children: [2, 3, 4, 5, 6].map((size) => RaisedButton(
						child: Text("New ${size}x${size} puzzle"),
						onPressed: () {
							Navigator.push(context, MaterialPageRoute(builder: (context) => PuzzlePage(size: size)));
						}
					)).toList(),
				),
			)
		);
  	}
}

class NewPuzzleButton extends StatelessWidget {

	@override
	Widget build(BuildContext context) {

	}
}