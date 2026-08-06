#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>

#define CE_PIN 9
#define CSN_PIN 10
byte direccion[6] = "canal";

RF24 radio(CE_PIN, CSN_PIN);

struct Paquete {
  float fuerza_N;
  unsigned long tiempo;
};

Paquete datos;

void setup() {
  Serial.begin(9600);

  radio.begin();
  radio.setChannel(100);
  radio.setDataRate(RF24_250KBPS);
  radio.setPALevel(RF24_PA_LOW);
  
  radio.openReadingPipe(0, direccion);
  radio.startListening();

  Serial.println("Receptor listo");
}

void loop() {

  if (radio.available()) {

    radio.read(&datos, sizeof(datos));

    // Print data in CSV format
    Serial.print(datos.fuerza_N);
    Serial.print(",");               // Separator
    Serial.println(datos.tiempo);    // New line at end

  }
}