int currentScale = 0;
float scaleOffset = 0;
float gridY;
float tileOffsetX, tileOffsetY = 0;


void loadLevel(int level){
  currentLevel = level;
  switch(level){
      // ------------------------------
    case 1:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(9,1,9,9));
      
      // Edge
      staticObjects.add(CreateWallBlock(8,0,10,1));
      staticObjects.add(CreateWallBlock(0,0,8,11));
      staticObjects.add(CreateWallBlock(19,2,1,3));
      staticObjects.add(CreateWallBlock(19,6,1,3));
      staticObjects.add(CreateWallBlock(8,10,10,1));
      
      // Obstacles
      staticObjects.add(CreateWallBlock(4,3,1,1));
      staticObjects.add(CreateWallBlock(3,4,1,1));
      staticObjects.add(CreateWallBlock(4,4,1,1));
      staticObjects.add(CreateWallBlock(5,4,1,1));
      staticObjects.add(CreateWallBlock(2,7,5,1));
      staticObjects.add(CreateWallBlock(18,0,2,2));
      staticObjects.add(CreateWallBlock(18,9,2,2));
      //staticObjects.add(CreateWallBlock(18,8,1,1));
      
      // TextBoxes
      textBoxes.add(CreateTextBox(3,2,3,1,"Movement",22));
      textBoxes.add(CreateTextBox(4,3,1,1,"↑",30));
      textBoxes.add(CreateTextBox(3,4,1,1,"←",30));
      textBoxes.add(CreateTextBox(4,4,1,1,"↓",30));
      textBoxes.add(CreateTextBox(5,4,1,1,"→",30));
      textBoxes.add(CreateTextBox(3,6,3,1,"Interact",22));
      textBoxes.add(CreateTextBox(2,7,5,1,"Spacebar",30));
      textBoxes.add(CreateTextBox(18,0,2,2,"The play\nbutton\ntoggles all\nlaser(s) on.",22));
      textBoxes.add(CreateTextBox(18,9,2,2,"The door to\nthe next level\nopens when\nall target(s)\nare hit.",22));
      
      // Lasers
      gameObjects.add(CreateMovingLaser(9,9));
      
      // Laser Controllers
      gameObjects.add(CreateLaserController(8,9,1,1,false,0));
      
      // Targets
      gameObjects.add(CreateMovingTarget(17,1,1));
      
      // Misc
      gameObjects.add(CreateLevelExit(19,5,2));
      gameObjects.add(CreateLevelEntrance(18,3,1));
      gameObjects.add(CreatePlayButton(18,2));
      
      //Player
      gameObjects.add(CreatePlayer(13,5,2));
      break;
      // ------------------------------
    case 2:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(15,0,5,5));
      gridObjects.add(CreateGrid(15,6,5,5));
      
      // Obstacles
      staticObjects.add(CreateWallBlock(15,5,5,1));      
      staticObjects.add(CreateWallBlock(14,0,1,2));
      staticObjects.add(CreateWallBlock(14,3,1,2));
      staticObjects.add(CreateWallBlock(14,6,1,2));
      staticObjects.add(CreateWallBlock(14,9,1,2));      
      staticObjects.add(CreateWallBlock(10,0,4,1));
      staticObjects.add(CreateWallBlock(0,0,10,4));
      staticObjects.add(CreateWallBlock(0,4,1,1));      
      staticObjects.add(CreateWallBlock(10,10,3,1));
      staticObjects.add(CreateWallBlock(0,7,10,4));
      staticObjects.add(CreateWallBlock(0,6,1,1));
      
      // TextBoxes
      textBoxes.add(CreateTextBox(0,0,10,4,"You can change the angle of a laser by\ninteracting (spacebar) with its controller while\nthe lasers are not on.\nThe color of a laser controller is the same as\nthe laser it controls.",35));
      textBoxes.add(CreateTextBox(0,7,10,4,"There is no penalty for turning on the lasers to\ntest with an incorrect solution, however the\nangle of the lasers cannot be changed before\nturning the lasers off again first.\n\nTurn off the lasers with the pause button.",35));
      
      // Lasers
      gameObjects.add(CreateMovingLaser(15,2));
      gameObjects.add(CreateMovingLaser(15,8));
      // LaserControllers
      gameObjects.add(CreateLaserController(14,2,2,1,false,0));
      gameObjects.add(CreateLaserController(14,8,0,2,false,1));
      
      // Targets
      gameObjects.add(CreateMovingTarget(18,0,1));
      gameObjects.add(CreateMovingTarget(17,7,1));
      
      // Misc
      gameObjects.add(CreatePlayButton(14,5));
      gameObjects.add(CreateLevelExit(13,10,3));
      gameObjects.add(CreateLevelEntrance(0,5,2));
      
      // Player
      gameObjects.add(CreatePlayer(1,5,2));
      break;
      // ------------------------------
    case 3:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(15,0,5,11));
      gridObjects.add(CreateGrid(5,7,9,4));
      // Obstacles
      staticObjects.add(CreateWallBlock(0,0,5,3));
      staticObjects.add(CreateWallBlock(5,0,4,2));
      staticObjects.add(CreateWallBlock(9,0,4,1));
      staticObjects.add(CreateWallBlock(14,0,1,2));
      staticObjects.add(CreateWallBlock(0,3,1,1));
      staticObjects.add(CreateWallBlock(0,5,1,1));
      staticObjects.add(CreateWallBlock(0,6,5,5));
      staticObjects.add(CreateWallBlock(5,6,1,1));
      staticObjects.add(CreateWallBlock(7,6,7,1));
      staticObjects.add(CreateWallBlock(14,3,1,8));
      // Lasers
      gameObjects.add(CreateMovingLaser(15,2));
      gameObjects.add(CreateMovingLaser(6,7));
      // LaserControllers
      gameObjects.add(CreateLaserController(14,2,1,3,false,0));
      gameObjects.add(CreateLaserController(6,6,-1,2,false,1));
      // Targets
      gameObjects.add(CreateMovingTarget(18,8,1));
      gameObjects.add(CreateMovingTarget(12,9,1));
      // TextBoxes
      textBoxes.add(CreateTextBox(0,0,5,3,"The angle of a laser can also\nbe a negative value.\n\nYou can do this by lowering\nthe top value bellow zero.",28));
      // Misc
      gameObjects.add(CreatePlayButton(10,4));
      gameObjects.add(CreateLevelExit(0,4,4));
      gameObjects.add(CreateLevelEntrance(13,0,3));
      // Player
      gameObjects.add(CreatePlayer(13,1,3));
      break;
      // ------------------------------
    case 4:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(1,1,5,5));
      gridObjects.add(CreateGrid(11,6,9,5));
      // Obstacles
      staticObjects.add(CreateWallBlock(0,0,6,1));
      staticObjects.add(CreateWallBlock(0,1,1,6));
      staticObjects.add(CreateWallBlock(6,0,1,6));
      staticObjects.add(CreateWallBlock(3,6,3,1));
      staticObjects.add(CreateWallBlock(7,0,3,1));
      staticObjects.add(CreateWallBlock(10,0,1,1));
      staticObjects.add(CreateWallBlock(11,0,2,2));
      staticObjects.add(CreateWallBlock(13,0,3,3));
      staticObjects.add(CreateWallBlock(16,0,4,4));
      staticObjects.add(CreateWallBlock(0,7,1,1));
      staticObjects.add(CreateWallBlock(0,9,2,2));
      staticObjects.add(CreateWallBlock(2,10,9,1));
      staticObjects.add(CreateWallBlock(10,5,1,3));
      staticObjects.add(CreateWallBlock(11,5,9,1));
      // Lasers
      gameObjects.add(CreateMovingLaser(2,5));
      gameObjects.add(CreateMovingLaser(1,5));
      gameObjects.add(CreateMovingLaser(11,8));
      gameObjects.add(CreateMovingLaser(11,9));
      // LaserControllers
      gameObjects.add(CreateLaserController(2,6,4,1,false,0));
      gameObjects.add(CreateLaserController(1,6,2,4,false,1));
      gameObjects.add(CreateLaserController(10,8,1,3,false,2));
      gameObjects.add(CreateLaserController(10,9,0,5,false,3));
      // Targets
      gameObjects.add(CreateMovingTarget(2,1,1));
      gameObjects.add(CreateMovingTarget(5,3,1));
      gameObjects.add(CreateMovingTarget(17,6,1));
      gameObjects.add(CreateMovingTarget(15,9,1));
      gameObjects.add(CreateMovingTarget(19,10,1));
      // TextBoxes
      textBoxes.add(CreateTextBox(16,0,4,4,"In some levels it\nmight be required\nfor one laser to hit\nmultiple targets.",35));
      // Misc
      gameObjects.add(CreatePlayButton(6,6));
      gameObjects.add(CreateLevelEntrance(19,4,4));
      gameObjects.add(CreateLevelExit(0,8,4));
      // Player
      gameObjects.add(CreatePlayer(18,4,4));
      break;
      // ------------------------------
    case 5:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(1,6,6,4));
      gridObjects.add(CreateGrid(12,1,7,5));
      // Obstacles
      staticObjects.add(CreateWallBlock(0,0,1,11));
      staticObjects.add(CreateWallBlock(1,0,3,2));
      staticObjects.add(CreateWallBlock(5,0,3,2));
      staticObjects.add(CreateWallBlock(8,0,11,1));
      staticObjects.add(CreateWallBlock(19,0,1,6));
      staticObjects.add(CreateWallBlock(11,2,1,2));
      staticObjects.add(CreateWallBlock(11,5,1,2));
      staticObjects.add(CreateWallBlock(12,6,4,1));
      staticObjects.add(CreateWallBlock(16,6,4,2));
      staticObjects.add(CreateWallBlock(16,9,4,2));
      staticObjects.add(CreateWallBlock(1,10,15,1));
      staticObjects.add(CreateWallBlock(1,5,1,1));
      staticObjects.add(CreateWallBlock(3,5,4,1));
      staticObjects.add(CreateWallBlock(7,6,1,2));
      staticObjects.add(CreateWallBlock(7,8,2,2));
      staticObjects.add(CreateWallBlock(9,9,2,1));
      // Lasers
      gameObjects.add(CreateMovingLaser(2,6));
      gameObjects.add(CreateMovingLaser(12,1));
      gameObjects.add(CreateMovingLaser(12,4));
      // LaserControllers
      gameObjects.add(CreateLaserController(2,5,-1,1,false,0));
      gameObjects.add(CreateLaserController(11,1,0,1,false,1));
      gameObjects.add(CreateLaserController(11,4,1,3,false,2));
      // Targets
      gameObjects.add(CreateMovingTarget(5,8,1));
      gameObjects.add(CreateMovingTarget(15,1,1));
      gameObjects.add(CreateMovingTarget(15,3,1));
      gameObjects.add(CreateMovingTarget(18,5,1));
      // Misc
      gameObjects.add(CreatePlayButton(7,5));
      gameObjects.add(CreateLevelEntrance(19,8,4));
      gameObjects.add(CreateLevelExit(4,0,1));
      // Player
      gameObjects.add(CreatePlayer(18,8,4));
      break;
      // ------------------------------
    case 6:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(13,0,7,7));
      // Obstacles
      staticObjects.add(CreateWallBlock(0,0,1,11));
      staticObjects.add(CreateWallBlock(1,0,10,1));
      staticObjects.add(CreateWallBlock(1,1,3,3));
      staticObjects.add(CreateWallBlock(1,4,2,2));
      staticObjects.add(CreateWallBlock(1,6,1,1));
      staticObjects.add(CreateWallBlock(1,9,2,2));
      staticObjects.add(CreateWallBlock(3,10,1,1));
      staticObjects.add(CreateWallBlock(4,1,2,2));
      staticObjects.add(CreateWallBlock(5,10,1,1));
      staticObjects.add(CreateWallBlock(6,1,1,1));
      staticObjects.add(CreateWallBlock(6,9,2,2));
      staticObjects.add(CreateWallBlock(8,7,4,4));
      staticObjects.add(CreateWallBlock(12,0,1,1));
      staticObjects.add(CreateWallBlock(12,2,1,2));
      staticObjects.add(CreateWallBlock(12,5,1,2));
      staticObjects.add(CreateWallBlock(12,7,8,4));
      // Lasers
      gameObjects.add(CreateMovingLaser(13,1));
      gameObjects.add(CreateMovingLaser(13,4));
      // LaserControllers
      gameObjects.add(CreateLaserController(12,1,-1,1,false,0));
      gameObjects.add(CreateLaserController(12,4,1,3,false,1));
      // TextBoxes
      textBoxes.add(CreateTextBox(12,7,8,4,"Some targets require that they\nare hit by multiple lasers.\n\nThe number of dots in the\nwhite square indicate how many\ntimes a target needs to be hit.",40));
      // Targets
      gameObjects.add(CreateMovingTarget(16,3,2));
      // Misc
      gameObjects.add(CreatePlayButton(11,6));
      gameObjects.add(CreateLevelEntrance(4,10,1));
      gameObjects.add(CreateLevelExit(11,0,1));
      // Player
      gameObjects.add(CreatePlayer(4,9,1));
      break;
      // ------------------------------
    case 7:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(11,2,7,7));
      // Obstacles
      staticObjects.add(CreateWallBlock(0,0,7,11));
      staticObjects.add(CreateWallBlock(7,0,12,1));
      staticObjects.add(CreateWallBlock(7,1,3,3));
      staticObjects.add(CreateWallBlock(7,4,4,4));
      staticObjects.add(CreateWallBlock(7,8,3,3));
      staticObjects.add(CreateWallBlock(10,1,2,2));
      staticObjects.add(CreateWallBlock(10,9,1,2));
      staticObjects.add(CreateWallBlock(12,10,7,1));
      staticObjects.add(CreateWallBlock(19,0,1,5));
      staticObjects.add(CreateWallBlock(19,6,1,5));
      // Lasers
      gameObjects.add(CreateMovingLaser(11,3));
      gameObjects.add(CreateMovingLaser(11,8));
      // LaserControllers
      gameObjects.add(CreateLaserController(10,3,-3,4,false,0));
      gameObjects.add(CreateLaserController(10,8,1,2,false,1));
      // TextBoxes
      textBoxes.add(CreateTextBox(7,4,4,4,"Oh no, we cannot reach\nthe controllers and do\nnot hit our target.\n\nIf only we could somehow\npush our target?\n\nOur target does however\nseem to be afraid to move\nwith the lasers active.",23));
      // Targets
      gameObjects.add(CreateMovingTarget(14,4,2));
      // Misc
      gameObjects.add(CreatePlayButton(18,9));
      gameObjects.add(CreateLevelEntrance(11,10,1));
      gameObjects.add(CreateLevelExit(19,5,2));
      // Player
      gameObjects.add(CreatePlayer(11,9,1));
      break;
      // ------------------------------
    case 8:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(2,2,7,7));
      gridObjects.add(CreateGrid(16,0,4,4));
      gridObjects.add(CreateGrid(16,7,4,4));
      // Obstacles
      staticObjects.add(CreateWallBlock(0,2,2,2));
      staticObjects.add(CreateWallBlock(0,4,1,1));
      staticObjects.add(CreateWallBlock(0,6,1,1));
      staticObjects.add(CreateWallBlock(0,7,2,2));
      staticObjects.add(CreateWallBlock(2,0,2,2));
      staticObjects.add(CreateWallBlock(2,9,2,2));
      staticObjects.add(CreateWallBlock(4,0,3,1));
      staticObjects.add(CreateWallBlock(4,10,3,1));
      staticObjects.add(CreateWallBlock(7,0,2,2));
      staticObjects.add(CreateWallBlock(7,9,2,2));
      staticObjects.add(CreateWallBlock(9,1,1,1));
      staticObjects.add(CreateWallBlock(9,2,2,2));
      staticObjects.add(CreateWallBlock(9,7,2,2));
      staticObjects.add(CreateWallBlock(9,9,1,1));
      staticObjects.add(CreateWallBlock(10,4,1,1));
      staticObjects.add(CreateWallBlock(10,6,1,1));
      staticObjects.add(CreateWallBlock(11,0,1,5));
      staticObjects.add(CreateWallBlock(11,6,1,5));
      staticObjects.add(CreateWallBlock(12,0,3,2));
      staticObjects.add(CreateWallBlock(12,9,3,2));
      staticObjects.add(CreateWallBlock(15,0,1,2));
      staticObjects.add(CreateWallBlock(15,3,1,2));
      staticObjects.add(CreateWallBlock(15,6,1,2));
      staticObjects.add(CreateWallBlock(15,9,1,2));
      staticObjects.add(CreateWallBlock(16,4,4,1));
      staticObjects.add(CreateWallBlock(16,6,4,1));
      // Lasers
      gameObjects.add(CreateMovingLaser(2,2));
      gameObjects.add(CreateMovingLaser(2,8));
      gameObjects.add(CreateMovingLaser(16,2));
      gameObjects.add(CreateMovingLaser(16,8));
      // LaserControllers
      gameObjects.add(CreateLaserController(1,1,-2,5,false,0));
      gameObjects.add(CreateLaserController(1,9,4,5,false,1));
      gameObjects.add(CreateLaserController(15,2,2,1,true,2));
      gameObjects.add(CreateLaserController(15,8,-2,1,false,3));
      // TextBoxes
      textBoxes.add(CreateTextBox(7,0,2,2,"The target\nmight get\nstuck by\nmistake.",23));
      textBoxes.add(CreateTextBox(9,2,2,2,"Interact with\nthis button\nto reset\nthe level.",23));
      textBoxes.add(CreateTextBox(12,0,3,2,"Angles are not only\nlimited to fractions,\nthey can also be\ndecimal numbers.",23));
      textBoxes.add(CreateTextBox(12,9,3,2,"For now this is\nthe final level.",30));
      // Targets
      gameObjects.add(CreateMovingTarget(5,5,2));
      gameObjects.add(CreateMovingTarget(18,1,1));
      gameObjects.add(CreateMovingTarget(18,9,1));
      // Misc
      gameObjects.add(CreatePlayButton(8,8));
      gameObjects.add(CreateResetButton(8,2));
      gameObjects.add(CreateLevelEntrance(0,5,2));
      gameObjects.add(CreateLevelExit(19,5,2));
      // Player
      gameObjects.add(CreatePlayer(1,5,2));
      break;
      // ------------------------------
      // Old levels
      // ------------------------------
      case -98:
      generateBlankLevel(6); 
      
      staticObjects.add(CreateWallBlock(0,0,20,1));
      staticObjects.add(CreateWallBlock(0,1,1,9));
      staticObjects.add(CreateWallBlock(0,10,20,1));
      staticObjects.add(CreateWallBlock(19,1,1,9));
      staticObjects.add(CreateTrackRail(9,2,1,8));
      staticObjects.add(CreateTrackRail(4,5,5,1));
      staticObjects.add(CreateTrackRail(9,1,9,1));
      
      gameObjects.add(CreateMovingTarget(13,5,1));
      gameObjects.add(CreateMovingLaser(4,5));
      gameObjects.add(CreateMovingLaser(9,1));
      gameObjects.add(CreatePlayButton(1,1));
      gameObjects.add(CreatePlayer(1, 5, 2));
      
      //printCollision();
      break;
      // ------------------------------
    case -99:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(15,0,5,5));
      gridObjects.add(CreateGrid(15,6,5,5));
      
      // Obstacles
      staticObjects.add(CreateWallBlock(15,5,2,1));
      staticObjects.add(CreateWallBlock(18,5,2,1));
      
      staticObjects.add(CreateWallBlock(14,0,1,2));
      staticObjects.add(CreateWallBlock(14,3,1,2));
      staticObjects.add(CreateWallBlock(14,6,1,2));
      staticObjects.add(CreateWallBlock(14,9,1,2));
      
      staticObjects.add(CreateWallBlock(10,0,4,1));
      staticObjects.add(CreateWallBlock(0,0,10,3));
      staticObjects.add(CreateWallBlock(0,3,1,2));
      
      staticObjects.add(CreateWallBlock(10,10,3,1));
      staticObjects.add(CreateWallBlock(0,8,10,3));
      staticObjects.add(CreateWallBlock(0,6,1,2));
      
      // TextBoxes
      textBoxes.add(CreateTextBox(0,0,10,3,"You can change the angle of a laser by\ninteracting (spacebar) with its controller.\n\nThe color of a laser controller is the same as\nthe laser it controls.",35));
      textBoxes.add(CreateTextBox(0,8,10,3,"You cannot change the angle of a\nlaser while the lasers are active.\n\nSo if you wish to change the angle of a laser\nyou first need to turn off the lasers",35));
      
      // Lasers
      gameObjects.add(CreateMovingLaser(15,2));
      gameObjects.add(CreateMovingLaser(15,8));
      // LaserControllers
      gameObjects.add(CreateLaserController(14,2,2,1,false,0));
      gameObjects.add(CreateLaserController(14,8,0,2,false,1));
      
      // Targets
      gameObjects.add(CreateMovingTarget(18,0,1));
      gameObjects.add(CreateMovingTarget(17,7,1));
      
      // Misc
      gameObjects.add(CreatePlayButton(14,5));
      gameObjects.add(CreateLevelExit(13,10,3));
      gameObjects.add(CreateLevelEntrance(0,5,2));
      
      // Player
      gameObjects.add(CreatePlayer(1,5,2));
      break;
      // ------------------------------
    case -100:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(9,1,9,9));
      
      // Edge
      staticObjects.add(CreateWallBlock(0,0,20,1));
      staticObjects.add(CreateWallBlock(19,1,1,9));
      staticObjects.add(CreateWallBlock(0,1,1,4));
      staticObjects.add(CreateWallBlock(0,6,1,4));
      staticObjects.add(CreateWallBlock(0,10,4,1));
      staticObjects.add(CreateWallBlock(5,10,15,1));
      
      // Obstacles
      staticObjects.add(CreateWallBlock(7,1,1,2));
      staticObjects.add(CreateWallBlock(7,4,1,1));
      staticObjects.add(CreateWallBlock(7,6,1,1));
      staticObjects.add(CreateWallBlock(7,8,1,2));
      
      // Lasers
      gameObjects.add(CreateMovingLaser(9,3));
      gameObjects.add(CreateMovingLaser(9,5));
      gameObjects.add(CreateMovingLaser(9,7));
      
      // Laser Controllers
      gameObjects.add(CreateLaserController(7,3,-2,1,false,0));
      gameObjects.add(CreateLaserController(7,5,0,1,false,1));
      gameObjects.add(CreateLaserController(7,7,1,1,false,2));
      
      // Targets
      gameObjects.add(CreateMovingTarget(14,2,1));
      gameObjects.add(CreateMovingTarget(15,8,1));
      gameObjects.add(CreateMovingTarget(12,9,1));
      
      // Misc
      gameObjects.add(CreateLevelEntrance(0,5,2));
      gameObjects.add(CreateLevelEntrance(6,3,2));
      gameObjects.add(CreateLevelEntrance(6,5,2));
      gameObjects.add(CreateLevelEntrance(6,7,2));
      
      gameObjects.add(CreateLevelExit(4,10,3));
      gameObjects.add(CreatePlayButton(1,1));
      
      //Player
      gameObjects.add(CreatePlayer(1, 5, 2));
      break;
      // ------------------------------
    case -101:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(9,1,9,9));
      
      // Edge
      staticObjects.add(CreateWallBlock(19,1,1,9));
      staticObjects.add(CreateWallBlock(0,1,1,9));
      staticObjects.add(CreateWallBlock(0,0,4,1));
      staticObjects.add(CreateWallBlock(5,0,15,1));
      staticObjects.add(CreateWallBlock(0,10,4,1));
      staticObjects.add(CreateWallBlock(5,10,15,1));
      
      // Obstacles
      staticObjects.add(CreateWallBlock(7,1,1,2));
      staticObjects.add(CreateWallBlock(7,4,1,3));
      staticObjects.add(CreateWallBlock(7,8,1,2));
      
      // Lasers
      gameObjects.add(CreateMovingLaser(9,3));
      gameObjects.add(CreateMovingLaser(9,7));
      
      // Laser Controllers
      gameObjects.add(CreateLaserController(7,3,-1,3,false,0));
      gameObjects.add(CreateLaserController(7,7,0,1,false,1));
      
      // Targets
      gameObjects.add(CreateSolidTarget(12,4,2));
      
      // Misc
      gameObjects.add(CreateLevelEntrance(4,0,3));
      gameObjects.add(CreateLevelExit(4,10,3));
      gameObjects.add(CreatePlayButton(6,5));
      
      //Player
      gameObjects.add(CreatePlayer(4, 1, 3));
      //printCollision();
      break;
    case -102:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(9,1,9,9));
      
      // Edge
      staticObjects.add(CreateWallBlock(19,1,1,9));
      staticObjects.add(CreateWallBlock(0,1,1,9));
      staticObjects.add(CreateWallBlock(0,0,4,1));
      staticObjects.add(CreateWallBlock(5,0,15,1));
      staticObjects.add(CreateWallBlock(0,10,15,1));
      staticObjects.add(CreateWallBlock(16,10,4,1));
      
      // Obstacles
      staticObjects.add(CreateWallBlock(8,1,1,1));
      staticObjects.add(CreateWallBlock(6,1,1,2));
      staticObjects.add(CreateWallBlock(7,2,2,1));
      
      staticObjects.add(CreateWallBlock(6,9,1,1));
      staticObjects.add(CreateWallBlock(8,8,1,2));
      staticObjects.add(CreateWallBlock(6,8,2,1));
      
      // Lasers
      gameObjects.add(CreateMovingLaser(9,1));
      gameObjects.add(CreateMovingLaser(9,9));
      
      // Laser Controllers
      gameObjects.add(CreateLaserController(7,1,-1,1,false,0));
      gameObjects.add(CreateLaserController(7,9,1,3,false,1));
      
      // Targets
      gameObjects.add(CreateLevelEntrance(13,4,1));
      gameObjects.add(CreateLevelEntrance(14,5,2));
      gameObjects.add(CreateLevelEntrance(13,6,3));
      gameObjects.add(CreateLevelEntrance(12,5,4));
      gameObjects.add(CreateMovingTarget(13,5,2));
      
      // Misc
      gameObjects.add(CreateLevelEntrance(4,0,3));
      gameObjects.add(CreateLevelExit(15,10,3));
      gameObjects.add(CreateResetButton(1,1));
      gameObjects.add(CreatePlayButton(7,5));
      
      //Player
      gameObjects.add(CreatePlayer(4, 1, 3));
      
      //printCollision();
      break;
    case -103:
      generateBlankLevel(6);
      // Grids
      gridObjects.add(CreateGrid(9,1,9,9));
      
      // Edge
      staticObjects.add(CreateWallBlock(19,1,1,9));
      staticObjects.add(CreateWallBlock(0,1,1,9));
      staticObjects.add(CreateWallBlock(0,0,4,1));
      staticObjects.add(CreateWallBlock(5,0,15,1));
      staticObjects.add(CreateWallBlock(0,10,4,1));
      staticObjects.add(CreateWallBlock(5,10,15,1));
      
      // Obstacles
      staticObjects.add(CreateWallBlock(7,1,1,2));
      staticObjects.add(CreateWallBlock(7,4,1,3));
      staticObjects.add(CreateWallBlock(7,8,1,2));
      
      // Lasers
      gameObjects.add(CreateMovingLaser(9,3));
      gameObjects.add(CreateMovingLaser(9,7));
      
      // Laser Controllers
      gameObjects.add(CreateLaserController(7,3,-3,4,true,0));
      gameObjects.add(CreateLaserController(7,7,1,5,true,1));
      
      // Targets
      gameObjects.add(CreateMovingTarget(13,4,1));
      gameObjects.add(CreateMovingTarget(14,5,1));
      
      // Misc
      gameObjects.add(CreateLevelEntrance(4,0,3));
      gameObjects.add(CreateLevelExit(4,10,3));
      gameObjects.add(CreatePlayButton(6,5));
      
      //Player
      gameObjects.add(CreatePlayer(4, 1, 3));
      break;
  }
}

