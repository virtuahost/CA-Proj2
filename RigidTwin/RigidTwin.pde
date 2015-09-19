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
  noStroke(); 
  
  if(animating) {t+=0.01; if(t>=1) {t=1; animating=false;}} 
  for (int i=0;i<P.nv;++i) {
    pen(blue, 5); P.G[i].show();
    pen(green, 5); if (i%2==0 && i+1!=P.nv) P.G[i].show(n(V(P.G[i+1], P.G[i])));
    }
    
  pen(red, 5); P.G[P.pv].show();
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
  if(key=='i') insertPt();
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

void insertPt() {  // executed when the mouse is pressed
  P.addPt(P(Mouse()));
  P.addPt(P(Mouse().x+15.0, Mouse().y));
  System.out.println("HI");
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
  
float timeWarp(float f) {return sq(sin(f*PI/2));}