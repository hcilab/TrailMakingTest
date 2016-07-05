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
    circles.add(new Circle((int)random(0, width/2), (int) random(0, height/2), texts.get(textIndex)));
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    circles.add(new Circle((int)random(width/2, width), (int) random(0, height/2), texts.get(textIndex)));
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    circles.add(new Circle((int)random(0, width/2), (int)random(height/2, height), texts.get(textIndex)));
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    circles.add(new Circle((int)random(width/2, width), (int)random(height/2, height), texts.get(textIndex)));
    texts.remove(textIndex);
  }

  for (int i=0; i<texts.size(); i++) {
    int textIndex = (int)random(texts.size());
    circles.add(new Circle((int)random(0, width), (int)random(0, height), texts.get(textIndex)));
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