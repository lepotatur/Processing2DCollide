
/*
p5.collide2D was created by http://benmoren.com
Some functions and code modified version from http://www.jeffreythompson.org/collision-detection
Apache License 2.0 
Processing2DCollide Version 0.1 | July 16, 2017

Processing2DCollide made by @lepotatur on github
__________________________________________________________________________
\\.....................................................................//|
I do not claim rights to this code. Rights go to their respective owners.|
        All I did was convert p5.collide2D to Processing's Java.         |
\\.....................................................................//|
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
//println("### processing collide ###")




//.....................................................................//
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
/////////////////////////________________________/////////////////////////
/////////////////////////| Calc Intersection is |/////////////////////////
/////////////////////////|      depricated      |////////////////////////
/////////////////////////| in the Java version. |////////////////////////
/////////////////////////¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯/////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//.....................................................................//

float undefinedF;
int undefinedI;
Boolean undefinedB;
Boolean _collideDebug = false;

void collideDebug(Boolean debugMode){
    _collideDebug = debugMode;
}

/*~++~+~+~++~+~++~++~+~+~ 2D ~+~+~++~+~++~+~+~+~+~+~+~+~+~+~+*/

Boolean collideRectRect(float x, float y, float w, float h, float x2, float y2, float w2, float h2) {
  //2d
  //add in a thing to detect rectMode CENTER
  if (x + w >= x2 &&    // r1 right edge past r2 left
      x <= x2 + w2 &&    // r1 left edge past r2 right
      y + h >= y2 &&    // r1 top edge past r2 bottom
      y <= y2 + h2) {    // r1 bottom edge past r2 top
        return true;
  }
  return false;
};

Boolean collideRectCircle(float rx, float ry, float rw, float rh, float cx, float cy, float diameter) {
  //2d
  // temporary variables to set edges for testing
  float testX = cx;
  float testY = cy;

  // which edge is closest?
  if (cx < rx){         testX = rx;       // left edge
  }else if (cx > rx+rw){ testX = rx+rw;  }   // right edge

  if (cy < ry){         testY = ry ;      // top edge
  }else if (cy > ry+rh){ testY = ry+rh ;}   // bottom edge

  // // get distance from closest edges
  float distance = dist(cx,cy,testX,testY);

  // if the distance is less than the radius, collision!
  if (distance <= diameter/2) {
    return true;
  }
  return false;
};

Boolean collideCircleCircle(float x, float y, float d, float x2, float y2, float d2) {
//2d
  if( dist(x,y,x2,y2) <= (d/2)+(d2/2) ){
    return true;
  }
  return false;
};

Boolean collidePointCircle(float x, float y, float cx, float cy, float d) {
//2d
if( dist(x,y,cx,cy) <= d/2 ){
  return true;
}
return false;
};

Boolean collidePointRect(float pointX, float pointY, float x, float y, float xW, float yW) {
//2d
if (pointX >= x &&         // right of the left edge AND
    pointX <= x + xW &&    // left of the right edge AND
    pointY >= y &&         // below the top AND
    pointY <= y + yW) {    // above the bottom
        return true;
}
return false;
};

Boolean collidePointLine( float px, float py, float x1, float y1, float x2, float y2, float buffer){
  // get distance from the point to the two ends of the line
float d1 = dist(px,py, x1,y1);
float d2 = dist(px,py, x2,y2);

// get the length of the line
float lineLen = dist(x1,y1, x2,y2);

// since floats are so minutely accurate, add a little buffer zone that will give collision
if (buffer == undefinedF){ buffer = 0.1; }   // higher # = less accurate

// if the two distances are equal to the line's length, the point is on the line!
// note we use the buffer here to give a range, rather than one #
if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
  return true;
}
return false;
}

