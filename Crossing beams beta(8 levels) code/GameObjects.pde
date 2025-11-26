// ----- Global -----
ArrayList<GameObject> gameObjects;
ArrayList<GameObject> staticObjects;
ArrayList<GameObject> gridObjects;
ArrayList<GameObject> textBoxes;
ArrayList<GameObject> laserList;
ArrayList<GameObject> targetList;
int[][] collisionGrid; //0 empty, 1 solid, 2 moveable, 3 track, 4 grid
GameObject[][] objectGrid;
GameObject[][] staticGrid;
GameObject playerObject;
GameObject levelExitObject;
GameObject playButtonObject;
float baseScale = 12.5;
float levelScale = 0;

// ----- GameObject -----
abstract class GameObject{
  // All objects have a grid position, default 0,0
  float posX, posY = 0;
  // Allow for external change of position
  void PosX(float x){posX = x;}
  void PosY(float y){posY = y;}
  
  // All objects have an integer size, default 1 by 1 grid spaces
  int sizeX, sizeY = 1;
  // Allows for external change of size
  void SizeX(int x){sizeX = x;}
  void SizeY(int y){sizeY = y;}
  
  // Read variables
  float GetPosX(){return posX;}
  float GetPosY(){return posY;}
  float getSizeX(){return sizeX;}
  float getSizeY(){return sizeY;}
  boolean GetActive(){return isActive;}
  
  // Link number is for linking laser cannons with laser controllers
  int linkNumber = 0;
  void LinkNumber(int n){linkNumber = n;}
  
  // Targets have a required number of hits
  int requiredHit = 0;
  void RequiredHit(int count){requiredHit = count;}
  int hitCount = 0;
  boolean GetHitResult(){return (requiredHit-hitCount <=0);}
  
  // Set object as interactable by the player
  boolean interactable = false;
  void Interactable(boolean bool){interactable = bool;}
  
  // Set laser controller mode
  boolean decimalController = false;
  void DecimalController(boolean bool){decimalController = bool;}
  
  // Set the RC for applicable objects
  float objRC = 0;
  void ObjRC(float rc){objRC = rc;}
  
  // Keep track if the button is active or not
  boolean isActive = false;
  
  // Keep track if object is marked as solid
  boolean isSolid = false;
  // Setting the object as solid on the collision grid, used for walls during level generation
  void setSolid(){
    isSolid = true;
    if (sizeX < 1){ 
      sizeX = 1;
    }
    if (sizeY < 1){ 
      sizeY = 1;
    }
    for (int x = 0; x < sizeX; x++){
      for (int y = 0; y < sizeY; y++){
        // Mark the occupied squares as solid
        collisionGrid[int(posX)+x][int(posY)+y] = 1;
        // Save object to object grid for easy collision handling
        objectGrid[int(posX)+x][int(posY)+y] = this;
      }
    }
  }
  
  // Insert the possitions of the track into the collisionGrid
  void setTrack(){
    for (int x = 0; x < sizeX; x++){
      for (int y = 0; y < sizeY; y++){
        // Mark the occupied squares as track
        collisionGrid[int(posX)+x][int(posY)+y] = 3;
      }
    }
  }
  
  // Setting the object as moveable on the collision grid, used for moveable objects during level generation
  void setMoveable(){
    // Mark the occupied square as moveable
    collisionGrid[int(posX)][int(posY)] = 2;
    // Save object to object grid for easy collision handling
    objectGrid[int(posX)][int(posY)] = this;
  }
  
  // Attempt to activate the object
  void activateObject(){}
  // Attempt to interact the object
  void interactObject(){}
  // Attempt to move the object
  boolean moveObject(int dir){print("This object does not move " + dir + "\n"); return false;};
  // All objects have an update function
  void updateObject(){}
  // All objects have a draw function
  void drawObject(){}
}

// ----- Player -----
class Player extends GameObject{
  int lookDir = 2; // 1 Up, 2 Right, 3 Down, 4 Left
  int collisionType = 0;
  boolean interacted = true;
  
  //Movement animation
  boolean isMoving = false;
  boolean inMenu = false;
  float startingX;
  float startingY;
  float targetX;
  float targetY;
  float moveTime = 0.3f;
  float timer;
  float moveDelay = 0f;
  GameObject targetObject = null;
  
  void updateObject(){
    
    // Player should not be active whilst in a menu
    if (!inMenu){
      // Player movement has two states, waiting input state, moving state
      // Waiting input state
      if (!isMoving){
        // Reset timer if no directional button is held
        if (!upHeld && !rightHeld && !downHeld && !leftHeld){
          timer = 0;
        } else { // When a directional button is held start a timer
          timer += deltaTime;
        }
        
        //Change direction
        if (upHeld){
          lookDir = 1;
        }
        if (rightHeld){ 
          lookDir = 2;
        }
        if (downHeld){
          lookDir = 3;
        }
        if (leftHeld){
          lookDir = 4;
        }
        
        // If the timer is greater than the delay, attempt to move
        if (timer > moveDelay){
          collisionType=checkMovement(lookDir, 0, posX, posY);
          timer = 0;
          startMovement();
        }
        
        // Reset interact on release
        if (interacted && (!zHeld && !spaceHeld)){
          interacted = false;  
        }
        // Interact in front
        if ((zHeld || spaceHeld) && !interacted){
          // Keep track if interacted for one interaction per button press
          interacted = true;
          switch(lookDir){
            case 1:
              if ((posY-1) >= 0){
              targetObject = objectGrid[int(posX)][int(posY-1)];
              } else {
                targetObject = null;
              }
              break;
            case 2:
              if ((posX+1) < objectGrid.length){
                targetObject = objectGrid[int(posX+1)][int(posY)];
              } else {
                targetObject = null;
              }
              break;
            case 3:
              if ((posY+1) < objectGrid[0].length){
              targetObject = objectGrid[int(posX)][int(posY+1)];
              } else {
                targetObject = null;
              }
              break;
            case 4:
              if ((posX-1) >= 0){
              targetObject = objectGrid[int(posX-1)][int(posY)];
              } else {
                targetObject = null;
              }
              break;
          }
          if (targetObject!=null){
            if (targetObject.interactable == true){
              targetObject.interactObject();
            }
          }
        }
      }
      else {
        switch(collisionType){
          case 1:
            timer += deltaTime;
            if (timer>moveTime){
              posX = int(targetX);
              posY = int(targetY);
              isMoving = false;
              break;
            }
            posX = startingX + (targetX - startingX) * timer / moveTime;
            posY = startingY + (targetY - startingY) * timer / moveTime;
            break;
          case 2:
            timer += deltaTime;
            if (timer > moveTime) {
              isMoving = false;
            }
            break;
        }
      }
    }
  }
  
