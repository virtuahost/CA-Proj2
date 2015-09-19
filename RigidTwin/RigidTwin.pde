// LecturesInGraphics: vector interpolation
// Template for sketches
// Author: James Moak, Deep Ghosh
// Computational Aesthetics: Project 1 

//**************************** global variables ****************************
pts P = new pts();
float t=1, f=0;
Boolean animate=true, linear=true, circular=true, beautiful=false, car=false, jarek=false, hermite=false;
PImage textureSource, jarekImg;
float len=60; // length of arrows
//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(1000,800, P3D);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/group.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureSource = loadImage("data/car.jpg");
  jarekImg = loadImage("data/jarek.jpg");
  P.declare().resetOnCircle(3);
  P.loadPts("data/pts");
  textureMode(NORMAL);
  }

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  if(snapPic) beginRecord(PDF,PicturesOutputPath+"/P"+nf(pictureCounter++,3)+".pdf"); 
  P.G[1]=P(P.G[0],len,U(P.G[0],P.G[1]));
  P.G[3]=P(P.G[2],len,U(P.G[2],P.G[3]));
  pt A=P.G[0], B=P.G[1], C=P.G[2], D=P.G[3]; 
  vec AB=V(A,B), CD=V(C,D);
  noStroke(); 
  
  if(animating) {t+=0.01; if(t>=1) {t=1; animating=false;}} 

  if(linear) {
    float a = angle(AB,CD);
    fill(blue); scribeHeader("1-LINEAR",1); 
    for(float s=0; s<=t; s+=0.1) {
      pt P=L(A,C,s); 
      vec V=R(AB,s*a); 
      noFill(); pen(cyan,3); drawObject(P,V);
      }
    pt P=L(A,C,t);
    vec V=R(AB,t*a);
    fill(blue); pen(blue,3); show(P,4); drawObject(P,V);
    }

  if(circular) {
    float a = angle(AB,CD);
    fill(brown); scribeHeader("2-CIRCULAR",2); 
    pt F = getF(A, C, AB, CD); 
    for(float s=0; s<=t; s+=0.1) {
      // for each s compute fixed point F and (P,V) for along pure constant speed rotation around F from (A,AB) to (C,CD)
      noFill(); pen(red,3); show(F,4);
      pt P = P(F, R(V(F, A), s*angle(AB, CD)));
      vec V= R(AB,s*a); 
      noFill(); pen(sand,3); drawObject(P,V);
      }
    // for t compute fixed point F and (P,V) for along pure constant speed rotation around F from (A,AB) to (C,CD)
    pt P = P(F, R(V(F, A), t*angle(AB, CD)));
    vec V= R(AB,t*a); 
    fill(brown); pen(brown,3); show(P,4); drawObject(P,V);
    }

  if(beautiful) {
    fill(green); scribeHeader("3-BEAUTIFUL",3); 
    //Get the third frame for interpolation
    pt tP = getThirdFramePT(A,C,AB,CD);
    vec tV = getThirdFrameVec(A,C,AB,CD);
    float a = angle(AB,tV);
    float b = angle(tV,CD);
    pen(blue,3); fill(blue); show(tP,4); arrow(tP, tV); 
    
    for(float s=0; s<=t; s+=0.1) {
      // for each s compute (P,V) for beautiful motion using a third frame from (A,AB) to (C,CD)
      pt P = nevilleFrame(A,tP,C,s);
      vec V = AB;
      if (s<=t/2.0) V = R(AB,s*a*2.0); 
      else          V = R(tV,(s-0.5)*b*2.0); 
     
      noFill(); pen(green,3); drawObject(P,V);
      }
    // for t compute (P,V) for beautiful motion from (A,AB) to (C,CD)
     
    pt P = nevilleFrame(A,tP,C,t);
    vec V = AB;
    if (t<=0.5) V = R(AB,t*a*2.0); 
    else        V = R(tV,(t-0.5)*b*2.0); 
    fill(green); pen(green,3); drawObject(P,V);
    }
  pen(green,3); fill(green); show(A,4);  arrow(A,B); // show the start and end arrows
  pen(red,3); fill(red); show(C,4);  arrow(C,D); 
  
  if(car) {
    float a = angle(AB,CD);
    fill(red); scribeHeader("4-CAR",4); 
    pt lastP = carPt(A, C, AB, CD, 0.f);
    for(float s=0; s<=t; s+=0.1) {
     // for each s compute (P,V) for beautiful motion from (A,AB) to (C,CD)
      pt P = carPt(A, C, AB, CD, s);
      vec V= carVec(A, C, AB, CD, s);
     
      noFill(); pen(red,3); line(lastP.x, lastP.y, P.x, P.y);
      lastP = P;
      }
    pt endP = carPt(A, C, AB, CD, t);
    line(lastP.x, lastP.y, endP.x, endP.y);
   // for t compute (P,V) for beautiful motion from (A,AB) to (C,CD)
     
    pt P = carPt(A, C, AB, CD, t);
    vec V= carVec(A, C, AB, CD, t);
    
    fill(red); pen(magenta,3); show(P,4); 
    noFill(); noStroke(); drawCar(P,V);
    }

  if(hermite) {
    float a = angle(AB,CD);
    fill(magenta); scribeHeader("5-HERMITE",5); 
    for(float s=0; s<=t; s+=0.1) {
     // for each s compute (P,V) for beautiful motion from (A,AB) to (C,CD)
      pt P = hermitePt(A, C, AB, CD, s);
      vec V= hermiteVec(A, C, AB, CD, s);
     
      noFill(); pen(pink,3); drawObject(P,V);
      }
   // for t compute (P,V) for beautiful motion from (A,AB) to (C,CD)
     
    pt P = hermitePt(A, C, AB, CD, t);
    vec V= hermiteVec(A, C, AB, CD, t);
    fill(magenta); pen(magenta,3); show(P,4); drawObject(P,V);
    }
    
  if(snapPic) {endRecord(); snapPic=false;} // end saving a .pdf of the screen

  fill(black); displayHeader();
  if(scribeText && !filming) displayFooter(); // shows title, menu, and my face & name 
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif"); // saves a movie frame 
  change=false; // to avoid capturing movie frames when nothing happens
  }  // end of draw()
  