Boolean collideLineCircle( float x1,  float y1,  float x2,  float y2,  float cx,  float cy,  float diameter) {
  // is either end INSIDE the circle?
  // if so, return true immediately
  Boolean inside1 = this.collidePointCircle(x1,y1, cx,cy,diameter);
  Boolean inside2 = this.collidePointCircle(x2,y2, cx,cy,diameter);
  if (inside1 || inside2) return true;

  // get length of the line
  float distX = x1 - x2;
  float distY = y1 - y2;
  float len = sqrt( (distX*distX) + (distY*distY) );

  // get dot product of the line and circle
  float dot = ( ((cx-x1)*(x2-x1)) + ((cy-y1)*(y2-y1)) ) / pow(len,2);

  // find the closest point on the line
  float closestX = x1 + (dot * (x2-x1));
  float closestY = y1 + (dot * (y2-y1));

  // is this point actually on the line segment?
  // if so keep going, but if not, return false
  Boolean onSegment = collidePointLine(closestX,closestY,x1,y1,x2,y2,0);
  if (!onSegment) return false;

  // draw a debug circle at the closest point on the line
  if(_collideDebug){
    ellipse(closestX, closestY,10,10);
  }

  // get distance to closest point
  distX = closestX - cx;
  distY = closestY - cy;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  if (distance <= diameter/2) {
    return true;
  }
  return false;
}

Boolean collideLineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  //Boolean intersection;

  // calculate the distance to intersection point
  float  uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float  uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    float intersectionX = 0;
    float intersectionY = 0;
    if(_collideDebug){
      // calc the point where the lines meet
      intersectionX = x1 + (uA * (x2-x1));
      intersectionY = y1 + (uA * (y2-y1));
    }

    if(_collideDebug){
      ellipse(intersectionX,intersectionY,10,10);
    }

    return true;
    
  }
  
  return false;
}

Boolean collideLineRect(float x1, float y1, float x2, float y2, float rx, float ry, float rw, float rh) {

  // check if the line has hit any of the rectangle's sides. uses the collideLineLine function above
  Boolean left, right, top, bottom;

  
  //return booleans
  left =   collideLineLine(x1,y1,x2,y2, rx,ry,rx, ry+rh);
  right =  collideLineLine(x1,y1,x2,y2, rx+rw,ry, rx+rw,ry+rh);
  top =    collideLineLine(x1,y1,x2,y2, rx,ry, rx+rw,ry);
  bottom = collideLineLine(x1,y1,x2,y2, rx,ry+rh, rx+rw,ry+rh);
  

  // if ANY of the above are true, the line has hit the rectangle
  if (left || right || top || bottom) {
    return true;
  }
  return false;
}


Boolean collidePointPoly(float px, float py, PVector vertices[]) {
  Boolean collision = false;

  // go through each of the vertices, plus the next vertex in the list
  float  next = 0;
  for (float  current=0; current<vertices.length; current++) {

    // get next vertex in list if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position this makes our if statement a little cleaner
    PVector  vc = vertices[(int)current];    // c for "current"
    PVector  vn = vertices[(int)next];       // n for "next"

    // compare position, flip 'collision' variable back and forth
    if (((vc.y > py && vn.y < py) || (vc.y < py && vn.y > py)) &&
         (px < (vn.x-vc.x)*(py-vc.y) / (vn.y-vc.y)+vc.x)) {
            collision = !collision;
    }
  }
  return collision;
}

// POLYGON/CIRCLE
Boolean collideCirclePoly(float cx, float cy, float diameter, PVector vertices[], Boolean interior) {

  if (interior == undefinedB){
    interior = false;
  }

  // go through each of the vertices, plus the next vertex in the list
  float  next = 0;
  for (float  current=0; current<vertices.length; current++) {

    // get next vertex in list if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position this makes our if statement a little cleaner
    PVector  vc = vertices[(int)current];    // c for "current"
    PVector  vn = vertices[(int)next];       // n for "next"

    // check for collision between the circle and a line formed between the two vertices
    Boolean collision = this.collideLineCircle(vc.x,vc.y, vn.x,vn.y, cx,cy,diameter);
    if (collision) return true;
  }

  // test if the center of the circle is inside the polygon
  if(interior == true){
    Boolean centerInside = this.collidePointPoly(cx,cy, vertices);
    if (centerInside) return true;
  }

  // otherwise, after all that, return false
  return false;
}

