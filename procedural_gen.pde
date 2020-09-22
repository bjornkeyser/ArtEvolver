int w, h;
Image[] phenotypes;
int POP_SIZE = 1;
boolean IS_BW = true;
int MAX_DEPTH = 50;


void setup() {
  size(200, 200, P2D); 
  colorMode(HSB, 360, 100, 100);
  w = width;
  h = height;
  background(0); 
  frameRate(990);
  smooth();

  phenotypes = new Image[POP_SIZE];
  for (int i = 0; i < POP_SIZE; i++) {
    phenotypes[i] = new Image(w, h, IS_BW);
    phenotypes[i].drawImage(); //<>//
  }
}

void draw() {
}

void mousePressed() {
  for (int i = 0; i < POP_SIZE; i++) {
    phenotypes[i] = new Image(w, h, IS_BW);
    phenotypes[i].drawImage();
    print("\n");
  }
}
