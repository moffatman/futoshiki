import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../game/constraint.dart';

Widget _getIcon(GameConstraintType type) {
	switch(type) {
		case GameConstraintType.Equality:
			return Text("=");
		case GameConstraintType.GreaterThan:
			return Text(">");
		case GameConstraintType.LessThan:
			return Text("<");
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
			decoration: BoxDecoration(
				border: Border.all(
					color: Colors.black
				)
			),
			child: _getIcon(constraint.type)
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