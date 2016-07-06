class Circle {
  int RADIUS = 40; //TODO in terms of height/width
  public int x;
  public int y;
  public String text;
  public boolean passed;

  public Circle(int x, int y, String text) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.passed = false;
  }

  public void draw(int r, int g, int b) {
    fill(r,g,b); // white circle
    ellipse(x, y, RADIUS*2, RADIUS*2);
    fill(0); // black text
    text(text, x, y);
  }

  public boolean isMoused() {
    int relativeX = mouseX - x;
    int relativeY = mouseY - y;
    return sqrt(relativeX*relativeX + relativeY*relativeY) < RADIUS;
  }

  public float getDistanceTo(Circle c) {
    int xComponent = abs(x - c.x);
    int yComponent = abs(y - c.y);
    return sqrt(xComponent*xComponent + yComponent*yComponent);
  }
}
