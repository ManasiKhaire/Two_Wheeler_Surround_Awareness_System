const int trigPins[] = {14, 12, 10, 8, 6, 4};
const int echoPins[] = {15, 13, 11, 9, 7, 5};
const int numSensors = 6;
const int buzzerPin = 3;

void setup() {
  Serial.begin(9600);

  for (int i = 0; i < numSensors; i++) {
    pinMode(trigPins[i], OUTPUT);
    pinMode(echoPins[i], INPUT);
  }

  // Set up the buzzer pin
  pinMode(buzzerPin, OUTPUT);
}

void loop() {
  String data = "";

  for (int i = 0; i < numSensors; i++) {
    float distance = measureDistance(trigPins[i], echoPins[i]);
    data += String(distance, 2) + ",";
  }

  // Remove the trailing comma
  data.remove(data.length() - 1);

  Serial.println(data);
  
  bool objectDetected = false; // Flag to indicate if an object is detected
  
  for (int i = 0; i < numSensors; i++) {
    float distance = measureDistance(trigPins[i], echoPins[i]);
    if (distance < 20) {
      objectDetected = true;
      break; // Exit the loop if any sensor detects an object within 20 cm
    }
  }

  if (objectDetected) {
    // Beep the buzzer
    tone(buzzerPin, 1535, 500);
    delay(200); // Adjust the delay for the beep duration
    tone(buzzerPin, 1200, 500);
    delay(200); // Adjust the delay between beeps
  }
  delay(100); 
}


unsigned long measureTime(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
 
  unsigned long duration = pulseIn(echoPin, HIGH);
  return duration; // Return time taken for the echo

  delay(100);
}

float measureDistance(int trigPin, int echoPin) {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  unsigned long duration = pulseIn(echoPin, HIGH);
  float distance = duration * 0.0343 / 2; // Distance in centimeters

  return distance;
}
