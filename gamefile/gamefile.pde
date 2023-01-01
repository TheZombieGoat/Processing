enum mode{
  TITLE,MAP,TG,LIB,RAC,DORM,WEEK,BASKET;
}

//images of icons
PImage ICON;
PImage TEMP_ICON; //button icons
PImage TEMP_STAT; //stat icons

PImage MC; //draws main character

//images of all map areas
PImage MAPS; //spritesheet of map + temp
PImage MTEMP;

//misc images
PImage BASKET;
PImage BALL;
PImage TBG;

PFont pixel;  //font type

int resX = 1920;
int resY = 1440; //resolution

float health;
float grades;
float social;
float hunger;

float choiceY = resY-resY/2.5; //Y value of choice hitbox
float[] basketX = {0,0,0,0,0}; //basket ball x and y values
float[] basketY = {-40,-120,-150,-200,-300}; 
float[] bDelta = {4,5,6,7,7}; //speed
float titleY = 520;


int mcX = 70;
int mcY = int(resY/3.4);
int LibraryBX = 710;
int LibraryBY = 440;
int DormBX = 1640;
int DormBY = 530;
int RACBX = 700;
int RACBY = 900;
int TrueGritsBX = 1490;
int TrueGritsBY = 600;  //x and y values of images
int timer = 0;

int fSize = 80; //font Size 
int a = 0; //stroke size
int b = 0; //stroke 2 size
int counter = 0;
int week = 1;

int[] msX = {690,487,497,1600,1441}; // mapSize X and Y for Spritesheet/ in order - OverWorld , Dorm, Food, Lib, RAC
int[] msY = {605,307,279,720,927};
int[] mapX = {0,690,1187,0,1684}; //map X and Y coordinates for Spritesheet
int[] mapY = {0,0,0,605,0};
//index: 0-2 Apple, 3-5 Heart, 6-8 Social, 9-11 Grades, Dorm, Food, Dumbell, Book 
int[] iconX = {0,123,245,367,489,611,733,855,977,1099,1211,1343,1465,1595,1725,1855}; 

int basketScore = 0;
int ballCount = 50;

boolean showIcon; //checks trigger for icon toggle

mode MODE = mode.TITLE; //default mode

void setup(){
  fullScreen();
  loadIcons();
  showIcon = true;
  hunger = 0;
  health = 0;
  grades = 0;
  social = 0;
}

void draw() {
  health += 0.05;
  social += 0.05;
  hunger += 0.05;
  grades += 0.05;
  iconTrigger();
  switch(MODE){ //map
    case TITLE:
      drawTBG();
      break;
    case MAP: 
      drawMaps(0); 
      drawLibraryB();
      drawDormB();
      drawRACB();
      drawTrueGritsB();
      mouseHover();
      dialogueBox(resX-resX/6,30,300,90);
      loadFont();
      text("Week: ",resX-resX/6.5,90);
      text(week,resX-resX/20,90);
      break;
    case TG:  //True Grits
      drawMaps(1); 
      drawMC();
      dialogueBox(0,resY-resY/2.5,resY+resY/2,resY);
      dText("EAT !!!",0);
      dText("Back",1);
      Choice();
      break;
    case LIB://Library
      drawMaps(3); 
      drawMC();
      dialogueBox(0,resY-resY/2.5,resY+resY/2,resY);
      dText("Study",0);
      dText("Back",1);
      Choice();
      break;
    case RAC: //RAC
      drawMaps(4); 
      drawMC();
      dialogueBox(0,resY-resY/2.5,resY+resY/2,resY);
      dText("Exercise",0);
      dText("Back",1);
      Choice();
      break;
    case DORM: //DORM
      drawMaps(2); 
      drawMC();
      dialogueBox(0,resY-resY/2.5,resY+resY/2,resY);
      dText("Socialize",0);
      dText("Laze around",1);
      Choice();
      break;
    case WEEK: //WEEK OVER
      background(0);
      fill(255);
      textSize(100);
      text("WEEK OVER", resX/2.6, resY/2.8); 
      textSize(30);
      fill(255);
      text("Total Stats: ",resX/2.5,resY/1.8);
      text(int(hunger+health+grades+social),resX/2,resY/1.8);
      dText("Back",0);
      Choice();
      break;
    case BASKET:
      background(0);
      BALL.resize(70,70);
      Basket();
      break;
  }  
  if(showIcon == true){
    drawHealth();
    drawGrades();
    drawSocial();
    drawHunger();
   }  
  if(counter == 4){
     MODE = mode.WEEK;
  }   
}

void iconTrigger(){ //triggers icon display
   if(keyPressed == true && key == 'v'){
       if(showIcon == false){
         showIcon = true;
       }else if(showIcon == true){
         showIcon = false;
       }
     }
   keyPressed = false;
}

void StatCheck(mode mode){ //checks which mode it's in
  switch(mode){
    case TG:
      hunger += 1;
      counter += 1;
      break;
    case LIB:
      grades += 1;
      counter += 1;
      break;
    case RAC:
      health += 1;
      counter += 1;
      break;
    case DORM:
      social += 1;
      counter += 1;
      break;
    case WEEK:
      counter = 1;
      break;
    case MAP:
      break;
    case BASKET:
      Basket();
      break;
    case TITLE:
      break;
  }
}