void generateBlankLevel(int scale){
  // Set the correct object scale
  levelScale = baseScale*scale;
  // Remeber set scale
  currentScale = scale;
  
  // Create/Reset references
  // Reset player object pointer
  playerObject = null;
  levelExitObject = null;
  // Reset the array of gameobjects
  gameObjects = new ArrayList<GameObject>();
  laserList = new ArrayList<GameObject>();
  targetList = new ArrayList<GameObject>();
  staticObjects = new ArrayList<GameObject>();
  gridObjects = new ArrayList<GameObject>();
  textBoxes = new ArrayList<GameObject>();
  // Reset collision and object grids
  collisionGrid = generateLevelGrid(scale);
  objectGrid = generateObjectGrid(scale);
  //// Set the graph as grid
  //addGridCollision(scale);
}

// Create a grid for the level to play in based in the scale of the level
int[][] generateLevelGrid(int scale){
  // Check if the given scale isn't too big
  if (scale > 6){
    print("ERROR: Level scale value higher than the maximum of 6");
    exit();
    return new int[0][0];
  }
  
  // We want the y axis to be odd to allow for an odd by odd shaped grid
  // Check what the y axis should be based on height
  gridY = height/levelScale;
  // Remove any decimals
  scaleOffset = gridY%1;
  gridY -= scaleOffset;
  // Check if the grid is even and subtract 1 if it is to make it odd
  if (gridY%2 == 0){
    scaleOffset++;
    gridY--;
  }
  // We only need halve the offset on the top and bottom
  scaleOffset *= 0.5f;
  
  return new int[int(width/levelScale)][int(gridY)];
}

