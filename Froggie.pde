/*************
 **  File : PA4_MSiaam.pde
 **  Name: Muhammad Moin Uddin (Siaam)
 **  Date : 11/6/2022
 **  Class : COMP101Y
 **  Email: zu75370@umbc.edu
 **  GitHub : TheZombieGoat
 **  Description: Frogger moves around, bouncing off top and bottom
 **  and wrapping around left and right edges BUT now he needs to avoid baddie.
 */

//Constants
final int NUM_GOODIES = 3; 
final int NUM_BADDIES = 4;
final float BADDIE_SPEED = 3;

//variables
float froggerX = 288; //x and y position of Frogger
float froggerY = 576;
//X and Y speed of frogger
float xDelta = 10; 
float yDelta = 10;
//arrays of X and Y values for goodie
float[] xTri = new float[NUM_GOODIES]; 
float[] yTri = new float[NUM_GOODIES]; 
//arrays of X and Y values for baddie
float[] badX = new float[NUM_BADDIES]; 
float[] badY = new float[NUM_BADDIES];
float scale = 2.0; //randomizes size of baddie each time it wraps around or comes into contact with character

int score = 0; //score
float timer = 3600; //used for calculating score
int goalPrompt = 3; 

boolean[] goodiePlaced = new boolean[NUM_GOODIES]; //boolean array which contains status of goodies
boolean isAlive = true; //Frogger status
boolean goal = false; //checks if all goodies have been eaten or not


/*
 * setup - prepares sketch environment
 */
void setup() {
  size(576, 576);
  for(int i = 0; i < NUM_GOODIES; i++){ //initializing all booleans to be true
    goodiePlaced[i] = false;
  }
  for(int i = 0; i < NUM_BADDIES; i++){ //initializing all baddie coordinates
    badX[i] = 576 + 15*scale + i*30;
    badY[i] = random(65,447);
  }
}

/*
 * draw - draw frogger and move, based on user input
 */
void draw() {
  frameRate(60);
  background(0);
  if(isAlive && goal == false){ //checks if Frogger has lives. Prompts Game Over screen otherwise
    //places and 
      for(int i = 0; i < NUM_GOODIES; i++){
        placeGoodies(i);
        goodiePlaced[i] = true;  
      }
  //drawFrogger - draws frogger at the given x, y
    drawFrogger();
  //draws Border on top and bottom of screen 
    drawBorder();
  //draws Score UI
    drawScore();
  //draws Goal
    if(goalPrompt == 0){
      drawGoal();
      if(GoalContact(200,33,froggerX,froggerY)){
        goal = true;
      }
    }
    
  //draws the Triforce Goodies which grants extra life (within limits)
  for(int i = 0; i < NUM_GOODIES; i++){
    drawGoodies(xTri[i],yTri[i]);
    if(goodieContact(xTri[i],yTri[i],froggerX,froggerY)){ //checks for contact between goodie and frogger and makes goodies disappear :( 
        score += 250 + ((timer/60)*5); 
        goalPrompt -= 1;
        xTri[i] = -9999999;
        yTri[i] = -9999999;
      }
  }
  //draws Cyclops Baddie
  for(int i = 0; i < NUM_BADDIES; i++){
    drawBaddies(i);
  //moves baddie from right to left and checks for contact between it and frogger
    moveBaddies(i);
  }
  //wrap right to left, left to right
    makeFroggerWrap();
  //move frogger up, down, left, right
    keyCheck(); 
  //check bounds and keep frogger from jumping off top/bottom
    restrictFrogger();   
    if(score < 0){
      isAlive = false;
    }
    if(timer > 0){
      timer -= 1;
    }
  }else if(!isAlive){  //game over screen
    background(0);
    fill(255);
    textSize(100);
    text("GAME OVER", 50, 250); 
    textSize(30);
    fill(255);
    text("Too bad ! Try Again !",150,400);
  }else{  //prompts winner screen
    background(0);
    fill(255);
    textSize(100);
    text("YOU WIN", 100, 250); 
    textSize(30);
    fill(255);
    text("Final Score: ",150,400);
    text(score,320,400);
  }
}

//keyCheck = Check if an input key is being pressed and moves Frogger.
void keyCheck(){
  if(keyPressed == true){
    if((key == 'd') || (key == 'D')){
        froggerX += xDelta;
    }else if((key == 'a') || (key == 'A')){
        froggerX -= xDelta;
    }else if((key == 'w') || (key == 'W')){
        froggerY -= yDelta;
    }else if((key == 's') || (key == 'S')){
        froggerY += yDelta;
    }
  }
  keyPressed = false;
}

