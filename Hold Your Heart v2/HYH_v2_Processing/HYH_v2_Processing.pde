import processing.serial.*;  // serial library lets us talk to Arduino
import processing.sound.*;

SoundFile file;
SoundFile file2;
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

long oneMinuteSongTime = 0; // amount of time the one-minute song has been playing
long oneMinuteSongWait = 0; // time you need wait before the one minute-long song can play again
long threeMinuteSongTime = 0; // amount of time the one-minute song has been playing
long threeMinuteSongWait = 0; // time you need wait before the one minute-long song can play again
boolean oneMinuteSongPlayed = false;
boolean threeMinuteSongPlayed = false;
int playerChoice = 0; 



//int level = 0;
//int numLevel = 2;




void setup() {
  size(1300, 750);  // Stage size
  frameRate(100);
  myFont1 = createFont("BentonGothic-Light-20", 20);
  myFont2 = createFont("BentonGothic-Bold-35", 35);
  myFont3 = createFont("BentonGothic-Black-80", 80);
  myFont4 = createFont("BentonGothic-Bold-50", 50);
  img = loadImage("heart.png");
  file = new SoundFile(this, "One_Minute.mp3");
  file2 = new SoundFile(this, "Three_Minute.mp3");
  
// GO FIND THE ARDUINO
  textSize(30);
  fill(0);
  textAlign(LEFT);
  text("Select Your Serial Port",20,50);
  listAvailablePorts();
}

void draw() {
if(serialPortFound){
  // ONLY RUN THE VISUALIZER AFTER THE PORT IS CONNECTED
  println(BPM);
  drawHeart();
  displayLevel();

  
  if (playerChoice == 1){
    
    background(137, 196, 244);
    fill(51, 49, 50); 
    textSize(40);
    text("You have selected one minute.", width/2, 190);
    
    textSize(50);
    fill(51, 49, 50);
    textFont(myFont4);
    textAlign(CENTER);
    text("Hold Your Heart", width/2, 90);
    textSize(25);
    text("To begin meditation, press 1 for one minute and 3 for three minutes.", width/2, 250);  
    textSize(50);
    textFont(myFont4);
    text(BPM + " BPM", width/2, 700); 
    drawHeart();
    
    if (oneMinuteSongPlayed == false) {
    playSongOne();
    }
  }
  else { 
    if (playerChoice == 3) {
      background(89, 171, 227);
      fill(51, 49, 50); 
      textSize(40);
      text("You have selected three minutes.", width/2, 190);
      
      textSize(50);
      fill(51, 49, 50);
      textFont(myFont4);
      textAlign(CENTER);
      text("Hold Your Heart", width/2, 90);
      textSize(25);
      text("To begin meditation, press 1 for one minute and 3 for three minutes.", width/2, 250); 
      textSize(50);
      textFont(myFont4);
      text(BPM + " BPM", width/2, 700); 
      drawHeart();
      
    if (threeMinuteSongPlayed == false){
      playSongTwo();
    //  background(174, 168, 211);
      
    }
  }
  }
  
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


void keyPressed() {
  if (key == '1') {
  playerChoice = 1;
  }
  if (key == '3') {
    playerChoice = 3;
  }
}
  

void playSongOne(){
  //if (millis() - oneMinuteSongTime >= oneMinuteSongWait){
    file2.stop();
    file.play();
    
    //oneMinuteSongTime = millis();
    //oneMinuteSongWait = 60000;
    oneMinuteSongPlayed = true;
  }
  
void playSongTwo(){
  //if (millis() - oneMinuteSongTime >= oneMinuteSongWait){
    file.stop();
    file2.play();
    //oneMinuteSongTime = millis();
    //oneMinuteSongWait = 60000;
    threeMinuteSongPlayed = true;
  }


void displayLevel()
{  
  background(174, 168, 211);
  textSize(50);
  fill(51, 49, 50);
  textFont(myFont4);
  textAlign(CENTER);
  text("Hold Your Heart", width/2, 90);
  textSize(30); 
  text("Hold the ball and rest a finger on the sensor.", width/2, 190);
  textSize(25);
  text("To begin meditation, press 1 for one minute and 3 for three minutes.", width/2, 250);  
  textSize(50);
  textFont(myFont4);
  text(BPM + " BPM", width/2, 700); 
  drawHeart();
  
}  

void drawHeart(){
  
  image(img, 650-0.5*BPM, 500-0.5*BPM, BPM, BPM);

}

  
void listAvailablePorts(){
  println((Object[])Serial.list());    // print a list of available serial ports to the console
  serialPorts = Serial.list();
  fill(0);
  textFont(myFont1,16);
  textAlign(LEFT);
  // set a counter to list the ports backwards
  int yPos = 0;
  int xPos = 35;
  for(int i=serialPorts.length-1; i>=0; i--){
    button[i] = new Radio(xPos, 95+(yPos*20),12,color(180),color(80),color(255),i,button);
    text(serialPorts[i],xPos+15, 100+(yPos*20));

    yPos++;
    if(yPos > height-30){
      yPos = 0; xPos+=200;
    }
  }
  int p = numPorts;
   fill(233,0,0);
  button[p] = new Radio(35, 95+(yPos*20),12,color(180),color(80),color(255),p,button);
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