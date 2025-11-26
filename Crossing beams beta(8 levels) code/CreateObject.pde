GameObject CreatePlayer(float x, float y, int lookDir){
  // Create a new player object
  GameObject player = new Player();
  // Set the position of the player object
  player.PosX(x);
  player.PosY(y);
  player.ObjRC(lookDir);
  // Add player to reference table
  objectGrid[int(x)][int(y)] = player;
  // Keep special track of the player object
  playerObject = player;
  // Return created player
  return player;
}

GameObject CreateWallBlock(float posX, float posY, int sizeX, int sizeY){
  // Create new wallBlock object
  GameObject wallBlock = new WallBlock();
  // Set position of wallBlock object
  wallBlock.PosX(posX);
  wallBlock.PosY(posY);
  // Set sizes of wallBlock object
  wallBlock.SizeX(sizeX);
  wallBlock.SizeY(sizeY);
  // Set the occupied spaces as solid and add object to reference table
  wallBlock.setSolid();
  return wallBlock;
}

GameObject CreateTrackRail(float posX, float posY, int sizeX, int sizeY){
  GameObject trackRail = new TrackRail();
  
  trackRail.PosX(posX);
  trackRail.PosY(posY);
  
  trackRail.SizeX(sizeX);
  trackRail.SizeY(sizeY);
  
  trackRail.setTrack();
  return trackRail;
}

GameObject CreateMovingTarget(float posX, float posY, int requiredHits){
  GameObject movingTarget = new Target();
  movingTarget.PosX(posX);
  movingTarget.PosY(posY);
  movingTarget.RequiredHit(requiredHits);
  movingTarget.setMoveable();
  targetList.add(movingTarget);
  return movingTarget;
}

GameObject CreateSolidTarget(float posX, float posY, int requiredHits){
  GameObject solidTarget = new Target();
  solidTarget.PosX(posX);
  solidTarget.PosY(posY);
  solidTarget.RequiredHit(requiredHits);
  solidTarget.setSolid();
  targetList.add(solidTarget);
  return solidTarget;
}

GameObject CreateMovingLaser(float posX, float posY){
  GameObject movingLaser = new Laser();
  movingLaser.PosX(posX);
  movingLaser.PosY(posY);
  movingLaser.setMoveable();
  //movingLaser.Interactable(true);
  laserList.add(movingLaser);
  return movingLaser;
}

GameObject CreateLaserController(float posX, float posY, int counter, int denominator, boolean decimalController, int linkNumber){
  GameObject laserController = new LaserController();
  laserController.PosX(posX);
  laserController.PosY(posY);
  laserController.SizeX(denominator);
  laserController.SizeY(counter);
  laserController.DecimalController(decimalController);
  laserController.LinkNumber(linkNumber);
  laserController.setSolid();
  laserController.Interactable(true);
  return laserController;
}

GameObject CreatePlayButton(float posX, float posY){
  GameObject playButton = new PlayButton();
  playButton.PosX(posX);
  playButton.PosY(posY);
  playButton.setSolid();
  playButton.Interactable(true);
  playButtonObject = playButton;
  return playButton;
}

GameObject CreateResetButton(float posX, float posY){
  GameObject resetButton = new ResetButton();
  resetButton.PosX(posX);
  resetButton.PosY(posY);
  resetButton.setSolid();
  resetButton.Interactable(true);
  return resetButton;
}

GameObject CreateLevelEntrance(float posX, float posY, int dir){
  GameObject levelEntrance = new LevelEntrance();
  levelEntrance.ObjRC(dir);
  levelEntrance.PosX(posX);
  levelEntrance.PosY(posY);
  return levelEntrance;
}

GameObject CreateLevelExit(float posX, float posY, int dir){
  GameObject levelExit = new LevelExit();
  levelExit.ObjRC(dir);
  levelExit.PosX(posX);
  levelExit.PosY(posY);
  levelExit.setSolid();
  levelExitObject = levelExit;
  return levelExit;
}

GameObject CreateGrid(float posX, float posY, int sizeX, int sizeY){
  Grid grid = new Grid();
  grid.PosX(posX);
  grid.PosY(posY);
  grid.SizeX(sizeX);
  grid.SizeY(sizeY);
  grid.AddGridCollision();
  return grid;
}

GameObject CreateTextBox(float posX, float posY, int sizeX, int sizeY, String _text, int _textSize){
  TextBox textBox = new TextBox();
  textBox.PosX(posX);
  textBox.PosY(posY);
  textBox.SizeX(sizeX);
  textBox.SizeY(sizeY);
  textBox.AddText(_text);
  textBox.TextSize(_textSize);
  return textBox;
}
