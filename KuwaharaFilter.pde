PImage src;
int radius = 1;


void setup() {
  //src = loadImage("test_512x512.png");
  src = loadImage("image1_impuls.jpg");
  size(256, 256, P2D);
}


void draw() {
  background(255);
  src.loadPixels();
  for (int x=0; x<src.width; x++) {
    for (int y=0; y<src.height; y++) {
      int startPos[][] = {{-radius, -radius}, {-radius, 0}, {0, -radius}, {0, 0}};
      float sigma[] = {0, 0, 0, 0};
      float average[] = {0, 0, 0, 0};
      float dispersion[] = {0, 0, 0, 0};
      for (int i=0; i<4; i++) {
        int n = 0;

        // 領域ごとの平均産出
        for (int rx=0; rx<=radius; rx++) {
          for (int ry=0; ry<=radius; ry++) {
            PVector pos = new PVector(constrain(x+startPos[i][0]+rx, 0, width-1), constrain(y+startPos[i][1]+ry, 0, height-1));
            float brightness = brightness(src.pixels[(int)(pos.y+height*pos.x)]);
            sigma[i]+=brightness;
            n++;
          }
        }
        average[i]=sigma[i]/n;
        
        // 領域ごとの分散産出
        for (int rx=0; rx<=radius; rx++) {
          for (int ry=0; ry<=radius; ry++) {
            PVector pos = new PVector(constrain(x+startPos[i][0]+rx, 0, width-1), constrain(y+startPos[i][1]+ry, 0, height-1));
            float brightness = brightness(src.pixels[(int)(pos.y+height*pos.x)]);
            dispersion[i]+=pow(brightness-average[i], 2);
          }
        }
        dispersion[i] /= n;
      }
      
      // 最も分散
      float min = min(dispersion);
      int area = -1;
      for (int i=0; i<4; i++) {
        if (dispersion[i] == min) {
          area = i;
          break;
        }
      }
      int n = 0;
      int r = 0;
      int g = 0;
      int b = 0;
      for (int rx=0; rx<=radius; rx++) {
        for (int ry=0; ry<=radius; ry++) {
          PVector pos = new PVector(constrain(x+startPos[area][0]+rx, 0, width-1), constrain(y+startPos[area][1]+ry, 0, height-1));
          int pixelsPos = (int)(pos.y+height*pos.x);
          r += red(src.pixels[pixelsPos]);
          g += green(src.pixels[pixelsPos]);
          b += blue(src.pixels[pixelsPos]);
          n++;
        }
      }
      r /= n;
      g /= n;
      b /= n;
      stroke(r, g, b);
      point(y, x);
    }
  }
  noLoop();
  save("result.png");
}
