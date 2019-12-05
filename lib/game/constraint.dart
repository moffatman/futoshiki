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

	GameAppliedConstraint({
		this.ax,
		this.ay,
		this.direction,
		this.type
	});
}

class GameConstraintGreaterThan extends GameAppliedConstraint {
	GameConstraintStatus check(int a, int b) {
		return ((a == 0) || (b == 0) || (a > b)) ? GameConstraintStatus.OK : GameConstraintStatus.Wrong;
	}
	GameConstraintGreaterThan({
		ax,
		ay,
		direction
	}) : super(
		ax: ax,
		ay: ay,
		direction: direction,
		type: GameConstraintType.GreaterThan
	);
}

class GameConstraintLessThan extends GameAppliedConstraint {
	GameConstraintStatus check(int a, int b) {
		return ((a == 0) || (b == 0) || (a < b)) ? GameConstraintStatus.OK : GameConstraintStatus.Wrong;
	}
	GameConstraintLessThan({
		ax,
		ay,
		direction
	}) : super(
		ax: ax,
		ay: ay,
		direction: direction,
		type: GameConstraintType.LessThan
	);
}
