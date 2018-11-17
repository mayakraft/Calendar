import processing.pdf.*;

Table table;
String planetNames[] = {"Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"};

int year[];
int month[];
int day[];
int hour[];
float sunAngle[];
float moonAngle[];
float planetAngle[][];
//String zodiacs[];
float moonPhase[];
float daylightHours[];

void setup(){
  size(500, 700, P3D);
  noLoop();
  importCSV();
  beginRaw(PDF, "output.pdf");
  drawCalendar();
  endRaw();
}

void importCSV(){
  table = loadTable("../2019.csv", "header");
  
  year = new int[table.getRowCount()];
  month = new int[table.getRowCount()];
  day = new int[table.getRowCount()];
  hour = new int[table.getRowCount()];
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
    hour[i] = row.getInt("Hour");
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

void moon(float x, float y, float r, float phase){
  float ph1 = 1;
  float ph2 = -1;
  if(phase < PI){ ph2 = cos(phase); }
  if(phase > PI){ ph1 = -cos(phase); }
  fill(200);
  noStroke();
  pushMatrix();
  translate(x,y);
  rotate(PI*0.2);
  beginShape();
  for(float a = 0; a < PI; a+=PI/24.0){  vertex(r*sin(a)*ph1, r*cos(a));  }
  for(float a = PI; a > 0; a-=PI/24.0){  vertex(r*sin(a)*ph2, r*cos(a));  }
  endShape();
  popMatrix();
}

void drawCalendar(){
  fill(40);
  noStroke();
  rect(0, 0, width, height);
  
  int pad = 20;

  // moon
  for(int i = 0; i < table.getRowCount(); i++){
    if(hour[i] == 0){
      float x = day[i]/33.0 * (width-pad*2) + pad;
      float y = float(month[i])/14.0 * height + day[i]*2;
      moon(x, y, 6, moonPhase[i]);
    }
  }


}
