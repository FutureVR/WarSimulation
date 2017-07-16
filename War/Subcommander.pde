class Subcommander
{
  ArrayList<Soldier> soldiers = new ArrayList<Soldier>();
  ArrayList<GridController> neightbors = new ArrayList<GridController>();
  
  GridController myGridController;
  int gridIndex;
  
  float topBound;
  float bottomBound;
  float leftBound;
  float rightBound;
  
  int owner;
  int numberOfSoldiers = 0;
  int maxSoldiers;
  boolean birth = true;
  
  int maxSpawnRate = (int)growthRateSlider.getMax();
  int maxAttackRate = (int)aggressionSlider.getMax();
  
  int spawnRate;
  int attackRate;
  
  float spawnBound = gridLengthX / 4f;
  
  Subcommander(GridController gc, int gi, int o)
  {
    myGridController = gc;
    topBound = gc.topBound;
    bottomBound = gc.bottomBound;
    leftBound = gc.leftBound;
    rightBound = gc.rightBound;
    gridIndex = gi;
    owner = o;
    //maxSoldiers = int( ((float)pow(soldierRadius, 2) / (float)(gridSizeX * gridSizeY)) * 5);
    
    myGridController.mySubcommanders.add(this);
    
    for(int i = 0; i < numberOfSoldiers; i++)
    {
     //TODO: UPDATE STARTING POSITION, SO NOT 0, 0
     PVector randVector = new PVector(random(myGridController.leftBound + 10, myGridController.rightBound - 10),
                                      random(myGridController.topBound + 10, myGridController.bottomBound - 10));
     soldiers.add( new Soldier(randVector, myGridController, owner));
    }
    
    
  }
  
  
  void mainUpdate()
  {
    attackRate = int(aggressionSlider.getValue() * .95);
    attackRate = maxAttackRate - attackRate;
    
    spawnRate = int(growthRateSlider.getValue() * .95);
    spawnRate = maxSpawnRate - spawnRate;
    
    maxSoldiers = (int)soldierCapSlider.getValue();

    
    if( soldiers.size() <= maxSoldiers  &&  
        int((random(0, spawnRate)) * (maxLandValue / (float)myGridController.landValue)) == 0) 
    {
      birth = false;
      spawnSoldier();
    }
    checkForEnemies();
    clearDead();
    
    if(soldiers.size() >= (1f / 2f) * maxSoldiers  &&  (int)random(0, attackRate) == 0) 
    {
      println("Attack");
      attack();
    }
  }
  
  void checkForEnemies()
  {
    if( myGridController.mySubcommanders.size() > 0)
    {
      for(Soldier s : soldiers)
      {
        for(int i = 0; i < myGridController.mySubcommanders.size(); i++)
        {
          if(myGridController.mySubcommanders.get(i).owner != owner)
          s.enemies = myGridController.mySubcommanders.get(i).soldiers;
        }
        
        s.friends = soldiers;
        s.mainUpdate();  
      }
    }
    else
    {
      //FIX THIS PART, SLOPPY
      
      for(Soldier s : soldiers)
      {
        s.friends = soldiers;
        //s.mainUpdate();  
      }
    }
    
  }
  
  void clearDead()
  {
    for(int i = soldiers.size() - 1; i >= 0; i--)
    {
      Soldier s = soldiers.get(i);
      if(s.isDead) soldiers.remove(i);
    }
  }
  
  void spawnSoldier()
  {
    PVector randVector = new PVector(random(myGridController.leftBound + spawnBound, myGridController.rightBound - spawnBound),
                                       random(myGridController.topBound + spawnBound, myGridController.bottomBound - spawnBound));
    soldiers.add( new Soldier(randVector, myGridController, owner));
  }
  
  void attack()
  {
    int victimIndex = -1;
    float highestImportance = 0;
    boolean attackable = true;
    
    for(int i = 0; i < myGridController.neighbors.size(); i++)
    {
      
      if(highestImportance < myGridController.neighbors.get(i).importance)
      {
        attackable = true;
        
        for(int j = 0; j < myGridController.neighbors.get(i).mySubcommanders.size(); j++)
        {
         if(myGridController.neighbors.get(i).mySubcommanders.get(j).owner == owner) attackable = false;
        }
        
        if(attackable)
        {
         highestImportance = myGridController.neighbors.get(i).importance;
         victimIndex = i;
        }
      }
    }
    
    if(victimIndex != -1)
    {
      int soldiersLeft = maxSoldiers / 4;
      
      GridController victimGrid = myGridController.neighbors.get(victimIndex);
      Subcommander newSubcommander = new Subcommander(victimGrid, int(victimGrid.gridIndex), owner);
      
      for(int i = soldiers.size() - 1; i > soldiersLeft; i--)
      {
        Soldier movingSoldier = soldiers.get(i);
        newSubcommander.soldiers.add(new Soldier(movingSoldier.myPosition, victimGrid, owner));
        soldiers.remove(i);
      }
      
      victimGrid.mySubcommanders.add(newSubcommander);
      //victimGrid.mySubcommanders.add( new Subcommander(victimGrid, int(victimGrid.gridIndex), owner));
    }
  }
  
}