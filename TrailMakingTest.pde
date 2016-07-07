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
Date timeOfDay;
float timeOfTrial;
float averageTargets;
float standardDeviation;
long seedValue;
String username;
long prevTargetTime;
long CurrentTargetTime;
int trialNumber;

Table tableResults;
TableRow resultsNewRow;
Table tableError;
Table tableRawData;

PFont font;
int fontSize = 30;
int bottomBarHeight = fontSize;

boolean ERROR_OCCURED;
String errorMessage;

void setup() {
  fullScreen();
  ellipseMode(CENTER);
  shapeMode(CENTER);
  textAlign(CENTER, CENTER);

  font = createFont("Helvetica", fontSize);
  textFont(font);

  // By explicitly setting the value of this seed, repeatable tests can be
  // created.
  seedValue = System.currentTimeMillis();
  randomSeed(seedValue);

  radius = adjustTargetSize();

  index = 0;
  errors = 0;
  errorLogged = false;
  errorLoggedFor = "NULL";
  trail = generateTrailA();
  generateCirclesTrail(trail);
  Collections.sort(circles, new TrailAComparator());
  optimizePath();
  returnToPrevious = false;
  drawCurrentLines = false;
  
  generateTables();
  resultsNewRow = tableResults.addRow(); 
  isTrialA = true;
  addCommonValuesToTableStart();

  ERROR_OCCURED = false;
  errorMessage = "";
  username = loadSetting("username.txt");
}

void draw() {
  background(255);
  
  if (ERROR_OCCURED) {
    fill(0);
    text(errorMessage, width/2, height/2);
    return;
  }

  int r,g,b;
  for (Circle c : circles) {
    if (c.passed && c.isMoused() && returnToPrevious) {
      if (c.text.equals(circles.get(index-1).text)) {
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
    else if (c.isMoused() && c.text.equals(trail.get(index)) && !returnToPrevious) {
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
        averageTargets += (CurrentTargetTime - prevTargetTime);
        prevTargetTime = CurrentTargetTime;
      }

      if (index == 1) {
        startTime = System.currentTimeMillis();
        prevTargetTime = startTime;
        errors = 0;
      } else if (index == 25) {
        drawCurrentLines = false;
        currentLines.clear();
        stopTime = System.currentTimeMillis();
        println("stopTime: " + stopTime + "startTime :" + startTime); 
        println("Test Run: " + (stopTime-startTime)/1000.0 + " seconds (" + errors + " errors).");
        timeOfTrial = (stopTime-startTime)/1000.0;
        if(isTrialA) {
          logTrialResults("Trial A ");
        }
        else {
          beforeExit();
        }
      }

      if (c.text.equals("25")) {
        index = 0;
        errors = 0;
        trail = generateTrailB();
        isTrialA = false;
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
  }
  else {
    runningTime = ((System.currentTimeMillis()-startTime)/1000.0);
  }

  text(runningTime, width/2, height-(fontSize/2));
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

  if(fileExists("results/results_" + username +".csv")){
    tableResults = loadTable("results/results_" + username +".csv", "header");
  }
  else{
    tableResults  = new Table();
    tableResults.addColumn("tod");
    tableResults.addColumn("username");
    tableResults.addColumn("seed");
    tableResults.addColumn("Trial #");
    tableResults.addColumn("Trial A Time");
    tableResults.addColumn("Trial A Errors");
    tableResults.addColumn("Trial A Average Time Between Targets");
    tableResults.addColumn("Trial A Standard Devation Between Targets");
    tableResults.addColumn("Trial B Time");
    tableResults.addColumn("Trial B Errors");
    tableResults.addColumn("Trial B Average Time Between Targets");
    tableResults.addColumn("Trial B Standard Devation Between Targets");
  }
  
  if(fileExists("error/error_" + username +".csv")){
    tableError = loadTable("error/error_" + username +".csv", "header");
  }
  else{
    tableError = new Table();
    tableError.addColumn("tod");
    tableError.addColumn("username");
    tableError.addColumn("Trial #");
    tableError.addColumn("Expected Target");
    tableError.addColumn("Acquired Target");
  }
  
  tableRawData = new Table();
  tableRawData.addColumn("Trial #");
  tableRawData.addColumn("1");
  tableRawData.addColumn("2");
  tableRawData.addColumn("3");
  tableRawData.addColumn("4");
  tableRawData.addColumn("5");
  tableRawData.addColumn("6");
  tableRawData.addColumn("7");
  tableRawData.addColumn("8");
  tableRawData.addColumn("9");
  tableRawData.addColumn("10");
  tableRawData.addColumn("11");
  tableRawData.addColumn("12");
  tableRawData.addColumn("13");
  tableRawData.addColumn("14");
  tableRawData.addColumn("15");
  tableRawData.addColumn("16");
  tableRawData.addColumn("17");
  tableRawData.addColumn("18");
  tableRawData.addColumn("19");
  tableRawData.addColumn("20");
  tableRawData.addColumn("21");
  tableRawData.addColumn("22");
  tableRawData.addColumn("23");
  tableRawData.addColumn("24");
  tableRawData.addColumn("25");
  
}

void addCommonValuesToTableStart(){
  timeOfDay = new Date();
  resultsNewRow.setLong("tod", timeOfDay.getTime());
  resultsNewRow.setString("username", "Username");
  resultsNewRow.setLong("seed", seedValue);
  trialNumber = tableResults.getRowCount();
  resultsNewRow.setInt("Trial #", trialNumber);
}

void logTrialResults(String trial){
  averageTargets = (averageTargets/24)/1000.0;
  resultsNewRow.setFloat(trial + "Time", timeOfTrial);
  resultsNewRow.setFloat(trial + "Errors", errors);
  resultsNewRow.setFloat(trial + "Average Time Between Targets", averageTargets);
  resultsNewRow.setFloat(trial + "Standard Devation Between Targets", 0);
}

void saveTables(){  
  saveTable(tableResults, "results/results_" + username +".csv");
  saveTable(tableError, "error/error_" + username +".csv");
  saveTable(tableRawData, "rawData/rawData_" + username +".csv");
}

void addRowError(String expTarget, String acqTarget){
  TableRow errorNewRow = tableError.addRow();
  errorNewRow.setLong("tod", timeOfDay.getTime());
  errorNewRow.setString("username", "Username");
  errorNewRow.setInt("Trial #", trialNumber);
  errorNewRow.setString("Expected Target", expTarget);
  errorNewRow.setString("Acquired Target", acqTarget);
}

boolean fileExists(String filename) {
 File file = new File(sketchPath(filename));

 if(!file.exists())
  return false;
   
 return true;
}

void beforeExit() {
  logTrialResults("Trial B ");
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

String loadSetting(String filename) {
  if (!fileExists(filename)) {
    ERROR_OCCURED = true;
    errorMessage = "Could not find file named: '" + filename + "'.";
    return null;
  }

  BufferedReader r = createReader(filename);
  String setting = null;
  try {
    setting = r.readLine();
  } catch (Exception e) {
    ERROR_OCCURED = true;
    errorMessage = "Error occured while loading setting from: '" + filename + "'.";
    return null;
  }
  return setting;
}
