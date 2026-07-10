; Calibrate Y Axis Steps/mm
G91                          ; Relative mode
G1 Y100 F3000                ; Move 100 mm in Y
G90                          ; Back to absolute mode

; ==> Measure actual movement and calculate correction as:
; New steps/mm = (current_steps/mm * commanded_distance) / actual_distance
; Update example:
; M92 Y80.0