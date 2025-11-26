//--------------------------------------------------------------------------------------------------------------
// Current game loop
//--------------------------------------------------------------------------------------------------------------

// 0. Calculate unchanging variables 
// 1. Generate level
// 2. Reset Level (waitTimer = waitTime, isMoving = true, youLose = false, youWin = false
// 3. Wait timer (waitTimer>0)
// 4. Player is moving (isMoving == true)
// 5. Reached destination 
// 6.a Destination is normal crystal (isMoving = false)
// 6.b Destination is end crystal (youWin = true) <= !!Not yet implemented!!
// 7. Use RC to find target (isMoving == false && isHooking == false)
// 8.a Target found (isHooking = true, crystalFound = true)
// 8.b Target not found (isHoooking = true, crystalFound = false)
// 9. Animate hooking (isHooking == true)
// 10.a There is a target (hookLength > targetDistance => isMoving = true, return to 4.)
// 10.b There is no target (hookLength > hookMaxLength => youLose = true)
// 11.a You lose (Return to 2.) <= !!Not yet implemented!!
// 11.b You win (Return to 1.) <= !!Not yet implemented!!

// Things to add to gameloop
// 2. Add collected crystal reset 
// 6.a Collect crystal (need to keep track of it to allow reset)
// 6.b You win (need to stop movement without starting hook)
// 6.- Other types of crystals/obstacles (unknown what they would do, mirror?, red crystal to lose?)
// 11.a Return to 2. (On pressing spacebar, need to make sure everything resets as it should)
// 11.b Return to 1. (On pressing spacebar, perhaps with increasing difficulty)

// Things to add to game
// - Camera follow based on level size
// - Gameplay UI (Lives, collected crystals, RC?, total crystals)
// - Draw grid if fractions crystals are used
// - RC select currently [1 -> 1.5 -> 1.333... || 1.666...] (Perhaps [1 -> 1.333... -> 1.5 -> 1.666...] would be more intuative)
// - Win/Lose UI

//--------------------------------------------------------------------------------------------------------------
// Setting variables (You can play around with these)
//--------------------------------------------------------------------------------------------------------------

// Gameplay settings
int startY = 0; // The height on the y axis on which the player starts
int maxInputRC = 3; // The maximum RC the player is able to use as an input
float waitTime = 5; // Time the game will wait at the start of every level

// Player settings
float playerSize = 25; // The size of the player
float[] playerColorRGB = {0,0,255}; // The RGB values of the color of the player
float moveTime = 4; // The time it takes to move from crystal to crystal in seconds at the start

// Hook settings
float maxHookWidth = 10; // The maximum thickness of the hook
float minHookWidth = 1; // The minimum thickness of the hook (the hook will approach this based on length compared to max length
float hookTime = 0.5f; // The time it takes for the hook to reach its max length

// Grid settings
// Start grid settings
int gridDistance = 100; // Unit distance between two crystal locations
int startGridSizeX = 7; // The number of columns excluding the two starting crystals
int startGridRangeY = 3; // Example: 3 means -3 to 3
// Endless grids settings
boolean increaseX = true; // Does the crystal field get extra columns every win
int amountIncreaseX = 1; // Increase in number of columns every win
int maxGridX = 30; // Upper bound limit of columns
boolean increaseY = false; // Does the crystal field get extra rows every win
int amountIncreaseY = 1; // Increase in number of row every win, every 1 adds two rows (top/bottom)
int maxGridY = 3; // Upper bound limit of rows
// Random seed settings
boolean useRandomSeed = true; // Determines if the game uses the given seed for level generation
int randomSeed = 0; // The random seed the game uses
// Multiple crystals per column
int maxCrystals = 2; // The maximum number of crystals per column (min = 1)
int[] crystalWeights = {3,1}; // Weights for a given number of crystals size must equal maxCrystals, Example: {3, 1} means 1 crystal has 3/(3+1) = 0.75 odds and 2 crystals has 1/(3+1) = 0.25 odds.

