color warm = color(22, 255, 255); //<>// //<>// //<>//
color cool = color(149, 255, 255);
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
          bw = (bw+1)/2;
          print(bw + "\n");
          stroke = lerpColor(warm, cool, bw);
          stroke = color(hue(stroke),saturation(stroke),255*bw);
          stroke(stroke);
        }
        point(x, y);
      }
    }
  }
}
