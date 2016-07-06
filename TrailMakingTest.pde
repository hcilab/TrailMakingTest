import java.util.ArrayList;

ArrayList<Circle> circles = new ArrayList<Circle>();

ArrayList<String> trailA;
ArrayList<String> trailB;

void setup() {
  fullScreen();
  ellipseMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);


  trailA = generateTrailA();
  trailB = generateTrailB();

  generateCirclesTrailA();
}


void draw() {
  background(255);

  for (Circle c : circles) {
    c.draw();
  }
}

void generateCirclesTrailA() {
  ArrayList<String> texts = (ArrayList<String>)trailA.clone();

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width/2), (int) random(0, height/2), texts.get(textIndex));
    while (isTouching(c)){
      c = new Circle((int)random(0, width/2), (int) random(0, height/2), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(width/2, width), (int) random(0, height/2), texts.get(textIndex));
    while (isTouching(c)) {
      c = new Circle((int)random(width/2, width), (int) random(0, height/2), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width/2), (int)random(height/2, height), texts.get(textIndex));
    while (isTouching(c)) {
      c = new Circle((int)random(0, width/2), (int)random(height/2, height), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(width/2, width), (int)random(height/2, height), texts.get(textIndex));
    while (isTouching(c)) {
      c = new Circle((int)random(width/2, width), (int)random(height/2, height), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  int circlesLeft = texts.size();
  for (int i=0; i<circlesLeft; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width), (int)random(0, height), texts.get(textIndex));
    while (isTouching(c)) {
      c = new Circle((int)random(0, width), (int)random(0, height), texts.get(textIndex));
    }
    circles.add(c);
    texts.remove(textIndex);
  }
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