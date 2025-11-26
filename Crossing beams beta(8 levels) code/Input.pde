boolean upHeld;
boolean downHeld;
boolean leftHeld;
boolean rightHeld;
boolean escHeld;
boolean spaceHeld;
boolean zHeld;
boolean xHeld;


void keyPressed(){  
  //Track heldkeys
  if (keyCode == UP) {upHeld = true;}
  if (keyCode == DOWN) {downHeld = true;}
  if (keyCode == LEFT) {leftHeld = true;}
  if (keyCode == RIGHT) {rightHeld = true;}
  if (keyCode == ESC) {escHeld = true;}
  if (key == ' ') {spaceHeld = true;}
  if (key == 'z') {zHeld = true;}
  if (key == 'x') {xHeld = true;}
  
  switch(gameState){
    case 0: // Main menu
      mainMenuKeyPressed();
      break;
    case 1: // Main game
      break;
  }
}

void keyReleased(){
  if (keyCode == UP) {upHeld = false;}
  if (keyCode == DOWN) {downHeld = false;}
  if (keyCode == LEFT) {leftHeld = false;}
  if (keyCode == RIGHT) {rightHeld = false;}
  if (keyCode == ESC) {escHeld = false;}
  if (key == ' ') {spaceHeld = false;}
  if (key == 'z') {zHeld = false;}
  if (key == 'x') {xHeld = false;}
}
