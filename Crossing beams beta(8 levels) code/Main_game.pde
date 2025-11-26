int startingLevel;
int currentLevel;

int mainGameZoomScale;

void mainGameSetup(){
  startingLevel = 1;
  loadLevel(startingLevel);
}

void mainGameDraw(){
  fill(0);
  rect(0,0,width,height);
  translate(0, scaleOffset*levelScale);
  // Temp background
  noStroke();
  fill(255);
  rect(0,0,collisionGrid.length*levelScale,collisionGrid[0].length*levelScale);
  
  drawLevel(currentScale);
  mainGameUpdateObjects();
  mainGameDrawObjects();
  translate(0, -scaleOffset);
}

void mainGameUpdateObjects(){
  for (GameObject object : gameObjects){
    object.updateObject();
  }
}

void mainGameDrawObjects(){
  for (GameObject object : gridObjects){
    object.drawObject();
  }
  for (GameObject object : gameObjects){
    object.drawObject();
  }
  for (GameObject object : staticObjects){
    object.drawObject();
  }
  for (GameObject object : textBoxes){
    object.drawObject();
  }
}
