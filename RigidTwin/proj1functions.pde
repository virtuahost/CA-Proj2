//James Moak + Deep Ghosh's work for Proj 1

pt getF(pt P0, pt P1, vec V0, vec V1) {
  vec P0P1 = V(P0, P1);
  float h = n(P0P1);
  float alpha = angle(V0, V1);
  float g = (h/2.0)/(tan(alpha/2.0));
  vec P0P1rotated = R(P0P1).normalize();
  pt P2 = P(P0, S(h/2.0, P0P1.normalize()));
  pt F = P(P2, S(g, P0P1rotated));
  return F;
}

pt hermitePt(pt P0, pt P1, vec V0, vec V1, float s) {
  vec U0 = V(V0);
  vec U1 = V(V1);
  
  vec P0P1 = V(P0, P1);
  float scaling = n(V(P0, P1))*0.04;
  
  U0.rotateBy(PI/2.0).scaleBy(scaling);
  U1.rotateBy(PI/2.0).scaleBy(scaling);
  //U0.scaleBy(scaling);
 // U1.scaleBy(scaling);
  
  float h1 = 2.0*pow(s,3.0) - 3.0*pow(s,2.0) + 1.0;
  float h2 = -2.0*pow(s,3.0) + 3.0*pow(s,2.0);
  float h3 = pow(s,3.0) - 2.0*pow(s,2.0) + s;
  float h4 = pow(s,3.0) - pow(s,2.0);
  // pt p = P(P(h1, P0, h2, P1), W(h3, V0, h4, V1));
  pt p = P(h1*P0.x + h2*P1.x + h3*U0.x + h4*U1.x,
           h1*P0.y + h2*P1.y + h3*U0.y + h4*U1.y);
  return p;
}

vec hermiteVec(pt P0, pt P1, vec V0, vec V1, float s) {
  vec U0 = V(V0);
  vec U1 = V(V1);
  
  vec P0P1 = V(P0, P1);
  float scaling = n(P0P1)*0.04;
  
  U0.rotateBy(PI/2.0).scaleBy(scaling);
  U1.rotateBy(PI/2.0).scaleBy(scaling);
  //U0.scaleBy(scaling);
  //U1.scaleBy(scaling);
  
  float h1 = 6.0*pow(s,2.0) - 6.0*s;
  float h2 = -6.0*pow(s,2.0) + 6.0*s;
  float h3 = 3.0*pow(s,2.0) - 4.0*s + 1.0;
  float h4 = 3.0*pow(s,2.0) - 2.0*s;
  pt p = P(h1*P0.x + h2*P1.x + h3*U0.x + h4*U1.x,
           h1*P0.y + h2*P1.y + h3*U0.y + h4*U1.y);
  vec v = R(V(p), -PI/2.0).normalize();
  //vec v = V(p).normalize();
  v = S(n(V0), v);
  return v;
}

pt getThirdFramePT(pt A, pt C,vec AB, vec CD)
{
  pt P = P(A,W(0.5,V(A,C)));
  if(abs(dot(AB,CD)) == 1)return P;
  P = findIntersction(A,P(A,AB),C,P(C,CD));
  return P;
}

vec getThirdFrameVec(pt A, pt C, vec AB, vec CD)
{
  pt cenF = getF(A,C,AB,CD);
  float angle = angle(V(A,cenF), V(C,cenF));
  vec XY = R(AB,angle/2);
  return R(XY,PI);
}

pt nevilleFrame(pt P0, pt P1, pt P2, float s)
{
  pt P = L(L(P0,P1,s*2),L(P1,P2,s*2-1),s);  
  return P;
}

pt findIntersction(pt P0, pt P1, pt P2,pt P3)
{
  //Equation 1
  float m0 = (P0.y - P1.y)/(P0.x - P1.x);
  float m1 = (P2.y - P3.y)/(P2.x - P3.x);
  float c0 = P0.y - m0*P0.x;
  float c1 = P2.y - m1*P2.x;
  float X = (c1-c0)/(m0-m1);
  float Y = m0*X + c0;
  return P(X,Y);
}

pt carPt(pt P0, pt P1, vec V0, vec V1, float s) {
  vec U0 = V(V0);
  vec U1 = V(V1);
  
  vec P0P1 = V(P0, P1);
  float scaling = n(V(P0, P1))*0.15;
  
  U0.scaleBy(scaling);
  U1.scaleBy(scaling);
  
  float h1 = 2.0*pow(s,3.0) - 3.0*pow(s,2.0) + 1.0;
  float h2 = -2.0*pow(s,3.0) + 3.0*pow(s,2.0);
  float h3 = pow(s,3.0) - 2.0*pow(s,2.0) + s;
  float h4 = pow(s,3.0) - pow(s,2.0);
  // pt p = P(P(h1, P0, h2, P1), W(h3, V0, h4, V1));
  pt p = P(h1*P0.x + h2*P1.x + h3*U0.x + h4*U1.x,
           h1*P0.y + h2*P1.y + h3*U0.y + h4*U1.y);
  return p;
}

vec carVec(pt P0, pt P1, vec V0, vec V1, float s) {
  vec U0 = V(V0);
  vec U1 = V(V1);
  
  vec P0P1 = V(P0, P1);
  float scaling = n(P0P1)*0.15;
  
  U0.scaleBy(scaling);
  U1.scaleBy(scaling);
  
  float h1 = 6.0*pow(s,2.0) - 6.0*s;
  float h2 = -6.0*pow(s,2.0) + 6.0*s;
  float h3 = 3.0*pow(s,2.0) - 4.0*s + 1.0;
  float h4 = 3.0*pow(s,2.0) - 2.0*s;
  pt p = P(h1*P0.x + h2*P1.x + h3*U0.x + h4*U1.x,
           h1*P0.y + h2*P1.y + h3*U0.y + h4*U1.y);
  vec v = V(p).normalize();
  //vec v = V(p).normalize();
  v = S(n(V0), v);
  return v;
}