//**************************** user actions ****************************
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
                    // till it is released or another key is pressed or released
  if(key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if(key=='!') snapPicture(); // make a picture of the canvas and saves as .jpg image
  if(key=='`') snapPic=true; // to snap an image of the canvas and save as zoomable a PDF
  if(key=='~') { filming=!filming; } // filming on/off capture frames into folder FRAMES 
  if(key=='a') {animating=true; f=0; t=0;}  
  if(key=='s') P.savePts("data/pts");   
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='1') linear=!linear;
  if(key=='2') circular=!circular;
  if(key=='3') beautiful=!beautiful;
  if(key=='4') car=!car;
  if(key=='j') jarek=!jarek;
  if(key=='5') hermite=!hermite;
  if(key=='Q') exit();  // quit application
  change=true; // to make sure that we save a movie frame each time something changes
  }

void mousePressed() {  // executed when the mouse is pressed
  P.pickClosest(Mouse()); // used to pick the closest vertex of C to the mouse
  change=true;
  }

void mouseDragged() {
  if (!keyPressed || (key=='a')) P.dragPicked();   // drag selected point with mouse
  if (keyPressed) {
      if (key=='.') f+=2.*float(mouseX-pmouseX)/width;  // adjust current frame   
      if (key=='t') P.dragAll(); // move all vertices
      if (key=='r') P.rotateAllAroundCentroid(Mouse(),Pmouse()); // turn all vertices around their center of mass
      if (key=='z') P.scaleAllAroundCentroid(Mouse(),Pmouse()); // scale all vertices with respect to their center of mass
      }
  change=true;
  }  

//**************************** text for name, title and help  ****************************
String title ="CA 2015 P1: Interpolation", 
       name ="Student: James Moak, Deep Ghosh",
       menu="?:(show/hide) help, a: animate, `:snap picture, ~:(start/stop) recording movie frames, Q:quit",
       guide="drag:edit P&V, t/r/z:trans/rotate/zoom all, 1/2/3/4/5:toggle linear/circular/beautiful/car/hermite, j:party-mode"; // help info

void drawObject(pt P, vec V) {
  beginShape(); 
    if (jarek) texture(jarekImg);
    v(P(P(P,1,V),0.25,R(V)), 0, 0);
    v(P(P(P,1,V),-0.25,R(V)), 1, 0);
    v(P(P(P,-1,V),-0.25,R(V)), 1, 1);
    v(P(P(P,-1,V),0.25,R(V)), 0, 1); 
  endShape(CLOSE);
  }
  
void drawCar(pt P, vec V) {
  beginShape(); 
    texture(textureSource);
    if (jarek) texture(jarekImg);
    v(P(P(P,0.9,V),0.4,R(V)), 0, 0);
    v(P(P(P,0.9,V),-0.4,R(V)), 1, 0);
    v(P(P(P,-0.9,V),-0.4,R(V)), 1, 1);
    v(P(P(P,-0.9,V),0.4,R(V)), 0, 1); 
  endShape(CLOSE);
  }
  
float timeWarp(float f) {return sq(sin(f*PI/2));}