; Macro to test jerk (M566) on X/Y axes
; Performs small rapid moves to evaluate max instantaneous speed changes

M291 P"Starting jerk test..." R"Jerk Test" S0

G90                         ; Use absolute positioning
G1 X0 Y0 F6000              ; Move to center
M400                        ; Wait for current moves to complete

; Define jerk values to test (in mm/min)
var jerkValues = {300, 500, 700, 800, 1000, 1100, 1300}

var i = 0
while var.i < #var.jerkValues
  var jer = var.jerkValues[var.i]
  M291 P{"Testing jerk: " ^ var.jer ^ " mm/min..."} R"Jerk Test" S0
  M566 X{var.jer} Y{var.jer} ; Set jerk for X and Y axes
  M400

  ; Perform test motion
  G91                      ; Enable relative positioning
  G1 X2 F6000
  G1 X-2 F6000
  G1 Y2 F6000
  G1 Y-2 F6000
  G90                      ; Return to absolute positioning

  M400
  G4 S3                    ; Wait 3 seconds before next step

  M291 P{"Did it move smoothly at " ^ var.jer ^ " mm/min? Click OK to continue or cancel."} R"Jerk Test" S3

  set var.i = var.i + 1

; Reset jerk to default
M566 X300 Y300
M291 P"Test completed. Jerk reset to 300 mm/min" R"Done" S0