  void startMovement(){
    switch(collisionType){
      case 0:
        // Bonk sound effect?
        break; 
      case 1:
        isMoving = true;
        startingX = posX;
        startingY = posY;
        targetX = posX;
        targetY = posY;
        switch(lookDir){
          case 1:
            targetY--;
            break;
          case 2:
            targetX++;
            break;
          case 3:
            targetY++;
            break;
          case 4:
            targetX--;
            break;
        }
        objectGrid[int(startingX)][int(startingY)] = null;
        objectGrid[int(targetX)][int(targetY)] = this;
        break;
      case 2:
        targetX = posX;
        targetY = posY;
        switch(lookDir){
          case 1:
            targetY--;
            break;
          case 2:
            targetX++;
            break;
          case 3:
            targetY++;
            break;
          case 4:
            targetX--;
            break;
        }
        if(!objectGrid[int(targetX)][int(targetY)].moveObject(lookDir)){
          timer = moveTime;
        }
        break;
    }
  }
  
  // Player "sprite"
  void drawObject(){
    // Main body
    noStroke();
    fill(color(0,155,0));
    rect(posX*levelScale,posY*levelScale,levelScale,levelScale);
    fill(0);
    // Use eyes to indicate which direction the player is looking at
    switch(lookDir){
      case 1:
        rect((posX+0.2f)*levelScale, (posY+0.2f)*levelScale, 0.1f*levelScale, 0.1f*levelScale);
        rect((posX+0.7f)*levelScale, (posY+0.2f)*levelScale, 0.1f*levelScale, 0.1f*levelScale);
        break;
      case 2:
        rect((posX+0.7f)*levelScale, (posY+0.2f)*levelScale, 0.1f*levelScale, 0.1f*levelScale);
        rect((posX+0.7f)*levelScale, (posY+0.7f)*levelScale, 0.1f*levelScale, 0.1f*levelScale);
        break;
      case 3:
        rect((posX+0.2f)*levelScale, (posY+0.7f)*levelScale, 0.1f*levelScale, 0.1f*levelScale);
        rect((posX+0.7f)*levelScale, (posY+0.7f)*levelScale, 0.1f*levelScale, 0.1f*levelScale);
        break;
      case 4:
        rect((posX+0.2f)*levelScale, (posY+0.2f)*levelScale, 0.1f*levelScale, 0.1f*levelScale);
        rect((posX+0.2f)*levelScale, (posY+0.7f)*levelScale, 0.1f*levelScale, 0.1f*levelScale);
        break;
    }
    rect(0,0,0,0);
  }
  
  // Activating the player switches between menu mode and active mode
  void activateObject(){
    inMenu = !inMenu;
  }
  
  // -- Repurposed function --
  // Set the lookDir of the player
  void ObjRC(float LookDir){lookDir = int(LookDir);}
}

// ----- LevelEntrance -----
class LevelEntrance extends GameObject{
  void drawObject(){
    pushMatrix();
    translate(posX*levelScale,posY*levelScale);
    translate(0.5*levelScale, 0.5*levelScale);
    // Rotate arrow
    switch(int(objRC)){
      case 2:
        rotate(0.5*PI);
        break;
      case 3:
        rotate(1*PI);
        break;
      case 4:
        rotate(1.5*PI);
        break;
    }
    // Draw Arrow outline
    fill(0);
    rect(-0.1*levelScale, -0.25*levelScale, 0.2*levelScale, 0.75*levelScale);
    triangle(-0.5*levelScale, 0, 0.5*levelScale, 0, 0, -0.5*levelScale);
    // Draw Arrow inside
    fill(255);
    rect(-0.05*levelScale, -0.2*levelScale, 0.1*levelScale, 0.65*levelScale);
    triangle(-0.375*levelScale,-0.05*levelScale,0.375*levelScale,-0.05*levelScale,0,-0.425*levelScale);  
    popMatrix();
  }
}

// ----- LevelExit -----
class LevelExit extends GameObject{
  boolean open = false;
  
  void updateObject(){
    if (open){
      if (posX == playerObject.GetPosX()){
        if (posY == playerObject.GetPosY()){
          loadLevel(currentLevel+1);
        }
      }
    }
  }
  
  void drawObject(){
    pushMatrix();
    translate(posX*levelScale,posY*levelScale);
    
    if (!open){
      fill(200,0,0);
      rect(0, 0, levelScale, levelScale);
      fill(255);
      rect(0.1*levelScale, 0.1*levelScale, 0.8*levelScale, 0.8*levelScale);
      pushMatrix();
      translate(0.5*levelScale, 0.5*levelScale);
      rotate(0.25*PI);
      fill(200,0,0);
      rect(-0.6*levelScale, -0.05*levelScale, 1.2*levelScale, 0.1*levelScale);
      popMatrix();
    } else {
      pushMatrix();
      translate(0.5*levelScale, 0.5*levelScale);
      // Rotate arrow
      switch(int(objRC)){
        case 2:
          rotate(0.5*PI);
          break;
        case 3:
          rotate(1*PI);
          break;
        case 4:
          rotate(1.5*PI);
          break;
      }
      // Draw Arrow outline
      fill(0);
      rect(-0.1*levelScale, -0.25*levelScale, 0.2*levelScale, 0.75*levelScale);
      triangle(-0.5*levelScale, 0, 0.5*levelScale, 0, 0, -0.5*levelScale);
      // Draw Arrow inside
      fill(255);
      rect(-0.05*levelScale, -0.2*levelScale, 0.1*levelScale, 0.65*levelScale);
      triangle(-0.375*levelScale,-0.05*levelScale,0.375*levelScale,-0.05*levelScale,0,-0.425*levelScale);
      popMatrix();
    }  
    popMatrix();
  }
  
  void activateObject(){
    open = true;
    collisionGrid[int(posX)][int(posY)] = 0;
  }
}

// ----- Laser Controller -----
class LaserController extends GameObject{
  GameObject linkedLaser = null;
  
  // RC control
  boolean isSelected = false;
  boolean cancelPrimed = false;
  float inputDelay = 0.25;
  float delayTimer = 0;
  int counter = 0;
  int denominator = 1;
  int decimalSelector = 0;
  boolean RCNegative = false;
  int RCWhole;
  int RCTenth;
  int RCHundredth;
  
