float ax = 800;
float ay = 100;
float bx = 350;
float by = 1000;
float cx = 1250;
float cy = 1000;
int n = 30; //THIS
float rand = 0;
float fpy = random(101,999);
float fpx = random(999-fpy,101+fpy);

void setup(){
  fullScreen();
  background(200);
}

void draw(){
  fill(0);
  ellipse(ax,ay,1,1);
  ellipse(bx,by,1,1);
  ellipse(cx,cy,1,1);
  ellipse(fpx,fpy,1,1);
  for(int i = 0; i < n; i++){
    rand = random(1,4);
    if(rand < 2){
      fpx = (bx+fpx)/2;
      fpy = (by+fpy)/2;
      ellipse(fpx,fpy,1,1);
    }else if(rand >= 2 && rand < 3){
      fpx = (cx+fpx)/2;
      fpy = (cy+fpy)/2;
      ellipse(fpx,fpy,1,1);
    }else if(rand >= 3){
      fpx = (ax+fpx)/2;
      fpy = (ay+fpy)/2;
      ellipse(fpx,fpy,1,1);
    }
  }

}
