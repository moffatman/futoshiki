import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../game/constraint.dart';

const Map<GameConstraintStatus, Color> constraintTextColors = {
	GameConstraintStatus.OK: Colors.black,
	GameConstraintStatus.Wrong: Colors.red
};

Widget _getIcon(GameConstraint constraint, double elementSize) {
	final style = TextStyle(fontSize: elementSize / 2, color: constraintTextColors[constraint.status]);
	switch(constraint.type) {
		case GameConstraintType.Equality:
			return Text("=", style: style);
		case GameConstraintType.GreaterThan:
			return Text(">", style: style);
		case GameConstraintType.LessThan:
			return Text("<", style: style);
		default:
			return Text("");
	}
}

class GameHorizontalConstraintUI extends StatelessWidget {
	final GameConstraint constraint;
	final double elementSize;

	GameHorizontalConstraintUI({
		@required this.constraint,
		@required this.elementSize
	});

	@override
	Widget build(BuildContext context) {
		return Container(
			width: elementSize / 2,
			height: elementSize,
			child: Center(
				child: _getIcon(constraint, elementSize)
			)
		);
	}
}

class GameVerticalConstraintUI extends StatelessWidget {
	final GameConstraint constraint;
	final double elementSize;

	GameVerticalConstraintUI({
		@required this.constraint,
		@required this.elementSize
	});

	@override
	Widget build(BuildContext context) {
		return Transform.rotate(
			angle: math.pi / 2,
			child: GameHorizontalConstraintUI(constraint: constraint, elementSize: elementSize)
		);
	}
}