; Calibrate X Axis Steps/mm
; Move 100mm, measure actual travel, then adjust M92

G91                          ; Relative mode
G1 X100 F3000                ; Move 100 mm in X
G90                          ; Back to absolute mode

; ==> Measure how far it *actually* moved, then calculate:
; New steps/mm = (current_steps/mm * commanded_distance) / actual_distance
; Then update below:
; Example:
; M92 X80.1                  ; If corrected