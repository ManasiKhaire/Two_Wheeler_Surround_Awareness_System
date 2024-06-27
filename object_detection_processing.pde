import processing.serial.*;

Serial myPort; // Create object from Serial class
float[] distances = new float[6]; // Array to store distances from ultrasonic sensors
int angleStep = 60; // Angle between sensors
int[] angles = {30, 90, 150, 210, 270, 330}; // Angles of each sensor
int[] colors = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)}; // Colors for each sensor
float maxDistance = 400.0; // Maximum distance in cm
float circleRadius20 = 20.0; // Radius for 20cm circle
float circleRadius30 = 30.0; // Radius for 30cm circle
PFont font;

void setup() {
  size(1366, 768); // Adjust the window size as needed
  font = createFont("Arial", 16);
  textFont(font);
  myPort = new Serial(this, Serial.list()[0], 9600); // Initialize serial communication
}

void draw() {
  background(255);
  // Read distances from serial port
  while (myPort.available() > 0) {
    String input = myPort.readStringUntil('\n');
    if (input != null) {
      input = input.trim();
      String[] data = input.split(",");
      for (int i = 0; i < min(data.length, 6); i++) {
        try {
          distances[i] = Float.parseFloat(data[i]); // Parse the float value
        } catch (NumberFormatException e) {
          println("Error parsing float: " + data[i]);
        }
      }
    }
  }
  
  // Draw concentric circles
  drawCircle(width/2, height/2, circleRadius20 * 20, color(255, 0, 0)); // Radius of 20cm
  drawCircle(width/2, height/2, circleRadius30 * 20, color(0, 0, 255)); // Radius of 30cm
  
  // Draw lines dividing the circle into segments
  stroke(150);
  for (int i = 0; i < 6; i++) {
    float angle = radians(angles[i]);
    float x2 = width/2 + cos(angle) * circleRadius30 * 20;
    float y2 = height/2 + sin(angle) * circleRadius30 * 20;
    line(width/2, height/2, x2, y2);
  }
  
  // Draw detected objects
  for (int i = 0; i < 6; i++) {
    if (distances[i] < circleRadius20 || distances[i] < circleRadius30) {
      float angle = radians(angles[i]);
      float x = width/2 + cos(angle) * distances[i] * 10;
      float y = height/2 + sin(angle) * distances[i] * 10;
      fill(255, 0, 0);
      ellipse(x, y, 10, 10); // Draw a red spot at the detected object position
      fill(0);
      textAlign(LEFT, BOTTOM);
      text("Distance: " + str(distances[i]) + " cm", x + 15, y); // Display distance next to the spot
      text("Angle: " + str(angles[i]) + "°", x + 15, y + 20); // Display angle next to the spot
    }
  }
}

void drawCircle(float x, float y, float diameter, color c) {
  noFill();
  stroke(c);
  ellipse(x, y, diameter, diameter);
}
