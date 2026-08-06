#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
#include "HX711.h"

// ---------- HX711 ----------
const int DOUT = A0;
const int CLK  = A1;
HX711 balanza;

// ---------- NRF24 ----------
#define CE_PIN 9
#define CSN_PIN 10
byte direccion[6] = "canal";
RF24 radio(CE_PIN, CSN_PIN);

// ---------- Paquete ----------
struct Paquete {
  float fuerza_N;
  unsigned long tiempo;
};

Paquete datos;

void setup() {
  Serial.begin(9600);

  // HX711
  balanza.begin(DOUT, CLK);
  balanza.set_scale(-650485);
  balanza.tare(20);

  // NRF24
  radio.begin();
  radio.setChannel(100);
  radio.setDataRate(RF24_250KBPS);
  radio.setPALevel(RF24_PA_LOW);


  radio.openWritingPipe(direccion);
  radio.stopListening();

  Serial.println("Sistema listo (HX711 + NRF24)");
}

void loop() {


  float fuerzaN = balanza.get_units() * 9.80665f;

  
  datos.fuerza_N = fuerzaN;
  datos.tiempo = millis();
  
  bool ok = radio.write(&datos, sizeof(datos));

  if (ok) {
    Serial.print("Enviado | Fuerza: ");
  } else {
    Serial.print("ERROR envio NRF24 | Fuerza: ");
  }

  Serial.print(datos.fuerza_N, 2);
  Serial.println(" N");  

  delay(100);
}
