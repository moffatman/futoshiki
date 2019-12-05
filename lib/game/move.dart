enum GameMoveType {
	Note,
	Play
}

class GameMove {
	bool locked = false;
	int x;
	int y;
	GameMoveType type;
	int value;

	GameMove({
		this.x,
		this.y,
		this.type,
		this.value
	});
}