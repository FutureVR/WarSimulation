class Bullet
{
  // Editable Values
  float bulletDiameter = 4;
  float bulletDamage = 6;
  int borderCheck = 100;
  
  // Non-Editable Values
  PVector myPosition;
  PVector myVelocity;
  boolean isDead = false;
  ArrayList<Soldier> soldiers = new ArrayList<Soldier>();
  GridController myGridController;
  
  
  Bullet(PVector p, PVector v, GridController gc, ArrayList<Soldier> s)
  {
    myPosition = p.copy();  
    myVelocity = v.copy();
    soldiers = s;
    myGridController = gc;
  }
  
  
  void mainUpdate()
  {
    move();
    checkHit();
    checkBounds();
    display();
  }
  
  void move()
  {
     myPosition.add(myVelocity);
  }
  
  void checkHit()
  { 
    for(int i = soldiers.size() - 1; i >= 0; i--)
    {  
      float heroRadius = soldiers.get(i).myRadius / 2;
      float heroX = soldiers.get(i).myPosition.x;
      float heroY = soldiers.get(i).myPosition.y;
      
      if(myPosition.x > heroX - heroRadius && myPosition.x < heroX + heroRadius &&
          myPosition.y > heroY - heroRadius && myPosition.y < heroY + heroRadius)
      {
        isDead = true;
        soldiers.get(i).takeDamage(bulletDamage);
        break;
      }
    }
  }
  
  void checkBounds()
  {
    if(myPosition.x > myGridController.rightBound + borderCheck && myVelocity.x > 0) isDead = true;
    if(myPosition.x < myGridController.leftBound - borderCheck && myVelocity.x < 0) isDead = true;
    if(myPosition.y > myGridController.bottomBound + borderCheck && myVelocity.y > 0) isDead = true;
    if(myPosition.y < myGridController.topBound - borderCheck && myVelocity.y < 0) isDead = true;
  }
  
  void display()
  {
    fill(255, 204, 0);
    ellipse(myPosition.x, myPosition.y, bulletDiameter, bulletDiameter);
  }
  
  boolean isDead()
  {
    if(isDead) return true;
    else return false;
  }
}