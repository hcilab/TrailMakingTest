import java.util.ArrayList;
import java.util.Collections;

ArrayList<Circle> circles = new ArrayList<Circle>();

ArrayList<String> trail;
int index;

void setup() {
  fullScreen();
  ellipseMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);


  index = 0;
  trail = generateTrailA();
  generateCirclesTrail(trail);
  Collections.sort(circles, new TrailAComparator());
  optimizePath();
}


void draw() {
  background(255);
  int r,g,b;
  for (Circle c : circles) {
    if (c.passed) {
      r=0;
      g=255;
      b=0;
    }
    else if (c.isMoused() && c.text.equals(trail.get(index))) {
      index++;
      c.passed = true;
      r=0;
      g=255;
      b=0;

      if (c.text.equals("25")) {
        index = 0;
        trail = generateTrailB();
        generateCirclesTrail(trail);
        Collections.sort(circles, new TrailBComparator());
        optimizePath();
      }
    }
    else if (c.isMoused()) {
      r=255;
      g=0;
      b=0;
    }
    else {
      r=255;
      g=255;
      b=255;
    }
    c.draw(r,g,b);
  }
}

void generateCirclesTrail(ArrayList<String> trail) {
  ArrayList<String> texts = (ArrayList<String>)trail.clone();

  circles.clear();
  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width/2), (int) random(0, height/2), texts.get(textIndex));
    while (isTouching(c) || !isInBounds(c)){
      c = new Circle((int)random(0, width/2), (int) random(0, height/2), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(width/2, width), (int) random(0, height/2), texts.get(textIndex));
    while (isTouching(c) || !isInBounds(c)) {
      c = new Circle((int)random(width/2, width), (int) random(0, height/2), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width/2), (int)random(height/2, height), texts.get(textIndex));
    while (isTouching(c) || !isInBounds(c)) {
      c = new Circle((int)random(0, width/2), (int)random(height/2, height), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(width/2, width), (int)random(height/2, height), texts.get(textIndex));
    while (isTouching(c) || !isInBounds(c)) {
      c = new Circle((int)random(width/2, width), (int)random(height/2, height), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  int circlesLeft = texts.size();
  for (int i=0; i<circlesLeft; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width), (int)random(0, height), texts.get(textIndex));
    while (isTouching(c) || !isInBounds(c)) {
      c = new Circle((int)random(0, width), (int)random(0, height), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }
}

void optimizePath() {
  for (int i=0; i<circles.size()-1; i++) {
    Circle cur = circles.get(i);
    Circle next = circles.get(i+1);
    Circle closestNeighbour = findClosestRemainingNeighbour(cur);
    if (next != closestNeighbour) {
      swapPositions(next, closestNeighbour);
    }
  }
}

Circle findClosestRemainingNeighbour(Circle c) {
  int index = circles.indexOf(c);
  assert (index < circles.size());

  Circle closestNeighbour = circles.get(index+1);
  for (int i = index+2; i<circles.size(); i++) {
    Circle candidate = circles.get(i);
    if (c.getDistanceTo(candidate) < c.getDistanceTo(closestNeighbour)) {
      closestNeighbour = candidate;
    }
  }
  return closestNeighbour;
}

void swapPositions(Circle c, Circle d) {
  int tmpX = c.x;
  int tmpY = c.y;
  c.x = d.x;
  c.y = d.y;
  d.x = tmpX;
  d.y = tmpY;
}

ArrayList<String> generateTrailA() {
  ArrayList<String> trail = new ArrayList<String>();
  for (int i=0; i<25; i++) {
    trail.add(Integer.toString(i+1));
  }

  return trail;
}

ArrayList<String> generateTrailB() {
  ArrayList<String> trail = new ArrayList<String>();
  int i;
  char j;
  for (i=1, j='A'; i<14; i++, j++) {
    trail.add(Integer.toString(i));
    if (i<13) {
      trail.add(Character.toString(j));
    }
  }

  return trail;
}

boolean isTouching(Circle c) {
  boolean touching = false;
  for (Circle curr : circles) {
    if ( sqrt(pow(abs(curr.x - c.x),2.0) + pow((abs(curr.y - c.y)), 2.0)) < 80) {
      touching = true;
      break;
    }
  }
  return touching;
}

boolean isInBounds(Circle c) {
  boolean inBounds = false;
  if (c.x > 40 && c.x < width-40 && c.y > 40 && c.y < height-40) {
    inBounds = true;
  }
  return inBounds;
}