// UI setting
int[] waitBoxSize = {200,100}; // The x, y sizes of the wait box
int waitBoxEdge = 20; // The thickness of the outer edge of the wait box 
float[] waitBoxRGB = {150,150,150}; // The outer edge base color
int waitBoxTextSize = 50; // The size of the text in the wait timer
int RCBoxOffset = 20; // the distance between the top of the player and the bottom of the RC text box
int[] RCBoxSize = {60,40}; // The X, y sizes of the RC box
int RCBoxEdge = 10; // The thickness of the outer edge of the RC box
float[] RCBoxRGB = {150,150,150}; // The base color of the outer edge of the RC box
int RCBoxTextSize = 30; // The main text size of the RC box text

// Crystal settings
float crystalSize = 25; // The size of a crystal

//--------------------------------------------------------------------------------------------------------------
// Global variables (these should not be touched)
//--------------------------------------------------------------------------------------------------------------

// Grid variables
boolean newGrid;
int gridSizeX = 7;
int gridRangeY = 3;
int gridCoordinates[][];
float gridStep;

// Crystal variables
int totalCrystalWeights;
int testCrystalWeight;
int randomCrystalWeight;
float triangleSize;

// Player Variables
int playerRC;
float playerTestRC;
int playerRCCounter;
int playerRCDivider;

boolean playerRCNegative;
float[] playerPos = new float[2];
boolean isMoving;
float moveTimer;
int[] currentPos = new int[2];
int[] targetPos = new int[2];
int[] testPos = new int[2];
float checkDistance;
boolean crystalFound;

// Hook variables
float hookRC;
float hookWidth;
float hookLength;
float hookMaxLength;
boolean isHooking;
float hookTimer;

// Camera variables
float[] camOffset = new float[2];

// Color variables
float[] colorRGB = new float[3];

// UI variables
float waitBoxTriangle;
float waitTimer;

// Game states
boolean resetGame;
boolean youWin = false;
boolean youLose = false;

// Keys
boolean holdShift = false;

//--------------------------------------------------------------------------------------------------------------
// Main Game loop
//--------------------------------------------------------------------------------------------------------------

void mainSetup(){
  setupVariables();
}


void mainGame(){
  if (resetGame){
    resetMain();
    resetGame = false;
  }
  updateMain();
  drawMain();
}

//--------------------------------------------------------------------------------------------------------------
// Game loop functions
//--------------------------------------------------------------------------------------------------------------

void resetMain(){
  setupGrid();
  setupPlayer();
  setupHook();
}

void updateMain(){
  updatePlayerMain();
  updateHookMain();
  updateCameraMain();
  updateWaiting();
}

void drawMain(){
  // Draw order determines layers, last is drawn on top
  drawBackgroundMain();
  drawHookMain(camOffset[0]+playerPos[0],camOffset[1]+playerPos[1]);
  drawLevelMain(camOffset[0],camOffset[1]);
  drawPlayerMain(camOffset[0]+playerPos[0],camOffset[1]+playerPos[1]);
  drawUIMain();
  // Draw the wait timer until it runs out
  if (waitTimer > 0){
    drawWaitingMain();
  }
  // Draw the win/lose textbox over everything else
  drawWinLoseMain();
}

//--------------------------------------------------------------------------------------------------------------
// Load functions
//--------------------------------------------------------------------------------------------------------------

void setupVariables(){
  // Crystal shine triangle size
  triangleSize = pow(pow(crystalSize, 2)*2,0.5f)/2;;
  // Wait box triangle size
  waitBoxTriangle = pow(pow(waitBoxSize[1],2)-pow(waitBoxSize[1]/2, 2),0.5f);
  // Reset wait timer
  waitTimer = waitTime;
  // Fractional steps
  gridStep = gridDistance/6f;
  // Calculate max hooking length based in max rc
  hookMaxLength = pow(pow(maxInputRC,2)+1,0.5)*gridDistance;
  // Start reset functions
  resetGame = true;
}

// Reset the player
void setupPlayer(){
  // Player starting position
  currentPos[0] = 0;
  currentPos[1] = startY;
  targetPos[0] = 6;
  targetPos[1] = startY;
  // The player starts by moving to the first crystal
  isMoving = true;
  moveTimer = 0;
  // Reset the RC
  playerRC = 0;
}

