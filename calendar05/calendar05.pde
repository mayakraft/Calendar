//import processing.dxf.*;
import processing.pdf.*;

Table table;
String planetNames[] = {"Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"};
static int colors[] = {192,192,192,206,172,113,172,81,40,186,130,83,253,196,126,149,188,198,98,119,226,169,149,146};
//float moonEventAngles[] = {0.0, 1.570796326794897, 3.141592653589793, 4.71238898038469};
float moonEventAngles[] = {0.0, 0.785398163397448, 1.570796326794897, 2.356194490192345, 3.141592653589793, 3.926990816987242, 4.71238898038469, 5.497787143782138};

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
    moonAngle[i] = row.getFloat("Moon") * PI/180 + PI/2.0;
    sunAngle[i] = row.getFloat("Sun") * PI/180 + PI/2.0;
    daylightHours[i] = row.getFloat("Daylight");
    moonPhase[i] = row.getFloat("Phase") * PI/180;
    if(moonAngle[i] > PI*2){ moonAngle[i] -= PI*2; }
    if(sunAngle[i] > PI*2){ sunAngle[i] -= PI*2; }

    for(int p = 0; p < planetNames.length; p++){
      planetAngle[i][p] = row.getFloat(planetNames[p]) * PI / 180 + PI/2.0;
      if(planetAngle[i][p] > PI*2){ planetAngle[i][p] -= PI*2; }
    }
    i++;
  }
}

void moon(float x, float y, float r, float phase){
  float ph1 = 1;
  float ph2 = -1;
  if(phase < PI){ ph2 = cos(phase); }
  if(phase > PI){ ph1 = -cos(phase); }
  fill(200, 198, 199);
  noStroke();
  pushMatrix();
  translate(x,y);
  rotate(PI*0.2 - PI/2);
  beginShape();
  for(float a = 0; a < PI; a+=PI/24.0){ vertex(r*sin(a)*ph1, r*cos(a)); }
  for(float a = PI; a > 0; a-=PI/24.0){ vertex(r*sin(a)*ph2, r*cos(a)); }
  endShape();
  popMatrix();
}

float pimargin = 0.075;

float pipad(float radians){

  while(radians < 0) radians += PI*2;
  while(radians > 2*PI) radians -= PI*2;
  float zto1 = radians/(2*PI);
  return pimargin + zto1*(2*PI-pimargin*2);
}

void drawCalendar(){

  float innerR = 100;
  float outerR = 280;

  fill(40);
  noStroke();
  rect(0, 0, width, height);

  translate(width*0.5, height*0.5);
  rotate(PI*0.5);
  

  noFill();
  stroke(255);
  arc(0,0, innerR*2, innerR*2, pipad(0), pipad(2*PI));
  arc(0,0, outerR*2, outerR*2, pipad(0), pipad(2*PI));
  for(int i = 1; i < 12; i++){
    float r = innerR*2 + (outerR*2-innerR*2)*i/12.0;
    arc(0,0, r, r, pipad(0), pipad(2*PI));    
  }
  for(float i = 0; i <= 12; i+=1){
    float a = pipad(i/12.0*PI*2);
    line(cos(a)*innerR, sin(a)*innerR, cos(a)*outerR, sin(a)*outerR );
  }
  
  
  // moon
  stroke(160);
  for(int i = 1; i < table.getRowCount(); i++) {
    strokeWeight( (1.0 - cos(moonPhase[i])*0.5+0.5)*1 );
    stroke( 100-(cos(moonPhase[i])*0.5+0.5)*60 );
    float calendarA = pipad(float(i)/table.getRowCount()*2*PI);
    float lastCalendarA = pipad(float(i-1)/table.getRowCount()*2*PI);
    float moonR = innerR + (outerR-innerR)*moonAngle[i]/(2*PI);
    float lastMoonR = innerR + (outerR-innerR)*moonAngle[i-1]/(2*PI);
    if( (moonAngle[i] > 5.7 && moonAngle[i-1] < .5) || (moonAngle[i-1] > 5.7 && moonAngle[i] < .5) ){
    } else{
      line(cos(lastCalendarA)*lastMoonR, sin(lastCalendarA)*lastMoonR, cos(calendarA)*moonR, sin(calendarA)*moonR);
    }
  }


      // planets
  //for(int i = 1; i < table.getRowCount(); i++) {
  //  for(int p = 0; p < 8; p++){
  //    strokeWeight( 2 );
  //    stroke( colors[p*3], colors[p*3+1], colors[p*3+2] );
  //    float calendarA = pipad(float(i)/table.getRowCount()*2*PI);
  //    float lastCalendarA = pipad(float(i-1)/table.getRowCount()*2*PI);
  //    float planetR = innerR + (outerR-innerR)*planetAngle[i][p]/(2*PI);
  //    float lastPlanetR = innerR + (outerR-innerR)*planetAngle[i-1][p]/(2*PI);
  //    if( (planetAngle[i][p] > 5.7 && planetAngle[i-1][p] < .5) || (planetAngle[i-1][p] > 5.7 && planetAngle[i][p] < .5) ){
  //    } else{
  //      line(cos(lastCalendarA)*lastPlanetR, sin(lastCalendarA)*lastPlanetR, cos(calendarA)*planetR, sin(calendarA)*planetR);
  //    }
  //  }
  //}
  
  
  
   // sun
  stroke(222,210,33);
  for(int i = 1; i < table.getRowCount(); i++) {
    //strokeWeight((daylightHours[i]-9)*2);
    strokeWeight((daylightHours[i]-9)*0.7+1);
    float calendarA = pipad(float(i)/table.getRowCount()*2*PI);
    float lastCalendarA = pipad(float(i-1)/table.getRowCount()*2*PI);
    float sunR = innerR + (outerR-innerR)*sunAngle[i]/(2*PI);
    float lastSunR = innerR + (outerR-innerR)*sunAngle[i-1]/(2*PI);
    if( (sunAngle[i] > 5.7 && sunAngle[i-1] < .5) || (sunAngle[i-1] > 5.7 && sunAngle[i] < .5) ){
    } else{
      line(cos(lastCalendarA)*lastSunR, sin(lastCalendarA)*lastSunR, cos(calendarA)*sunR, sin(calendarA)*sunR);
    }
  }
  
  //// moon phase
  //for(int i = 1; i < table.getRowCount(); i++) {
  //  for(int m = 0; m < 8; m++){
  //    int phase = -1;
  //    if(moonPhase[i-1] < moonEventAngles[m] && moonEventAngles[m] < moonPhase[i]){ phase = m; }
  //    if(moonPhase[i-1] > 5.26 && moonPhase[i] < 1){ phase = 0; }
  //    if( phase != -1 ){
  //      float calendarA = pipad(float(i)/table.getRowCount()*2*PI);
  //      float moonR = innerR + (outerR-innerR)*moonAngle[i]/(2*PI);
  //      moon(cos(calendarA)*moonR, sin(calendarA)*moonR, 4, moonPhase[i]);
  //    }
  //  }
  //}
  
    

}