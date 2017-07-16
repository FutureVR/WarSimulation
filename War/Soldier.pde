class Soldier
{
  //TODO: Set up bounds conditions
  
  ArrayList<Soldier> enemies = new ArrayList<Soldier>();
  ArrayList<Soldier> friends = new ArrayList<Soldier>();
  ArrayList<Bullet> myBullets = new ArrayList<Bullet>();
  GridController myGridController;
  int owner;
  boolean attacking = false;
  
  //Editable Values
  public float myRadius = 10;
  float attackRadius = 300;
  float fighterDistance = 1.2;
  float maxBulletSpeed = 2;
  float shotDelay = 700;
  float health = 10;
  float maxVelocity = 5;
  float maxForce = .2;
  
  // Non-editable Values
  PVector myPosition = new PVector();
  PVector myVelocity = new PVector(0, 0);
  PVector myAcceleration = new PVector();
  PVector targetPosition = new PVector(400, 400);
  float lastFireTime;
  boolean isDead = false;
  PVector desiredVelocity = new PVector();
  PVector steering = new PVector();
  float m = 10;
  float distanceToTarget;
  float smallestDistance = 1000;
  int closestIndex;
  
  
  Soldier(PVector p, GridController gc, int o)
  {
    myPosition.x = p.x;
    myPosition.y = p.y;
    myGridController = gc;
    owner = o;
    
    targetPosition = new PVector( myGridController.leftBound + gridLengthX / 2f, 
                                      myGridController.topBound + gridLengthY / 2f);
    
    //if(myPosition.x + myRadius > width) myPosition.x = width - myRadius;
    //if(myPosition.x - myRadius < 0) myPosition.x = myRadius;
    //if(myPosition.y - myRadius < 0) myPosition.y = myRadius;
    //if(myPosition.y + myRadius > height) myPosition.y = height - myRadius;
  }
  
  
  void mainUpdate()
  {
    clearBullets();
    updateBullets();
    
    updateTarget();
    updateSteering();
    spreadOut();
    updateMovement();
    display();
  }
  
  
  void updateMovement()
  {
    myVelocity.add(myAcceleration);
    myPosition.add(myVelocity);
    myAcceleration = new PVector(0, 0);
    
    //if(myPosition.x + myRadius > myGridController.rightBound) myPosition.x = myGridController.rightBound - myRadius;
    //if(myPosition.x - myRadius < myGridController.leftBound) myPosition.x = myGridController.leftBound + myRadius;
    //if(myPosition.y + myRadius > myGridController.bottomBound) myPosition.y = myGridController.bottomBound - myRadius;
    //if(myPosition.y - myRadius < myGridController.topBound) myPosition.y = myGridController.topBound + myRadius;
  }
  
  void updateSteering()
  {
    desiredVelocity = PVector.sub(targetPosition, myPosition);
    
    if(desiredVelocity.mag() < attackRadius)
    {
      m = map(desiredVelocity.mag(), 0, attackRadius, 0, maxVelocity);
      if(attacking) m -= fighterDistance;
      desiredVelocity.setMag(m);
    }
    else
    {
      desiredVelocity.setMag(maxVelocity);
    }
    
    if(m < 1.5)
    {
      if(enemies.size() > 0) 
      {
        shoot();  
      }
    }
    
    steering = PVector.sub(desiredVelocity, myVelocity);
    steering.limit(maxForce);
    addForce(steering);
  }
  
  void shoot()
  {
    if(millis() - lastFireTime > shotDelay)
    {
      PVector bulletSpeed = PVector.sub(targetPosition, myPosition);
      PVector bulletPosition = myPosition;
      bulletSpeed.setMag(myRadius / 2);
      bulletPosition = PVector.add(myPosition, bulletSpeed);
      
      bulletSpeed.setMag(maxBulletSpeed);
      myBullets.add(new Bullet(bulletPosition, bulletSpeed, myGridController, enemies));
      lastFireTime = millis();
    }
  }
  
  void updateBullets()
  { 
    for(int i = 0; i < myBullets.size(); i++)
    {
      Bullet b = myBullets.get(i);
      b.mainUpdate();
    }  
  }
  
  void clearBullets()
  {
    for(int i = 0; i < myBullets.size(); i++)
    {
      Bullet b = myBullets.get(i);
      if(b.isDead) myBullets.remove(i);
    }  
  }
  
  
  void updateTarget()
  {
    smallestDistance = 2000;
    
    if(enemies.size() > 0)
    {
      attacking = true;
      
      for(int i = 0; i < enemies.size(); i++)
      {
        distanceToTarget = mag(myPosition.x - enemies.get(i).myPosition.x, myPosition.y - enemies.get(i).myPosition.y);
        if(distanceToTarget < smallestDistance)
        {
          smallestDistance = distanceToTarget;
          closestIndex = i;
        }
      }
      targetPosition = enemies.get(closestIndex).myPosition.copy();
    }
    else
    {
      attacking = false;
      //targetPosition = new PVector( myGridController.leftBound + gridLengthX / 2f, 
      //                                myGridController.topBound + gridLengthY / 2f);
    }
  }
  
  
  void spreadOut()
  {
    for(int i = friends.size() - 1; i >= 0; i--)
    {
      PVector distance = PVector.sub(myPosition, friends.get(i).myPosition);
      if(distance.mag() < 15)
      {
        distance.normalize();
        distance.mult(.6);
        addForce(distance);
      }    
      
      if(15 <= distance.mag())
      {
        if(int(random(0, 6)) == 0) 
        {
          float changeX = (myGridController.rightBound - myGridController.leftBound) / 30f; 
          float changeY = (myGridController.bottomBound - myGridController.topBound) / 30f; 
          targetPosition = new PVector(targetPosition.x + random(-changeX, changeX), targetPosition.y + random(-changeY, changeY));
        }
        
        if(int(random(0, 100)) == 0) 
        {
        PVector randVector = new PVector(random(myGridController.leftBound + 10, myGridController.rightBound - 10),
                                   random(myGridController.topBound + 10, myGridController.bottomBound - 10));
        targetPosition = randVector;
        }
      }
    }  
  }
  
  
  void takeDamage(float damage)
  {
    health -= damage;
    if(health <= 0)
    {
      isDead = true;
    }
  }
  
  void addForce(PVector force)
  {
    myAcceleration.add(force);
  }
  
  boolean isDead()
  {
    if(isDead) return true;
    else return false;
  }
  
  void display()
  {
    if(owner == RED) fill(255, 0, 0);
    if(owner == GREEN) fill(0, 255, 0);
    if(owner == BLUE) fill(0, 0, 255);
    if(owner == PURPLE) fill(186, 85, 211);
    ellipse(myPosition.x, myPosition.y, myRadius, myRadius);  
  }
}