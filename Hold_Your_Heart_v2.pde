import processing.serial.*;  // serial library lets us talk to Arduino
import processing.sound.*;
SoundFile file;
PFont font;
PFont portsFont;

Serial port;

int Sensor;      // HOLDS PULSE SENSOR DATA FROM ARDUINO
int IBI;         // HOLDS TIME BETWEN HEARTBEATS FROM ARDUINO
int BPM;         // HOLDS HEART RATE VALUE FROM ARDUINO
int heart = 0;   // This variable times the heart image 'pulse' on screen
boolean beat = false;    // set when a heart beat is detected, then cleared when the BPM graph is advanced
PImage img;
PFont myFont1;
PFont myFont2;
PFont myFont3;
PFont myFont4;
int value = 0; 

// SERIAL PORT STUFF TO HELP YOU FIND THE CORRECT SERIAL PORT
String serialPort;
String[] serialPorts = new String[Serial.list().length];
boolean serialPortFound = false;
Radio[] button = new Radio[Serial.list().length*2];
int numPorts = serialPorts.length;
boolean refreshPorts = false;
int level = 0;
int numLevel = 4;

void setup() {
  size(900, 600);  // Stage size
  frameRate(100);
  fill(0);
  myFont1 = createFont("BentonGothic-Light-20", 20);
  myFont2 = createFont("BentonGothic-Bold-35", 35);
  myFont3 = createFont("BentonGothic-Black-80", 80);
  myFont4 = createFont("BentonGothic-Bold-50", 50);
  fill(51, 49, 50);
  img = loadImage("heart.png");
  file = new SoundFile(this, "Happiness.mp3"); // Load a soundfile from the /data folder of the sketch and play it back
  file.play();
  
  // GO FIND THE ARDUINO
  textSize(30);
  fill(0);
  background(174, 168, 211);
  textAlign(LEFT);
  text("Select Your Serial Port",20,50);
  listAvailablePorts();
}

void draw() {
if(serialPortFound){
  // ONLY RUN THE VISUALIZER AFTER THE PORT IS CONNECTED
  if (BPM > 100) {
    background(214, 69, 65);
    }
  else {
    background(174, 168, 211);}
    
  println(BPM);
  println("level" + level);
  displayLevel();
  drawHeart();
  
  } else { // SCAN BUTTONS TO FIND THE SERIAL PORT

  autoScanPorts();

  if(refreshPorts){
    refreshPorts = false;
    drawHeart();
    listAvailablePorts();
  }

  for(int i=0; i<numPorts+1; i++){
    button[i].overRadio(mouseX,mouseY);
    button[i].displayRadio();
  }

}
}  //end of draw loop
     
void drawHeart(){
  
  image(img, 700-0.5*BPM, 250-0.5*BPM, BPM, BPM);
   
}

void level0()
{
  textSize(35);
  textAlign(LEFT); 
  textFont(myFont2);
  text("Press a key to begin." , 100, 300, height/2);
}

void level1()
{
  textAlign(LEFT);
  textSize(35);
  textFont(myFont2);
  fill(51, 49, 50);
  text("Inhale slowly and" + "\n" + "count to five.", 100, height/2); 
  textFont(myFont1);
  textSize(20);
  text("Press a key to continue.", 100, 510);
}

void level2()
{
  textAlign(LEFT);
  textSize(35);
  textFont(myFont2);
  text("Hold your breath" + "\n" + "and count to five.", 100, height/2); 
  textSize(20);
  textFont(myFont1);
  text("Press a key to continue.", 100, 510);
}

void level3()
{
  textAlign(LEFT);
  textSize(35);
  textFont(myFont2);
  text("Exhale slowly and" + "\n" + "count to five.", 100, height/2); 
  textSize(20);
  textFont(myFont1);
  text("Repeat this exercise 3 times." + "\n" + "Press a key to start again.", 100, 480); 
}

void displayLevel()
{  
  textSize(50);
  textFont(myFont4);
  textAlign(CENTER);
  text("Hold Your Heart", width/2, 100);
  textSize(80);
  fill(51, 49, 50);
  textAlign(RIGHT);
  textFont(myFont3);
  text(BPM, 770, 450);
  textSize(50);
  textFont(myFont4);
  fill(51, 49, 50);
  text("BPM",770,510);
 
  switch(level)
  {
    case 0:
    level0();
    break;
    case 1:
    level1();
    break;
    case 2: 
    level2();
    break;
    case 3: 
    level3();
    break;
   }
}
void keyPressed()
{
  if (level < numLevel -1)
  {
   level++;
 }
 else level = 1;

}

  
void listAvailablePorts(){
  println(Serial.list());    // print a list of available serial ports to the console
  serialPorts = Serial.list();
  fill(0);
  textFont(myFont1,16);
  textAlign(LEFT);
  // set a counter to list the ports backwards
  int yPos = 0;
  int xPos = 35;
  for(int i=serialPorts.length-1; i>=0; i--){
    button[i] = new Radio(xPos, 95+(yPos*20),12,color(232, 227, 252),color(66, 162, 247),color(161, 209, 252),i,button);
    text(serialPorts[i],xPos+15, 100+(yPos*20));

    yPos++;
    if(yPos > height-30){
      yPos = 0; xPos+=200;
    }
  }
  int p = numPorts;
   fill(81, 65, 142);
  button[p] = new Radio(35, 95+(yPos*20),12,color(232, 227, 252),color(66, 162, 247),color(161, 209, 252),p,button);
    text("Refresh Serial Ports List",50, 100+(yPos*20));

  textFont(myFont1);
  textAlign(CENTER);
}

void autoScanPorts(){
  if(Serial.list().length != numPorts){
    if(Serial.list().length > numPorts){
      println("New Ports Opened!");
      int diff = Serial.list().length - numPorts;	// was serialPorts.length
      serialPorts = expand(serialPorts,diff);
      numPorts = Serial.list().length;
    }else if(Serial.list().length < numPorts){
      println("Some Ports Closed!");
      numPorts = Serial.list().length;
    }
    refreshPorts = true;
    return;
  }
}