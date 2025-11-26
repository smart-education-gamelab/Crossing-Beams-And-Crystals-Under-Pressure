// Angle test
float test0Angle = 0;
int test0Rc = 0;

String test0AngleText;
String RCText;

void drawTest0(){
  //Background
  noStroke();
  fill(color(250));
  rect(0,0,width,height);      
  
  //Calculate angle
  test0Angle = -atan(test0Rc);
  
  //Text
  fill(color(0));
      
  textSize(50);
  RCText = "RC = " + test0Rc;
  test0AngleText = "Angle = " + test0Angle;
    
  text(RCText, 50, 100);
  text(test0AngleText, 50, 150);
      
  //Bar
  fill(color(0));
  translate(500, height/2);
  rotate(test0Angle);
  rect(0, -1, 400, 2);
  rotate(-test0Angle);
      
  //Targets
  //RC -3
  circle(100,-300,20);
  //RC -2
  circle(100,-200,20);
  //RC -1
  circle(100,-100,20);
  //RC 0
  circle(100,0,20);
  //RC 1
  circle(100,100,20);
  //RC 2
  circle(100,200,20);
  //RC 3
  circle(100,300,20);
}

void inputTest0(){
  //Input
  if(keyCode == UP){
    test0Rc += 1;
  }
  if(keyCode == DOWN){
    test0Rc -= 1;
  } 
}