  void setSolid(){
    isSolid = true;
    // Mark the occupied squares as solid
    collisionGrid[int(posX)][int(posY)] = 1;
    // Save object to object grid for easy collision handling
    objectGrid[int(posX)][int(posY)] = this;
    
    if (decimalController){
      objRC = float(counter)/float(denominator);
      print(objRC+"\n");
      if (abs(objRC%0.01) > 0.001){
        print(objRC%0.01+"\n");
        print("ERROR: Given RC cannot have more than 2 decimals\n" + "Laser controller " + linkNumber + " has an RC of " + objRC + "\n" + "It's recomended to pick a denominator of the values: 1,2,4 or 10.\n");
      }
    }
    
    // Link the laserController to laser based on link number
    if (laserList.size() > linkNumber){
      linkedLaser = laserList.get(linkNumber);
      linkedLaser.LinkNumber(linkNumber);
      linkedLaser.ObjRC(float(counter)/float(denominator));
    } else {
      print("ERROR: Not enough lasers to link to laser " + linkNumber + "\n");  
    }
  }
  
  void updateObject(){
    // When the laser is selected
    if (isSelected){
      // Open window to show RC changes
      // Prevent the window for instantly closing if x or z is held before the laser is selected
      if (!xHeld && !zHeld && !spaceHeld){
        // Once the window detects a frame without x or z being held prime canceling
        cancelPrimed = true;
      }
      // If x is held while canceling is primed deselect the laser
      else if (cancelPrimed){
        // Deselect the laser
        isSelected = false;
        // Reset the priming for next interaction
        cancelPrimed =  false;
        if (decimalController){
          // Set RC based on controller RC
          linkedLaser.ObjRC(objRC);
        } else  {
          // Set RC based on noemer and teller
          linkedLaser.ObjRC(float(counter)/float(denominator));
        }
        // Turn off player menu mode
        playerObject.activateObject();
      }
      // Handle inputs for RC window
      
      // Reset delay if no input is detected
      if (!(upHeld || downHeld || leftHeld || rightHeld)){
        delayTimer = 0;
      }
      // Decrease delay
      if (delayTimer > 0){
        delayTimer -= deltaTime;
      }
      if (!decimalController){
        // Prevent double input
        if (!(rightHeld && leftHeld)){
          // Wait for delay
          if (delayTimer <= 0){
            if (rightHeld){
              denominator++;
              delayTimer = inputDelay;
            }
            if (leftHeld){
              // Prevent divide by zero
              if (denominator > 1){
                denominator--;
              }
              delayTimer = inputDelay;
            }
          }
        }
        // Prevent double input
        if (!(upHeld && downHeld)){
          // Wait for delay
          if (delayTimer <= 0){
            if (upHeld){
              counter++;
              delayTimer = inputDelay;
            }
            if (downHeld){
              counter--;
              delayTimer = inputDelay;
            }
          }
        }
      } else {
        // Prevent double input
        if (!(upHeld && downHeld)){
          // Wait for delay
          if (delayTimer <= 0){
            if (upHeld){
              switch(decimalSelector){
                case 0:
                  RCNegative = !RCNegative;
                  objRC = float(RCWhole)+float(RCTenth)*0.1+float(RCHundredth)*0.01;
                  if (RCNegative) {objRC*=-1;}
                  break;
                case 1:
                  if (RCWhole == 9){
                    RCWhole = 0;
                  } else {
                    RCWhole++;
                  }
                  objRC = float(RCWhole)+float(RCTenth)*0.1+float(RCHundredth)*0.01;
                  if (RCNegative) {objRC*=-1;}
                  break;
                case 2:
                  if (RCTenth == 9){
                    RCTenth = 0;
                  } else {
                    RCTenth++;
                  }
                  objRC = float(RCWhole)+float(RCTenth)*0.1+float(RCHundredth)*0.01;
                  if (RCNegative) {objRC*=-1;}
                  break;
                case 3:
                  if (RCHundredth == 9){
                    RCHundredth = 0;
                  } else {
                    RCHundredth++;
                  }
                  objRC = float(RCWhole)+float(RCTenth)*0.1+float(RCHundredth)*0.01;
                  if (RCNegative) {objRC*=-1;}
                  break;
              }
              delayTimer = inputDelay;
            }
            if (downHeld){
              switch(decimalSelector){
                case 0:
                  RCNegative = !RCNegative;
                  objRC = float(RCWhole)+float(RCTenth)*0.1+float(RCHundredth)*0.01;
                  if (RCNegative) {objRC*=-1;}
                  break;
                case 1:
                  if (RCWhole == 0){
                    RCWhole = 9;
                  } else {
                    RCWhole--;
                  }
                  objRC = float(RCWhole)+float(RCTenth)*0.1+float(RCHundredth)*0.01;
                  if (RCNegative) {objRC*=-1;}
                  break;
                case 2:
                  if (RCTenth == 0){
                    RCTenth = 9;
                  } else {
                    RCTenth--;
                  }
                  objRC = float(RCWhole)+float(RCTenth)*0.1+float(RCHundredth)*0.01;
                  if (RCNegative) {objRC*=-1;}
                  break;
                case 3:
                  if (RCHundredth == 0){
                    RCHundredth = 9;
                  } else {
                    RCHundredth--;
                  }
                  objRC = float(RCWhole)+float(RCTenth)*0.1+float(RCHundredth)*0.01;
                  if (RCNegative) {objRC*=-1;}
                  break;
              }
              delayTimer = inputDelay;
            }
          }
        }
        // Prevent double input
        if (!(rightHeld && leftHeld)){
          // Wait for delay
          if (delayTimer <= 0){
            if (rightHeld){
              decimalSelector++;
              if (decimalSelector > 3){
                decimalSelector = 0;
              }
              delayTimer = inputDelay;
            }
            if (leftHeld){
              // Prevent divide by zero
              decimalSelector--;
              if (decimalSelector < 0){
                decimalSelector = 3;
              }
              delayTimer = inputDelay;
            }
          }
        }
      }
    } 
  }
  
