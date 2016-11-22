import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;

ArrayList<Circle> circles = new ArrayList<Circle>();
ArrayList<Line> previousLines = new ArrayList<Line>();
ArrayList<Line> currentLines = new ArrayList<Line>();

ArrayList<String> trail;
int index;
int radius;

long startTime;
long stopTime;
float runningTime;
int errors;
boolean errorLogged;
String errorLoggedFor;
boolean returnToPrevious;
boolean drawCurrentLines;

boolean isTrialA;
float timeOfTrial;
float averageTargets;
float standardDeviation;
long seedValue;
String username;
String type;
long prevTargetTime;
long CurrentTargetTime;
int currErrorCount;
int prevErrorCount;

int trialNumber;
float[] targetTimes;
int[] targetErrors;
float totalPathDistance;

Table tableResults;
TableRow resultsNewRow;
Table tableError;
Table tableRawData;

PFont font;
int fontSize = 30;
int bottomBarHeight = fontSize;


boolean mouseClicked;
int mouseClickedX;
int mouseClickedY;

void setup() {
  username = loadUsername();
  seedValue = loadRandomSeed();
  //randomSeed(seedValue);

  fullScreen();
  ellipseMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);

  font = createFont("Helvetica", fontSize);
  textFont(font);

  radius = adjustTargetSize();

  mouseClicked = false;
  mouseClickedX = 0;
  mouseClickedY = 0;

  index = 0;
  errors = 0;
  errorLogged = false;
  errorLoggedFor = "NULL";

  // HAck =======================================================
  Table input = loadTable("results-sample.csv", "header");
  Table output = new Table();
  output.addColumn("seed");
  for(int i = 1; i < 25;i++)
    output.addColumn("DistanceA " + i);
  for(int i = 1; i <= 25;i++){
    output.addColumn("xA " + i);
    output.addColumn("yA " + i);
  }
  for(int i = 1; i < 25;i++)
    output.addColumn("DistanceB " + i);
  for(int i = 1; i <= 25;i++){
    output.addColumn("xB " + i);
    output.addColumn("yB " + i);
  }



  for (TableRow r : input.rows()) {
    long seed = r.getLong("seed");
    println(seed);
    randomSeed(seed);

    // generate Trail A
    trail = generateTrailA();
    generateCirclesTrail(trail);
    Collections.sort(circles, new TrailAComparator());
    optimizePath();

    // log distances
    TableRow outputRow = output.addRow();
    outputRow.setLong("seed", seed);
    outputRow.setFloat("xA " + 1, circles.get(0).x);
    outputRow.setFloat("yA " + 1, circles.get(0).y);
    int j = 0;
    for(int i = 1; i < 25;i++){
      float pathDistance = circles.get(i-1).getDistanceTo(circles.get(i));
      outputRow.setFloat("DistanceA " + i, pathDistance);
      j = i+1;
      outputRow.setFloat("xA " + j, circles.get(i).x);
      outputRow.setFloat("yA " + j, circles.get(i).y);
    }

    // generate Trail B
    trail = generateTrailB();
    generateCirclesTrail(trail);
    Collections.sort(circles, new TrailBComparator());
    optimizePath();

    // log distances
    outputRow.setFloat("xB " + 1, circles.get(0).x);
    outputRow.setFloat("yB " + 1, circles.get(0).y);
    for(int i = 1; i < 25;i++){
      float pathDistance = circles.get(i-1).getDistanceTo(circles.get(i));
      outputRow.setFloat("DistanceB " + i, pathDistance);
      j = i+1;
      outputRow.setFloat("xB " + j, circles.get(i).x);
      outputRow.setFloat("yB " + j, circles.get(i).y);
    }
  }

  String outputFile = "output-sample.csv";
  saveTable(output, outputFile);
  println("Saved data successfully to: " + outputFile);
  System.exit(0);
  // =================================================================

  returnToPrevious = false;
  drawCurrentLines = false;
  targetTimes = new float[24];
  targetErrors = new int[24];
  
  generateTables();
  resultsNewRow = tableResults.addRow();
  isTrialA = true;
  addCommonValuesToTableStart();
  type = "A";
}

