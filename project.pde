int count = 150;
int maxSize = 200;
int minSize = 10;
float[][] p = new float[count][5];
color[][] c = new color[count][3];
boolean area = false;
boolean lines = false;
boolean hidden = false;
boolean place;

float dotSize = 2;
int sel = 0;
boolean dragging = false;

void mouseDragged() {
  dragging = true;
}

void mouseReleased() {
  dragging = false;
}

void mousePressed(){
  place = true;
}

void setup() {
  size(800, 300, P3D);
  strokeWeight(1);
  smooth();
  //ellipseMode(CENTER);

  for (int i=0; i<count; i++) {
    p[i][0] = random(width); //X
    p[i][1] = random(height); //Y
    p[i][2] = random(minSize, maxSize); //Radius
    p[i][3] = random(-.5, .5); // X Speed
    p[i][4] = random(-.5, .5); // Y Speed

    c[i][0] = int(random(255));
    c[i][1] = int(random(255));
    c[i][2] = int(random(255));
  }
}

void keyPressed() {
  if (key=='Q' || key=='q') {
    area = !area;
  }
  if (key=='A' || key=='a') {
    hidden = !hidden;
  }
  if (key=='C' || key=='c') {
    saveFrame("particle-####.jpg");
  }
}

void draw() {
  background(70);

  for (int i=0; i<count; i++) {
    noStroke();
    float radi = p[i][2];
    float diam = radi/2;

  // HOVER PARTICLE WITH POSSIBLE CONNECTIONS
    if (dist(p[i][0], p[i][1], mouseX, mouseY) < radi/2) {
       stroke(255, 200-radi);
       line(p[i][0], p[i][1], mouseX, mouseY);
     }
      if (place) {
        p[i][0] = mouseX;
        p[i][1] = mouseY;
        ellipse(p[i][0]-dotSize, p[i][1]-dotSize, dotSize*2, dotSize*2);
        place = false;
      }

    p[i][0] += p[i][3];
    p[i][1] += p[i][4];

    if (p[i][0] < - diam) {
      p[i][0] = width+diam;
    }
    if (p[i][0] > width+diam) {
      p[i][0] = -diam;
    }
    if (p[i][1] < - diam) {
      p[i][1] = height+diam;
    }
    if (p[i][1] > height+diam) {
      p[i][1] = -diam;
    }

    //TOGGLE VISIBLE CONNECTIONS
    if (!hidden) {
      stroke(255, 200-radi);
      for (int l=0; l<count; l++) {
        if (dist(p[i][0], p[i][1], p[l][0], p[l][1]) < radi/3) {
          line(p[i][0], p[i][1], p[l][0], p[l][1]);
          for (int w=0; w<count; w++) {
            if (dist(p[w][0], p[w][1], p[l][0], p[l][1]) < radi/3) {
              line(p[w][0], p[w][1], p[l][0], p[l][1]);
            }
          }
        }
      }

      if (!area) {
        noStroke();
        fill(c[i][0], c[i][1], c[i][2], 10);
        for (int l=0; l<count; l++) {
          if (dist(p[i][0], p[i][1], p[l][0], p[l][1]) < radi/3) {
            for (int w=0; w<count; w++) {
              if (dist(p[w][0], p[w][1], p[l][0], p[l][1]) < radi/3 && dist(p[w][0], p[w][1], p[i][0], p[i][1]) < radi/3) {
                beginShape(TRIANGLES);
                vertex(p[i][0], p[i][1]);
                vertex(p[l][0], p[l][1]);
                vertex(p[w][0], p[w][1]);
                endShape();
              }
            }
          }
        }
      }
    }

    //DRAW CIRCLES
    noStroke();
    fill(c[i][0], c[i][1], c[i][2]);
    ellipse(p[i][0]-dotSize, p[i][1]-dotSize, dotSize*2, dotSize*2);
  }
}