  void drawObject(){
    // Collor the controller to match the corresponding linked laser
    switch(linkNumber){
      case 0:
        fill(100,255,100); // Green
        break;
      case 1:
        fill(0,255,200); // Cyan 
        break;
      case 2:
        fill(255,100,0); // Orange
        break;
      case 3:
        fill(0,0,200); // Dark blue
        break;
      case 4:
        fill(255,255,0); // Yellow
        break;
      case 5:
        fill(255,141,161); // Pink
        break;
    }  
    
    // Open a matrix
    pushMatrix();
    // Move to the correct position
    translate(posX*levelScale,posY*levelScale);
    // Draw the base of the controller with the link color
    rect(0,0,levelScale,levelScale);
    
    if (decimalController){
      fill(255);
      rect(0.2*levelScale, 0.2*levelScale, 0.6*levelScale, 0.6*levelScale);
      fill(0);
      textAlign(CENTER);
      textSize(22);
      text(nf(objRC, 0, 2), 0.5*levelScale, 0.6*levelScale);
    } else {
      // Add the RC fraction text onto the controller
      fill(255);
      rect(0.2*levelScale, 0.2*levelScale, 0.6*levelScale, 0.6*levelScale);
      fill(0);
      rect(0.4*levelScale, 0.49*levelScale, 0.2*levelScale, 0.02*levelScale);
      textAlign(CENTER);
      textSize(20);
      text((int)counter, 0.5*levelScale, 0.45*levelScale);
      text((int)denominator, 0.5*levelScale, 0.7*levelScale);
    }
    
    // Draw window to indicate the laser controller is selected and to chance the RC
    if(isSelected){
      fill(0);
      rect(0, 0, levelScale, levelScale);
      fill(255);
      rect(0.05*levelScale, 0.05*levelScale, 0.9*levelScale, 0.9*levelScale);
      
      if (decimalController){
        fill(0);
        // Set text size based on levelScale
        textAlign(CENTER);
        textSize(22);
        if (RCNegative){
          text(nf(objRC, 0, 2), 0.5*levelScale, 0.6*levelScale);
        } else {
          text("+" + nf(objRC, 0, 2), 0.5*levelScale, 0.6*levelScale);
        }
        if (RCNegative){
          switch(decimalSelector){
            case 0:
              text("↑", (0.245)*levelScale, 0.35*levelScale);
              text("↓", (0.245)*levelScale, 0.8*levelScale);
              break;
            case 1:
              text("↑", (0.375)*levelScale, 0.35*levelScale);
              text("↓", (0.375)*levelScale, 0.8*levelScale);
              break;
            case 2:
              text("↑", (0.58)*levelScale, 0.35*levelScale);
              text("↓", (0.58)*levelScale, 0.8*levelScale);
              break;
            case 3:
              text("↑", (0.72)*levelScale, 0.35*levelScale);
              text("↓", (0.72)*levelScale, 0.8*levelScale);
              break;
          }
        } else {
          switch(decimalSelector){
            case 0:
              text("↑", (0.245)*levelScale, 0.35*levelScale);
              text("↓", (0.245)*levelScale, 0.8*levelScale);
              break;
            case 1:
              text("↑", (0.395)*levelScale, 0.35*levelScale);
              text("↓", (0.395)*levelScale, 0.8*levelScale);
              break;
            case 2:
              text("↑", (0.61)*levelScale, 0.35*levelScale);
              text("↓", (0.61)*levelScale, 0.8*levelScale);
              break;
            case 3:
              text("↑", (0.74)*levelScale, 0.35*levelScale);
              text("↓", (0.74)*levelScale, 0.8*levelScale);
              break;
          }
        }
        
      } else {
        fill(0);
        rect(0.3*levelScale, 0.48*levelScale, 0.4*levelScale, 0.04*levelScale);
        // Set text size based on levelScale
        textAlign(CENTER);
        textSize(20);
        text("↓", 0.2*levelScale, 0.3*levelScale);
        text("↑", 0.8*levelScale, 0.3*levelScale);
        text("←", 0.2*levelScale, 0.75*levelScale);
        text("→", 0.8*levelScale, 0.75*levelScale);
        
        textSize(30);
        text((int)counter, 0.5*levelScale, 0.4*levelScale);
        text((int)denominator, 0.5*levelScale, 0.8*levelScale);
      }
    }
    popMatrix();
  }
  // When the player attempts to interact with this object
  void interactObject(){
    // Prevent interaction while active
    if (!linkedLaser.GetActive()){
      // Set this object as selected
      isSelected = true;
      delayTimer = inputDelay*2;
      // Tell the player object to enter menu mode by activating it
      playerObject.activateObject();
      if (objRC < 0){
        RCNegative = true;
      }
      if (RCNegative){
        RCWhole = abs(int(ceil(objRC)));
        RCTenth = abs(int(ceil((objRC*10)%10)));
        RCHundredth = abs(int(ceil((objRC*100)%10)));
      } else {
        RCWhole = abs(int(floor(objRC)));
        RCTenth = abs(int(floor((objRC*10)%10)));
        RCHundredth = abs(int(floor((objRC*100)%10)));
      }
    }
    // ??? Add check to prevent interaction if RC is set unchangeable ???
  }
  void SizeX(int Denominator){
    denominator = Denominator;
  }
  void SizeY(int Counter){
    counter = Counter;
  }
}

// ----- Laser Cannon -----
class Laser extends GameObject{
  //Movement animation
  boolean isMoving = false;
  float startingX;
  float startingY;
  float targetX;
  float targetY;
  float moveTime = 0.3f;
  float timer = 0;
  
  // RC control
  boolean isSelected = false;
  boolean cancelPrimed = false;
  float inputDelay = 0.25;
  float delayTimer = 0;
  int teller = 0;
  int noemer = 1;
  
  // Shooting laser
  float testX = 0;
  float testY = 0;
  float testRCY = 0;
  float wallX = 0;
  float wallY = 0;
  float[] hitX = {0,0};
  float[] hitY = {0,0};
  float[] hitPoint = {0,0};
  float laserLength;
  boolean laserHit = false;
  
  // Attempt to move the laser in the given direction
  boolean moveObject(int dir){ // 1 Up, 2 Right, 3 Down, 4 Left
    // Prevent movement while the laser is active
    if (!isActive){
      // Check if the laser can be moved in the desired direction
      if (checkMovement(dir, 1, posX, posY) == 1){
        // Move the laser if movement check is valid
        timer = 0;
        startingX = posX;
        startingY = posY;
        targetX = posX;
        targetY = posY;
        switch(dir){
          case 1:
            targetY--;
            break;
          case 2:
            targetX++;
            break;
          case 3:
            targetY++;
            break;
          case 4:
            targetX--;
            break;
        }
        objectGrid[int(startingX)][int(startingY)] = null;
        objectGrid[int(targetX)][int(targetY)] = this;
        collisionGrid[int(startingX)][int(startingY)] = 3;
        collisionGrid[int(targetX)][int(targetY)] = 2;
        isMoving = true;
        // Return that the movement wat succesfull
        return true;
      }
      // If the movecheck fails 
      else {
        // Return that the movement was unsuccesfull
        return false;
      }
    }
    // If the laser is active
    else{
      // Return that the movement was unsuccesfull
      return false;
    }
  }
  
