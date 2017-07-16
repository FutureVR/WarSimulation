//Create a way for the subcommanders to attack
//Find a way to automatically place subcommanders on grids
//Make different subcommanders of the same color within the same grid repel each other
//Allow the commander to make decisions based on certain random variables
//When attacking, shift the soldiers from one grid to another instead of creating new ones
//Allow subcommanders to spawn more soldiers after a certain time limit

import controlP5.*;

//ArrayList<GridController> gridControllers = new ArrayList<GridController>();
ArrayList<GridController> gridControllers;
ArrayList<Subcommander> subcommanders = new ArrayList<Subcommander>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

float gridSizeX = 16;
float gridSizeY = 16;
float gridLengthX;
float gridLengthY;

int RED = 0;
int GREEN = 1;
int BLUE = 2;
int PURPLE = 3;

int minLandValue = 5;
int maxLandValue = 10;

float soldierRadius = 10;

ControlP5 cp5;

//Buttons
// 1) Restart
// 2) Pause
//Sliders
// 3) Attack Frequency
// 4) Growth Rate
// 5) Tile capacity

Button restartButton;
Button pauseButton;

Slider aggressionSlider;
Slider growthRateSlider;
Slider soldierCapSlider;

int buttonWidth = 200;
int buttonHeight = 50;
int buttonVerticalOffset = 56;

int sliderWidth = 200;
int sliderHeight = 32;
int sliderVerticalOffset = 40;

boolean paused;

//Button createButton(String name, int x, int y, int myWidth, int myHeight)
//Slider createSlider(String name, int x, int y, 
//    int myWidth, int myHeight, float min, float max, float value)

void setup()
{
  size(1600, 1600);
  background(255);
  paused = false;
  
  cp5 = new ControlP5(this);
  
  gridLengthX = width / gridSizeX;
  gridLengthY = height / gridSizeY;
  
  gridControllers = new ArrayList<GridController>();
  
  initializeGrid();
  initializeGridNeighbors();
  
  // Set up the UI
  restartButton = createButton("RESTART", width - buttonWidth - 10, 10, buttonWidth, buttonHeight);
  pauseButton = createButton("PAUSE", width - buttonWidth - 10, 10 + buttonVerticalOffset, buttonWidth, buttonHeight);
  aggressionSlider = createSlider("Aggression_Rate", 10, 10, sliderWidth, sliderHeight, 1, 1000, 500);
  growthRateSlider = createSlider("Growth_Rate", 10, 10 + sliderVerticalOffset, sliderWidth, sliderHeight, 1, 1000, 500);
  soldierCapSlider = createSlider("Soldier_Cap", 10, 10 + sliderVerticalOffset * 2, sliderWidth, sliderHeight , 1, 10, 4);
  
  placeSubcommandersOnGrid();
}



void draw()
{
  if (!paused)
  {
    background(255);
    drawGrid();
    for(GridController gc : gridControllers) gc.mainUpdate(); 
  }
}


public void controlEvent(ControlEvent theEvent) 
{
  Controller object = theEvent.getController();
  
  if (object == pauseButton)
  {
    paused = !paused;
  }
  else if (object == restartButton)
  {
    initializeGrid();
    initializeGridNeighbors();
    placeSubcommandersOnGrid();
  }
  else if (object == aggressionSlider)
  {
    
  }
  else if (object == growthRateSlider)
  {
    
  }
}



void drawGrid()
{
  for(int x = 0; x < width; x += gridLengthX)
  {
    line(x, 0, x, height);  
  }
  
  for(int y = 0; y < height; y += gridLengthY)
  {
    line(0, y, width, y);  
  }
}


void initializeGrid()
{
  // Clear old gridControllers, if they have already been created
  if (gridControllers.size() != 0)
  {
    gridControllers.clear();
  }
  
  // Create new gridControllers
  for(float y = 0; y < height; y += gridLengthY)
  {
    for(float x = 0; x < width; x += gridLengthX)
    {
      float landValue = (int)random(minLandValue, maxLandValue);
      gridControllers.add( new GridController((x / gridLengthX) + (y / gridLengthY) * gridSizeY, y, y + gridLengthY, x, x + gridLengthX, landValue));          
    }
  }
}
  
void initializeGridNeighbors()
{
  for(GridController gc : gridControllers) 
  {
    gc.findNeighbors();
  }
}


void placeSubcommandersOnGrid()
{
  // Add subcommanders and soldiers to the board
  int maxSoldiers = (int)soldierCapSlider.getValue();
  
  subcommanders.add( new Subcommander
      (gridControllers.get(0), 1, RED));
  subcommanders.add( new Subcommander
      (gridControllers.get( 1 ), 1, RED));
  subcommanders.add( new Subcommander
      (gridControllers.get((int)gridSizeX - 2), 2, GREEN));
  subcommanders.add( new Subcommander
      (gridControllers.get((int)gridSizeX - 1), 2, GREEN));
  subcommanders.add( new Subcommander
      (gridControllers.get( (int)gridSizeY * (int)(gridSizeX - 1) ), 3, BLUE));
  subcommanders.add( new Subcommander
      (gridControllers.get( (int)gridSizeY * (int)(gridSizeX - 1) + 1 ), 3, BLUE));
  subcommanders.add( new Subcommander
      (gridControllers.get( (int)gridSizeX * (int)gridSizeY - 2 ), 4, PURPLE));
  subcommanders.add( new Subcommander
      (gridControllers.get( (int)gridSizeX * (int)gridSizeY - 1 ), 4, PURPLE));
}


Button createButton(String name, int x, int y, int myWidth, int myHeight)
{
  Button button = cp5.addButton(name);
  button.setValue(0).setPosition(x, y).setSize(myWidth, myHeight);
  button.getCaptionLabel().setSize(myWidth / 10);
  return button;
}

Slider createSlider(String name, int x, int y, 
    int myWidth, int myHeight, float min, float max, float value)
{

  Slider slider = cp5.addSlider(name)
    .setCaptionLabel(name)
    .setPosition(x, y)
    .setColorCaptionLabel(color(0,0,0))
    .setSize(myWidth, myHeight)
    .setRange(min, max)
    .setValue(value)
    .setDecimalPrecision(2);
    
  slider.getCaptionLabel().setSize(20);
    
  return slider;
}