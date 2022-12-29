/** //<>//
 * The skill class
 */
class Attack //<>//
{
  String type;
  boolean range;
  boolean air;
  float distance;
  int damage;
  float time, dt = 0.01;
  Animation skill;
  
  /* constructor */
  Attack(String typ)
  {
    if (typ.equals("light")) 
    { /* name | pathA | pathB | Frame Number | Speed | sheet or not | loop or not | skill or not */
      skill = new Animation(typ, "./img/sprites/adventurer-attack1-0", ".png", 5, 6, false, false, true); //0.5s
      /* range | air | damage | time */
      setSkill("light", false, false, 16, 1, 0.3);
    } else if (typ.equals("heavy"))
    {
      skill = new Animation(typ, "./img/sprites/adventurer-attack2-0", ".png", 6, 10, false, false, true); //1s
      setSkill("heavy", false, false, 18, 2, 0.6);
    } else if (typ.equals("range"))
    {
      skill = new Animation(typ, "./img/sprites/adventurer-attack3-0", ".png", 6, 8, false, false, true); //0.8s
      setSkill("range", true, false, 20, 1, 0.48);
    } else if (typ.equals("airLight"))
    {
      skill = new Animation(typ, "./img/sprites/adventurer-air-attack2-0", ".png", 3, 6, false, false, true); //0.3s
      setSkill("airLight", false, true, 15, 1, 0.18);
    } else if (typ.equals("airHeavy"))
    {
      skill = new Animation(typ, "./img/sprites/adventurer-air-attack1-0", ".png", 4, 6, false, false, true);//0.4s
      setSkill("airHeavy", false, true, 15, 2, 0.24);
    } else if (typ.equals("airDown"))
    {
      skill = new Animation(typ, "./img/sprites/adventurer-air-attack-down-0", ".png", 1, 6, false, false, true);//0.1s
      setSkill("airDown", false, true, 20, 2, 0.06);
    } else if (typ.equals("airGround"))
    {
      skill = new Animation(typ, "./img/sprites/adventurer-air-attack3-0", ".png", 3, 10, false, false, true); //0.5
      setSkill("airGround", true, false, 22, 3, 0.3);
    }
  }
  
  /**
   * Called inside the constructor
   */
  void setSkill(String typ, boolean rang, boolean ai, int dist, int dama, float tim)
  {
    type = typ;
    range = rang;
    air = ai;
    distance = dist;
    damage = dama;
    time = tim;
  }

  /**
   * calculate the cooldown of skills
   */
  boolean timer()
  {
    time -= dt;

    if (time <= 0 )
    {      
      if (type.equals("light")) time = 0.3;
      if (type.equals("heavy")) time = 0.6;
      if (type.equals("range")) time = 0.48;
      if (type.equals("airLight")) time = 0.18;
      if (type.equals("airHeavy")) time = 0.24;
      if (type.equals("airDown")) time = 0.06;
      if (type.equals("airGround")) time = 0.3;
      return false;
    }
    return true;
  }

  /**
   * check if the monsters is in the range or not
   */
  boolean inRange(Sprite p, Skeleton s)
  {
    float playerCentre = p.x + 25; //25 is player's image.width //<>//
    float playerL = playerCentre - distance; 
    float playerR = playerCentre + distance; 
    float monsterCentre = s.compX + 11;
    float monsterL = s.l;
    float monsterR = s.r;
    if (range)
    {

      if (monsterCentre >= playerL && monsterCentre <= playerR) 
      {
        return true;
      }
    } else if (!range)
    {
      //println("Player: " + (p.x + 25)+ "   " + "MonsterL: " + s.l + "   " + "MonsterR: " + s.r + "   " + "Range: " + distance);
      if (p.facingDirection == RIGHT && (monsterL >= playerCentre && monsterL <= playerCentre + distance)) 
      {
        //println("Player: " + (p.x + 25)+ "   " + "Monster: " + s.l + "   " + "Range: " + distance);
        return true;
      }
      if (p.facingDirection == LEFT && (monsterR >= playerCentre - distance && monsterR <= playerCentre)) 
      {
        //println("Player: " + (p.x + 25)+ "   " + "Monster: " + s.r + "   " + "Range: " + distance);
        return true;
      }
    }
    return false;
  }

  /**
   * update the values
   */
  void update()
  {
    for (Skeleton s : monsters)
    {
      if (!s.dead)
      {
        if (range)
        {
          if (inRange(mainPlayer, s))
          {
            s.hit = true;
            s.health -= damage;
            //println("hit");
          } else
          {
          }
        } else
        {
          if (inRange(mainPlayer, s))
          {

            s.hit = true;
            s.health -= damage;
            //println("hit");
          } else
          {
          }
        }
      }
    }
  }
  
  /**
   * call animation class
   */
  void display(float x, float y, int dir)
  {
    skill.display(x, y, dir);
  }
  
  /**
   * return the type of the skill
   */
  String getType()
  {
    return type;
  }
  
  /**
   * call the reset() method in animation class
   */
  void reset()
  {
    skill.reset();
  }
}