void draw() {
  background(255);
  textAlign(CENTER,CENTER);

  int r,g,b;
  for (Circle c : circles) {
    if (c.passed && c.isMoused() && returnToPrevious) {
      if (c.text.equals(circles.get(index-1).text) && mouseClicked && clickedWithinCircle(c)) {
        returnToPrevious = false;
        drawCurrentLines = true;
        currentLines.clear();
      }
      r=0;
      g=255;
      b=0;
    }
    else if (c.passed) {
      r=0;
      g=255;
      b=0;
    }
    else if (c.isMoused() && c.text.equals(trail.get(index)) && !returnToPrevious && mouseClicked) {
      drawCurrentLines = true;
      currentLines.clear();
      if (index>0) {
        Circle prev = circles.get(index-1);
        Circle cur = circles.get(index);
        previousLines.add(new Line(prev.x, prev.y, cur.x, cur.y));
      }
      index++;
      c.passed = true;
      r=0;
      g=255;
      b=0;
      if(index > 1){
        CurrentTargetTime = System.currentTimeMillis();
        targetTimes[index-2] = ((CurrentTargetTime - prevTargetTime)/1000.0);
        averageTargets += (CurrentTargetTime - prevTargetTime);
        prevTargetTime = CurrentTargetTime;
        currErrorCount = errors;
        targetErrors[index-2] = currErrorCount-prevErrorCount;
        prevErrorCount = currErrorCount;
      }

      if (index == 1) {
        startTime = System.currentTimeMillis();
        prevTargetTime = startTime;
        prevErrorCount = 0;
        errors = 0;
        totalPathDistance = 0;
      } else if (index == 25) {
        drawCurrentLines = false;
        currentLines.clear();
        stopTime = System.currentTimeMillis();
        println("Test Run: " + (stopTime-startTime)/1000.0 + " seconds (" + errors + " errors).");
        timeOfTrial = (stopTime-startTime)/1000.0;
        if(isTrialA) {
          logRawDataResults();
          logTrialResults("Trail A ");
        }
        else {
          beforeExit();
        }
        mouseClicked = false;
      }

      if (c.text.equals("25")) {
        index = 0;
        errors = 0;
        trail = generateTrailB();
        isTrialA = false;
         type = "B";
        generateCirclesTrail(trail);
        Collections.sort(circles, new TrailBComparator());
        optimizePath();
      }
    }
    else if (c.isMoused()) {
      if (!errorLogged && index > 0) {
        errors++;
        String expectedTarget = trail.get(index);
        String acquiredTarget = c.text;
        addRowError(expectedTarget, acquiredTarget);
        errorLogged = true;
        errorLoggedFor = c.text;
        returnToPrevious = true;
        drawCurrentLines = false;
        currentLines.clear();
      }
      r=255;
      g=0;
      b=0;
    }
    else {
      if (c.text.equals(errorLoggedFor)) {
        errorLogged = false;
        errorLoggedFor = "NULL";
      }
      r=255;
      g=255;
      b=255;
    }
    c.draw(r,g,b);
  }

  if (drawCurrentLines) {
    currentLines.add(new Line(pmouseX, pmouseY, mouseX, mouseY));
    for (Line l : currentLines) {
      l.draw(0, 0, 0);
    }
  }
  for (Line l : previousLines) {
    l.draw(169, 169, 169);
  }

  if (index < 1) {
    runningTime = 0;
    mouseClicked = false;
    drawCurrentLines = false;
    returnToPrevious = false;
  }
  else {
    runningTime = ((System.currentTimeMillis()-startTime)/1000.0);
  }

  text(runningTime, width/2, height-(fontSize/2));
  textAlign(LEFT, CENTER);
  if (username.equals("")) {
    fill(255,0,0);
  }
  text("Username: " + username, 0, height-(fontSize/2));
}

