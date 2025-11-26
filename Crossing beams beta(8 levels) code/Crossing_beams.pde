int gameState;

// Time keeping
int currentMillis;
int pastMillis;
float deltaTime;

void setup(){
  size(1500,825);
  gameState = -1;  
  switchState(0);
}

void draw(){
  // Track frame time
  pastMillis = currentMillis;
  currentMillis = millis();
  deltaTime = (currentMillis-pastMillis)*0.001; 

  // Main gameloop
  switch(gameState){
    case 0: // Main menu
      mainMenuDraw();
      break;
    case 1: // Main game
      mainGameDraw();
      break;
    case 2: // Level select
      break;
    case 3: // Settings
      break;
    case 4: // Tests
      drawTests();
      break;
  }
}


void switchState(int newState){
  // Loading state
  gameState = -1;
  switch(newState){
    case 0:
      mainMenuSetup();
      gameState = 0;
      break;
    case 1: // Main game
      mainGameSetup();
      gameState = 1;
      break;
  }
}
