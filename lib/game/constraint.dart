enum GameConstraintType {
	Equality,
	GreaterThan,
	LessThan
}

class GameConstraint {
	GameConstraintType type;
	GameConstraintStatus status = GameConstraintStatus.OK;
	GameConstraint(this.type);
}

enum GameConstraintDirection {
	Horizontal,
	Vertical
}

enum GameConstraintStatus {
	OK,
	Wrong
}

abstract class GameAppliedConstraint {
	GameConstraintType type;
	int ax;
	int ay;
	GameConstraintDirection direction;
	GameConstraintStatus check(int a, int b);
}

class GameConstraintGreaterThan extends GameAppliedConstraint {
	GameConstraintType type = GameConstraintType.GreaterThan;
	GameConstraintStatus check(int a, int b) {
		return (a > b) ? GameConstraintStatus.OK : GameConstraintStatus.Wrong;
	}
}

class GameConstraintLessThan extends GameAppliedConstraint {
	GameConstraintType type = GameConstraintType.LessThan;
	GameConstraintStatus check(int a, int b) {
		return (a < b) ? GameConstraintStatus.OK : GameConstraintStatus.Wrong;
	}
}
