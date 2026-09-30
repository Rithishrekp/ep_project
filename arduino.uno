#define IR1 18
#define IR2 19

#define GREEN_LED 25
#define RED_LED 33

int peopleCount = 0;

// 0 = waiting for a person
// 1 = IR1 detected first → waiting for IR2
// 2 = IR2 detected first → waiting for IR1
int state = 0;

void setup() {
  Serial.begin(115200);

  pinMode(IR1, INPUT);
  pinMode(IR2, INPUT);

  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);

  digitalWrite(GREEN_LED, LOW);
  digitalWrite(RED_LED, LOW);

  Serial.println("People Counter Started");
  Serial.println("Count = 0");
}

void loop() {

  int sensor1 = digitalRead(IR1);
  int sensor2 = digitalRead(IR2);

  // -----------------------------------
  // STATE 0: No sequence started
  // -----------------------------------
  if (state == 0) {

    // IR1 detects first → person entering
    if (sensor1 == LOW && sensor2 == HIGH) {
      state = 1;
      Serial.println("IR1 detected first - ENTERING");
    }

    // IR2 detects first → person exiting
    else if (sensor2 == LOW && sensor1 == HIGH) {
      state = 2;
      Serial.println("IR2 detected first - EXITING");
    }
  }


  else if (state == 1) {

    if (sensor2 == LOW) {

      peopleCount++;

      Serial.print("PERSON ENTERED | Count = ");
      Serial.println(peopleCount);

      state = 3;   // wait until both sensors become clear
    }
  }

  else if (state == 2) {

    if (sensor1 == LOW) {

      if (peopleCount > 0) {
        peopleCount--;
      }

      Serial.print("PERSON EXITED | Count = ");
      Serial.println(peopleCount);

      state = 3;   // wait until both sensors become clear
    }
  }

  else if (state == 3) {

    if (sensor1 == HIGH && sensor2 == HIGH) {
      state = 0;
    }
  }

  if (peopleCount >= 1) {

    digitalWrite(GREEN_LED, HIGH);
    digitalWrite(RED_LED, HIGH);

  } else {

    digitalWrite(GREEN_LED, LOW);
    digitalWrite(RED_LED, LOW);
  }

  delay(50);
}
