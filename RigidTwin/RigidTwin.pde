// LecturesInGraphics: vector interpolation
// Template for sketches
// Author: James Moak, Deep Ghosh
// Computational Aesthetics: Project 2 

//**************************** global variables ****************************
pts P = new pts();
int numPts = 3;
float t=numPts, f=0, rot = 2.0;
Boolean animate=true, control=true, party=false;
float len=60; // length of arrows
//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(800,600);            // window size
  frameRate(30);             // render 30 frames per second
  smooth();                  // turn on antialiasing
  myFace = loadImage("data/group.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  P.declare();
  P.addPt(P(400,100));
  P.addPt(P(P.G[0].x + 50.0, P.G[0].y));
  P.addPt(P(P.G[0].x + 100.0, P.G[0].y));
  P.addPt(P(400,100));
  P.addPt(P(227,400));
  P.addPt(P(573,400));
  }
                                                          
//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  if(snapPic) beginRecord(PDF,PicturesOutputPath+"/P"+nf(pictureCounter++,3)+".pdf"); 
  noStroke(); 
  
  rot = n(V(P.G[1], P.G[2]))/400.0/(float)numPts;
  
  if(!animating) t=numPts;
  if(animating&&!party) {t+=0.003*numPts; if(t>=numPts) {t=numPts; animating=false;party=false;}} 
  if(animating&&party) {t+=0.05; if(t>=numPts) {t=numPts; animating=false;party=false;}} 
  for (int i=0;i<P.nv-3;++i) {
    pen(blue, 1); edge(P.G[3 + i%(P.nv-3)], P.G[3 + (i+1)%(P.nv-3)]);
    }
  
  vec r = V(P.G[0], P.G[1]);
  pt lastpr = P(P.G[0],r);
  pt c = P.G[0];
  int currPt = 0;
  if (!party)
  for (float s=0.0;s<t;s+=0.001) {
    currPt = (int)s;
    c = L(P.G[3 + currPt%(P.nv-3)], P.G[3 + (currPt+1)%(P.nv-3)], s-(float)currPt);
    r.rotateBy(rot);
    pen(red, 2); edge(lastpr, P(c,r));
    lastpr = P(c,r);
    }
  
  if (party) 
  for (float s=0.0;s<t;s+=0.1) {
    currPt = (int)s;
    c = L(P.G[3 + currPt%(P.nv-3)], P.G[3 + (currPt+1)%(P.nv-3)], s-(float)currPt);
    r.rotateBy(rot);
    for (int i=0;i<P.nv-3;++i) {
      pen(blue, 1); edge(P.G[3 + i%(P.nv-3)], P(c,r));
      }
    lastpr = P(c,r);
    }
  
  //pt pr = P(S.G[0], r);
  // S.G[1] = pr;
  if (!animating) {
    pen(green, 5); P.G[0].show(n(r));
    pen(pink, 5); arrow(P.G[1], P.G[2]);
    pen(red, 5); P.G[0].show(); P.G[1].show();
    }
  else {
    pen(red, 5); P(c,r).show();
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
  if(key=='a') {animating=true; f=0; t=0.0;}  
  if(key=='s') P.savePts("data/pts");   
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='Q') exit();  // quit application
  if(key=='i') {++numPts; P.addPt(P(Mouse())); change=true;}
  if(key=='j') {animating=true; f=0; t=0.0; party=true;}
  change=true; // to make sure that we save a movie frame each time something changes
  }

void mousePressed() {  // executed when the mouse is pressed
  P.pickClosest(Mouse()); // used to pick the closest vertex of C to the mouse
  change=true;
  }

void mouseDragged() {
  if (!keyPressed || (key=='a')) {P.dragPicked(); P.G[0] = P.G[3]; P.G[3] = P.G[0];} // drag selected point with mouse
  if (keyPressed) {
      if (key=='.') f+=2.*float(mouseX-pmouseX)/width;  // adjust current frame   
      if (key=='t') P.dragAll(); // move all vertices
      if (key=='r') P.rotateAllAroundCentroid(Mouse(),Pmouse()); // turn all vertices around their center of mass
      if (key=='z') P.scaleAllAroundCentroid(Mouse(),Pmouse()); // scale all vertices with respect to their center of mass
      }
  change=true;
  }  
  
//**************************** text for name, title and help  ****************************
String title ="CA 2015 P2: Really Cool Patterns for Really Cool People", 
       name ="Student: James Moak, Deep Ghosh",
       menu="?:(show/hide) help, a: animate, `:snap picture, ~:(start/stop) recording movie frames, Q:quit",
       guide="drag:edit P&V, t/r/z:trans/rotate/zoom all, i:insert point, j:party-mode"; // help info

void drawObject(pt P, vec V) {
  beginShape(); 
    v(P(P(P,1,V),0.25,R(V)), 0, 0);
    v(P(P(P,1,V),-0.25,R(V)), 1, 0);
    v(P(P(P,-1,V),-0.25,R(V)), 1, 1);
    v(P(P(P,-1,V),0.25,R(V)), 0, 1); 
  endShape(CLOSE);
  }
  
float timeWarp(float f) {return sq(sin(f*PI/2));}