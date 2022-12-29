/** //<>//
 * The monster class
 */
class Skeleton
{
  float bgx;
  float compX;
  float x, y;
  float l, r;
  int facingDirection;
  float xvel, yvel;
  boolean attackP1, skillDone, attackP2;
  boolean hit;
  boolean dead;
  boolean out;
  float timerAttack = 1.62;
  int distance = 40;
  float timerDead = 3;
  float timerHit = 1;
  boolean onGround;

  int health;

  Animation walkAnimation;
  Animation atc;
  Animation die, hurt;

  /* Constructor */
  Skeleton(int x1, int y1)
  {
    reset(x1, y1);
    walkAnimation = new Animation("walk", "./img/sprites/skeleton-walk", ".png", 13, 10, true, true, false);
    atc = new Animation("attack", "./img/sprites/skeleton-attack", ".png", 18, 9, true, false, true); //2.7s
    die = new Animation("die", "./img/sprites/skeleton-dead", ".png", 15, 10, true, false, false);
    hurt = new Animation("hurt", "./img/sprites/skeleton-hurt", ".png", 8, 8, true, false, false);
  }
  
  /**
   * called when reset the game 
   */
  void reset(int x1, int y1)
  {
    x = x1; 
    y = y1;
    l = compX;
    r=l+22;
    xvel = random(0.05, 0.2);
    yvel = 0;
    onGround = true;
    health = 2;
    facingDirection = LEFT;
    attackP1 = false;
    hit = false;
  }
  
  /**
   * update the left and right bound
   */
  void updateBox()
  {
    l=compX;
    r=compX+22;
  }

  /**
   * called when the hero in the range
   */
  void attack()
  {
    attackP1 = true;
    attackP2= true;
    skillDone = false;
  }

  /**
   * update the data
   */
  void update(float px)
  {
    if (mainPlayer.dead)
    {
      return;
    }
    if (inRange(mainPlayer) && !attackP1)
    {
      attack();
    }

    if (attackP1) 
    {
      timerAttack -= 0.01;

      if (timerAttack < 0)
      {
        timerAttack = 1.62;
        attackP1 = false;
      }
      if (timerAttack < 1 && !skillDone && attackP2)
      {
        skillDone = true; 
        attackP2=false;
      }
    }

    if (inRange(mainPlayer)  && !dead && skillDone && (timerAttack < 1 && timerAttack > 0.8))
    {
      mainPlayer.isHurt = true;
      mainPlayer.health -= 1;
      skillDone = false;
    }

    bgx = px;

    if (health <= 0)
    {
      dead = true;
      attackP1 = false;
    }
  }

  /**
   * check whether the hero is in the range
   */
  boolean inRange(Sprite p)
  {
    float monsterCentre = compX + 11; //11 is monster's image.width
    float playerCentre = p.x + 25;
    float absDist = abs(monsterCentre - playerCentre);
    //println("monster: " + monsterCentre + "   " + "PlayerL: " + p.l + "   " + "PlayerR: " + p.r + "   " + "Range: " + distance);
    if (facingDirection == RIGHT && absDist <= distance && mainPlayer.onGround)
    {
      return true;
    }
    if (facingDirection == LEFT && absDist <= distance && mainPlayer.onGround) 
    {
      return true;
    }
    return false;
  }

  /**
   * draw the skeletons
   */
  void display()
  {
    updateBox();
    if (dead)
    {
      timerDead -= 0.01;
      compX = bgx + x;
      die.display(compX, y, facingDirection);
      if (timerDead <= 0)
      {
        out = true;
        timerDead = 3;
      }
    } else
    {
      if (hit)
      {
        timerHit -= 0.03;
        compX = bgx + x;
        hurt.display(compX, y, facingDirection);
        if (timerHit <= 0)
        {
          hit = false;
          timerHit = 1;
        }
      } else
      {
        if (!attackP1)
        {
          if (mainPlayer.x +27 < compX)
          { //<>//
            x -= xvel;
            facingDirection = LEFT;
            compX = bgx + x;
            walkAnimation.display(compX, y, facingDirection);
          } else if (mainPlayer.x > compX)
          {
            x += xvel; 
            facingDirection = RIGHT;
            compX = bgx + x; 
            walkAnimation.display(compX, y, facingDirection);
          } else
          {
            compX = bgx + x; 
            walkAnimation.display(compX, y, facingDirection);
          }
          atc.reset();
          //deadAnimation.reset();
        } else
        {
          if (mainPlayer.x < compX)
          {
            facingDirection = LEFT;
            compX = bgx + x;
            atc.display(compX, y, facingDirection);
          } else if (mainPlayer.x - 50 > compX)
          {
            facingDirection = RIGHT;
            compX = bgx + x;
            atc.display(compX, y, facingDirection);
          } else
          {
            compX = bgx + x;
            atc.display(compX, y, facingDirection);
          }
        }
      }
    }
  }
}
