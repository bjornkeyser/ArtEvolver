int w, h; //<>//
Image[] phenotypes;
int POP_SIZE = 16; // only squarable numbers
int MAX_DEPTH = 5;
boolean[] selected = new boolean[POP_SIZE];
int numSelected = 0;

void setup() {
  size(440, 440, P2D); 
  colorMode(HSB, 360, 100, 100);
  w = 110;
  h = 110;
  background(0); 
  //frameRate(990);
  smooth();

  phenotypes = new Image[POP_SIZE];
  for (int i = 0; i < POP_SIZE; i++) {
    phenotypes[i] = new Image(110, 110);
    selected[i] = false;
  }

  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      phenotypes[i*4+j].drawImage(110*j, 110*i);
    }
  }
}

void draw() {
}

void mousePressed() {
  int x = mouseX/110;
  int y = mouseY/110;

  if (mouseButton == RIGHT) {
    phenotypes[4*x + y] = new Image(110, 110);
    phenotypes[4*x + y].drawImage(110*x, 110*y);
    print(phenotypes[4*x + y].dna.toStr() + "\n");
  } else {
    if (!selected[x*4 + y]) {
      selected[x * 4 + y] = true;
      numSelected++;
      print(phenotypes[x*4+y].dna.toStr() + "\n");
      print("height: " + Integer.toString(phenotypes[x*4+y].dna.getHeight()) + "\n");
      print("size: " + Integer.toString(phenotypes[x*4+y].dna.getSize()) + "\n");
    } else {
      selected[x * 4 + y] = false;
      numSelected--;
    }
  }

  /*for (int i = 0; i < POP_SIZE; i++) {
   phenotypes[i] = new Image(w, h);
   }
   
   for (int i = 0; i < 4; i++) {
   for (int j = 0; j < 4; j++) {
   phenotypes[i*4+j].drawImage(110*j, 110*i);
   }
   }*/
}

void keyPressed() {
  if (numSelected < 2) {
    print("Please select two images\n");
  } else {
    DNA mother, father;
    mother = new DNA();
    father = mother;

    boolean z = true;

    for (int i = 0; i < POP_SIZE; i++) {
      if (selected[i]) {
        if (z) {
          z = !z;
          mother = phenotypes[i].dna.copy();
        } else {
          father = phenotypes[i].dna.copy();
          print(father.toStr());
        }
      }
    }
    phenotypes[0] = new Image(110, 110, mother);
    phenotypes[1] = new Image(110, 110, father);
    print("mother: " + mother.toStr() + "\n");
    print("father: " + father.toStr() + "\n");

    DNA[] children = breed(mother, father, POP_SIZE - 2);
    for (int i = 0; i < POP_SIZE - 4; i++) {
      phenotypes[i + 2] = new Image(110, 110, children[i]);
    }

    // New random elements
    phenotypes[14] = new Image(110, 110);
    phenotypes[15] = new Image(110, 110);
    print("\ntestikel\n");

    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        phenotypes[i*4+j].drawImage(110*j, 110*i);
        selected[i*4 + j] = false;
      }
    }
    numSelected = 0;
  }
}
