import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import themidibus.*;

 
Minim        minim;
AudioInput in;
FFT          fft;
 
MidiBus myBus;


int frames = 101;
our_image[] our_images = new our_image[frames]; 

PImage[] pic = new PImage[frames];
int[] opacityold = new int[frames + 1];
int[] matrix = new int[2];

int w = 80;
int h = 80;

int count = 0;

//String [] params = new String[100];
 
void setup() {
    
  for (int i = 0; i<frames; i++) {
    our_images[i] = new our_image();
   }
  reloadOpacity();
  MidiBus.list();
  myBus = new MidiBus(this, 2, "AKAI");
  reload();
  
  size(1000, 1000);
  int timeSize = 2048;
  size(1280, 720);
  
  minim = new Minim(this);
  
    in = minim.getLineIn(Minim.STEREO, 2048);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    fft.logAverages(40, 1);
  
  frameRate(60);
  background(0);
  strokeWeight(4);
    
}

void reloadOpacity() {
    
    for (int i = 0; i<frames; i = i + 1) {
        
        opacityold[i] = int(random(255));   
    
    }
    
}

void reload() {
    
    for (int i = 0; i<frames; i = i + 1) {
        
        our_images[1].loadOurImage(1);   
    
    }
    
}


 void keyPressed() {
   switch(key) {
    case 'r' :
      reload();
      break;
   
    case 'q' : 
     String [] params1  = {"/usr/local/bin/node /Users/mintslip/Desktop/interactive_p/fliget3/programm.js -i 101 -s 101 -w fire"} ;
    println(params1);

 open(params1);
      break;
      
      case 'w' :
 
String [] params2  = {"/usr/local/bin/node /Users/mintslip/Desktop/interactive_p/fliget3/programm.js -i 101 -s 101 -w water"} ;

 println(params2);

 open(params2);
      break;
  } 
   println(key);
     
  
  }
  
  
 void fade(int i, int j) {
  
 } 


 int flag_bochka = 0;



void draw() {
  

  // translate(200, 200);
  //   translate(width/2, height/2);
   background(0);
      stroke(255);
    
   //-----------EQ----------------
       
   pushMatrix();
    translate(150, -300);
     
    for(int i = 0; i < fft.specSize() - 600; i=i+10)
    {
        float band = fft.getBand(i);
        float vo = height - band * 16;
       
        line(i + 128, height, i + 128, vo);
    }
    //------------EQ===================

   
      popMatrix();
    // ---------------------------- audio --------------------------------
    
    fft.forward(in.mix); 
    
    //float lens[] = new float[fft.avgSize()];
    
    /*
    for (int band = 0; band < fft.avgSize (); band++) {
          lens[band] = fft.getAvg(band);
    }  
    */
    
   float bochka = fft.getAvg(1);
    
   //    float bochka = 200;
   // println(bochka);
    
      if (bochka > 150)
     {
        flag_bochka++;
    }
    
    // ---------------------------- pic --------------------------------
    
    if (flag_bochka > 0)  
    {
       flag_bochka = 0;
       //println(frameRate);
       count = 0;
      
    
        //fft.forward(in.mix); 
     
     // ap.mute();
     
         reloadOpacity();
     
    }
     
     
   
   count = 0;
        for (int x=0 ; x < matrix[0]; x = x+1) {
            for ( int y = 0; y< matrix[1]; y = y+1) {
              
             our_images[count].setXY(x*1000/matrix[0], y*1000/matrix[1]);
           boolean  ifFadeIn = our_images[count].getFadeIn(); 
            
             if (!ifFadeIn) {
             our_images[count].OpacityInc(1);
             } else 
             { 
          our_images[count].OpacityDec(1);
             }
             
             our_images[count].drawpic(count);
             
             /* tint(opacity[count]);
        
                  int new_x_size = 1000/matrix[0];
                  int new_y_size = 1000/matrix[1];
        
                if (new_x_size < 1)
                 {
                   new_x_size = 100;
                 }
                if (new_y_size < 1)
                 {
                 new_y_size = 100;
                 }  
           */
           
             // our_images[count].resize(new_x_size, new_y_size);
             // image(pic[count], int(matrix[0]*1000/matrix[0]), int(matrix[1]*1000/matrix[1]));  
             
              //image(our_images[count], x*1000/matrix[0], y*1000/matrix[1]);
          //if (opacity[count][opacity]<opasity[])
    
          }
          
          
          
          count = count + 1;
          
          println(count);
          
          
        }

    }
 
  

    


void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);

  switch(number) {
    case (102) : 
    matrix[0] = (int(value/10)-2); 
    if (matrix[0] == 0 ) {
    matrix[0] = 1;
    }
    println(matrix[0]);
    break;
    case (103) : 
    matrix[1] = (int(value/10)-2); 
       if (matrix[1] == 0 ) {
        matrix[1] = 1;
    }
      println(matrix[1]);
    break;
    case (104) : 
  
    break;
  }
}



