// Main menu settings
int[] mainMenuBackgroundColor = {100,200,100};

// Menu button settings
//Colors
int[] mainMenuButtonColorUnselected = {150,150,150};
int[] mainMenuButtonColorSelected = {200,200,200};
int[] mainMenuButtonPulseColor = {200,200,200};
// Button
int mainMenuButtonGap = 25;
int[] mainMenuPlayButtonDimensions = {300,100};
int mainMenuPlayButtonFontSize = 75;
int[] mainMenuMiscButtonDimensions = {300,75};
int mainMenuMiscButtonFontSize = 50;
// Pulse
float mainMenuButtonPulseDuration = 2.5f;

// Menu variables
int mainMenuSelectedButton;
float mainMenuButtonOffsetY;
int mainMenuButtonAmount = 4;


// Setup for drawing main menu
void mainMenuSetup(){
  // Setup variables
  mainMenuSelectedButton = 0;
  
  // Draw unchanging part of menu
  mainMenuBackground();
  mainMenuTitle();
}

void mainMenuDraw(){
  mainMenuDrawButtons();
}

void mainMenuBackground(){
  //Solid color background
  noStroke();
  fill(color(mainMenuBackgroundColor[0],mainMenuBackgroundColor[1],mainMenuBackgroundColor[2]));
  rect(0,0,width,height);
}

void mainMenuTitle(){
  
}

void mainMenuDrawButtons(){
  // Starting height of buttons
  mainMenuButtonOffsetY = height*0.5f;
  // Play button
  mainMenuDrawButton(width*0.5f,mainMenuButtonOffsetY, mainMenuPlayButtonDimensions[0], mainMenuPlayButtonDimensions[1], 
    "Play", mainMenuPlayButtonFontSize, mainMenuSelectedButton == 0);
  mainMenuButtonOffsetY += mainMenuPlayButtonDimensions[1] * 0.5f + mainMenuMiscButtonDimensions[1] * 0.5f + mainMenuButtonGap;
  // Level select button
  mainMenuDrawButton(width*0.5f,mainMenuButtonOffsetY, mainMenuMiscButtonDimensions[0], mainMenuMiscButtonDimensions[1], 
    "Level Select", mainMenuMiscButtonFontSize, mainMenuSelectedButton == 1);
  mainMenuButtonOffsetY += mainMenuMiscButtonDimensions[1] + mainMenuButtonGap;
  // Setings button
  mainMenuDrawButton(width*0.5f,mainMenuButtonOffsetY, mainMenuMiscButtonDimensions[0], mainMenuMiscButtonDimensions[1],
    "Settings", mainMenuMiscButtonFontSize, mainMenuSelectedButton == 2);
  mainMenuButtonOffsetY += mainMenuMiscButtonDimensions[1] + mainMenuButtonGap;
  // Exit button
  mainMenuDrawButton(width*0.5f,mainMenuButtonOffsetY, mainMenuMiscButtonDimensions[0], mainMenuMiscButtonDimensions[1],
    "Exit", mainMenuMiscButtonFontSize, mainMenuSelectedButton == 3);
}

void mainMenuDrawButton(float posX, float posY, int sizeX, int sizeY, String buttonText, int fontSize, boolean buttonSelected){
  // Selected button pulses and changes color
  if (!buttonSelected){
    noStroke();
    fill(color(mainMenuButtonColorUnselected[0],mainMenuButtonColorUnselected[1],mainMenuButtonColorUnselected[2]));
    rect(posX-sizeX*0.5f, posY-sizeY*0.5f, sizeX, sizeY);
    fill(color(0));
    textAlign(CENTER, CENTER);
    textSize(fontSize);
    text(buttonText,posX,posY);
  }
  else{
    noStroke();
    fill(color(mainMenuButtonColorSelected[0],mainMenuButtonColorSelected[1],mainMenuButtonColorSelected[2]));
    rect(posX-sizeX*0.5f, posY-sizeY*0.5f, sizeX, sizeY);
    fill(color(0));
    textAlign(CENTER, CENTER);
    textSize(fontSize);
    text(buttonText,posX,posY);
  }
}

void mainMenuKeyPressed(){
  if (keyCode == UP){ 
    mainMenuSelectedButton -= 1;
  }
  if (keyCode == DOWN){ 
    mainMenuSelectedButton += 1;
  }
  if (mainMenuSelectedButton < 0){
    mainMenuSelectedButton = 0;
  }
  if (mainMenuSelectedButton > mainMenuButtonAmount - 1){
    mainMenuSelectedButton = mainMenuButtonAmount - 1;
  }
  
  // Activate selected button
  if (key == 'z' || key == ' '){ 
    switch(mainMenuSelectedButton){
      case 0: // Play
        startingLevel = 1;
        switchState(1);
        break;
      case 1: // Level Select
        //switchState(2);
        break;
      case 2: // Settings
        //switchState(3);
        break;
      case 3: // Exit
        exit();
        break;
    }
  }
}
