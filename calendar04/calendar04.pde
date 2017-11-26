import processing.pdf.*;

Table table;
String planetNames[] = {"Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"};
static int colors[] = {
  129,127,130,  // mercury
  239,194,107, // venus
  172,81,40, // mars
  187, 150, 110, // jupiter
  234, 208, 153,  // saturn
  149,188,198,  // uranus
  98,119,226,  // neptune
  169,149,146};  // pluto
float moonEventAngles[] = {0.0, 1.570796326794897, 3.141592653589793, 4.71238898038469};
String moonEventDescriptions[] = {"New", "First Quarter", "Full", "Third Quarter" };

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
  table = loadTable("../2018.csv", "header");
  
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

void moon(float x, float y, float r, float phase){
  float tilt = 0.6;
  fill(200);
  noStroke();
  float ph1 = 1;
  float ph2 = -1;
  if(phase < PI){ ph2 = cos(phase); }
  if(phase > PI){ ph1 = -cos(phase); }
  beginShape();
  for(float a = 0; a < PI; a+=PI/24.0){  vertex(x+r*sin(a)*ph1, y+r*cos(a));  }
  for(float a = PI; a > 0; a-=PI/24.0){  vertex(x+r*sin(a)*ph2, y+r*cos(a));  }
  endShape();
}

void drawCalendar(){
  fill(40);
  noStroke();
  rect(0, 0, width, height);
  
  int pad = 20;

  // moon
  int dayCount = 1;
  for(int i = 0; i < table.getRowCount(); i++){
    if(hour[i] == 0){
      int week = int(float(dayCount)/7.0);
      float x = day[i]/33.0 * (width-pad*2) + pad;
      float y = float(month[i])/14.0 * height + day[i]*2;
      //float y = week / 52.0 * (height-pad*2) + pad;
      moon(x, y, 6, moonPhase[i]);
      dayCount+=1;
    }
  }


}