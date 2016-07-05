import java.util.ArrayList;

ArrayList<Circle> circles = new ArrayList<Circle>();


void setup() {
	fullScreen();
	ellipseMode(CENTER);
	shapeMode(CENTER);
	textAlign(CENTER, CENTER);

	generateCircles();
}


void draw() {
	background(255);
	for (Circle c : circles) {
		c.draw();
	}
}

void generateCircles() {
	circles.add(new Circle(100,100, "A"));
	circles.add(new Circle(200,200, "B"));
	circles.add(new Circle(300,300, "C"));
}
