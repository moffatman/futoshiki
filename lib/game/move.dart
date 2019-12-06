import 'package:meta/meta.dart';

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
		@required this.x,
		@required this.y,
		@required this.type,
		@required this.value,
		this.locked
	});
}