  // Laser update fuction
  void updateObject(){
    // Handle movement animation
    if (isMoving){
      timer += deltaTime;
      if (timer > moveTime){
        timer = moveTime;
        isMoving = false;
      }
      posX = startingX + (targetX - startingX) * timer / moveTime;
      posY = startingY + (targetY - startingY) * timer / moveTime;
    }
    // When the laser is selected
    if (isSelected){
      // Open window to show RC changes
      
      // Prevent the window for instantly closing if x or z is held before the laser is selected
      if (!xHeld && !zHeld){
        // Once the window detects a frame without x or z being held prime canceling
        cancelPrimed = true;
      }
      // If x is held while canceling is primed deselect the laser
      else if (cancelPrimed){
        // Deselect the laser
        isSelected = false;
        // Reset the priming for next interaction
        cancelPrimed =  false;
        // Set RC based on noemer and teller
        objRC = float(teller)/float(noemer);
        // Turn off player menu mode
        playerObject.activateObject();
      }
      // Handle inputs for RC window
      
      // Reset delay if no input is detected
      if (!(upHeld || downHeld || leftHeld || rightHeld)){
        delayTimer = 0;
      }
      // Decrease delay
      if (delayTimer > 0){
        delayTimer -= deltaTime;
      }
      // Prevent double input
      if (!(upHeld && downHeld)){
        // Wait for delay
        if (delayTimer <= 0){
          if (upHeld){
            teller++;
            delayTimer = inputDelay;
          }
          if (downHeld){
            teller--;
            delayTimer = inputDelay;
          }
        }
      }
      // Prevent double input
      if (!(rightHeld && leftHeld)){
        // Wait for delay
        if (delayTimer <= 0){
          if (rightHeld){
            noemer++;
            delayTimer = inputDelay;
          }
          if (leftHeld){
            // Prevent divide by zero
            if (noemer > 1){
              noemer--;
            }
            delayTimer = inputDelay;
          }
        }
      }
    } 
  }
  
  // Laser draw function
  void drawObject(){
    
    // Collor the controller to match the corresponding linked laser
    switch(linkNumber){
      case 0:
        fill(100,255,100); // Green
        break;
      case 1:
        fill(0,255,200); // Cyan 
        break;
      case 2:
        fill(255,100,0); // Orange
        break;
      case 3:
        fill(0,0,200); // Dark blue
        break;
      case 4:
        fill(255,255,0); // Yellow
        break;
      case 5:
        fill(255,141,161); // Pink
        break;
    }
    pushMatrix();
    translate(posX*levelScale,posY*levelScale);
    rect(0,0,levelScale,levelScale);
    
    if(isActive){
      pushMatrix();
      translate(levelScale*0.5, levelScale*0.5);
      rotate(-atan(objRC) - PI*0.5); // ? Why do I need to rotate -0.5*PI
      fill(color(255,0,0));
      rect(-0.05*levelScale, 0, 0.1*levelScale, laserLength*levelScale);
      popMatrix();
    }
    
    // Draw window to indicate the laser is selected and to chance the RC
    if(isSelected){
      fill(color(0));
      rect(0, 0, levelScale, levelScale);
      fill(color(255));
      rect(0.05*levelScale, 0.05*levelScale, 0.9*levelScale, 0.9*levelScale);
      
      fill(color(0));
      rect(0.3*levelScale, 0.48*levelScale, 0.4*levelScale, 0.04*levelScale);
      // Set text size based on levelScale
      textAlign(CENTER);
      textSize(20);
      text("↓", 0.2*levelScale, 0.3*levelScale);
      text("↑", 0.8*levelScale, 0.3*levelScale);
      text("←", 0.2*levelScale, 0.75*levelScale);
      text("→", 0.8*levelScale, 0.75*levelScale);
      
      textSize(30);
      text((int)teller, 0.5*levelScale, 0.4*levelScale);
      text((int)noemer, 0.5*levelScale, 0.8*levelScale);
    }
    popMatrix();
  }
  
  // When the player attempts to interact with this object
  void interactObject(){
    // Prevent interaction while active
    if (!isActive){
      // Set this object as selected
      isSelected = true;
      // Tell the player object to enter menu mode by activating it
      playerObject.activateObject();
    }
    // ??? Add check to prevent interaction if RC is set unchangeable ???
  }
  