// At the start set the correct hook length and width so it looks good during the count down timer
void setupHook(){
  hookLength = gridDistance;
  hookWidth = maxHookWidth-(maxHookWidth-minHookWidth)*hookLength/hookMaxLength;
  // Reset the RC back to 0 in case it wasn't
  hookRC = 0;
}

void setupGrid(){
  generateLevel();
}

// Generate a new level
void generateLevel(){
  // Generate an empty grid (6n+1 to allow for fraction of 1/6th as 1/2 = 3/6, 1/3 = 2/6 and 2/3 = 4/6)
  gridCoordinates = new int[(gridSizeX+1)*6+1][gridRangeY*12+1];
  
  // Generation variables
  int lastY = startY;
  int[] columnCrystals;
  IntList columnRange;
  
  // Starting crystals
  addCrystal(0,startY,2);
  addCrystal(1,startY,1);
  
  // Do preparations and checks for multiple crystals in a column
  crystalWeightsSetup();
  
  // Generate crystal field by looping through all columns
  for (int i = 0; i < gridSizeX; i++){
    if (i < gridSizeX-1){
      // Using the given weights determine the number of crystals in this column
      columnCrystals = new int[selectCrystalAmount()];
    }
    else {
      // The last column always has one crystal
      columnCrystals = new int[1];
    }
    // Create a list of possible crystal positions within reach of the player from the last crystal position bounded between the grid bounds
    columnRange = range(max(-gridRangeY, lastY-maxInputRC),min(gridRangeY, lastY+maxInputRC));
    // Fill the column crystals array with unique values within the given range
    for (int j = 0; j < columnCrystals.length; j++){
      // Shuffle the range for a random value within the range
      columnRange.shuffle();
      // Grab the first value of the shuffled list
      columnCrystals[j] = columnRange.get(0);
      // Remove this value as an option going forward
      columnRange.remove(0);
      
      if (i < gridSizeX-1){
        // Add column crystal to the grid
        addCrystal(i+2, columnCrystals[j], 1);
      }
      else {
        // Last crystal is the end point
        addCrystal(i+2, columnCrystals[j], 3);
      }
    }
    // Keep track of the last Y position for the next column range
    lastY = columnCrystals[0];
  }
}

//--------------------------------------------------------------------------------------------------------------
// Update functions
//--------------------------------------------------------------------------------------------------------------

// Player based calculations
void updatePlayerMain(){
  // Animate player movement
  if (isMoving &&!(waitTimer>0)){
    // Move based on frame time
    moveTimer += deltaM/1000f;
    // When the destination is reached
    if (moveTimer >= moveTime){
      // Prevent overshooting movement
      moveTimer = moveTime;
      switch(gridCoordinates[targetPos[0]][gridRangeY*6 - targetPos[1]]){
        case 1:
          isMoving = false;
          break;
        case 3:
          break;
      }
    }
    // Apply movement
    playerPos[0] = (currentPos[0] + ((targetPos[0]-currentPos[0])*moveTimer/moveTime)) * gridStep;
    playerPos[1] = -(currentPos[1] + ((targetPos[1]-currentPos[1])*moveTimer/moveTime)) * gridStep;
  }
  // Calculate next crystal based on current RC
  if (!isMoving && !isHooking){
    // Reset move timer
    moveTimer = 0;
    // Set the target crytal as the current crystal
    currentPos[0] = targetPos[0];
    currentPos[1] = targetPos[1];
    testPos[0] = currentPos[0];
    testPos[1] = currentPos[1];
    // Set the test RC by translating playerRC
    playerTestRC = (playerRC-playerRC%4)/4;
    switch (playerRC%4){
      case 1:
        playerTestRC += 1f/3f;
        break;
      case 2:
        playerTestRC += 1f/2f;
        break;
      case 3:
        playerTestRC += 2f/3f;
        break;
      case -1:
        playerTestRC -= 1f/3f;
        break;
      case -2:
        playerTestRC -= 1f/2f;
        break;
      case -3:
        playerTestRC -= 2f/3f;
        break;
    } 
    
    // Reset the distance tracker for checking crystals
    checkDistance = 0;
    crystalFound = false;
    // Check for crystals until 
    while (!crystalFound && checkDistance <= hookMaxLength){
      // Cannot check fractions in an array so the checking needs to be done differenly
      if (playerTestRC%1 == 0){
        testPos[0] += 1;
        testPos[1] += playerTestRC;
      }
      // Check if the RC is x.5
      else if ((playerTestRC*2f)%1 == 0){
        testPos[0] += 2;
        testPos[1] += playerTestRC*2f;
      } 
      // Check if the RC is x.333...
      else if ((playerTestRC*3f)%1 == 0){
        testPos[0] += 3;
        testPos[1] += playerTestRC*3f;
      } else {
        print("ERROR: RC mismatch, RC = " + playerTestRC + "\n");  
      }
      
      // Calculate the distance of this check
      checkDistance = pow(pow(testPos[0] - currentPos[0],2) + pow(testPos[1] - currentPos[1],2),0.5) * gridStep;
      // If the check is not too far
      if (checkDistance <= hookMaxLength){
        // If the distance is not too far set this as the next target
        targetPos[0] = testPos[0];
        targetPos[1] = testPos[1];  
        //Check if outside grid
        if (targetPos[0] > gridCoordinates.length-1 || targetPos[0] < 0 || (gridRangeY*6 - targetPos[1]) > gridCoordinates[0].length-1 || (gridRangeY*6 - targetPos[1]) < 0){
          break;
        }  
        // Check if this coordinate is filled
        if (gridCoordinates[targetPos[0]][gridRangeY*6 - targetPos[1]] > 0){
          crystalFound = true;
        }
      }
    }
    // After a crystal is or isn't found start the hooking sequence
    isHooking = true;
    hookRC = playerTestRC;
    hookTimer = 0;
  }
}

