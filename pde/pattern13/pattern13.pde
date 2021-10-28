

import netP5.*;
import oscP5.*;

OscP5 oscP5;

int songposition = 0;
int patternnr = 0;
int patternrow = 0;
int channel1instr = 0;
int channel2instr = 0;
int channel3instr = 0;
int channel4instr = 0;
int channel1note = 0;
int channel2note = 0;
int channel3note = 0;
int channel4note = 0;
char channel1effect;
char channel2effect;
char channel3effect;
char channel4effect;
String channel1effect_param = "00";
String channel2effect_param = "00";
String channel3effect_param = "00";
String channel4effect_param = "00";
String feedback_formatted = "";
PFont mono;

int i = 0; //Ik weet niet zeker of deze op de goede plek staat
float t = 0;
float m = 0;
int q = 20;

void setup()
{
  size(720, 480);
  oscP5 = new OscP5(this,6200);
  mono = createFont("Andale Mono", 12);
  //println(PFont.list());
  textFont(mono);
}

void draw() 
{
  if (channel2instr != 0 ) //volgens mij zit de beat op channel 2, maar ik wil dat die elke tel af gaat. Zonder de high-hat
  { 
    background(0);
    pushMatrix();
    translate(width/2, height/2);
    textAlign(CENTER, CENTER);
    textSize(200);
    String [] words = {"HELP", "ME", "END", "ME"};
    i = patternrow / 4 % words.length;
    text(words[i], 0 + random(-30, 30), 0 + random(-30, 30));
    text(words[i], 0 + random(-30, 30), 0 + random(-30, 30));
    textSize(12);
    popMatrix();
    i++;
    
    if(i > 1)
    {
      i = 0;
    }
  }
  else
  {
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
  
    background(0);
  
    translate(width/2, height/2);
  
    beginShape();
  
    for (float theta = 0; theta <= 2 * PI; theta += 0.01)
    {
      float rad = r(theta,
      3, // a     part of shape
      20, // b     part of shape
      q, // m     amount of rotational symmetry
      1, // n1     higher = spikier
      t, // n2
      t  // n3
      );
      float x = rad * cos(theta) * 30;
      float y = rad * sin(theta) * 30;
      vertex(x, y);
    }
  
    endShape();
  
    t += 0.3;
    m += 0.1;
    q += 3;
    if (t > 3)
    {
      t = 0;
    }
    if (q > 300)
    {
      q = 20;
    }
  }
  
  fill(0);
  rect(0,height-14,feedback_formatted.length()*8,14);
  fill(255);
  
  text(feedback_formatted, 2, height-2);
}

float r(float theta, float a, float b, float m, float n1, float n2, float n3)
{
  return pow(pow(abs(cos(m * theta /4) / a), n2) + 
  pow(abs(sin(m * theta /4) / b), n3), -1.0 / n1);
}


void oscEvent(OscMessage message) 
{
  if (message.checkAddrPattern("/patternevent" ) )
  {
    /* print the address pattern and the typetag of the received OscMessage */
    //print("### received an osc message.");
    //print(" addrpattern: "+message.addrPattern());
    //println(" typetag: "+message.typetag());
    
    songposition = message.get(0).intValue();
    patternnr = message.get(1).intValue();
    patternrow = message.get(2).intValue();
    
    channel1note = message.get(3).intValue();
    channel1instr = message.get(4).intValue();
    channel1effect = message.get(5).charValue();
    channel1effect_param = message.get(6).stringValue();
    channel2note = message.get(7).intValue();
    channel2instr = message.get(8).intValue();
    channel2effect = message.get(9).charValue();
    channel2effect_param = message.get(10).stringValue();    
    channel3note = message.get(11).intValue();
    channel3instr = message.get(12).intValue();
    channel3effect = message.get(13).charValue();
    channel3effect_param = message.get(14).stringValue();
    channel4note = message.get(15).intValue();;
    channel4instr = message.get(16).intValue();
    channel4effect = message.get(17).charValue();
    channel4effect_param = message.get(18).stringValue();


    feedback_formatted = String.format("%02d:%02d | %03d:%02d:%c%s | %03d:%02d:%c%s | %03d:%02d:%c%s | %03d:%02d:%c%s |" , 
                                      patternnr, patternrow, 
                                      channel1note, channel1instr, channel1effect, channel1effect_param, 
                                      channel2note, channel2instr, channel2effect, channel2effect_param, 
                                      channel3note, channel3instr, channel3effect, channel3effect_param,
                                      channel4note, channel4instr, channel4effect, channel4effect_param
                                      );
    println( feedback_formatted );
  }
}