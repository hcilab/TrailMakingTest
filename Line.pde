class Line {
  int startx;
  int endx;
  int starty;
  int endy;

  public Line(int startx, int starty, int endx, int endy) {
    this.startx = startx;
    this.starty = starty;
    this.endx = endx;
    this.endy = endy;
  }

  public void draw(int r, int g, int b) {
    stroke(r,g,b);
    strokeWeight(4);
    line(startx, starty, endx, endy);
  }
}
