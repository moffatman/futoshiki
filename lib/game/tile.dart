enum GameTileStatus {
	OK,
	Wrong,
	WrongDependency
}

class GameTile {
	int value = 0;
	Set<int> notes = Set<int>();
	bool locked = false;
	GameTileStatus get status {
		if (errorParents.isEmpty) {
			if (errorChildren.isEmpty) {
				return GameTileStatus.OK;
			}
			else {
				return GameTileStatus.WrongDependency;
			}
		}
		else {
			return GameTileStatus.Wrong;
		}
	}
	Set<GameTile> errorParents = Set<GameTile>();
	Set<GameTile> errorChildren = Set<GameTile>();
}