import processing.opengl.*;

//Current gameState
int gameState;
int testState;

//For loading purposes
boolean loading;

//Timekeeping
int currentM;
int pastM;
int deltaM;

// Images
PImage MLBFront;
PImage MLBMid;
PImage MLBBack;

void setup(){
  size(1500,750, OPENGL);
  gameState = 3;
  loading = true;
  testState = 1;
  currentM = millis();
  
  // Load images into memory
  MLBFront = loadImage("MLB Front.png");
  MLBMid = loadImage("MLB Mid.png");
  MLBBack = loadImage("MLB Back.png");
}

void draw(){
  //Track frame time
  pastM = currentM;
  currentM = millis();
  deltaM = currentM-pastM; 
  
  // Load before changing game state
  if (!loading){
    switch(gameState){
      //Main menu
      case 0:
        break;
      //Main game
      case 1:
        mainGame();
        break;
      //Level select
      case 2:
        break;
      //Testing around
      case 3:
        drawTest(testState);
        break;
    }
  }
  else {
    switch(gameState){
      //Main menu
      case 0:
        break;
      //Main game
      case 1:
      mainSetup();
        break;
      //Level select
      case 2:
        break;
      //Testing around
      case 3:
        setupTest(testState);
        break;
    }
    loading = false;
  }
}

void keyPressed(){
  // No inputs during loading
  if (!loading){
    switch(gameState){
      //Main menu
      case 0:
        break;
      //Main game
      case 1:
      mainKeyPressed();
        break;
      //Level select
      case 2:
        break;
      //Testing around
      case 3:
        inputTest(testState);
        break;
    }
  }
}

void keyReleased(){
  // No inputs during loading
  if (!loading){
    switch(gameState){
      //Main menu
      case 0:
        break;
      //Main game
      case 1:
      mainKeyReleased();
        break;
      //Level select
      case 2:
        break;
      //Testing around
      case 3:
        break;
    }
  }
}
