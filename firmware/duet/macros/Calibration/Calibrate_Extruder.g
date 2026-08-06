; Calibrate Extruder Steps/mm
; Heat up before extruding

M104 S200                    ; Set hotend to 200°C
M109 S200                    ; Wait until hotend reaches 200°C
G92 E0                       ; Reset extruder position
G1 E100 F100                 ; Extrude 100 mm of filament

; ==> Measure how much filament actually moved (from mark)
; New steps/mm = (current_steps/mm * commanded_length) / actual_length
; Update:
; M92 E95.45