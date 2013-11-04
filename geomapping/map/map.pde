//
// Jihyun Lee
// hellojihyun.com | jihyun.lee@nyu.edu
//
// this sketch is for experiment how to convert geo to screen and vice versa 
//

import com.modestmaps.*;
import com.modestmaps.core.*;
import com.modestmaps.geo.*;
import com.modestmaps.providers.*;

InteractiveMap map;

Point2f ptLoc;
Point2f mouseLoc = null;

void setup() {
  size(640, 480);
  smooth();
  
  map = new InteractiveMap(this, new OpenStreetMapProvider());

  // new york centered
  Location baseLoc = new Location(40.7361657, -73.9925548);
  map.setCenterZoom(baseLoc, 15); // zoom 0 is the whole world, 19 is street level  

  ptLoc = map.locationPoint(baseLoc);
}

void draw() {
  background(132, 212, 209);
  noStroke(); 

  fill(255);
  ellipse(ptLoc.x, ptLoc.y, 5, 5);

  if (mouseLoc != null) {
    fill(115, 113, 137);
    ellipse(mouseLoc.x, mouseLoc.y, 5, 5);
  }
}

void mousePressed() {
  mouseLoc = new Point2f(mouseX, mouseY);
  Location loc = map.pointLocation(mouseLoc);
  println("mouse: "+loc.lat+","+loc.lon);
}
