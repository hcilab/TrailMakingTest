class Circle {
  private int radius;
  public int x;
  public int y;
  public String text;
  public boolean passed;

  public Circle(int x, int y, String text, int radius) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.radius = radius;
    this.passed = false;
  }

  public void draw(int r, int g, int b) {
    stroke(0,0,0);
    strokeWeight(1);
    fill(r,g,b); // white circle
    ellipse(x, y, radius*2, radius*2);
    fill(0); // black text
    text(text, x, y);
  }

  public boolean isMoused() {
    int relativeX = mouseX - x;
    int relativeY = mouseY - y;
    return sqrt(relativeX*relativeX + relativeY*relativeY) < radius;
  }

  public float getDistanceTo(Circle c) {
    int xComponent = abs(x - c.x);
    int yComponent = abs(y - c.y);
    return sqrt(xComponent*xComponent + yComponent*yComponent);
  }
}