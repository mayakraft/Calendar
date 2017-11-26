//import processing.dxf.*;
import processing.pdf.*;

Table table;
String planetNames[] = {"Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"};
static int colors[] = {192,192,192,206,172,113,172,81,40,186,130,83,253,196,126,149,188,198,98,119,226,169,149,146};
float moonEventAngles[] = {0.0, 1.570796326794897, 3.141592653589793, 4.71238898038469};
String moonEventDescriptions[] = {"New", "First Quarter", "Full", "Third Quarter" };

int year[];
int month[];
int day[];
//int hour[];
float sunAngle[];
float moonAngle[];
float planetAngle[][];
//String zodiacs[];
float moonPhase[];
float daylightHours[];

void setup(){
  size(700, 700, P3D);
  noLoop();
  
  importCSV();

  //beginRaw(DXF, "output.dxf");
  beginRaw(PDF, "output.pdf");
  drawCalendar();
  endRaw();
}

void importCSV(){
  table = loadTable("../2018.csv", "header");

  year = new int[table.getRowCount()];
  month = new int[table.getRowCount()];
  day = new int[table.getRowCount()];
  //hour = new int[table.getRowCount()];
  sunAngle = new float[table.getRowCount()];
  moonAngle = new float[table.getRowCount()];
  planetAngle = new float[table.getRowCount()][planetNames.length];
  //zodiacs = new String[table.getRowCount()];
  moonPhase = new float[table.getRowCount()];
  daylightHours = new float[table.getRowCount()];

  int i = 0;
  for (TableRow row : table.rows()) {
    //String zodiac = row.getString("zodiac");
    year[i] = row.getInt("Year");
    month[i] = row.getInt("Month");
    day[i] = row.getInt("Day");
    moonAngle[i] = row.getFloat("Moon") * PI/180;
    sunAngle[i] = row.getFloat("Sun") * PI/180;
    daylightHours[i] = row.getFloat("Daylight");
    moonPhase[i] = row.getFloat("Phase") * PI/180;

    for(int p = 0; p < planetNames.length; p++){
      planetAngle[i][p] = row.getFloat(planetNames[p]) * PI / 180;
    }
    i++;
  }
}

void moon(float x, float y, float r, int phase){
  float tilt = 0.6;
  int gray = 200;
  switch (phase){
    case 0:
      noFill();
      strokeWeight(1);
      stroke(gray);
      ellipse(x, y, r-0.5, r-0.5);
      ellipse(x, y, r, r);
    break;
    case 1:
      fill(gray);
      noStroke();
      arc(x, y, r, r, PI+HALF_PI+tilt, TWO_PI+HALF_PI+tilt, CHORD);
    break;
    case 2:
      fill(gray);
      noStroke();
      ellipse(x, y, r, r);
    break;
    case 3:
      fill(gray);
      noStroke();
      arc(x, y, r, r, HALF_PI+tilt, PI+HALF_PI+tilt, CHORD);
    break;
  }
}

void drawCalendar(){
  fill(40);
  noStroke();
  rect(0, 0, width, height);
  
  strokeWeight(.5);
  stroke(100);
  for(int i = 0; i < 13; i++){
    float x = i/12.0*width;
    line(x,0,x,height);
  }
  
  strokeWeight(3);
  stroke(255);
  for(int i = 1; i < table.getRowCount(); i++){
    float y = float(i) / table.getRowCount()*height;
    float yPrev = float(i-1) / table.getRowCount()*height;
    for(int p = 0; p < planetNames.length; p++){
      float pos = (planetAngle[i][p] - PI*3/2);
      float posPrev = (planetAngle[i-1][p] - PI*3/2);
      if(pos < 0){ pos += TWO_PI; }
      if(posPrev < 0){ posPrev += TWO_PI; }
      pos = TWO_PI - pos;
      posPrev = TWO_PI - posPrev;
      stroke(colors[p*3+0], colors[p*3+1], colors[p*3+2]);
      strokeWeight(10 - p);
      if( !( (pos > 5.28 && posPrev < 1)  || (pos < 1 && posPrev > 5.28) ) ){
        line(pos / TWO_PI * width, y, posPrev / TWO_PI * width, yPrev);     
      }
    }
  }
  
  // moon
  for(int i = 1; i < table.getRowCount(); i++){
    float y = float(i) / table.getRowCount()*height;
    float yPrev = float(i-1) / table.getRowCount()*height;
    float pos = (moonAngle[i] - PI*3/2);
    float posPrev = (moonAngle[i-1] - PI*3/2);
    if(pos < 0){ pos += TWO_PI; }
    if(posPrev < 0){ posPrev += TWO_PI; }
    pos = TWO_PI - pos;
    posPrev = TWO_PI - posPrev;
    float phase0_1 = 1.0 - (cos(moonPhase[i])*0.5+0.5);
    strokeWeight(phase0_1 * 5 + 1);
    stroke(phase0_1 * 100 + 100);
    if( !( (pos > 5.28 && posPrev < 1)  || (pos < 1 && posPrev > 5.28) ) ){
      line(pos / TWO_PI * width, y, posPrev / TWO_PI * width, yPrev);     
    }
  }


  // moon
  for(int i = 1; i < table.getRowCount(); i++){
    float y = float(i) / table.getRowCount()*height;
    for(int m = 0; m < 4; m++){
      int phase = -1;
      if(moonPhase[i-1] < moonEventAngles[m] && moonEventAngles[m] < moonPhase[i]){ phase = m; }
      if(moonPhase[i-1] > 5.26 && moonPhase[i] < 1){ phase = 0; }
      if( phase != -1 ){
        float pos = (moonAngle[i] - PI*3/2);
        float posPrev = (moonAngle[i-1] - PI*3/2);
        if(pos < 0){ pos += TWO_PI; }
        if(posPrev < 0){ posPrev += TWO_PI; }
        pos = TWO_PI - pos;
        moon(pos / TWO_PI * width, y, 40, phase);
      }
    }
  }

  
  // sun
  for(int i = 1; i < table.getRowCount(); i++){
    float y = float(i) / table.getRowCount()*height;
    float yPrev = float(i-1) / table.getRowCount()*height;
    float pos = (sunAngle[i] - PI*3/2);
    float posPrev = (sunAngle[i-1] - PI*3/2);
    if(pos < 0){ pos += TWO_PI; }
    if(posPrev < 0){ posPrev += TWO_PI; }
    pos = TWO_PI - pos;
    posPrev = TWO_PI - posPrev;
    strokeWeight(daylightHours[i]);
    stroke(222,210,33);
    if( !( (pos > 5.28 && posPrev < 1)  || (pos < 1 && posPrev > 5.28) ) ){
      line(pos / TWO_PI * width, y, posPrev / TWO_PI * width, yPrev);     
    }
  }

  

}