void generateCirclesTrail(ArrayList<String> trail) {
  ArrayList<String> texts = (ArrayList<String>)trail.clone();

  circles.clear();
  previousLines.clear();
  currentLines.clear();
  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width/2), (int) random(0, height/2), texts.get(textIndex), radius);
    while (isTouching(c) || !isInBounds(c)){
      c = new Circle((int)random(0, width/2), (int) random(0, height/2), texts.get(textIndex), radius);
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(width/2, width), (int) random(0, height/2), texts.get(textIndex), radius);
    while (isTouching(c) || !isInBounds(c)) {
      c = new Circle((int)random(width/2, width), (int) random(0, height/2), texts.get(textIndex), radius);
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width/2), (int)random(height/2, height), texts.get(textIndex), radius);
    while (isTouching(c) || !isInBounds(c)) {
      c = new Circle((int)random(0, width/2), (int)random(height/2, height), texts.get(textIndex), radius);
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  for (int i=0; i<3; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(width/2, width), (int)random(height/2, height), texts.get(textIndex), radius);
    while (isTouching(c) || !isInBounds(c)) {
      c = new Circle((int)random(width/2, width), (int)random(height/2, height), texts.get(textIndex), radius);
    }
    circles.add(c);
    texts.remove(textIndex);
  }

  int circlesLeft = texts.size();
  for (int i=0; i<circlesLeft; i++) {
    int textIndex = (int)random(texts.size());
    Circle c = new Circle((int)random(0, width), (int)random(0, height), texts.get(textIndex), radius);
    while (isTouching(c) || !isInBounds(c)) {
      c = new Circle((int)random(0, width), (int)random(0, height), texts.get(textIndex), radius);
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
    if (sqrt(pow(abs(curr.x - c.x),2.0) + pow((abs(curr.y - c.y)), 2.0)) < radius*2) {
      touching = true;
      break;
    }
  }
  return touching;
}

boolean isInBounds(Circle c) {
  boolean inBounds = false;
  if (c.x > radius && c.x < width-radius && c.y > radius && c.y < height-radius-bottomBarHeight) {
    inBounds = true;
  }
  return inBounds;
}

void generateTables(){

  if(fileExists("logging/results/results_" + username +".csv")){
    tableResults = loadTable("logging/results/results_" + username +".csv", "header");
  }
  else{
    tableResults  = new Table();
    tableResults.addColumn("TOD");
    tableResults.addColumn("username");
    tableResults.addColumn("seed");
    tableResults.addColumn("Trial #");
    tableResults.addColumn("Trail A Time");
    tableResults.addColumn("Trail A Errors");
    tableResults.addColumn("Trail A Average Time Between Targets");
    tableResults.addColumn("Trail A Standard Deviation Between Targets");
    tableResults.addColumn("Trail A Path Length");
    tableResults.addColumn("Trail B Time");
    tableResults.addColumn("Trail B Errors");
    tableResults.addColumn("Trail B Average Time Between Targets");
    tableResults.addColumn("Trail B Standard Deviation Between Targets");
    tableResults.addColumn("Trail B Path Length");
  }
  
  if(fileExists("logging/error/error_" + username +".csv")){
    tableError = loadTable("logging/error/error_" + username +".csv", "header");
  }
  else{
    tableError = new Table();
    tableError.addColumn("TOD");
    tableError.addColumn("username");
    tableError.addColumn("Trial #");
    tableError.addColumn("Trail");
    tableError.addColumn("Expected Target");
    tableError.addColumn("Acquired Target");
  }
   if(fileExists("logging/rawData/rawData_" + username +".csv")){
    tableRawData = loadTable("logging/rawData/rawData_" + username +".csv", "header");
  }
  else{
    tableRawData = new Table();
    tableRawData.addColumn("TOD");
    tableRawData.addColumn("username");
    tableRawData.addColumn("Trial #");
    tableRawData.addColumn("Trail");
    for(int i = 1; i < 25;i++){
      tableRawData.addColumn("Time " + i);
    }
    for(int i = 1; i < 25;i++){
      tableRawData.addColumn("Errors " + i);
    }
    for(int i = 1; i < 25;i++){
      tableRawData.addColumn("Distance " + i);
    }
  }
}

void addCommonValuesToTableStart(){
  resultsNewRow.setLong("TOD", System.currentTimeMillis());
  resultsNewRow.setString("username", username);
  resultsNewRow.setLong("seed", seedValue);
  trialNumber = tableResults.getRowCount();
  resultsNewRow.setInt("Trial #", trialNumber);
}

void logTrialResults(String trial){
  averageTargets = (averageTargets/24)/1000.0;
  resultsNewRow.setFloat(trial + "Time", timeOfTrial);
  resultsNewRow.setFloat(trial + "Errors", errors);
  resultsNewRow.setFloat(trial + "Average Time Between Targets", averageTargets);
  resultsNewRow.setFloat(trial + "Standard Deviation Between Targets", calcStandardDev(averageTargets, targetTimes));
  resultsNewRow.setFloat(trial + "Path Length", totalPathDistance);
}

