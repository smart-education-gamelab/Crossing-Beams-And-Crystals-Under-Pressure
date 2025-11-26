// Grid test
// Grid variables
int[][] test1Coordinates;
int test1GridX = 16;
int test1YRange = 3;
int test1GridDist = 100;
boolean test1NewGrid = true;

// Crystal variables
float test1CrystalSize = 26;
float test1TriangleSize;

// Generation variables
boolean test1GenerateField = true;
int test1MaxRC = 3;

//Player variables
float test1PlayerX;
float test1PlayerY;
float test1PlayerSize = 25;
int test1TargetX;
int test1TargetY;
int test1CurrentX;
int test1CurrentY;
int test1Rc;
int test1StepTimer;
float test1StepTime = 3f;
boolean test1UseSpeedUp = true;
float test1StepSpeedUp = 0.9f;
float test1MinStepTime = 1.5f;
boolean test1IsMoving;

//Hook
boolean test1TargetFound;
boolean test1IsHooking;
boolean test1Hooked;
float test1HookLength;
float test1MaxHookLength;
float test1HookWidth;
int test1HookRc;
float test1MaxHookTime = 0.5;

//Wait 5 seconds before starting
float test1WaitTime = 5;
float test1WaitTimer;
boolean test1Waiting;

//Win condition
boolean test1Win = false;
boolean test1Lose = false;

//Camera
float test1CameraX;
float test1CameraY;

// Seeded random for testing
boolean test1UseRandomSeed = true;
int test1Seed = 0; 
//Seeds without split: 0, 1, 5, 7, 8
//Seeds with split: 2, 3, 4, 6, 9

//--------------------------------------------------------------------------------------------------------------

void setupTest1(){  
  //Reset wait timer
  test1Waiting = true;
  test1WaitTimer = test1WaitTime;  
  //Reset win/lose
  test1Win = false;
  test1Lose = false;
  
  //Use a seed to determine the random generation
  if (test1UseRandomSeed){
    randomSeed(test1Seed);
    test1UseRandomSeed = false;
  }
  //Save the diagonal of crystals to avoid unnessesary calculations
  test1TriangleSize = pow(pow(test1CrystalSize, 2)*2,0.5f)/2;  
  
  //Set starting coordinates
  test1CurrentX = 0;
  test1CurrentY = 0;
  //Set target coordinates
  test1TargetX = 1;
  test1TargetY = 0;
  
  test1TargetFound = true;
  
  //Start movement
  test1IsMoving = true;
  updateTest1Player();
  
  //Reset hook
  test1HookWidth = 0;
  test1HookRc = 0;
  test1MaxHookLength = pow(pow(test1MaxRC*test1GridDist,2)+pow(test1GridDist,2),0.5f);
  
  if (test1NewGrid){
    test1NewGrid = false;    
    //Create the grid
    test1Coordinates = new int[test1GridX][test1YRange*2+1];
    //Randomly generate a field of crystals
    if (test1GenerateField){
      //Starting crystals
      test1AddCrystal(0,0,2);
      test1AddCrystal(1,0,1);
    
      //Variables for crystal generation
      int lastY = 0;
      int y = 0;
      int nCrystals = 1;
    
      //For as big as the crystal field is
      for (int i = 2; i<test1GridX; i++){
        //Have a weighted random chance to get two crystals in a colum but not the final crystal
        if (i != test1GridX-1){
          nCrystals = (int(random(2)-0.5)+1);
        }
        else {
          nCrystals = 1; 
        }
        //Generate nCrystals
        for (int j = 0; j < nCrystals; j++){
          //Pick a random y position
          y = int(random(test1YRange*2+1))-test1YRange;
          //Prevent crystals from being too far apart in height
          while(abs(lastY - y) > test1MaxRC){
            y = int(random(test1YRange*2+1))-test1YRange;
          }
          //Add a normal crystal unless its the last one
          if (i != test1GridX-1){
            test1AddCrystal(i,y,1);
          }
          else {
            test1AddCrystal(i,y,3);
          }
        }
        //Keep track of the last y position for height distance
        lastY = y;
      }
    }
    //Use a set field for testing
    else{
      test1AddCrystal(0,3,1);
      test1AddCrystal(1,2,1);
      test1AddCrystal(2,1,1);
      test1AddCrystal(3,0,1);
      test1AddCrystal(4,-1,1);
      test1AddCrystal(5,-2,1);
      test1AddCrystal(6,-3,1);
    }
  }
}

//--------------------------------------------------------------------------------------------------------------