// Update hook length and width
void updateHookMain(){
  // Hooking animation for shooting the hook
  if (isHooking){
    // Increment hookTimer based on delta time
    hookTimer += deltaM/1000f;
    // Prevent overshooting
    if (hookTimer > hookTime){
      hookTimer = hookTime;
    }
    // Hook length depends on max length and hook timer progress
    hookLength = hookMaxLength * hookTimer / hookTime;
    // In case a valid target was found
    if (crystalFound){
      // When the hook reaches the target crystal
      if (hookLength >= pow(pow(targetPos[0]*gridStep-playerPos[0],2)+pow(-targetPos[1]*gridStep-playerPos[1],2),0.5f)){
        // Make sure the hook did not overshoot
        hookLength = pow(pow(targetPos[0]*gridStep-playerPos[0],2)+pow(-targetPos[1]*gridStep-playerPos[1],2),0.5f);
        // No longer hooking
        isHooking = false;
        isMoving = true;
      }
    }
    // In case a valid target was not found, show animation before losing
    else {
      if (hookTimer == hookTime){
        youLose = true;
      }
    }
  } 
  else {
    // Shrink hook back down as player aproaches target crystal 
    hookLength = pow(pow(targetPos[0]*gridStep-playerPos[0],2)+pow(-targetPos[1]*gridStep-playerPos[1],2),0.5f);
  }
  // Hook width is dependend on hook length
  hookWidth = maxHookWidth-(maxHookWidth-minHookWidth)*hookLength/hookMaxLength;
}

void updateCameraMain(){
  camOffset[0] = width/5;
  camOffset[1] = height/2;
}

// Decrease the wait timer until it is 0
void updateWaiting(){
  waitTimer -= deltaM/1000f;
  // Prevent overshooting
  if (waitTimer < 0){
    waitTimer = 0; 
  }
}

//--------------------------------------------------------------------------------------------------------------
// Draw functions
//--------------------------------------------------------------------------------------------------------------

// Refresh the frame by pasting a borderless white box over the entire screen
void drawBackgroundMain(){
  noStroke();
  fill(color(255));
  rect(0,0,width,height);
}

// Draws the hook
void drawHookMain(float offsetX, float offsetY){
  // Move the 0,0 point to the player
  translate(offsetX, offsetY);
  // Rotate the hook based on the hookRC
  rotate(-atan(hookRC));
  // Draw the hook
  fill(color(0));
  rect(0, -hookWidth/2, hookLength, hookWidth);
  // Undo rotation 
  rotate(atan(hookRC));
  // Undo translation
  translate(-offsetX, -offsetY);
}

