// Brendan Leder

/*
 * Global variables – accessible in any function below.
 */

int high1;
int high2;
int high3;

char letter;
String line;

float r = 100;
float g = 10;
float b = 1;
int rflip = 1;
int gflip = 1;
int bflip = 1;

boolean lose;

boolean pause;
int pauseTimer;

int lives = 3;


int red=255;
int green=255;
int blue=255;

int hit = 255;

int canShoot;

int timer=0;

boolean reset = false;

float exp = 0;
int level = 1;
float lvlup = 50;

float x = 0; // Horizontal position of target
float y = 0; // Vertical position of target
float ySpeed = 0;  // Vertical speed of target
float diameter = 0;  // Size of target
float score = 0;       // Keeps track of score

/*
 * This function runs once, unless explicitly invoked elsewhere.
 */
void setup() {

  red=255;
  green=255;
  blue=255;
  lives = 5;
  // Create a canvas with white background
  size(600, 700);
  background(255);
  stroke(0);

  // Set game initial values
  // (int) casts, or forces, non-integer results to become integers 
  y = 0 - diameter / 2;       // Target starts just off of top of screen
  ySpeed = random(1, 10);     // Speed varies
  diameter = random(25, 50);  // Diameter varies
  x = random(0+diameter/2, width-diameter/2);       // Horizontal position changes
  score = 0;                  // Score begins at zero
  fill(0);                    // Black fill for target
  canShoot = 0;
  exp = 0;
  level = 1;
  lvlup = 50;
  hit = 0;
  lose = false;
  pause = false;
  pauseTimer =  0;

  // Show values to illustrate how game works
  println("Horizontal position is: " + x);
  println("Vertical position is: " + y);
  println("Vertical speed is: " + ySpeed);
  println("Size of target is: " + diameter);
  println("Score is: " + score);
}

/*
 * This function runs repeatedly.
 */
void draw() {

 

  if (lives > 10) {
    lives = 10;
  }

  if (pauseTimer > 0) {
    pauseTimer -= 1;
  }

  if (pause == false) {

    if (reset == true) {
      exp -= lvlup/40;
      if (exp <= 0) {
        reset = false; 
        exp = 0;
      }
    }
     if (lose == false) {

    r += random(3, 5) * rflip;
    g += random(3, 5) * gflip;
    b += random(3, 5) * bflip;

    if (r < 0 || r > 255) {
      if (r < 0) {
        r = 1;
      } else {
        r=254;
      }
      rflip = rflip * -1;
    }


    if (g < 0 || g > 255) {

      if (g < 0) {
        g = 1;
      } else {
        g=254;
      }
      gflip = gflip * -1;
    }
    if (keyPressed && pauseTimer == 0) {
      if (key == ' ') {
        pause = true; 
        pauseTimer = 10;
      }
    }

    if (b < 0 || b > 255) {
      if (b < 0) {
        b = 1;
      } else {
        b=254;
      }
      bflip =bflip* -1;
    }

    // Clear prior screen
    background(red, green-hit, blue-hit);

    if (hit >= 1) {
      hit -=7;
    }

    if (canShoot >= 1) {
      canShoot -= 1;
    }

    if (timer > 1) {
      timer -= 1;
      textSize(60);
      fill(200, 200, 0, timer * 4);
      text("LEVEL UP", width/2, height/2);
    }

    if (sqrt(((x-mouseX)*(x-mouseX)) + ((y-mouseY) * (y-mouseY))) <= diameter/2 && mousePressed && canShoot <= 0) {
      y = 0 - diameter/2; 
      x = random(0+diameter/2, width-diameter/2);
      score+=level + 10 + 3*ySpeed - int(diameter)/4;
      exp+= level + 10 + 3*ySpeed - int(diameter)/4;
      ySpeed = random(1, 5) + level/3;
      diameter = random(25, 50) + 2*level;
      canShoot = 40 - level;
    }

    if (mousePressed && canShoot <= 0) {

      canShoot = 40;
    }

    if (exp >= lvlup) {
      reset = true;
      timer = 60;
      level+=1; 
      lvlup = 5 * level + lvlup;
      red = int(random(150, 255));
      green = int(random(150, 255));
      blue = int(random(150, 255));
      lives += int(level/3);
    }



   

      y = y + ySpeed;
      fill(r, g, b);
      stroke(0);
      ellipse(x, y, diameter, diameter);
    }

    if (y > height) {
      y = 0 - diameter; 
      x = random(0+diameter/2, width-diameter/2);
      ySpeed = random(1, 5) + level/3;
      reset = true;
      hit = 255;
      lives -= 1;
      diameter = random(25, 50) + 2*level;
      if (lives == 0) {
        lose = true;
      }

      if (score >= 50) {
        score-= 50;
      } else {
        score = 0;
      }
    } 

    int e = int(exp);
    int l = int(lvlup);

    for (int w = 1; w <= lives; w++) {
      fill(255, 0, 0);
      ellipse(width - 20 * w, height - 20, 10, 10);
    }



    fill(0);
    textAlign(CENTER);
    textSize(20);
    text("Score: " + int(score), width/2, 20);
    text("Exp: " + e + "/" + l, width/2, 90);
    text("Level: " + level, width/2, 40);

    fill(150, 150, 150);

    rect(width/5, 46, width/5 * 3, 20);

    fill(0, 255, 0);
    noStroke();
    rect(width/5 +1, 47, 3*((width/5) * (exp/lvlup)), 19);

    fill(0);

    rect(10, height-30, 120, 20);

    fill(150, 150, 0);
    noStroke();
    rect(10, height-30, 120-3*canShoot*(60/(60-level/2)), 20); 
    rect(mouseX-canShoot/2, mouseY+20, canShoot, 5);

    stroke(200, 200, 150);
    noFill();

    if (lose == false) {
      if (canShoot <= 0) {
        stroke(100, 100, 50);
      } else {
        stroke(200, 200, 150);
      }
      strokeWeight(2);
      ellipse(mouseX, mouseY, 15 + canShoot/2 - level/2, 15+canShoot/2 - level/2);
      line(mouseX-15, mouseY, mouseX+15, mouseY);
      line(mouseX, mouseY-15, mouseX, mouseY+15);
    }
    strokeWeight(1);
    if (lose == true) {
      /*
     try {
       line = reader.readLine();
       } 
       catch (IOException u) {
       u.printStackTrace();
       line = null;
       } 
       */

      /*
      if (line == null) {
       //noLoop();
       } else {
       String[] pieces = split(line, TAB);
       println(pieces);
       }
       */

      textSize(40);
      fill(0);
      text("You Lose", width/2, height/2);
      textSize(20);
      stroke(200, 200, 150);
      fill(255);
      rect(width/2 - 40, height/2 +10, 80, 28);
      rect(width/2 - 40, height/2 +45, 80, 28);
      fill(0);
      text("Reset", width/2, height/2 + 31);
      text("Quit", width/2, height/2 + 66);
      if (mouseX > width/2 - 40 && mouseX < width/2 + 40 && mousePressed) {
        if (mouseY > height/2 + 10 && mouseY < height/2 + 38) {
          setup();
        }
        if (mouseY > height/2 + 45 && mouseY < height/2 + 73) {
          exit();
        }
      }
    }
  }
  if (keyPressed && pauseTimer == 0) {
    if (key == ' ') {
      pause = false; 
      pauseTimer = 10;
    }
  }
}