  // Activate the laser to shoot its beam
  void activateObject(){
    isActive = !isActive;
    
    if (isActive){
      // Calculate if the laser gets blocked
      testX = posX;
      testY = posY;
      laserHit = false;      
      
      // Test if there is a hit in the X+ direction until a solid object is hit or the edge of the screen is reached
      while (!laserHit){
        // Increment the x value by 1
        testX++;
        // Calculate the y value for the given x value minus 0.5 to check the edge of the walls and not the center
        testY = posY-objRC*(testX-posX-0.5f);
        // Test if the point is still on the collision grid
        if (testX > collisionGrid.length-1 || testY > collisionGrid[0].length-1 || testY < 0){ 
          // If the point falls outside the collisiongrid, count this as hitting the edge of the screen
          laserHit = true;
          // Keep track of the coördinates of this hit
          hitX[0] = (testX-0.5)*2;
          hitX[1] = testY;
        }
        // Prevent checking outside the grid
        if (!laserHit){
          if (testY%1 < 0.5f){
            // Check the collision grid if there is a hit with a solid coördinate
            if (collisionGrid[int(testX)][int(floor(testY))] == 1){
              laserHit = true;
              hitX[0] = testX-0.5;
              hitX[1] = testY;
            }
          } else {
            // Check the collision grid if there is a hit with a solid coördinate
            if (collisionGrid[int(testX)][int(ceil(testY))] == 1){
              laserHit = true;
              hitX[0] = testX-0.5;
              hitX[1] = testY;
            }
          }
        }
      }
      
      testX = posX;
      testY = posY;
      if (objRC != 0){
        laserHit = false;
      } else {
        hitY[0] = 100;
        hitY[1] = posY;
      }
      while (!laserHit){
        if (objRC < 0){
          testY++;
          testX = posX+(testY-posY-0.5)/(-objRC);
        } else {
          testY--;
          testX = posX+(testY-posY+0.5)/(-objRC);
        }
        if (testX > collisionGrid.length-1 || testY > collisionGrid[0].length-1 || testY < 0){ 
          // If the point falls outside the collisiongrid, count this as hitting the edge of the screen
          laserHit = true;
          // Keep track of the coördinates of this hit
          hitY[0] = (testX-0.5)*2;
          hitY[1] = testY;
        }
        if (!laserHit){
          if (testX%1 < 0.5f){
            // Check the collision grid if there is a hit with a solid coördinate
            if (collisionGrid[int(floor(testX))][int(testY)] == 1){
              laserHit = true;
            }
          } else {
            // Check the collision grid if there is a hit with a solid coördinate
            if (collisionGrid[int(ceil(testX))][int(testY)] == 1){
              laserHit = true;
            }
          }
          if (laserHit){
            hitY[0] = testX;
            if (-objRC < 0){
              hitY[1] = testY+0.5;
            } else {
              hitY[1] = testY-0.5;
            }
          }
        }
      }
      if (hitX[0] <= hitY[0]){
        laserLength = dist(posX, posY, hitX[0], hitX[1])+0.05f;
        hitPoint[0] = hitX[0];
        hitPoint[1] = hitX[1];
      } else {
        laserLength = dist(posX, posY, hitY[0], hitY[1])+0.05f;
        hitPoint[0] = hitY[0];
        hitPoint[1] = hitY[1];
      }
    }
    
    // Test if any targets are hit
    for (GameObject object : targetList){
      // Get the X of a target
      testX = object.GetPosX();
      // Calculate the Y of the laser at that X
      testY = posY-objRC*(testX-posX);
      // Compare the laser Y with the target Y
      if (testY == object.GetPosY()){
        if (object.GetPosX() < hitPoint[0] && ((-objRC<0 && object.GetPosY() > hitPoint[1])||(-objRC>=0 && object.GetPosY() <= hitPoint[1]))){
          if (isActive){
            // Add one to the object hit count
            object.activateObject();
          } else {
            // Subtract one from the object hit count
            object.interactObject();
          }
        }
      } 
    }
      
    // Set laser as active
    // Activate laser calculations
  }
  
  void SizeX(int Noemer){
    noemer = Noemer;
    objRC = float(teller)/float(noemer);
  }
  void SizeY(int Teller){
    teller = Teller;
    objRC = float(teller)/float(noemer);
  }
}

// ----- Target -----
class Target extends GameObject{
  
  //Movement animation
  boolean isMoving = false;
  float startingX;
  float startingY;
  float targetX;
  float targetY;
  float moveTime = 0.3f;
  float timer = 0;
  
  boolean moveObject(int dir){ // 1 Up, 2 Right, 3 Down, 4 Left
    if ((!playButtonObject.GetActive()) && (checkMovement(dir, 2, posX, posY) == 1)){
      timer = 0;
      startingX = posX;
      startingY = posY;
      targetX = posX;
      targetY = posY;
      switch(dir){
        case 1:
          targetY--;
          break;
        case 2:
          targetX++;
          break;
        case 3:
          targetY++;
          break;
        case 4:
          targetX--;
          break;
      }
      objectGrid[int(startingX)][int(startingY)] = null;
      objectGrid[int(targetX)][int(targetY)] = this;
      collisionGrid[int(startingX)][int(startingY)] = 4;
      collisionGrid[int(targetX)][int(targetY)] = 2;
      isMoving = true;
      return true;
    }
    else {
      return false;
    }
  }
  void updateObject(){
    if (isMoving){
      timer += deltaTime;
      if (timer > moveTime){
        timer = moveTime;
        isMoving = false;
      }
      posX = startingX + (targetX - startingX) * timer / moveTime;
      posY = startingY + (targetY - startingY) * timer / moveTime;
    }
  }
  void drawObject(){
    fill(color(255,0,0));
    pushMatrix();
    translate(posX*levelScale,posY*levelScale);
    rect(0,0,levelScale,levelScale);
    fill(0);
    rect(0.2*levelScale, 0.2*levelScale, 0.6*levelScale, 0.6*levelScale);
    fill(255);
    rect(0.25*levelScale, 0.25*levelScale, 0.5*levelScale, 0.5*levelScale);
    
    if (!(requiredHit - hitCount <= 0)){
      fill(0);
      switch(requiredHit - hitCount){
        case 5:
          circle(levelScale*0.375, levelScale*0.625, levelScale*0.1);
          circle(levelScale*0.625, levelScale*0.375, levelScale*0.1);
        case 3:
          circle(levelScale*0.375, levelScale*0.375, levelScale*0.1);
          circle(levelScale*0.625, levelScale*0.625, levelScale*0.1);
        case 1:
          circle(levelScale*0.5, levelScale*0.5, levelScale*0.1);
          break;
        case 6:
          circle(levelScale*0.375, levelScale*0.5, levelScale*0.1);
          circle(levelScale*0.625, levelScale*0.5, levelScale*0.1);
        case 4:
          circle(levelScale*0.375, levelScale*0.625, levelScale*0.1);
          circle(levelScale*0.625, levelScale*0.375, levelScale*0.1);
        case 2:
          circle(levelScale*0.375, levelScale*0.375, levelScale*0.1);
          circle(levelScale*0.625, levelScale*0.625, levelScale*0.1);
          break;
      }
      
    } else {
      fill(0,255,0);
      rect(0.25*levelScale, 0.25*levelScale, 0.5*levelScale, 0.5*levelScale);
    }
    
    popMatrix();
  }
  
  // -- Repurposed function --
  // When a laser hits the target add one to the hit count
  void activateObject(){
    hitCount++;
  }
  
  // -- Repurposed function --
  // When a laser turns off remove one from the hit count
  void interactObject(){
    hitCount--;
  }
}

