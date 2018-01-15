import gab.opencv.*;
OpenCV cv;

PrintWriter output;
PrintWriter output2;

final int WIDTH = 640;
final int HEIGHT = 480;
final int picsNumber = 30;

PImage[] pics = new PImage[picsNumber];
PImage[] picsbin = new PImage[picsNumber];

float[] picsarea = new float[picsNumber];
int[] picsred = new int[picsNumber];

//画面の設定
void settings(){

  size(WIDTH,HEIGHT);

}


void setup(){
  output = createWriter("area.txt");
  output2 = createWriter("area2.txt");
  
  //画像の読み込み
  for(int i = 0, j = 1; i < picsNumber; i++, j++){
    String str;
    if(i < 9){
      str = "pic0" + j + ".jpg";
    }
    else{
      str = "pic" + j + ".jpg";
    }
    pics[i] = loadImage(str);
    pics[i].loadPixels();
    image(pics[0], 0, 0, WIDTH/2, HEIGHT/2);
    
    //二値化
    cv = new OpenCV(this, pics[i]);
    cv.gray();
    cv.threshold(95); 
    picsbin[i] = cv.getOutput();
    
    //面積
    float sum = 0;
    for (int y = 0; y < picsbin[i].height; y++) {
      for (int x = 0; x < picsbin[i].width; x++) {
        if (picsbin[i].pixels[x + y*picsbin[i].width] == color(0)) {
          sum++;
        }
      }
    }
    picsarea[i] = sum/5000;
    println("picsarea[" + i + "] = " + picsarea[i]);
    
    //output.print("picsarea[" + i + "] = " + picsarea[i]);
    if(i < 15){
      //picsarea[i] = picsarea[i] ;
      output.print( picsarea[i]+" ");
    }else{
      picsarea[i] = picsarea[i] * 10;
      output2.print(picsarea[i]+" ");
    }
    //色情報の取得(赤の平均)
    int count = 0;
    //int red = 0;
    float red_sum = 0;
    float red_avg = 0;
    float r,g,b;
    for(int w = 0; w < pics[i].width; w++){
      for(int h = 0; h < pics[i].height; h++){
        //color c = pics[i].get(h, w);
        int c = w + h * pics[i].width;
        r = red(pics[i].pixels[c]);
        g = green(pics[i].pixels[c]);
        b = blue(pics[i].pixels[c]);
        
        //if(r == 255 && g == 255 && b == 255){
        if(red(picsbin[i].pixels[c]) == 0){
          count++;
          red_sum = red_sum + r;
        }
        red_avg = red_sum / count/100;
      }
    }
    //picsred[i] = red_avg;
    println("picsred[" + i + "] = " + red_avg);
    //output.print("picsgreen[" + i + "] = " + picsgreen[i]);
    if(i < 15){
      red_avg = red_avg * 5;
      output.print(red_avg);
      output.println("");
    }else{
      output2.print(red_avg);
      output2.println("");
    }
  }
  output.flush();
  output.close();
  output2.flush();
  output2.close();
}

void draw(){
  //画像表示
  for(int i = 0, x = 0, y = 0; i < picsNumber; i++, x++){
    if(i != 0 && i % 7 == 0){
      y++;
      x = 0;
    }
    image(pics[i], x * WIDTH / 7, y * HEIGHT / 7, WIDTH / 7, HEIGHT / 7);
  }
}