// Create a grid for the level to keep track of gameobjects
GameObject[][] generateObjectGrid(int scale){
  // Check if the given scale isn't too big
  if (scale > 6){
    print("ERROR: Level scale value higher than the maximum of 6");
    exit();
    return new GameObject[0][0];
  }
  return new GameObject[int(width/levelScale)][int(gridY)];
}

void drawLevel(int scale){
  drawFloor(scale);
  //drawGrid(scale);
}

void drawFloor(int scale){
  fill(color(229, 211, 179));
  rect(0,0,width,height);
  // A big mess of tan sin and cos to simulate randomness but be deterministic for a brick floor
  for(int y = 0; y < 180/scale; y++){
    for(int x = 0; x < 180/scale; x++){
      tileOffsetX = tan(sin(x)+cos(y))%1f;
      tileOffsetY = tan(sin(y)+cos(x))%1f;
      // Random shading
      fill(color(210+tileOffsetX*10, 180+tileOffsetX*10, 140+tileOffsetX*10));
      pushMatrix();
      // Slight random offset
      translate(x*levelScale*0.7+tileOffsetX+y%2*levelScale-levelScale, (y+0.35)*levelScale*0.4f+tileOffsetY);
      // Slight random rotation
      rotate((tileOffsetX+tileOffsetY)%0.02f);
      rect(0,0, levelScale*0.65, levelScale*0.35);
      popMatrix();
    }
  }
}

