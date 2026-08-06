; Macro to test max speed (M203) on X/Y axes
; Performs long movements at increasing speeds

M291 P"Starting speed test..." R"Speed Test" S0

G90                          ; Absolute positioning
G1 X0 Y0 F6000               ; Move to origin
M400                         ; Wait for moves to complete

; Define max speeds to test (in mm/min)
var speedValues = {3000, 6000, 9000, 12000, 15000}

var i = 0
while var.i < #var.speedValues
  var spd = var.speedValues[var.i]
  M291 P{"Testing speed: " ^ var.spd ^ " mm/min..."} R"Speed Test" S0
  M203 X{var.spd} Y{var.spd}     ; Set max speed for X/Y axes
  M400

  ; Move diagonally to test both X and Y
  G1 Z4
  G1 X100 Y100 F{var.spd}
  G1 X0 Y0 F{var.spd}

  M400
  G4 S2                          ; Wait 2 seconds

  M291 P{"Did it move smoothly at " ^ var.spd ^ " mm/min? Click OK to continue or cancel."} R"Speed Test" S3

  set var.i = var.i + 1

; Reset to default speed limits
M203 X6000 Y6000
M291 P"Speed test completed. Max speeds reset to 6000 mm/min." R"Done" S0_