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
  table = loadTable("../2019.csv", "header");

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
    moonAngle[i] = row.getFloat("MoonLongitude") * PI/180;
    sunAngle[i] = row.getFloat("SunLongitude") * PI/180;
    daylightHours[i] = row.getFloat("Daylight");
    moonPhase[i] = row.getFloat("MoonPhase") * PI/180;

    for(int p = 0; p < planetNames.length; p++){
      planetAngle[i][p] = row.getFloat(planetNames[p]+"Longitude") * PI / 180;
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
  strokeWeight(0);
  noStroke();
  //rect(0, 0, width, height);

  translate(width*0.5, height*0.5);
  rotate(-9.0/365.0*PI*2);
  
  float innerR = 100;
  float outerR = 280;
  
  noFill();
  strokeWeight(1);
  stroke(100);
  //ellipse(0, 0, innerR*2, innerR*2);
  //ellipse(0, 0, outerR*2, outerR*2);

  for(float i = 0; i < PI*2; i += PI*2/60.0 ){
    float r1 = outerR;
    float r2 = outerR+10;
    line(cos(i)*r1, sin(i)*r1, cos(i)*r2, sin(i)*r2);
  }
  
  int count = 0;
  for(float i = 0; i < PI*2; i += PI*2/120.0 ){
    if(count % 2 == 1){
      float r1 = outerR;
      float r2 = outerR+6.66;
      line(cos(i)*r1, sin(i)*r1, cos(i)*r2, sin(i)*r2);
    }
    count++;
  }
  count = 0;
  for(float i = 0; i < PI*2; i += PI*2/240.0 ){
    if(count % 2 == 1){
      float r1 = outerR;
      float r2 = outerR+4.444;
      line(cos(i)*r1, sin(i)*r1, cos(i)*r2, sin(i)*r2);
    }
    count++;
  }  
  count = 0;
  for(float i = 0; i < PI*2; i += PI*2/480.0 ){
    if(count % 2 == 1){
      float r1 = outerR;
      float r2 = outerR+2.888;
      line(cos(i)*r1, sin(i)*r1, cos(i)*r2, sin(i)*r2);
    }
    count++;
  }  
  count = 0;
  for(float i = 0; i < PI*2; i += PI*2/960.0 ){
    if(count % 2 == 1){
      float r1 = outerR;
      float r2 = outerR+1.9;
      line(cos(i)*r1, sin(i)*r1, cos(i)*r2, sin(i)*r2);
    }
    count++;
  }  
    
  //noStroke();
//  for(int i = 12; i >= 0; i--){
////    fill(40 + (i%2)*160 );
//    float r = innerR + (outerR-innerR) * i/12.0;
//    ellipse(0, 0, r*2, r*2);
//  }

  strokeWeight(1);
  for(float i = 0; i < PI*2; i += PI*2/12 ){
    line(cos(i)*innerR, sin(i)*innerR, cos(i)*outerR, sin(i)*outerR);
  }
  
//  strokeWeight(4);
//  stroke(200);
//  noFill();


  //ellipse(center.x, center.y, radius*2, radius*2);
  //ellipse(center.x, center.y, radius*2*0.9, radius*2*0.9);
  //for(float i = 0; i < 12; i++){
  //  float angle = i/12*PI*2;
  //  float r;
  //  if(i%2 == 0){ r = 0.875; }
  //  else        { r = 1.07;  }
  //  for(float j = 0; j < PI*2/12; j+=0.001){
  //    PVector blur = new PVector( cos(angle+j)*radius, sin(angle+j)*radius );
  //    line(blur.x*(r),     blur.y*(r),
  //         blur.x*(r+.005), blur.y*(r+.005));
  //  }
  //  PVector twelfth = new PVector( cos(angle)*radius, sin(angle)*radius );
  //  line(twelfth.x*1.07,  twelfth.y*1.07,
  //       twelfth.x*0.875, twelfth.y*0.875);
  //}
    
    
  // draw moon
  for(int i = 1; i < table.getRowCount(); i++) {
    float calendarR = innerR + (outerR-innerR)*i/table.getRowCount();
    float lastCalendarR = innerR + (outerR-innerR)*(i-1)/table.getRowCount();
    float phase0_1 = cos(moonPhase[i])*0.5+0.5;
    strokeWeight(6 - phase0_1*5);
    stroke(255 - phase0_1 * 255);
    line(cos(moonAngle[i-1])*lastCalendarR, sin(moonAngle[i-1])*lastCalendarR,
         cos(moonAngle[i])*calendarR, sin(moonAngle[i])*calendarR );
  }
    
    
  //// moon phases
  for(int i = 1; i < table.getRowCount(); i++) {
    for(int m = 0; m < 4; m++){
      int phase = -1;
      if(moonPhase[i-1] < moonEventAngles[m] && moonEventAngles[m] < moonPhase[i]){ phase = m; }
      if(moonPhase[i-1] > 5.26 && moonPhase[i] < 1){ phase = 0; }
      if( phase != -1 ){
        float calendarR = innerR + (outerR-innerR)*i/table.getRowCount();
        moon(cos(moonAngle[i])*calendarR, sin(moonAngle[i])*calendarR, 12, phase);
      }
    }
  }


  //// draw sun
  for(int i = 1; i < table.getRowCount(); i++) {
    float calendarR = innerR + (outerR-innerR)*i/table.getRowCount();
    float lastCalendarR = innerR + (outerR-innerR)*(i-1)/table.getRowCount();
    //strokeWeight(3);
    strokeWeight((daylightHours[i]-9.1)*2);
    stroke(222,210,33);
    line(cos(sunAngle[i-1])*lastCalendarR, sin(sunAngle[i-1])*lastCalendarR,
         cos(sunAngle[i])*calendarR, sin(sunAngle[i])*calendarR );      
  }
  
  
  //// draw planets
  for(int i = 1; i < table.getRowCount(); i++) {
    float calendarR = innerR + (outerR-innerR)*i/table.getRowCount();
    float lastCalendarR = innerR + (outerR-innerR)*(i-1)/table.getRowCount();
    strokeWeight(2);
    for(int p = 0; p < planetNames.length; p++){
      stroke(colors[3*p+0],colors[3*p+1],colors[3*p+2]);
      line(cos(planetAngle[i-1][p])*lastCalendarR, sin(planetAngle[i-1][p])*lastCalendarR, cos(planetAngle[i][p])*calendarR, sin(planetAngle[i][p])*calendarR);
    }
  }


}
