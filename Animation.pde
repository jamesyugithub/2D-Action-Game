/** //<>//
 * Animation class, play the animation for characters and skills
 */
class Animation 
{
  String name;
  int offsetX, offsetY;
  PImage[] images; //Sequence
  PImage imageSheet; //Sheet
  int imageCount; //Number of the action
  int frame_loop; //index of the frame for looping animation
  int frame_single; //index of the frame for single animation
  int speed; //display speed
  int imgWidth; //single action's width
  int imgHeight;
  boolean isSheet;
  boolean isLoop;
  boolean isSkill;

  /* 
   * Constructor:
   *   Parameters: 
   *     imagePrefix: First part of the path, imageSuffix: second part of the path
   *     count: number of the sequence, spd: display speed
   *     sheet: using sheet or sequence, loop: is a loop or single animation, skill: is a skill or not (damage check)    
   */
  Animation(String nam, String imagePrefix, String imageSuffix, int count, int spd, boolean sheet, boolean loop, boolean skill)
  {
    name = nam;
    if (sheet)
    {
      if (nam.equals("die")) 
      { 
        offsetX = 0; 
        offsetY = 2;
      } 
      /* if using sheet of hurt */
      else if (nam.equals("hurt")) 
      { 
        offsetX = 0; 
        offsetY = 2;
      }
      else if(nam.equals("attack"))
      {
        offsetX = 4;
        offsetY = -4; 
      }
    }

    frame_loop = (int)random(1, count - 2);
    imageCount = count;
    speed = spd;
    isSheet = sheet;
    isLoop = loop;
    isSkill = skill;

    /* if using sheet */
    if (sheet) { 
      imageSheet = new PImage();
      String fileName = imagePrefix + imageSuffix;
      imageSheet = loadImage(fileName);
      imgWidth = imageSheet.width/count; //use lenght of the whole sheet divide by the number of the number of the action
      imgHeight = imageSheet.height;
    } 
    /* if using sequence */
    else {
      images = new PImage[imageCount];
      for (int i = 0; i < imageCount; i++) {
        String fileName = imagePrefix + i + imageSuffix;
        images[i] = loadImage(fileName);
      }
      imgWidth = images[0].width;
      imgHeight = images[0].height;
    }
  }

  /**
   * display the animation for both sheet and sequence
   */
  void display(float xpos, float ypos, int dir)
  { /* Using sheet */
    if (isSheet) 
    { /* Is a loop */
      if (isLoop) 
      { /* every ? frame change the index */
        if (frameCount % speed == 0)
        {
          frame_loop= (frame_loop + 1) % imageCount;
        }
        /* Draw sheet if it's facing right */
        if (dir == RIGHT)
        {
          copy(imageSheet, frame_loop * imgWidth, 0, imgWidth, imgHeight, (int)xpos, (int)ypos, imgWidth, imgHeight);
        } 
        /* otherwise draw sheet that is facing left */
        else 
        {
          copy(imageSheet, frame_loop * imgWidth, 0, imgWidth, imgHeight, (int)xpos+22, (int)ypos, -imgWidth, imgHeight);//11
        }
      } else //is a single animation
      {
        if (frame_single < imageCount - 1 && frameCount % speed == 0)
        {
          frame_single = (frame_single + 1) % imageCount;
        }
        if (dir == RIGHT)
        {
          copy(imageSheet, frame_single * imgWidth, 0, imgWidth, imgHeight, (int)xpos-offsetX, (int)ypos+offsetY, imgWidth, imgHeight);
        } else 
        {
          copy(imageSheet, frame_single * imgWidth, 0, imgWidth, imgHeight, (int)xpos+22+offsetX, (int)ypos+offsetY, -imgWidth, imgHeight);
        }
      }
    } 
    /* Using sequence */
    else 
    { /* Is a loop */
      if (isLoop) 
      { /* every ? frame change the index */
        if (frameCount % speed == 0)
        {
          frame_loop = (frame_loop + 1) % imageCount;
        }
        /* draw the sequence facing right */
        if (dir == RIGHT)
        {
          image(images[frame_loop], xpos, ypos); //make xpos center, images[].width is 50
        } 
        /* otherwise draw the sequence facing left */
        else 
        {
          pushMatrix();
          translate(images[0].width, 0);
          scale(-1, 1);
          image(images[frame_loop], -xpos, ypos); //make xpos center
          popMatrix();
        }
      } 
      /* If is a one time animation */
      else 
      {
        if (frame_single < imageCount - 1 && frameCount % speed == 0) //Check the animation is over or not
        {
          frame_single = (frame_single + 1) % imageCount;
          if (frame_single == imageCount - 2 && isSkill) //ATTACK      -2?
          {
            mainPlayer.skillDone = true;
          } else
          {
            mainPlayer.skillDone = false;
          }
        }

        if (dir == RIGHT) //Direction check
        {
          image(images[frame_single], xpos, ypos);
        } else 
        {
          pushMatrix();
          translate(images[0].width, 0);
          scale(-1, 1);
          image(images[frame_single], -xpos, ypos);
          popMatrix();
        }
      }
    }
  }

  /**
   * for check if the skill is cast or not
   */
  void timer()
  {
    if (frame_single < imageCount - 1 && frameCount % speed == 0)
    {
      frame_single = (frame_single + 1) % imageCount;
      if (frame_single == imageCount - 1)   
      {
        mainPlayer.smrslting = false;
      } else
      {
        mainPlayer.smrslting = true;
      }
    }
  }

  /**
   * reset the frame of the animation (for single play)
   */
  void reset()
  {
    frame_single=0;
  }
}
