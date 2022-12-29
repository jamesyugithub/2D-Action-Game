/** //<>//
 * Main hero class, create the main hero
 */

boolean movingLeftOrRight = false;

class Sprite
{
  float x, y, tempXOnStart, tempXOnEnd; //x is image's left, but wider
  float xvel, yvel;
  int facingDirection;
  float l, r;

  int livingState;
  int health;
  float timerHit = 1;
  boolean attack, attackDown, isHurt, dead;
  boolean skillDone;
  boolean onGround, floating, smrslting, falling;

  ArrayList<Attack> attackList = new ArrayList<Attack>();
  ArrayList<Attack> attackAirList = new ArrayList<Attack>();

  Animation idleAnimation, run, die, hurt;
  Animation jump, smrslt, fall;
  Animation airAttackLoop;
  Attack atcLight, atcHeavy, atcRange;
  Attack atcAirLight, atcAirHeavy;
  Attack atcAirDown, atcAirGround;
  Attack currentAtc;

  /**
   * Constructor
   */
  Sprite(int x, int y)
  { /* name | pathA | pathB | Frame Number | Speed | sheet or not | loop or not | skill or not */

    idleAnimation = new Animation("idle", "./img/sprites/adventurer-idle-0", ".png", 4, 12, false, true, false); 
    run = new Animation("run", "./img/sprites/adventurer-run-0", ".png", 6, 6, false, true, false);
    fall = new Animation("fall", "./img/sprites/adventurer-fall-0", ".png", 2, 4, false, true, false);
    jump = new Animation("jump", "./img/sprites/adventurer-jump-0", ".png", 4, 20, false, false, false);
    smrslt = new Animation("smrslt", "./img/sprites/adventurer-smrslt-0", ".png", 4, 10, false, false, false);
    airAttackLoop = new Animation("airAtcLop", "./img/sprites/adventurer-air-attack-loop-0", ".png", 2, 4, false, false, true);
    die = new Animation("die", "./img/sprites/adventurer-die-0", ".png", 7, 14, false, false, false);
    hurt = new Animation("dhurt", "./img/sprites/adventurer-hurt-0", ".png", 3, 6, false, false, false);
                          /* type */
    atcLight = new Attack("light");
    atcHeavy = new Attack("heavy");
    atcRange = new Attack("range");
                              /* type */
    atcAirLight = new Attack("airLight");
    atcAirHeavy = new Attack("airHeavy");
    atcAirDown = new Attack("airDown");
    atcAirGround = new Attack("airGround");

    attackAirList.add(atcAirLight);
    attackAirList.add(atcAirHeavy);
    attackList.add(atcLight);
    attackList.add(atcHeavy);
    attackList.add(atcRange);

    resetPlayer(x, y);
  }

  /**
   * Called when reset the level 
   */
  void resetPlayer(int x1, int y1)
  {
    x = x1; 
    y = y1;
    l =x;
    r=x+50;

    tempXOnStart = x1;
    xvel = 0;
    yvel = 0;
    onGround = true;
    livingState = 0;
    health = 5;
    attack=false; attackDown=false; isHurt=false; dead=false;
    facingDirection = RIGHT;
  }

  /**
   * update the left and right bound of the hero
   */
  void updateBox(float x)
  {
    l = x;
    r = x+50;
  }

  /**
   * Called by clicking mouse button, 3 types cast with order
   */
  void attack(int button)
  {
    if (button == LEFT)
    {
      if (!onGround)
      {
        currentAtc = attackAirList.get(0);
        attackAirList.remove(0);
        attackAirList.add(currentAtc);
      } else
      {
        currentAtc = attackList.get(0);
        attackList.remove(0);
        attackList.add(currentAtc);
      }
    } else if (button == RIGHT)
    {
      if (!onGround) 
      {
        currentAtc = atcAirDown;
        attackDown = true;
      } else
      {
        return;
      }
    }
    attack = true;
  }
  
  /**
   * Jump method 
   */
  void jump()
  {

    if (yvel == 0 && onGround)
    {   
      attackDown = false;
      yvel = 6;
      onGround = false;
      floating=true;
    }
    /* double jump */
    if (floating && yvel <= 3)
    {
      yvel = 6;
      floating = false;
      smrslting = true;
      falling = true;
    }
  }
  
