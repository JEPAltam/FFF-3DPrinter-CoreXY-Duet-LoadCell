; === Verificar Heater y Sensor del Hotend (H1) ===

; Mostrar temperatura del hotend en consola
M308 S1

; Esperar 2 segundos
G4 S2

; Establecer temperatura baja para probar
M104 S50

; Esperar 10 segundos para ver si sube
G4 S10

; Detener calentador por seguridad
M104 S0

; Mostrar mensaje de finalización
M291 P"Heater verificado. Verifica en DWC que la temperatura haya subido. Luego reactiva el modelo térmico con M307 autocalibrado." R"Verificación completada" S1 T5