void drawGrid(int scale){
  float offsetX = 0;
  float offsetY = 1;
  float gridSize = 0;
  int lineWidth = 2;
  float borderWidth = 0.1;  
  // Determine grid dimentions based on scale
  switch(scale){
    case 1:
      offsetX = 56;
      gridSize = 61;
      lineWidth = 1;
      break;
    case 2:
      offsetX = 28;
      gridSize = 29;
      break;
    case 3:
      offsetX = 20;
      gridSize = 17;
      break;
    case 4:
      offsetX = 16;
      gridSize = 11;
      break;
    case 5:
      offsetX = 12;
      gridSize = 9;
      break;
    case 6:
      offsetX = 9;
      gridSize = 9;
      break;
  }
  // Grid borders
  fill(150);
  rect(offsetX*levelScale, offsetY*levelScale, gridSize*levelScale, gridSize*levelScale);
  fill(125);
  triangle(offsetX*levelScale, offsetY*levelScale, (offsetX+gridSize)*levelScale, offsetY*levelScale, (offsetX+gridSize*0.5f)*levelScale, (offsetY+gridSize*0.5f)*levelScale);
  fill(200);
  triangle(offsetX*levelScale, (offsetY+gridSize)*levelScale, (offsetX+gridSize)*levelScale, (offsetY+gridSize)*levelScale, (offsetX+gridSize*0.5f)*levelScale, (offsetY+gridSize*0.5f)*levelScale);
  // Grid background
  fill(color(255,255,197));
  rect((offsetX+borderWidth)*levelScale, (offsetY+borderWidth)*levelScale, (gridSize-borderWidth*2)*levelScale, (gridSize-borderWidth*2)*levelScale);
  // Grid lines
  fill(0);
  for (int i = 0; i < gridSize; i++){
    if (i != gridSize*0.5f-0.5f){
      rect((offsetX+0.5f+i)*levelScale-lineWidth*0.5f, (offsetY+0.5f)*levelScale-lineWidth*0.5f, lineWidth, (gridSize-1)*levelScale);
      rect((offsetX+0.5f)*levelScale-lineWidth*0.5f, (offsetY+0.5f+i)*levelScale-lineWidth*0.5f, (gridSize-1)*levelScale, lineWidth);
    }
    else {
      rect((offsetX+0.5f+i)*levelScale-lineWidth, (offsetY+0.5f)*levelScale-lineWidth*0.5f, lineWidth*2, (gridSize-1)*levelScale);
      rect((offsetX+0.5f)*levelScale-lineWidth*0.5f, (offsetY+0.5f+i)*levelScale-lineWidth, (gridSize-1)*levelScale, lineWidth*2);
    }
  }
}

void addGridCollision(int scale){
  int offsetX = 0;
  int offsetY = 1;
  int gridSize = 0;
  // Determine grid dimentions based on scale
  switch(scale){
    case 1:
      offsetX = 56;
      gridSize = 61;
      break;
    case 2:
      offsetX = 28;
      gridSize = 29;
      break;
    case 3:
      offsetX = 20;
      gridSize = 17;
      break;
    case 4:
      offsetX = 16;
      gridSize = 11;
      break;
    case 5:
      offsetX = 12;
      gridSize = 9;
      break;
    case 6:
      offsetX = 9;
      gridSize = 9;
      break;
  }
  for (int x = 0; x < gridSize; x++){
    for (int y = 0; y < gridSize; y++){
      collisionGrid[offsetX+x][offsetY+y] = 4;
    }
  }
}

void printCollision(){
  for (int y = 0; y < collisionGrid[0].length; y++){
    for (int x = 0; x < collisionGrid.length; x++){
      print(collisionGrid[x][y]);
    }
    print("\n");
  }
}
