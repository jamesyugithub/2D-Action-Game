/** //<>//
 * CGRA 151 Final Project
 * Name: Zhenchuan (James) Yu, ID: 300489509, Username: yuzhen1
 */

PImage[] BG = new PImage[11];
PImage menuBG = new PImage();
float[] bgx, bgy;
float BACKGROUND_OFFSET = 330;
float[] layerVel = new float[11];
float cameraXpos, cameraYpos;
float cameraXvel, cameraYvel;

int level = 1;

int GROUND = 362;
int SCENE_SIZE = 800;

PImage heart = new PImage();

int finalScore = 0;
int numEnemy = 0;
int score = 0;

Sprite mainPlayer;
ArrayList<Skeleton> monsters = new ArrayList<Skeleton>();

boolean [] keyHeldDown = new boolean[255];
boolean start = false;
boolean gameover = false;

void setup()
{
  frameRate(60);
  size(800, 450, P2D); 

  menuBG = loadImage("./img/background.png");
  heart = loadImage("./img/items/heart.png"); // https://itch.io/game-assets/free


  float j = 3.3;
  for (int i = 0; i < 11; i++)
  {
    BG[i] = loadImage("./img/background/Layer_" + i + ".png");
    layerVel[i] = j - 0.3*i;
  }

  mainPlayer = new Sprite(100, GROUND);
  reset();
}

/**
 * Main draw method 
 */
void draw()
{
  if (keyHeldDown[ENTER])
  {
    start = true;
  }

  if (!start)
  { /* draw menu window */
    startWindow();
    return;
  }

  if (keyHeldDown['P'])
  {
    println("Player: " + mainPlayer.x + "   " + "Enemy: " + monsters.get(0).compX);
  }

  if (keyHeldDown['O'])
  {
    level = 1;
    reset();
    mainPlayer.resetPlayer(100, GROUND);
    start = false;
    gameover = false;
  }

  /* BACKGROUND DRAWING */
  for (int i = 10; i >= 2; i--)
  {
    image(BG[i], bgx[i], bgy[i] - BACKGROUND_OFFSET);
    image(BG[i], bgx[i] + BG[i].width, bgy[i] - BACKGROUND_OFFSET);
  }
  /* BACKGROUND SCROLLING */
  if (!mainPlayer.attack || (mainPlayer.attack && !mainPlayer.onGround)) 
  {
    for (int i = 10; i >= 0; i--)
    {
      if (mainPlayer.x >= width/2 && mainPlayer.facingDirection == RIGHT && keyHeldDown['D'])
      {
        if (bgx[1] < -800) continue;
        bgx[i] -= layerVel[i];
      } else if (mainPlayer.x <= width/2 && mainPlayer.facingDirection == LEFT && keyHeldDown['A'])
      {
        bgx[i] += layerVel[i];
        if (bgx[i] > 0) bgx[i] = 0;
      }
      if (bgx[i] < -BG[i].width)
      {
        bgx[i] = 0;
      }
    }
  }

  /* JUMP */
  if (keyHeldDown['W'] || keyHeldDown[' '])
  {
    mainPlayer.jump();
  }

  if (finalScore==0) 
  {
    mainPlayer.update();
    mainPlayer.display();
  }

  /* Display the monsters */
  int enemyNumCount = 0;
  for (Skeleton s : monsters)
  {
    if (s.out) continue;
    s.update(bgx[1]);
    s.display();
    if (!s.dead) enemyNumCount++;
  }
  numEnemy = enemyNumCount;

  /* FOREGROUND DRAWING */
  for (int i = 1; i >= 0; i--)
  {
    image(BG[i], bgx[i], bgy[i] - BACKGROUND_OFFSET);
    image(BG[i], bgx[i] + BG[i].width, bgy[i] - BACKGROUND_OFFSET);
  }

  if (numEnemy == 0)
  {
    level++;
    mainPlayer.resetPlayer(100, GROUND);
    reset();
  }

  drawUI();
  if (gameover)
  {
    textAlign(CENTER, CENTER);
    textSize(20); 
    text("Press 'O' to re-start the game ", width/2, height/2);
  }
  //rect(mainPlayer.x, 300, 50, 37);
  //for (Skeleton s : monsters)
  //{
  //rect(s.compX, 300, 22, 37);
  //}
}

/**
 * reset the game
 */
void reset()
{
  bgx = new float[11]; 
  bgy = new float[11];
  monsters.clear();
  for (int i=0; i<level*5; i++)
  {
    monsters.add(new Skeleton((int)random(300, 700), GROUND+2));
    //monsters.add(new Skeleton(350, GROUND+2));
  }
}

/*******************************   UI and Starting window   *******************************/

/**
 * Draw the manual window
 */
void drawUI()
{
  textAlign(CENTER, CENTER);
  textSize(15); 
  //text("Score: " + finalScore, width/2, 30);
  text("Level: " + level, width/2, 30);
  for (int i=0; i<mainPlayer.health; i++)
  {
    image(heart, 30+20*i, 30);
  }

  textAlign(RIGHT, CENTER);
  textSize(15); 
  text("Enemies: " + numEnemy, width-30, 30);
}

/**
 * Draw the manual window
 */
void startWindow()
{
  pushMatrix();
  scale(1.5, 1.5);
  translate(0, -200);
  image(menuBG, 0, 0);
  popMatrix();
  //if (alp <= 0) start = true;
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(20); 
  text("Press ENTER to start the game ", width/2, height*4/5);
  textAlign(LEFT, CENTER);
  textSize(15);
  text("A/D: Move to left or right", width/5, height*1/5);
  text("SPACE: Jump", width*3/5, height*1/5);
  image(mainPlayer.atcLight.skill.images[2], width/5-80, height*2/5-30);
  image(mainPlayer.atcHeavy.skill.images[3], width/5+120, height*2/5-30);
  image(mainPlayer.atcRange.skill.images[2], width/5+340, height*2/5-30);
  image(mainPlayer.jump.images[3], width/5-80, height*2/5+40);
  image(mainPlayer.airAttackLoop.images[0], width/5+120, height*2/5+40);
  text("Light Strike", width/5-10, height*2/5-15);
  text("Heavy Strike", width/5+190, height*2/5-15);
  text("Range Strike", width/5+410, height*2/5-15);
  textSize(12);
  text("1st Click", width/5-10, height*2/5);
  text("2nd Click", width/5+190, height*2/5);
  text("3rd Click", width/5+410, height*2/5);
  textSize(15);
  text("Double Jump", width/5-10, height*2/5+55);
  text("Air Strike", width/5+190, height*2/5+55);
  textSize(12);
  text("Right Button while jumping", width/5+190, height*2/5+75);
  text("SPACE while jumping", width/5-10, height*2/5+75);
}

/*******************************   Mouse and keyboard events   *******************************/

/**
 * Response when mouse button clicked
 */
void mouseClicked()
{
  if (start)
  {
    if (mouseButton == LEFT)
    {
      mainPlayer.attack(LEFT);
    }
    if (mouseButton == RIGHT)
    {
      mainPlayer.attack(RIGHT);
    }
  }
}

/**
 * Response when key pressed
 */
void keyPressed()
{
  keyHeldDown[keyCode] = true;
}

/**
 * Response when key released
 */
void keyReleased()
{
  keyHeldDown[keyCode] = false;
}