// ----- WallBlock -----
class WallBlock extends GameObject{ 
  void drawObject(){
    if (sizeX > sizeY){
      fill(200);
      rect(posX*levelScale, posY*levelScale, sizeX*levelScale, sizeY*0.5f*levelScale);
      fill(125);
      rect(posX*levelScale, (posY+sizeY*0.5f)*levelScale, sizeX*levelScale, sizeY*0.5f*levelScale);
      fill(150);
      triangle(posX*levelScale, posY*levelScale, posX*levelScale, (posY+sizeY)*levelScale, (posX+0.5f*sizeY)*levelScale, (posY+0.5f*sizeY)*levelScale);
      triangle((posX+sizeX)*levelScale, posY*levelScale, (posX+sizeX)*levelScale, (posY+sizeY)*levelScale, (posX+sizeX-0.5f*sizeY)*levelScale, (posY+0.5f*sizeY)*levelScale);
    }
    else {
      fill(150);
      rect(posX*levelScale, posY*levelScale, sizeX*levelScale, sizeY*levelScale);
      fill(200);
      triangle(posX*levelScale, posY*levelScale, (posX+sizeX)*levelScale, posY*levelScale, (posX+0.5f*sizeX)*levelScale, (posY+0.5f*sizeX)*levelScale);
      fill(125);
      triangle(posX*levelScale, (posY+sizeY)*levelScale, (posX+sizeX)*levelScale, (posY+sizeY)*levelScale, (posX+0.5f*sizeX)*levelScale, (posY+sizeY-0.5f*sizeX)*levelScale);
    }
    fill(175);
    rect(posX*levelScale+0.125f*levelScale, posY*levelScale+0.125f*levelScale, (sizeX-0.25f)*levelScale, (sizeY-0.25f)*levelScale);
  }
}

// ----- TrackRail -----
class TrackRail extends GameObject{
  void drawObject(){
    pushMatrix();
    translate((posX+0.5)*levelScale, (posY+0.5)*levelScale);

    if (sizeX>sizeY){
      // Top shade
      fill(color(185, 153, 118, 128));
      rect(-0.5*levelScale,-0.5*levelScale,sizeX*levelScale,sizeY*levelScale*0.5);
      // Bottom shade
      fill(color(229, 211, 179, 128));
      rect(-0.5*levelScale,(-0.5+sizeY*0.5)*levelScale,sizeX*levelScale,sizeY*levelScale*0.5);
      // Shading triangles
      // Sides
      fill(color(210, 180, 140, 128));
      //rect(-0.5*levelScale,-0.5*levelScale,levelScale*sizeX,levelScale*sizeY);
      triangle(-0.5*levelScale,-0.5*levelScale,-0.5*levelScale,(sizeY-0.5)*levelScale,(sizeY*0.5f-0.5f)*levelScale,(sizeY*0.5f-0.5f)*levelScale);
      triangle((sizeX-0.5)*levelScale,-0.5*levelScale,(sizeX-0.5)*levelScale,(sizeY-0.5)*levelScale,(sizeX-sizeY*0.5f-0.5f)*levelScale,(sizeY*0.5f-0.5f)*levelScale);
      //triangle((sizeX-0.5)*levelScale,-0.5*levelScale,(sizeX-0.5f)*levelScale,-0.5*levelScale,(sizeX*0.5f-0.5f)*levelScale,(sizeX*0.5f-0.5f)*levelScale);
    } else {
      // Sides
      fill(color(210, 180, 140, 128));
      rect(-0.5*levelScale,-0.5*levelScale,levelScale*sizeX,levelScale*sizeY);
      // Shading triangles
      // Top shade
      fill(color(185, 153, 118, 128));
      triangle(-0.5*levelScale,-0.5*levelScale,(sizeX-0.5f)*levelScale,-0.5*levelScale,(sizeX*0.5f-0.5f)*levelScale,(sizeX*0.5f-0.5f)*levelScale);
      // Bottom shade
      fill(color(229, 211, 179, 128));
      triangle(-0.5*levelScale,(sizeY-0.5)*levelScale,(sizeX-0.5f)*levelScale,(sizeY-0.5)*levelScale,(sizeX*0.5f-0.5f)*levelScale,(sizeY-sizeX*0.5f-0.5f)*levelScale);
    }
    // Center
    fill(color(167, 132, 99, 128));
    rect(-0.4*levelScale,-0.4*levelScale,levelScale*(sizeX-0.2),levelScale*(sizeY-0.2));
    
    rectMode(CENTER);
    for (int x = 0; x < sizeX; x++){
      pushMatrix();
      translate(levelScale*x, 0);
      for (int y = 0; y < sizeY; y++){
        pushMatrix();
        translate(0, levelScale*y);        
        // Railgrove center
        fill(color(102, 66, 41));
        rect(0,0,levelScale*0.25f,levelScale*0.25f);
        // Up
        if (y > 0){
          rect(0,-levelScale*0.3125f,levelScale*0.25f,levelScale*0.375f);
        }
        // Right
        if (x < sizeX-1){
          rect(levelScale*0.3125f,0,levelScale*0.375f,levelScale*0.25f);
        }
        // Down
        if (y < sizeY-1){
          rect(0,levelScale*0.3125f,levelScale*0.25f,levelScale*0.375f);
        }
        // Left
        if (x > 0){
          rect(-levelScale*0.3125f,0,levelScale*0.375f,levelScale*0.25f);
        }
        popMatrix();
      }
      popMatrix();
    }
    popMatrix();
    rectMode(CORNER);
  }
}

// ----- PlayButton -----
class PlayButton extends GameObject{
  boolean solved = false;
  
  void drawObject(){
    pushMatrix();
    translate((posX)*levelScale, (posY)*levelScale);
    fill(color(155,155,0));
    rect(0,0,levelScale, levelScale);
    // Display symbol based on active state
    if (!isActive){ // Play Symbol
      fill(color(0));
      triangle(0.25*levelScale, 0.25*levelScale, 0.25*levelScale, 0.75*levelScale, 0.75*levelScale, 0.5*levelScale);
    }
    else { // Pause Symbol
      fill(color(0));
      rect(0.25*levelScale, 0.25*levelScale, 0.5*levelScale, 0.5*levelScale);
      fill(color(155,155,0));
      rect(0.45*levelScale, 0.2*levelScale, 0.1*levelScale, 0.7*levelScale);
    }
    popMatrix();
  }
  // When interacting with the play button switch between activate and deactivate
  void interactObject(){
    isActive = !isActive;
    // Activate all lasers when pressing play
    for (GameObject object : laserList){
      object.activateObject();
    }
    solved = true;
    for (GameObject object : targetList){
      solved = solved && object.GetHitResult();
    }
    if (solved){
      levelExitObject.activateObject();
    }
  }
}

