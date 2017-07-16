class GridController
{
  ArrayList<Subcommander> mySubcommanders = new ArrayList<Subcommander>();
  ArrayList<GridController> neighbors = new ArrayList<GridController>();
  
  float topBound;
  float bottomBound;
  float leftBound;
  float rightBound;
  float gridIndex;
  
  float landValue;
  float importance;
  
  GridController(float gi, float tb, float bb, float lb, float rb, float lv)
  {
    topBound = tb;
    bottomBound = bb;
    leftBound = lb;
    rightBound = rb;
    landValue = lv;
    gridIndex = gi;
  }
  
  
  void mainUpdate()
  {
    checkSubcommanders();  
    drawRect();
    updateImportance();
    
    for(int i = 0; i < mySubcommanders.size(); i++)
    {
      Subcommander sub = mySubcommanders.get(i);
      sub.mainUpdate();
    }
  }
  
  void updateImportance()
  {
    importance = landValue + 4 * mySubcommanders.size();
  }
  
  void checkSubcommanders()
  {
    for(int i = 0; i < mySubcommanders.size(); i++)
    {
      Subcommander sub = mySubcommanders.get(i);
      if(sub.soldiers.size() == 0  &&  sub.birth == false) mySubcommanders.remove(i);  
    }
  }
  
  void drawRect()
  {
    float greenValue = map(landValue, minLandValue, maxLandValue, 50, 120);
    fill(0, greenValue, 0, 50);
    rect(leftBound, topBound, rightBound - leftBound, bottomBound - topBound);
  }
  
  void findNeighbors()
  {
    boolean onTop = true;
    boolean onBottom = true;
    boolean onLeft = true;
    boolean onRight = true;
    
    if(gridIndex - gridSizeX >= 0) onTop = false;
    if(gridIndex + gridSizeX < gridSizeX * gridSizeY) onBottom = false;
    if(gridIndex % gridSizeX > 0) onLeft = false;
    if(gridIndex % gridSizeX != gridSizeX - 1) onRight = false;
    
    
    if(!onTop && !onLeft) neighbors.add(gridControllers.get(int(gridIndex - gridSizeX - 1)));
    if(!onTop) neighbors.add(gridControllers.get(int(gridIndex - gridSizeX)));
    if(!onTop && !onRight) neighbors.add(gridControllers.get(int(gridIndex - gridSizeX + 1)));
    if(!onLeft) neighbors.add(gridControllers.get(int(gridIndex - 1)));
    if(!onRight) neighbors.add(gridControllers.get(int(gridIndex + 1)));
    if(!onLeft && !onBottom) neighbors.add(gridControllers.get(int(gridIndex + gridSizeX - 1)));
    if(!onBottom) neighbors.add(gridControllers.get(int(gridIndex + gridSizeX)));    
    if(!onBottom && !onRight) neighbors.add(gridControllers.get(int(gridIndex + gridSizeX + 1)));
  }
}