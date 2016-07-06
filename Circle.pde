class Circle {
	int RADIUS = 40; //TODO in terms of height/width
	public int x;
	public int y;
	public String text;

	public Circle(int x, int y, String text) {
		this.x = x;
		this.y = y;
		this.text = text;
	}

	public void draw() {
		fill(255); // white circle
		ellipse(x, y, RADIUS*2, RADIUS*2);
		fill(0); // black text
		text(text, x, y);
	}

	public boolean isMoused() {
		int relativeX = mouseX - x;
		int relativeY = mouseY - y;
		return sqrt(relativeX*relativeX + relativeY*relativeY) < RADIUS;
	}
}