// ----- PlayButton -----
class ResetButton extends GameObject{
  void drawObject(){
    pushMatrix();
    translate((posX)*levelScale, (posY)*levelScale);
    fill(255, 174, 66);
    rect(0,0,levelScale, levelScale);
    fill(0);
    circle(0.5*levelScale, 0.5*levelScale, 0.75*levelScale);
    fill(255, 174, 66);
    circle(0.5*levelScale, 0.5*levelScale, 0.5*levelScale);
    rect(0, 0.35*levelScale, levelScale, 0.3*levelScale);
    fill(0);
    triangle(0.08*levelScale, 0.65*levelScale, 0.4*levelScale, 0.65*levelScale, 0.24*levelScale, 0.5*levelScale);
    triangle(0.92*levelScale, 0.35*levelScale, 0.6*levelScale, 0.35*levelScale, 0.76*levelScale, 0.5*levelScale);
    popMatrix();
  }
  
  void interactObject(){
    loadLevel(currentLevel);
  }
}

// ----- Grid -----
class Grid extends GameObject{
  void drawObject(){
    pushMatrix();
    translate(posX*levelScale, posY*levelScale);
    
    // Grid borders
    if (sizeX > sizeY){
      fill(125);
      rect(0, 0, sizeX*levelScale, sizeY*0.5f*levelScale);
      fill(200);
      rect(0, sizeY*0.5f*levelScale, sizeX*levelScale, sizeY*0.5f*levelScale);
      fill(150);
      triangle(0, 0, 0, sizeY*levelScale, 0.5f*sizeY*levelScale, 0.5f*sizeY*levelScale);
      triangle(sizeX*levelScale, 0, sizeX*levelScale, sizeY*levelScale, (sizeX-0.5f*sizeY)*levelScale, 0.5f*sizeY*levelScale);
    }
    else {
      fill(150);
      rect(0, 0, sizeX*levelScale, sizeY*levelScale);
      fill(125);
      triangle(0, 0, sizeX*levelScale, 0, 0.5f*sizeX*levelScale, 0.5f*sizeX*levelScale);
      fill(200);
      triangle(0, sizeY*levelScale, sizeX*levelScale, sizeY*levelScale, 0.5f*sizeX*levelScale, (sizeY-0.5f*sizeX)*levelScale);
    }
    // Grid background
    fill(color(255,255,197));
    rect(0.1f*levelScale, 0.1f*levelScale, (sizeX-0.2)*levelScale, (sizeY-0.2)*levelScale);
    // Grid lines
    fill(0);
    for (int x = 0; x < sizeX; x++){
      rect((x+0.5f)*levelScale-1, 0.5f*levelScale-1, 2, (sizeY-1)*levelScale);
    }
    for (int y = 0; y < sizeY; y++){
      rect(0.5f*levelScale-1, (y+0.5f)*levelScale-1, (sizeX-1)*levelScale, 2);
    }
    if (sizeX%2 == 1){
      rect(((float)sizeX*0.5f)*levelScale-2, 0.5f*levelScale-1, 4, (sizeY-1)*levelScale);
    }
    if (sizeY%2 == 1){
      rect(0.5f*levelScale-1, ((float)sizeY*0.5f)*levelScale-2, (sizeX-1)*levelScale, 4);
    }
    popMatrix();
  }
  
  void AddGridCollision(){
    for (int x = 0; x < sizeX; x++){
      for (int y = 0; y < sizeY; y++){
        collisionGrid[(int)posX+x][(int)posY+y] = 4;
      }
    }
  }
}

// ----- TextBox -----
class TextBox extends GameObject{
  String text = "";
  int textSize = 0;
  void AddText(String _text){ text = _text;}
  void TextSize(int _textSize){ textSize = _textSize;}
  
  void drawObject(){
    // Don't draw the textbox if the player overlaps with the textbox
    if (playerObject.GetPosX() >= posX && playerObject.GetPosX() < posX+sizeX){
      if (playerObject.GetPosY() >= posY && playerObject.GetPosY() < posY+sizeY){
        return;
      }
    }
    pushMatrix();
    translate(posX*levelScale, posY*levelScale);
    fill(255);
    rect(0.125*levelScale, 0.125*levelScale, (sizeX-0.25)*levelScale, (sizeY-0.25)*levelScale);
    
    fill(0);
    textAlign(CENTER,CENTER);
    textSize(textSize);
    translate(sizeX*0.48f*levelScale, (sizeY*0.5f)*levelScale);
    text(text, 0,0);
    popMatrix();
  } 
}


// Check if the attempted movement is allowed returns: 0 = blocked, 1 = not blocked, 2 = hit moveable object
int checkMovement(int dir, int boundType, float posX, float posY){ 
  // boundType: 0 Unbound, 1 trackBound, 2 gridBound
  int foundCollision = -1;
  switch(dir){
    case 1: // Up
      // Check if out of array bounds
      if (posY-1 < 0){
        return 0;
      }
      foundCollision = collisionGrid[int(posX)][int(posY-1)];
      break;
    case 2:
      // Check if out of array bounds
      if (posX+1 > collisionGrid.length-1){
        return 0;
      }
      foundCollision = collisionGrid[int(posX+1)][int(posY)];
      break;
    case 3:
      // Check if out of array bounds
      if (posY+1 > collisionGrid[0].length-1){
        return 0;
      }
      foundCollision = collisionGrid[int(posX)][int(posY+1)];
      break;
    case 4:
      // Check if out of array bounds
      if (posX-1 < 0){
        return 0;
      }
      foundCollision = collisionGrid[int(posX-1)][int(posY)];
      break;
  }
  switch(foundCollision){
    case -1: // foundCollision wasn't changed for some reason
      print("ERROR: no collision data found, default to solid");
      return 0;
    case 0: // Empty
      if (boundType == 0){ // Unbound objects can move freely to empty spaces
        return 1;
      }
      else { // Bound objects can only move in given bounds
        return 0;
      }
    case 1: // Solid
      return 0;
    case 2: // Moveable
      return 2;
    case 3:
      if (boundType != 2){ // Unbound and track bound objects can move onto track spaces
        return 1;
      }
      else { // Grid bound objects cannot move onto tracks
        return 0;
      }
    case 4:
      if (boundType != 1){ // Unbound and grid bound objects can move onto grid spaces
        return 1;
      }
      else { // Track bound objects cannot move onto grid
        return 0;
      }
  }
  return 0;
}