void drawTest1(){
  //Background
  noStroke();
  fill(255);
  rect(0,0,width,height); 
  
  //Wait for a certain time after starting the game before updating the player
  if (!test1Waiting){
    updateTest1Player();
  }
  
  drawMovingBackground();
  updateTest1Camera();
  
  //No hook when the game is done
  if (!test1Win && !test1Lose){
    drawTest1Hook();
  }
  drawTest1Crystals();
  drawTest1Player();
  
  translate(-test1CameraX, -test1CameraY);
  
  if (test1Waiting){
    //Keep track of time passing
    test1WaitTimer -= (deltaM/1000f);
    
    //Create a box with a black edge for the countdown timer
    fill(color(0));
    rect(width/2 - 50, height/2 - 50, 100,100);
    fill(color(255));
    rect(width/2 - 45, height/2 - 45, 90,90);
    
    fill(color(0));
    //Allign the countdown timer to the center of the screen
    textAlign(CENTER, CENTER);
    textSize(50);
    //Write the countdown time as an int+1 so that 0.0001 seconds left still shows 1
    text((int(test1WaitTimer)+1), width/2, height*0.49);
    //Once the wait time is over stop the waiting
    if (test1WaitTimer < 0){
      test1Waiting = false;
    }
  }
  
  //Draw win text
  if (test1Win || test1Lose){
    //Create a box with a black edge for the countdown timer
    fill(color(0));
    rect(width/2 - 150, height/2 - 50, 300,100);
    fill(color(255));
    rect(width/2 - 145, height/2 - 45, 290,90);
  
    fill(color(0));
    //Allign the countdown timer to the center of the screen
    textAlign(CENTER, CENTER);
    textSize(40);
    //Write the win/lose text
    if(!test1Lose){ 
      text("You win!",width/2, height/2-30);
      text("Spacebar next", width/2, height/2+15);
    }
    else{
      text("You lose!",width/2, height/2-30);
      text("Press spacebar", width/2, height/2+15);
    }
  }
}

//--------------------------------------------------------------------------------------------------------------

void inputTest1(){
  //Input
  if(keyCode == DOWN || keyCode == LEFT){
    if (test1IsMoving) {
      test1Rc += 1;
      //Clamp input positive
      if (test1Rc > test1YRange){
        test1Rc = test1YRange;
      }
    }
  } 
  if(keyCode == UP || keyCode == RIGHT){
    if (test1IsMoving) {
      test1Rc -= 1;
      //Clamp input negative
      if (test1Rc < -test1YRange){
        test1Rc = -test1YRange;
      }
    }
  }
  if(key == ' '){
    if (test1Lose || test1Win){
      loading = true;
      test1Rc = 0;
      if(test1Win){
        test1NewGrid = true;
        test1GridX += 2;
        if (test1UseSpeedUp){
          test1StepTime *= test1StepSpeedUp;
          if (test1StepTime < test1MinStepTime){
            test1StepTime = test1MinStepTime;
          }
        }
      }
    }
  }
}

//--------------------------------------------------------------------------------------------------------------

void test1AddCrystal(int posX, int posY, int type){
  test1Coordinates[posX][test1YRange*2-(posY+test1YRange)] = type;
}

//--------------------------------------------------------------------------------------------------------------

void drawTest1Crystals(){  
  float R = 0;
  float G = 0;
  float B = 0;
  
  for(int i = 0; i<test1GridX; i++){
    for(int j = 0; j<test1YRange*2+1; j++){
      if (test1Coordinates[i][j] != 0){
        //Set colors
        switch(test1Coordinates[i][j]){
          //Basic crystal
          case 1:
            R = 200; //150
            G = 150; //100
            B = 200; //150
            break;
          //Starting crystal
          case 2:
            R = 150;
            G = 150;
            B = 150;
            break;
          case 3:
            R = 250;
            G = 150;
            B = 0;
            break;
          case 4:
            break;
        }
        noStroke();
        pushMatrix();
        translate(test1GridDist*i,test1GridDist*(j-test1YRange));
        //Diamond shape
        pushMatrix();
        rotate(atan(1));
        fill(R,G,B);
        rect(-test1CrystalSize/2,-test1CrystalSize/2,test1CrystalSize,test1CrystalSize);
        popMatrix();
        //Shine triangles
        fill(R*0.75,G*0.75,B*0.75);
        triangle(0,0,test1TriangleSize,0,0,test1TriangleSize);
        fill(R*1.25,G*1.25,B*1.25);
        triangle(0,0,-test1TriangleSize,0,0,-test1TriangleSize);
        popMatrix();
      }
    }
  }
}

//--------------------------------------------------------------------------------------------------------------

void updateTest1Camera(){
  test1CameraX = 0;
  test1CameraY = height/2;
  
  //The camera follows the player horizontally keeping the player at the left boundry untill the maze hits the right boundry.
  if (test1PlayerX <= ((test1GridX-1)*test1GridDist-width/5*3) && test1PlayerX >= 0){
    test1CameraX = width/5 - test1PlayerX;
  }
  //When the maze hits the right boundry
  else if (test1PlayerX > (test1GridX-1)*100-width/5*3){
    //Lock the camera at the right boundry
    if ((test1GridX-1)*test1GridDist>width/5*3){
      test1CameraX = width-((test1GridX-1)*test1GridDist+width/5);
    }
    //If the total width of the maze is too small for scrolling the camera is static
    else{
      test1CameraX = width/5;
    }
  }
  //The camera shouldn't move when the player goes behind the starting crystal (keeps boundry of width/5)
  else if (test1PlayerX < 0){
    test1CameraX = width/5;
  }
  
  //Draw borders
  fill(color(150));
  //Left border
  rect(0,0,width/5 - (width/5 - test1CameraX),height);
  //Right border
  rect(width/5*4+(test1GridX-1)*test1GridDist-(width/5*3)-(width/5 - test1CameraX),0,width/5,height);
  //Top border
  rect(0,0,width,15);
  rect(0,height-15,width,15);
  
  // Apply camera movements
  translate(test1CameraX, test1CameraY);
}