// Draws the grid of crystals
void drawLevelMain(float offsetX, float offsetY){
  // Move the level based on the camera
  translate(offsetX, offsetY);
  // Loop through all columns
  for (int i = 0; i<gridCoordinates.length; i++){
    // Loop through all rows
    for (int j = 0; j<gridCoordinates[0].length; j++){
      // Don't draw empty spots
      if (gridCoordinates[i][j] != 0){
        // Make the crystal draw position 0,0
        translate(gridStep*i, gridStep*(j-gridRangeY*6));
        // Draw the correct crystal in this position
        drawCrystalMain(gridCoordinates[i][j]);
        // Undo translation
        translate(-gridStep*i, -gridStep*(j-gridRangeY*6));
      }
    }
  }
  translate(-offsetX, -offsetY);
}

// Draw a crystal based on its type
void drawCrystalMain(int type){
  // Change crystal color based on type
  switch(type){
    // Normal crystal
    case 1:
      colorRGB[0] = 150;
      colorRGB[1] = 100;
      colorRGB[2] = 150;
      break;
    // Starting crystal
    case 2:
      colorRGB[0] = 100;
      colorRGB[1] = 100;
      colorRGB[2] = 100;
      break;
    // End crystal
    case 3:
      colorRGB[0] = 200;
      colorRGB[1] = 100;
      colorRGB[2] = 0;
      break;
  }
  // For now all crystals look the same
  //Diamond shape
  noStroke();
  rotate(atan(1));
  fill(colorRGB[0],colorRGB[1],colorRGB[2]);
  rect(-crystalSize/2,-crystalSize/2,crystalSize,crystalSize);
  rotate(-atan(1));    
  //Shine triangles
  fill(colorRGB[0]*0.75,colorRGB[1]*0.75,colorRGB[2]*0.75);
  triangle(0,0,triangleSize,0,0,triangleSize);
  fill(colorRGB[0]*1.25,colorRGB[1]*1.25,colorRGB[2]*1.25);
  triangle(0,0,-triangleSize,0,0,-triangleSize);
}

// Draw the player
void drawPlayerMain(float offsetX, float offsetY){
  translate(offsetX, offsetY);
  noStroke();
  fill(playerColorRGB[0], playerColorRGB[1], playerColorRGB[2]);
  rect(-playerSize/2, -playerSize/2, playerSize, playerSize);
  
  //Draw the RC box
  drawRC(0,-(RCBoxOffset + playerSize/2 + RCBoxSize[1]/2));
  translate(-offsetX, -offsetY);
}

// Draw the box with the current RC value inside of it
void drawRC(float offsetX, float offsetY){
  translate(offsetX, offsetY);
  noStroke();
  drawBox(RCBoxSize, RCBoxEdge, RCBoxRGB);
  fill(color(0));
  textAlign(CENTER, CENTER);
  
  playerRCCounter = 1;
  playerRCDivider = 3;
  switch(playerRC%4){
    case 0: // Whole numbers
      textSize(RCBoxTextSize);
      text(playerRC/4,0,0);
      break;
    case 3: // Positive 2/3
      playerRCCounter = 2;
    case 1: // Positive 1/3
    case 2: // Positive 1/2
      if (playerRC%4 == 2){
        playerRCDivider = 2;
      }
      textSize(RCBoxTextSize); // Front number is big
      if (playerRC > 0 && playerRC < 4){
        text("_",0,-RCBoxTextSize*0.4);
        textSize(RCBoxTextSize/2); // Fraction numbers are small
        text(playerRCCounter,0,-RCBoxTextSize/4);
        text(playerRCDivider,0,RCBoxTextSize*0.3);
      }
      else {
        text(int((playerRC-playerRC%4)/4),-RCBoxTextSize/4,0);
        text("_",RCBoxTextSize/4,-RCBoxTextSize*0.4);
        textSize(RCBoxTextSize/2); // Fraction numbers are small
        text(playerRCCounter,RCBoxTextSize/4,-RCBoxTextSize/4);
        text(playerRCDivider,RCBoxTextSize/4,RCBoxTextSize*0.3);
      }
      break;
    case -3:
      playerRCCounter = 2;
    case -1:
    case -2:
      if (abs(playerRC%4) == 2){
        playerRCDivider = 2;
      }
      textSize(RCBoxTextSize); // Front number is big
      if (playerRC < 0 && playerRC > -4){
        text("-",-RCBoxTextSize/4,0);
        text("_",RCBoxTextSize/4,-RCBoxTextSize*0.4);
        textSize(RCBoxTextSize/2); // Fraction numbers are small
        text(playerRCCounter,RCBoxTextSize/4,-RCBoxTextSize/4);
        text(playerRCDivider,RCBoxTextSize/4,RCBoxTextSize*0.3);
      }
      else {
        text(int((playerRC-playerRC%4)/4),-RCBoxTextSize/3,0);
        text("_",RCBoxTextSize/3,-RCBoxTextSize*0.4);
        textSize(RCBoxTextSize/2); // Fraction numbers are small
        text(playerRCCounter,RCBoxTextSize/3,-RCBoxTextSize/4);
        text(playerRCDivider,RCBoxTextSize/3,RCBoxTextSize*0.3);
      }
      break;
  }  
  translate(-offsetX, -offsetY);
}