  /**
   * update the data
   */
  void update()
  {
    if (health <= 0)
    {
      dead = true;
      gameover = true;
      return;
    }

    movingLeftOrRight = false;
    
    if (keyHeldDown['A'])
    {
      xvel = -3;
      if (!attack && !isHurt) facingDirection = LEFT; //Update direction
      movingLeftOrRight = true;
    }
    if (keyHeldDown['D'])
    {
      xvel = 3;
      if (!attack && !isHurt) facingDirection = RIGHT; //Update direction
      movingLeftOrRight = true;
    }
    if (movingLeftOrRight==false)
    {
      xvel *= 0.6; //decrease vel when release key
    }

    /*** JUMP SECTION ***/
    if (!onGround)
    {
      yvel -= 0.2;
      if (y > GROUND )
      {
        yvel = 0;
        y = GROUND ;
        onGround = true;
        attack = false;
        floating = false;
        smrslting = false;
        falling = false;
      }
    }
    
    /*** SMRSLT SECTION ***/
    if (smrslting) smrslt.timer();

    /*** ATTACK SEDTION ***/
    if (attack && currentAtc != null)
    {
      attack = currentAtc.timer();
    }
    /*** AIR ATTACK SECTION ***/
    if (onGround && attackDown)
    {
      attackDown = currentAtc.timer();
    }
    
    /*** UPDATE X VALUE ***/
    if ((!attack || (attack && !onGround)) && !isHurt) 
    {
      x += xvel; 
      tempXOnStart += xvel;
      updateBox(x);
    }
    
    /*** CORRESPOND WITH BACKGROUND SCROLL ***/
    if (bgx[1] > -800 && facingDirection == RIGHT) 
    {
      tempXOnEnd = width/2;
    } else if (bgx[1] <= -800 && facingDirection == RIGHT)
    {
      if (!attack || (attack && !onGround))  tempXOnEnd += xvel;
    } else if (bgx[1] <= -800 && facingDirection == LEFT)
    {
      if (!attack || (attack && !onGround))  tempXOnEnd += xvel;
    }
    /* in the middle */
    if (x > width/2 && facingDirection == RIGHT || x <= width/2 && facingDirection == LEFT)
    {

      if (bgx[10] >= 0 && facingDirection == LEFT)  //on most left
      {
        //do nothing
      } else if (bgx[1] <= -800 && facingDirection == RIGHT) //on most right
      { 
        x = tempXOnEnd;
      } else {
        x =width/2;
      }
    } else if (x > width/2 && facingDirection == LEFT)
    {
      x = tempXOnEnd;
    }

    if (x < 0 && facingDirection == LEFT) 
    {
      x = 0; 
      tempXOnStart = 0;
    }
    if (x > width - 50 && facingDirection == RIGHT) 
    {
      x = width - 50; 
      tempXOnStart = SCENE_SIZE - 50;
      tempXOnEnd = width - 50;
    }

    y -= yvel; //UPDATE Y
  }

  /**
   * draw the hero
   */
  void display()
  {
    if (dead)
    {
      die.display(x, y, facingDirection);
    } else
    {
      if (isHurt)
      {
        hurt.display(x, y, facingDirection);
        timerHit -= 0.03;
        if (timerHit <= 0)
        {
          isHurt = false;
          timerHit = 1;
        }
      } else
      {
        if (!onGround)
        {
          if (attack)
          {
            currentAtc.display(x, y, facingDirection);
          } else
          {
            if (attackDown)
            {
              airAttackLoop.display(x, y, facingDirection);
            } else
            {
              if (smrslting)
              {
                smrslt.display(x, y, facingDirection);
              } else if (falling)
              {
                fall.display(x, y, facingDirection);
              } else
              {
                jump.display(x, y, facingDirection);
              }
            }
          }
        } else {
          if (attackDown)
          {
            atcAirGround.display(x, y, facingDirection);
            if (skillDone)
            {
              atcAirGround.update();
            }
          } else if (attack && currentAtc != null)
          {
            currentAtc.display(x, y, facingDirection);

            /* Damage Check */
            if (skillDone)
            {
              currentAtc.update();
            }
          } else
          {
            if (movingLeftOrRight)
            {
              run.display(x, y, facingDirection);
            } else
            {
              idleAnimation.display(x, y, facingDirection);
            }
            jump.reset();
            smrslt.reset();
            atcLight.reset();
            atcHeavy.reset();
            atcRange.reset();
            atcAirLight.reset();
            atcAirHeavy.reset();
            atcAirDown.reset();
            atcAirGround.reset();
            hurt.reset();
            die.reset();
          }
        }
        
      }
      
    }
    skillDone = false;
  }
}
