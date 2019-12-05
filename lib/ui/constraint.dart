import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../game/constraint.dart';

const Map<GameConstraintStatus, TextStyle> constraintTextStyles = {
	GameConstraintStatus.OK: TextStyle(fontSize: 24, color: Colors.black),
	GameConstraintStatus.Wrong: TextStyle(fontSize: 24, color: Colors.red)
};

Widget _getIcon(GameConstraint constraint) {
	switch(constraint.type) {
		case GameConstraintType.Equality:
			return Text("=", style: constraintTextStyles[constraint.status]);
		case GameConstraintType.GreaterThan:
			return Text(">", style: constraintTextStyles[constraint.status]);
		case GameConstraintType.LessThan:
			return Text("<", style: constraintTextStyles[constraint.status]);
		default:
			return Container();
	}
}

class GameHorizontalConstraintUI extends StatelessWidget {
	final GameConstraint constraint;

	GameHorizontalConstraintUI(this.constraint);

	@override
	Widget build(BuildContext context) {
		return Container(
			child: Center(
				child: _getIcon(constraint)
			)
		);
	}
}

class GameVerticalConstraintUI extends StatelessWidget {
	final GameConstraint constraint;

	GameVerticalConstraintUI(this.constraint);

	@override
	Widget build(BuildContext context) {
		return Transform.rotate(
			angle: math.pi / 2,
			child: GameHorizontalConstraintUI(constraint)
		);
	}
}