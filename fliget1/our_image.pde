class our_image  {
 
 protected   PImage pic1;
    float x, y;
    int opacity;
    boolean ifFadeIn = true;
    
  public void loadOurImage(int i) {
     pic1 = loadImage("/Users/mintslip/Desktop/interactive_p/fliget3/images/ready/" + i + ".jpg");   
  }    
  
  public void setXY(int nx, int ny) {
     x = nx;
     y = ny;  
  }    
  
  public void OpacityInc(int opacityIndex) {
    opacity = opacity + opacityIndex; 
  }    
    public void OpacityDec(int opacityIndex) {
    opacity = opacity - opacityIndex; 
  }    
  
    public void drawpic(int picnumber) {
    image(pic1, x, y);  
  }    
    
    public boolean getFadeIn(){
      
     return ifFadeIn; 
    }
    
}
