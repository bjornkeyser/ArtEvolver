color warm = color(20, 100, 100);
color cool = color(230, 100, 100);
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
    print(grey.toStr() + "\n");
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
          float scaledCol = (bw + 1)/2; //scale to [0,1] TODO: idont even fokin know
          if (scaledCol < min) min = scaledCol;
          if (scaledCol > max) max = scaledCol;
          
          if (bw > 0) { stroke = warm; }
          else { stroke = cool; }
          //stroke = lerpColor(warm,cool,scaledCol);
          //print(scaledCol + " ");
          stroke = color(hue(stroke), 100-abs(scaledCol*10), abs(bw) * 100);
          // HUE color
          // SAT 0 = white, 100 = color of hue
          // V or BRIGHTNESS = 0 = black
          stroke(stroke);
        }
        point(x, y);
      }
    }
    print("min: " + min + " max: " + max + "\n");
  }
}