void dialogueBox(float x,float y,float w,float h){ //draws dialogue box
  stroke(255);
  fill(0);
  rect(x,y,w,h);
}

void dText(String s, float dist){
  loadFont();
  text(s,30,resY-resY/2.8 + dist*120);
}

void Choice(){ //options presented to MC
  noFill();
  strokeWeight(a);
  stroke(255);
  rect(30,choiceY,400,80);
  strokeWeight(b);
  rect(30,choiceY+120,250,80);
  if(MouseBound(30,choiceY,250,80)){
    if(mousePressed){
      StatCheck(MODE);
      if(MODE == mode.RAC){
         MODE = mode.BASKET;
         mousePressed = false;
      }else{
      MODE = mode.MAP;
      mousePressed = false;
      }
    }
    a = 2;
  }else{
    a = 0;
  }
  if(MouseBound(30,choiceY+120,250,80)){
    if(mousePressed){
      if(MODE == mode.LIB){
        hunger -= 1;
        health -= 1;
        grades -= 1;
        social -= 1;
      }
      counter += 1;
      MODE = mode.MAP;
      mousePressed = false;
    }
    b = 2;
  }else{
    b = 0;
  }
}

void mouseHover(){  //checks if mouse is hovering over buttons
  if(MouseBound(LibraryBX,LibraryBY,120,120)){
    dialogueBox(LibraryBX,LibraryBY-50,170,50);
    loadFont();
    textSize(40);
    text("Library",LibraryBX+5,LibraryBY-10);
  }
  if(MouseBound(TrueGritsBX-50,TrueGritsBY,120,120)){
    dialogueBox(TrueGritsBX-50,TrueGritsBY+140,220,50);
    loadFont();
    textSize(40);
    text("True Grits",TrueGritsBX-45,TrueGritsBY+170);
  }
  if(MouseBound(RACBX,RACBY,120,120)){
    dialogueBox(RACBX,RACBY-50,120,50);
    loadFont();
    textSize(40);
    text("RAC",RACBX+5,RACBY-10);
  } 
  if(MouseBound(DormBX,DormBY,120,120)){
    dialogueBox(DormBX,DormBY-50,120,50);
    loadFont();
    textSize(40);
    text("Dorm",DormBX+5,DormBY-10);
  }
}

// drawing functions

void drawMC(){
  image(MC,mcX,mcY);
}

void drawHealth(){ //draws Health icon and bar
  if(health >= 20){
    drawIconsS(3);
    image(TEMP_STAT, 0, -10);
  }else if(health <= 10){
    drawIconsS(5);
    image(TEMP_STAT, 0, -10);
  }else{  
    drawIconsS(4);
    image(TEMP_STAT, 0, -10);
  }
  stroke(255);
  strokeWeight(3);
  noFill();
  rect(120,30,200,40);
  noStroke();
  fill(255,0,0);
  rect(121,31,int(198 * health/30),38);
}

void drawGrades(){   //draws Grade icon and bar
  if(grades >= 20){
    drawIconsS(9);
    TEMP_STAT.resize(80,80);
    image(TEMP_STAT, 20, 100);
  }else if(grades <= 10){
    drawIconsS(11);
    TEMP_STAT.resize(80,80); 
    image(TEMP_STAT, 20, 100);
  }else{
    drawIconsS(10);
    TEMP_STAT.resize(80,80);
    image(TEMP_STAT, 20, 100);
  }

  stroke(255);
  strokeWeight(3);
  noFill();
  rect(120,131,200,40);
  noStroke();
  fill(0,255,0);
  rect(122,132,int(198 * grades/30),38);
}

void drawSocial(){  //draws Social icon and bar
  if(social >= 20){
    drawIconsS(6);
    TEMP_STAT.resize(80,80);
    image(TEMP_STAT, 20, 200);
  }else if(social <= 10){
    drawIconsS(8);
    TEMP_STAT.resize(80,80);
    image(TEMP_STAT, 20, 200);
  }else{  
    drawIconsS(7);
    TEMP_STAT.resize(80,80);
    image(TEMP_STAT, 20, 200); 
  }
  stroke(255);
  strokeWeight(3);
  noFill();
  rect(120,231,200,40);
  noStroke();
  fill(255,255,0);
  rect(122,233,int(198 * social/30),36);
}

void drawHunger(){  //draws Social icon and bar
  if(hunger >= 20){
    drawIconsS(0);
    TEMP_STAT.resize(80,80);
    image(TEMP_STAT, 20, 300);
  }else if(hunger <= 10){
    drawIconsS(2);
    TEMP_STAT.resize(80,80);
    image(TEMP_STAT, 20, 300);
  }else{
    drawIconsS(1);
    TEMP_STAT.resize(80,80);
    image(TEMP_STAT, 20, 300);
  }
  stroke(255);
  strokeWeight(3);
  noFill();
  rect(120,331,200,40);
  noStroke();
  fill(0,0,255);
  rect(122,333,int(198 * hunger/30),36);
}

