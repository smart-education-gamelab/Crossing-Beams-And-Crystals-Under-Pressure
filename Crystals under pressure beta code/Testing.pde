//Tests
void setupTest(int testNumber){
  switch(testNumber){
    //Angle
    case 0:
      break;
      //Grid
    case 1:
      setupTest1();
      break;
  }
}

void drawTest(int testNumber){
  switch(testNumber){
    //Angle
    case 0:
      drawTest0();
      break;
    //Grid
    case 1:
      drawTest1();
      break;
  }
}

void inputTest(int testNumber){
  switch(testNumber){
    //Angle
    case 0:
      inputTest0();
      break;
    //Grid
    case 1:
      inputTest1();
      break;
  }
}
