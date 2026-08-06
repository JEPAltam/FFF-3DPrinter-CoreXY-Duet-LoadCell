; === Test Acceleration Macro ===
; This macro tests increasing acceleration on X/Y axes
; For CoreXY printers (head fixed, bed moves Z)

M291 P"Starting acceleration test..." R"Accel Test" S0

G90                          ; Absolute positioning
G1 X0 Y0 F6000           ; Move to center
M400                         ; Wait for moves to finish

; Define acceleration values to test (in mm/s²)
; Feel free to add/remove as needed
var accelValues = {300, 500, 700, 800, 900, 1000}

; Loop through each acceleration level
while iterations < #var.accelValues
  var acc = var.accelValues[iterations]
  M291 P{"Testing acceleration: " ^ var.acc ^ " mm/s²..."} R"Accel Test" S0
  M201 X{var.acc} Y{var.acc} ; Set XY acceleration
  M400                       ; Wait for any prior movement

  ; Perform back and forth test motion
  G91                        ; Relative positioning
  G1 X50 F6000
  G1 X-100 F6000
  G1 X50 F6000
  G1 Y50 F6000
  G1 Y-100 F6000
  G1 Y50 F6000
  G90                        ; Absolute positioning

  M400                       ; Wait for motion
  G4 S3                      ; Pause 3 seconds between steps
  M291 P{"Did it move smoothly at " ^ var.acc ^ " mm/s²? Click OK to continue or cancel."} R"Accel Test" S3

; Reset to default acceleration
M201 X300 Y300
M291 P"Test completed. Acceleration reset to 300 mm/s²" R"Done" S0