Boolean collideRectPoly( float rx, float ry, float rw, float rh, PVector vertices[], Boolean interior) {
  if (interior == undefinedB){
    interior = false;
  }

  // go through each of the vertices, plus the next vertex in the list
  float next = 0;
  for (float current=0; current<vertices.length; current++) {

    // get next vertex in list if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position this makes our if statement a little cleaner
    PVector vc = vertices[(int)current];    // c for "current"
    PVector vn = vertices[(int)next];       // n for "next"

    // check against all four sides of the rectangle
    Boolean collision = this.collideLineRect(vc.x,vc.y,vn.x,vn.y, rx,ry,rw,rh);
    if (collision) return true;

    // optional: test if the rectangle is INSIDE the polygon note that this iterates all sides of the polygon again, so only use this if you need to
    if(interior == true){
      Boolean inside = this.collidePointPoly(rx,ry, vertices);
      if (inside) return true;
    }
  }

  return false;
}

Boolean collideLinePoly(float x1, float y1, float x2, float y2, PVector vertices[]) {

  // go through each of the vertices, plus the next vertex in the list
  float  next = 0;
  for (float  current=0; current<vertices.length; current++) {

    // get next vertex in list if we've hit the end, wrap around to 0
    next = current+1;
    if (next == vertices.length) next = 0;

    // get the PVectors at our current position extract X/Y coordinates from each
    float  x3 = vertices[(int)current].x;
    float  y3 = vertices[(int)current].y;
    float  x4 = vertices[(int)next].x;
    float  y4 = vertices[(int)next].y;

    // do a Line/Line comparison if true, return 'true' immediately and stop testing (faster)
    Boolean hit = this.collideLineLine(x1, y1, x2, y2, x3, y3, x4, y4);
    if (hit) {
      return true;
    }
  }
  // never got a hit
  return false;
}

Boolean collidePolyPoly(PVector p1[], PVector p2[], Boolean interior) {
  if (interior == undefinedB){
    interior = false;
  }

  // go through each of the vertices, plus the next vertex in the list
  float  next = 0;
  for (float  current=0; current<p1.length; current++) {

    // get next vertex in list, if we've hit the end, wrap around to 0
    next = current+1;
    if (next == p1.length) next = 0;

    // get the PVectors at our current position this makes our if statement a little cleaner
    PVector  vc = p1[(int)current];    // c for "current"
    PVector  vn = p1[(int)next];       // n for "next"

    //use these two points (a line) to compare to the other polygon's vertices using polyLine()
    Boolean collision = this.collideLinePoly(vc.x,vc.y,vn.x,vn.y,p2);
    if (collision) return true;

    //check if the 2nd polygon is INSIDE the first
    if(interior == true){
      collision = this.collidePointPoly(p2[0].x, p2[0].y, p1);
      if (collision) return true;
    }
  }

  return false;
}

Boolean collidePointTriangle(float px, float py, float x1, float y1, float x2,float  y2, float x3, float y3) {

  // get the area of the triangle
  float areaOrig = abs( (x2-x1)*(y3-y1) - (x3-x1)*(y2-y1) );

  // get the area of 3 triangles made between the point and the corners of the triangle
  float area1 = abs( (x1-px)*(y2-py) - (x2-px)*(y1-py) );
  float area2 = abs( (x2-px)*(y3-py) - (x3-px)*(y2-py) );
  float area3 = abs( (x3-px)*(y1-py) - (x1-px)*(y3-py) );

  // if the sum of the three areas equals the original, we're inside the triangle!
  if (area1 + area2 + area3 == areaOrig) {
    return true;
  }
  return false;
}

Boolean collidePointPoint(float x,float y,float x2,float y2, float buffer) {
    if(buffer == undefinedF){
      buffer = 0;
    }

    if(dist(x,y,x2,y2) <= buffer){
      return true;
    }

  return false;
};

Boolean collidePointArc(float px, float py, float ax, float ay, float arcRadius, float arcHeading, float arcAngle, float buffer) {

  if (buffer == undefinedF) {
    buffer = 0;
  }
  // point
  PVector point = new PVector(px, py);
  // arc center point
  PVector arcPos = new PVector(ax, ay);
  // arc radius vector
  PVector radius = new PVector(arcRadius, 0).rotate(arcHeading);

  PVector pointToArc = point.copy().sub(arcPos);

  if (point.dist(arcPos) <= (arcRadius + buffer)) {
    float dot = radius.dot(pointToArc);
    float angle = radius.angleBetween(pointToArc,radius);
    if (dot > 0 && angle <= arcAngle / 2 && angle >= -arcAngle / 2) {
      return true;
    }
  }
  return false;
}
