//Jeffrey Andersen
//started 10/30/2020
//inspiration: https://www.youtube.com/watch?v=IKB1hWWedMk


//future considerations: horizontal and (bounded) vertical movement control, colored terrain


int scale = 16; //how zoomed in the terrain is; experimentally determined to be decent
float maxHeight = 127; //maximum height of terrain; experimentally determined to be decent
float minHeight = -127; //minimum height of terrain; experimentally determined to be decent
float delta = 0.1; //how spiky the terrain is; experimentally determined to be decent
float movementSpeed = 0.02; //how fast the terrain moves; experimentally determined to be decent (for large scale numbers, evenly divisible factors of delta produces perfect translation of points, whereas factors of large remainders produce more nuanced wavelike behavior)
float terrainMultiplier = 1; //how much terrain is generated; experimentally determined to be decent


int numRows, numColumns;
float[][][] coordsXY;
float[][] elevations; //aka z coordinates
float distanceFromOrigin = 0;


void setup() {
  size(600, 900, P3D);
  numColumns = int(1.4 * terrainMultiplier * (width / scale)) + 1; //can be modified to increase the amount of terrain generated, but cannot be negative; multiplied relative to the number of rows to move the corners of generation outside the viewing window
  numRows = int(terrainMultiplier * (height / scale)) + 1; //can be modified to increase the amount of terrain generated, but cannot be negative
  coordsXY = new float[numColumns][numRows][2]; //x then y of every location
  for (int y = 0; y < numRows; ++y) {
    for (int x = 0; x < numColumns; ++x) {
      coordsXY[x][y][0] = x * scale;
      coordsXY[x][y][1] = y * scale;
    }
  }
  elevations = new float[numColumns][numRows];
}


void draw() {
  background(0);
  stroke(255);
  noFill();
  
  float dy = distanceFromOrigin;
  distanceFromOrigin -= movementSpeed;
  for (int y = 0; y < numRows; ++y) {
    float dx = 0;
    for (int x = 0; x < numColumns; ++x) {
      elevations[x][y] = map(noise(dx, dy), 0, 1, maxHeight, minHeight); //Perlin noise
      //elevations[y][x] = random(31);
      dx += delta;
    }
    dy += delta;
  }
  
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-scale * (numColumns-1) / 2, -scale * (numRows-1) / 2 + maxHeight, -sqrt(pow(numColumns-1, 2) + pow(numRows-1, 2)) / scale);
  
  for (int y = 0; y < numRows - 1; ++y) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < numColumns; ++x) {
      vertex(coordsXY[x][y][0], coordsXY[x][y][1], elevations[x][y]);
      vertex(coordsXY[x][y][0], coordsXY[x][y + 1][1], elevations[x][y + 1]); //FIXME: elevations are disconnected
    }
    endShape();
  }
}