void drawTBG(){ //title background
   timer += 1;
   if(timer % 30 == 0 && timer % 60 != 0){
     titleY = 530;
   }else if(timer % 60 == 0){
     titleY = 510;
   }
   noStroke();
   float r = random(3,255)/random(0.5,3);
   float g = r*random(0.5,5);
   float b = random(0,255);
   fill(r,g,b,mouseY/10);
   ellipse(random(0,resX),random(0,resY),mouseX/10,mouseX/10);
   fill(r,r,r,mouseY/14);
   ellipse(random(0,resX),random(0,resY),mouseX/12,mouseX/12);
   dialogueBox(760,400,500,200);
   loadFont();
   text("Start Game",800,titleY);
   if(MouseBound(760,400,500,200)){
     noStroke();
     ellipse(1220,titleY-20,20,20);
     ellipse(780,titleY-20,20,20);
     if(mousePressed){
       MODE = mode.MAP;
     }
   }
   showIcon = false;
}

//draws the map background
void drawMaps(int num){
  MTEMP = MAPS.get(mapX[num],mapY[num],msX[num],msY[num]);
  MTEMP.resize(1920,1440);
  image(MTEMP,0,0);
}

//draws Overworld icons
void drawIconsO(int num){
  TEMP_ICON = ICON.get(iconX[num],0,125,125);
}

void drawIconsS(int n){
  TEMP_STAT = ICON.get(iconX[n],0,125,125);
}

//draws the library button and adds text to it
void drawLibraryB(){
  drawIconsO(15);
  TEMP_ICON.resize(120,120);
  image(TEMP_ICON,LibraryBX,LibraryBY);
  if(mousePressed){
    if(MouseBound(LibraryBX,LibraryBY,120,120)){
      MODE = mode.LIB;
    }
  }
}

//draws the Dorm button and adds text to it
void drawDormB(){
  drawIconsO(12);
  image(TEMP_ICON,DormBX, DormBY);
  if(mousePressed){
   if(MouseBound(DormBX,DormBY,120,120)){
     MODE = mode.DORM;
    }
  }
}

//draws the RAC button and adds text to it
void drawRACB(){
  drawIconsO(14);
  image(TEMP_ICON,RACBX,RACBY);
  if(mousePressed){
   if(MouseBound(RACBX,RACBY,120,120)){
     MODE = mode.RAC;
    }
  }
}
//draws the True Grits button and adds text to it
void drawTrueGritsB(){
  drawIconsO(13);
  image(TEMP_ICON,TrueGritsBX-50,TrueGritsBY);
  if(mousePressed){
    if(MouseBound(TrueGritsBX-50,TrueGritsBY,120,120)){
      MODE = mode.TG;
    }
  }
}

//helper
boolean MouseBound(float x,float y,float w,float h){
  if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h){
    return true;
  }
  return false;
}

boolean hitBox(float objAx, float ObjAy, float ObjBx, float ObjBy,float sizeA, float sizeB){
  if(((objAx-sizeA > ObjBx-sizeB && objAx-sizeA < ObjBx+sizeB) || (objAx+sizeA > ObjBx-sizeB && objAx+33 < ObjBx+sizeB)) && ((ObjAy+sizeA > ObjBy-sizeB && ObjAy+sizeA < ObjBy+sizeB) || (ObjAy > ObjBy-sizeB && ObjAy < ObjBy))){
    return true;
  }
  return false; 
}


//Minigames ! AHAHA ASDGHAKSHDKAJSDHSJAK LIFE IS PAIN
void Basket(){
  boolean[] bID= {false,false,false,false,false};
  background(0);
  fill(200,30,0);
  for(int i = 0; i < 5; i++){
    bID[i] = false;
    if(hitBox(mouseX,resY-resY/2.8,basketX[i],basketY[i],120,70)){
      bID[i] = true;
    }
    if(basketY[i] < -30){
      basketX[i] = random(100,resX-200);
    } 
    image(BALL,basketX[i],basketY[i]);
    basketY[i] += bDelta[i];
    if(basketY[i] > resY){
      basketScore -= 1;
      basketY[i] = -300;
      ballCount -= 1;
    }else if(bID[i] == true){
      basketScore += 1;
      basketY[i] = -300;
      ballCount -= 1;
    }
  }
  image(BASKET,mouseX,resY-resY/2.8);
  loadFont();
  text(basketScore,resX-resX/6.5,90);
  if(ballCount < 0){
    MODE = mode.MAP;
  }
}

//loading functions
void loadFont(){
  pixel = createFont("Pix.ttf",80);
  textFont(pixel);
  fill(255);
  textSize(fSize);
}

void loadIcons(){ //loads image files for icons
  MC = loadImage("MC.png");
  MAPS = loadImage("spritesheet.png");
  ICON = loadImage("iconsheet.png");
  
  BASKET = loadImage("Basket.png");
  BALL = loadImage("BALL.png");
  TBG = loadImage("Blue.jpg");
}
