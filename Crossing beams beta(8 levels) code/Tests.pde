float tileSize = 75;

void drawTests(){
  noStroke();
  for (int x = 0; x < width/tileSize; x++){
    for (int y = 0; y < height/tileSize; y++){
      if((x+y)%2==0){
        fill(100);
      }
      else{
        fill(200);
      }
      rect(x*tileSize, y*tileSize, tileSize, tileSize);
    }
  }
}