void logRawDataResults(){
  TableRow rawDataNewRow = tableRawData.addRow();
  rawDataNewRow.setLong("TOD", startTime);
  rawDataNewRow.setString("username", username);
  rawDataNewRow.setString("Trail", type);
  rawDataNewRow.setInt("Trial #", trialNumber);
  float pathDistance;
  for(int i = 1; i < 25;i++){
    rawDataNewRow.setFloat("Time " + i, targetTimes[i-1]);
    rawDataNewRow.setFloat("Errors " + i, targetErrors[i-1]);
    pathDistance = circles.get(i-1).getDistanceTo(circles.get(i));
    totalPathDistance += pathDistance;
    rawDataNewRow.setFloat("Distance " + i, pathDistance);
  }
}

void addRowError(String expTarget, String acqTarget){
  TableRow errorNewRow = tableError.addRow();
  errorNewRow.setLong("TOD", System.currentTimeMillis());
  errorNewRow.setString("username", username);
  errorNewRow.setInt("Trial #", trialNumber);
  errorNewRow.setString("Trail", type);
  errorNewRow.setString("Expected Target", expTarget);
  errorNewRow.setString("Acquired Target", acqTarget);
}

float calcStandardDev(float mean, float[] targTimes){
  float sumOfSquares = 0;
  for(int i = 0;i < targTimes.length; i++){
    sumOfSquares += pow(targTimes[i] - mean, 2);
  }
  float div = (sumOfSquares/24);
  return sqrt(div);
}

void saveTables(){  
  saveTable(tableResults, "logging/results/results_" + username +".csv");
  saveTable(tableError, "logging/error/error_" + username +".csv");
  saveTable(tableRawData, "logging/rawData/rawData_" + username +".csv");
}

boolean fileExists(String filename) {
 File file = new File(sketchPath(filename));

 if(!file.exists())
  return false;
   
 return true;
}

void beforeExit() {
  logRawDataResults();
  logTrialResults("Trail B ");
  saveTables();
  exit();
}

void keyPressed() {
  if (key == ESC) {
    key = 0; // override so that signal is not propogated on to kill window
    return;
  }
}

int adjustTargetSize() {
  int radius;
  if (width > height) {
    radius = Math.round(height/22.5);
  }
  else {
    radius = Math.round(width/22.5);
  }
  return radius;
}

/*
 * Always return something meaningful, so that test run will never be inhibited.
 * Returns:
 *   - "" when 'username.txt' does not exist
 *   - "" when load fails
 *   - contents of 'username.txt' otherwise
 */
String loadUsername() {
  String filename = "username.txt";
  String defaultValue = "";

  if (!fileExists(filename)) {
    return defaultValue;
  }

  BufferedReader r = createReader(filename);
  String username = "";
  try {
    username = r.readLine();
  } catch (Exception e) {
    return defaultValue;
  }
  return username;
}

/*
 * Always return something meaningful, so that test run will never be inhibited.
 * Returns:
 *   - currentTime when 'randomSeed.txt' does not exist
 *   - currentTime when load fails
 *   - currentTime when invalid integer format in 'randomSeed.txt'
 *   - contents of 'randomSeed.txt' otherwise
 */
long loadRandomSeed() {
  String filename = "randomSeed.txt";
  long defaultValue = System.currentTimeMillis();

  if (!fileExists(filename)) {
    return defaultValue;
  }

  BufferedReader r = createReader(filename);
  String seedString = "";
  try {
    seedString = r.readLine();
  } catch (Exception e) {
    return defaultValue;
  }

  long seed = defaultValue;
  try {
    seed = Long.parseLong(seedString);
  } catch (Exception e) {
    return defaultValue;
  }
  return seed;
}

void mousePressed() {
  mouseClicked = true;
  mouseClickedX = mouseX;
  mouseClickedY = mouseY;
}

void mouseReleased() {
  mouseClicked = false;
  drawCurrentLines = false;
  returnToPrevious = true;
}

boolean clickedWithinCircle(Circle c) {
  boolean withinCircle = false;
  if (mouseClickedX > c.x-radius && mouseClickedX < c.x+radius && mouseClickedY > c.y - radius && mouseClickedY < c.y + radius) {
    withinCircle = true;
  }
  return withinCircle;
}