// Draw the countdown timer at the start of levels
void drawWaitingMain(){
  // The waiting textbox will be in the center of the screen
  translate(width/2, height/2);
  
  // Create a textbox
  drawBox(waitBoxSize, waitBoxEdge, waitBoxRGB);
  fill(color(0));
  textAlign(CENTER, CENTER);
  textSize(waitBoxTextSize);
  text(int(waitTimer)+1,0,0);
  
  // Undo translation
  translate(-width/2, -height/2);
}

void drawUIMain(){
  // Lives
  // Score
  // RC?
}

void drawWinLoseMain(){
  
}

//--------------------------------------------------------------------------------------------------------------
// Grid generation functions
//--------------------------------------------------------------------------------------------------------------

// This function adds a crystal in the grid coordinates array using our coordinate system 
// (0,0) = center left start point, (1,1) is up 1 and 1 to the right, (1,-1) is down 1 and 1 to the right
void addCrystal(int posX, int posY, int type){
  gridCoordinates[posX*6][(gridRangeY*2-(posY+gridRangeY))*6] = type;
}

// Do preparations for generation of multiple crystals per column and check if the given variables are correct
void crystalWeightsSetup(){
  // Check if the number of given weigths matches the maximum number of crystals and if the maximum number of crystals does not exceed 
  if (crystalWeights.length == maxCrystals && maxCrystals <= gridRangeY*2+1){
    // Count up all weights 
    totalCrystalWeights = 0;
    for (int i = 0; i < crystalWeights.length; i++){
      totalCrystalWeights += crystalWeights[i];
    }
  }
  else{
    if (crystalWeights.length != maxCrystals){
      print("ERROR: The amount of crystal weights and the maximum number of crystals do not match\n");
    }
    else
    {
      print("ERROR: The maximum number of crystals exceeds the maximum amount possible given the grid range on the y axis\n");
    }
    exit(); // I want to exit the game immediately to prevent further crashes but unfortunately exiting after finishing the current draw loop is the best I can do.
  }
}

// Selects the amount of crystals in a column using the given maximum number of crystals per column and given crysal weights
int selectCrystalAmount(){
  // Determine the number of crystals in the column
  // Generate a random value between 0 and the total of all weights
  randomCrystalWeight = int(random(totalCrystalWeights));
  // Reset the testWeight for the current column
  testCrystalWeight = 0;
  // Test every number of crystals until the correct number is found
  for(int j=0; j<crystalWeights.length; j++){
    // Add the weight of the tested amound of crytals to the test weight
    testCrystalWeight += crystalWeights[j];
    // If the test weight is bigger than the random value that is the correct number of crytals
    if (randomCrystalWeight < testCrystalWeight){
      // Since j starts counting from 0 add 1 to start at 1 crystals
      return j+1;
    }
  }
  // The code should never reach here but if it does throw an error and default to 1 crystal in the column
  print("ERROR: random weigth bigger than weights total, defaulting to 1\n");
  return 1;
}

//--------------------------------------------------------------------------------------------------------------
// Input functions
//--------------------------------------------------------------------------------------------------------------

