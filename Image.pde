color stroke = color(0, 0, 0);

class Image {
  int w, h;
  DNA dna, hue, sat, bri; 
  boolean isBW;

  Image(int ww, int hh) {
    w = ww;
    h = hh;
    dna = new DNA();
    //print(dna.toStr() + "\n");
  }

  Image(int ww, int hh, DNA dd) {
    w = ww;
    h = hh;
    dna = dd;
    print(dna.toStr() + "\n");
  }

  void drawImage(float xoffset, float yoffset) {
    float min = 0, max = 0;
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        float val = dna.getColorVal(x, y);   // could be  [-inf, inf]
        if (val > 0) { 
          stroke = dna.warm;
        } else { 
          stroke = dna.cool;
        }
        
        float zeroOne = abs(val)/(abs(val)+1);  // [-inf,inf] -> [0,1>
        if (val < min) min = val;
        if (val > max) max = val;

        //stroke = lerpColor(dna.warm,dna.cool,zeroOne);
        stroke = color(hue(stroke), map(zeroOne, 0, 1, 100, 0), map(zeroOne, 0, 1, 0, 150));
        // HUE color
        // SAT 0 = white, 100 = color of hue
        // V or BRIGHTNESS = 0 = black
        stroke(stroke);

        point(x + xoffset, y + yoffset);
      }
    }
    //print(dna.toStr() + "   min: " + min + " max: " + max + "\n");
  }
}
