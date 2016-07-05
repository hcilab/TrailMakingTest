class Circle {
	int RADIUS = 40; //TODO in terms of height/width
	int x;
	int y;
	String text;

	public Circle(int x, int y, String text) {
		this.x = x;
		this.y = y;
		this.text = text;
	}

	public void draw() {
		fill(255); // white circle
		ellipse(x, y, RADIUS, RADIUS);
		fill(0); // black text
		text(text, x, y);
	}
}