//--------------------------------------------------------------------------------------------------------------

void updateTest1Player(){
  if (test1IsMoving){
    if (!loading){
      //Keep track of the step duration in real time
      test1StepTimer += deltaM;
    }
    
    //Check if the step is complete
    if (test1StepTimer >= test1StepTime*1000){
      //Reset the step timer for next step
      test1StepTimer = 0;
      
      //Since we've arived the target position is now the current position;
      test1CurrentX = test1TargetX;
      test1CurrentY = test1TargetY;
      
      //The player is no longer moving
      test1IsMoving = false;
      if (!test1IsMoving){
        switch(test1Coordinates[test1TargetX][test1TargetY+3]){
          //Target was air;
          case 0:
            break;
          //Target was a normal crystal
          case 1:
            //Search for next crystal
            test1TargetFound = false;
            boolean tooFar = false;
            float testLength = 0;
            while (!test1TargetFound && !tooFar){
              testLength += pow(pow(test1Rc * test1GridDist,2)+pow(test1GridDist,2),0.5f);;
              if (!test1TargetFound && testLength > test1MaxHookLength || abs(test1TargetY + test1Rc) > test1YRange || test1TargetX + 1 > test1GridX-1){
                tooFar = true;
              }
              else{
                test1TargetX += 1;
                test1TargetY += test1Rc;
                if (test1Coordinates[test1TargetX][test1TargetY+3] > 0){
                  // Found the next target
                  test1TargetFound  = true;
                }
              }              
            }
            test1IsHooking = true;
            test1Hooked = false;
            break;
          //Target was start point
          case 2:
            break;
          //Target was end point
          case 3:
            test1Win = true;
            break;
        }
      }
    }
    //Position the player based on starting position and target position and the progress in the step
    test1PlayerX = test1CurrentX*test1GridDist + (test1TargetX-test1CurrentX)*test1GridDist*test1StepTimer/(test1StepTime*1000);
    test1PlayerY = test1CurrentY*test1GridDist + (test1TargetY-test1CurrentY)*test1GridDist*test1StepTimer/(test1StepTime*1000);
  }
}

//--------------------------------------------------------------------------------------------------------------

void drawTest1Player(){
  fill(0);
  rect(test1PlayerX - 26, test1PlayerY - 26 - 50, 52,52);
  fill(255);
  rect(test1PlayerX - 25, test1PlayerY - 25 - 50, 50,50);
  
  fill(0);
  //Allign RC to center text
  textAlign(CENTER, CENTER);
  textSize(50);
  text(-test1Rc, test1PlayerX, test1PlayerY - 58);
  
  noStroke();
  fill(color(0,0,255));
  rect(test1PlayerX - (test1PlayerSize/2), test1PlayerY - (test1PlayerSize/2), test1PlayerSize, test1PlayerSize);
}

//--------------------------------------------------------------------------------------------------------------

void drawTest1Hook(){
  if (test1IsHooking){
    //Keep track of the hook duration in real time
    test1StepTimer += deltaM;    
    test1HookLength = test1MaxHookLength*test1StepTimer/(test1MaxHookTime*1000);
    test1HookWidth = test1HookLength/test1GridDist;
    test1HookRc = test1Rc;
    if (test1StepTimer >= test1MaxHookTime*1000 || (test1HookLength >= pow(pow(((test1TargetX-test1CurrentX)*test1GridDist),2)+pow(((test1TargetY-test1CurrentY)*test1GridDist),2),0.5f)) && test1TargetFound){
      //Reset the step timer for next step
      test1StepTimer = 0;
      test1IsHooking = false;
      if (test1TargetFound){
        test1IsMoving = true;
      } 
      else {
        test1Lose=true;
      }
    }    
  }
  else{
    if(test1TargetFound){
      test1HookLength = pow(pow(test1TargetX*test1GridDist-test1PlayerX,2)+pow((test1TargetY*test1GridDist-test1PlayerY),2),0.5f);
    }
    else{
      test1HookLength = test1MaxHookLength;
    }
  }
  pushMatrix();
  translate(test1PlayerX, test1PlayerY);
  fill(color(0));
  rotate(atan(test1HookRc));
  rect(0,-3.5+test1HookWidth,test1HookLength, 7-test1HookWidth*2);
  popMatrix();
}

//--------------------------------------------------------------------------------------------------------------

void drawMovingBackground(){
  noStroke();
  // Backdrop
  fill(125,156,122);
  rect(0,0,width,height); 
  // Layer back
  image(MLBBack,test1CameraX*0.25,0);
  // Layer mid
  image(MLBMid,test1CameraX*0.5,0);
  // Layer front
  image(MLBFront,test1CameraX,0);
}