//drawFrogger() = Function to draw Frogger
void drawFrogger() {
  rectMode(CENTER);
  ellipseMode(CENTER);
  fill(0,256,0);
  noStroke();
  rect(froggerX, froggerY, 64, 64);
  fill(0);
  stroke(200);
  strokeWeight(6);
  ellipse(froggerX-19,froggerY-5,20,20);
  ellipse(froggerX+19,froggerY-5,20,20);
}

/*
 * restrictFrogger - do not advance frogger when hitting top/bottom
 */
void restrictFrogger() {
  if(froggerY < 34){
    froggerY = 34;
  }else if(froggerY > 545){
    froggerY = 545;
  }
}

//randomizes position of goodies
void placeGoodies(int i){
  if(!goodiePlaced[i]){
   xTri[i] = random(552/(i+1)); 
   yTri[i] = random(80,511);
  }
}

//Draws Good items which increases hearts upon consumption. Takes values randomized by placeGoodies() as input.
void drawGoodies(float xt, float yt){
    fill(250,250,0);
    noStroke();
    triangle(xt,yt,xt+6,yt-12,xt+12,yt);
    triangle(xt+12,yt,xt+18,yt-12,xt+24,yt);
    triangle(xt+6,yt-12,xt+12,yt-24,xt+18,yt-12);
}

//Draws baddies
void drawBaddies(int i){
  rectMode(CENTER);
  ellipseMode(CENTER);
  fill(250,0,0);
  noStroke();
  rect(badX[i] + i*100, badY[i], 10 * scale, 10 * scale);
  fill(0);
  stroke(200);
  strokeWeight(3);
  ellipse(badX[i] + i*100,badY[i],4*scale,4*scale);
}

//moves baddies from right edge to left and wraps from left to right and checks contact between baddies and frogger
void moveBaddies(int i){
  badX[i] = badX[i] - BADDIE_SPEED;
  if(badX[i]+ i*100 < 0-15*scale){
    badX[i] = 576 + 15*scale;
    badY[i] = random(65,447);
    scale = random(2,3);
  }
  if(baddieContact(badX[i] + i*100,badY[i],froggerX,froggerY)){
    badX[i] = 576 + 15*scale;
    badY[i] = random(65,447);
    scale = random(2,4);
    score -= 500;
    froggerX = 288;
    froggerY = 576;
  }
}

//drawBorder - draw a border on top and bottom
void drawBorder(){
  stroke(250,0,0);
  strokeWeight(2);
  line(0,1,576,1);
  line(0,574,576,574);
}

void drawScore(){ //draws Score
  fill(255);
  textSize(30);
  text("Score : ",380, 40); 
  text(score,480,40);
}

void drawGoal(){ //draws Goal
  rectMode(CENTER);
  noStroke();
  fill(255,255,0);
  rect(200,33,66,66);
}

//checks if frogger comes into contact with igoodies using their coordinates as input
boolean goodieContact(float itemX, float itemY, float frogX, float frogY){
  if(((itemX > frogX-32 && itemX < frogX+32) || (itemX+24 > frogX-32 && itemX+24 < frogX+32)) && ((itemY > frogY-32 && itemY < frogY+32) || (itemY-24 > frogY-32 && itemY-24 < frogY+32))){
    return true;
  }
  return false; 
}

//checks if frogger comes into contact with baddies using their coordinates as input
boolean baddieContact(float x1,float y1,float x2,float y2){
  float helper = 8 * scale;
  if(((x1+helper > x2-32 && x1+helper < x2+32) || (x1-helper > x2-32 && x1-helper < x2+32)) && ((y1+helper > y2-32 && y1+helper < y2+32) || (y1-helper > y2-32 && y1-helper < y2+32))){
    return true;
  }
  return false;
}

//checks contact with goal
boolean GoalContact(float itemX, float itemY, float frogX, float frogY){
  if(((itemX-33 > frogX-32 && itemX-33 < frogX+32) || (itemX+32 > frogX-32 && itemX+33 < frogX+32)) && ((itemY+33 > frogY-32 && itemY+33 < frogY+32) || (itemY-33 > frogY-32 && itemY-33 < frogY+32))){
    return true;
  }
  return false; 
}

/*
 * makeFroggerWrap - puts frogger on left when it reaches right,
 * right when left
 */
void makeFroggerWrap() {
  if(froggerX < -64){
    froggerX += 630;
  }else if(froggerX > 630){
    froggerX -= 630;
  }
}
