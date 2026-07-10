; === Auto PID Tune para Hotend (H1) ===
; Ejecuta PID tuning y entrega los parámetros para actualizar en config.g

M291 R"Autotune PID - Hotend" P"Este proceso tomará varios minutos. Asegúrate de que el hotend esté libre y la fuente encendida." S3

; Inicia PID autotune a 200 °C
M303 H1 S200

; Espera a que finalice, luego mostrarás el resultado manualmente
M291 R"PID Tuning Finalizado" P"Revisa la consola. Copia la línea que empieza con M307 H1 y pégala en config.g para reemplazar el modelo térmico anterior." S2 T10