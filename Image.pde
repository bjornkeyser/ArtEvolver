color warm = color(random(0,360), 100, 100);
color cool = color(random(0,360), 100, 100);
color stroke = color(0, 0, 0);

class Image {
  int w, h;
  DNA grey, hue, sat, bri; 
  boolean isBW;

  Image(int ww, int hh, boolean BW) {
    w = ww;
    h = hh;
    isBW = BW;
    grey = new DNA();
    //print(grey.toStr() + "\n");
    //hue = new DNA(0);
    //sat = new DNA(0);
    //bri = new DNA(0);
  }

  void drawImage() {
    float min = 0, max = 0;
    for (int x = 0; x < w; x++) {
      for (int y = 0; y < h; y++) {
        if (!isBW) {
          //int hu = hue.getColorVal(x, y, w);
          //int s = sat.getColorVal(x, y, w);
          //int b = bri.getColorVal(x, y, w);
          //colorMode(HSB, 255, 255, 255);
          //stroke(hu, s, b);
        } else {
          float bw = grey.getColorVal(x, y, w);
          float scaledCol = ((bw/(bw+1)) + 1)/2; //TODO: idont even fokin know
          if (scaledCol < min) min = scaledCol;
          if (scaledCol > max) max = scaledCol;
          stroke = lerpColor(warm, cool, scaledCol);
          stroke = color(hue(stroke),map(scaledCol, -1, 1, 100, 0) ,255*bw);
          stroke(stroke);
        }
        point(x, y);
      }
    }
    print("min: " + min + " max: " + max);
  }
}