// Keep track if the shift key has been pressed
void mainKeyPressed(){
  if (keyCode == SHIFT){
    holdShift = true;
  }
  
  // Increase the RC
  if (keyCode == UP){
    // Not holding shift snap to the next whole number
    if (!holdShift){
      if (playerRC < 0){
        switch(playerRC%4){
          case 0:
            playerRC += 4;
            break;
          case -1:
          case -2:
          case -3:
            playerRC += abs(playerRC%4);
            break;
        }
      }
      else {
        playerRC += (4 - playerRC%4);
      }
    }
    // Holding shift work with fractions
    else {
      switch(abs(playerRC%4)){
        case 0: // n to 1/2
          playerRC += 2;
          break;
        case 1: // 1/3 to 1/2 or -1/3 to 0
        case 2: // 1/2 to 2/3 or -1/2 to -1/3
        case 3: // 2/3 to n or -2/3 to -1/2
          playerRC += 1;
          break;
      }
    }
    // Upperbound
    if (playerRC > 4*maxInputRC){
      playerRC = 4*maxInputRC;
    }
  }
  
  // Decrease the RC
  if (keyCode == DOWN){
    // Not holding shift snap to the next whole number
    if (!holdShift){
      if (playerRC < 0){
        playerRC -= 4+playerRC%4;
      }
      else {
        switch(playerRC%4){
          case 0:
            playerRC -= 4;
            break;
          case 1:
          case 2:
          case 3:
            playerRC -= playerRC%4;
            break;
        }
      }
    }
    // Holding shift work with fractions
    else {
      switch(abs(playerRC%4)){
        case 0: // n to n-1,1/2
          playerRC -= 2;
          break;
        case 1: // -1/3 to -1/2 or 1/3 to 0
        case 2: // -1/2 to -2/3 or 1/2 to 1/3
        case 3: // -2/3 to -n or 2/3 to 1/2
          playerRC -= 1;
          break;
      }
    }
    // Lowerbound
    if (playerRC < -4*maxInputRC){
      playerRC = -4*maxInputRC;
    }
  }
}

// Keep track if the shift key has been released
void mainKeyReleased(){
  if (keyCode == SHIFT){
    holdShift = false;
  }
}

//--------------------------------------------------------------------------------------------------------------
// Misc. functions
//--------------------------------------------------------------------------------------------------------------

// Range isn't a function in processing so I made my own
IntList range(int min, int max){
  IntList intRange = new IntList();
  for (int i = min; i <= max; i++){
    intRange.append(i);
  }
  return intRange;
}

// Draw a textbox with shaded edges
void drawBox(int[] size, int edge, float[] colRGB){
  noStroke();
  //Shading trangle edges differs based on ratio
  if (size[0]>size[1]){
    fill(color(colRGB[0]*0.75, colRGB[1]*0.75, colRGB[2]*0.75));
    rect(-size[0]/2, 0, size[0], size[1]/2);
    fill(color(colRGB[0]*1.25, colRGB[1]*1.25, colRGB[2]*1.25));
    rect(-size[0]/2, -size[1]/2, size[0], size[1]/2);
    fill(color(colRGB[0], colRGB[1], colRGB[2]));
    triangle(size[0]/2, size[1]/2, size[0]/2-size[1]/2, 0, size[0]/2, -size[1]/2);
    triangle(-size[0]/2, size[1]/2, -size[0]/2+size[1]/2, 0, -size[0]/2, -size[1]/2);
  }
  else {
    fill(color(colRGB[0], colRGB[1], colRGB[2]));
    rect(-size[0]/2, -size[1]/2, size[0], size[1]);
    fill(color(colRGB[0]*0.75, colRGB[1]*0.75, colRGB[2]*0.75));
    triangle(size[0]/2, size[1]/2, 0, size[1]/2-size[0]/2, -size[0]/2, size[1]/2);
    fill(color(colRGB[0]*1.25, colRGB[1]*1.25, colRGB[2]*1.25));
    triangle(size[0]/2, -size[1]/2, 0, -size[1]/2+size[0]/2, -size[0]/2, -size[1]/2);
  }
  // Create the white center
  fill(color(255));
  rect(-(size[0]-edge)/2,-(size[1]-edge)/2, size[0]-edge, size[1]-edge);
}
