# 02 — Operation Instructions

---

## Table of Contents

1. [System Startup](#1-system-startup)
2. [Pre-Print Preparation](#2-pre-print-preparation)
3. [Printing](#3-printing)
4. [Load Cell Operation and Force Monitoring](#4-load-cell-operation-and-force-monitoring)
5. [Safe Shutdown](#5-safe-shutdown)
6. [Maintenance Recommendations](#6-maintenance-recommendations)

---

## 1. System Startup

1. Verify that all mechanical sub-assemblies are correctly installed and that no tools, cables, or foreign objects are within the motion range of the CoreXY carriage or the Z-axis platform.

2. Connect the 24 V power supply to the mains supply. The Duet Maestro 2 control board will power on automatically and begin loading the RepRapFirmware 3 configuration.

3. Connect the host computer to the same local network as the Duet Maestro 2 via **Ethernet**. Open a web browser and navigate to the IP address assigned to the board to access **Duet Web Control (DWC)**.

4. In DWC, verify that all connected devices are recognized:
   - Three stepper motors for CoreXY motion (X, Y) and Z-axis
   - One extruder motor (E)
   - Three endstop switches
   - Hotend heater and thermistor
   - Heated bed heater and thermistor
   - Fan outputs
   
   > ⚠️ Any unrecognized device must be investigated before proceeding.

5. Execute the `homeall.g` macro from the DWC console to home all axes. Confirm that X, Y, and Z axes reach their endstop positions without mechanical interference and that the homing sequence completes without error.

---

## 2. Pre-Print Preparation

1. Preheat the hotend and heated bed by executing the preheating G-code in the DWC terminal. For PLA:
   - Hotend: **210 °C**
   - Bed: **60 °C**
   
   *(See slicer settings in [01_Build_Instructions.md](01_Build_Instructions.md#3-slicer-settings))*

2. Once temperatures are stable, perform a **manual bed leveling check** using a sheet of standard 80 g/m² paper as a feeler gauge. Adjust the four spring-loaded bed leveling screws until uniform drag resistance is achieved at each corner and at the bed center.

3. Load filament through the Bowden tube by commanding a controlled extrusion of **50–100 mm at 5 mm/s** from the DWC terminal. Confirm that filament exits the nozzle cleanly with no bubbling or color inconsistency before proceeding.

4. Slice the model in **OrcaSlicer 2.3.2** using the settings listed in the build instructions. Verify that the start and end G-code scripts are active in the slicer printer profile. Export the G-code file and upload it to the Duet Maestro 2 via DWC.

### Start G-code

```gcode
T0
M82            ; Absolute extrusion mode
G21            ; Units in millimetres
G90            ; Absolute positioning
G92 E0         ; Reset extruder position
G28            ; Home all axes
G29 S1         ; Load bed leveling mesh
G1 Z5.0 F3000  ; Raise Z to avoid scratching bed
G1 X-112 Y0 F3000
M104 S200      ; Set hotend temperature (no wait)
M140 S55       ; Set bed temperature (no wait)
M190 S55       ; Wait for bed temperature
M109 S200      ; Wait for hotend temperature
G1 Z5.0 F3000  ; Raise Z before purge
G1 X-112 Y0 F3000
G92 E0         ; Reset extruder
G1 Z0.2 F1500  ; Lower to purge height
G1 X-50 Y-100 F3000        ; Move to purge start
G1 X50  Y-100 E5 F800      ; Purge line, 100 mm
G92 E0         ; Reset extruder after purge
G1 Z2.0 F2400  ; Raise Z before print start
```

### End G-code

```gcode
G91            ; Relative positioning
G1 E-2 F2700   ; Retract filament 2 mm
G1 E-2 Z0.2 F2400  ; Retract and raise Z 0.2 mm
G1 X0 Y112 F3000   ; Wipe nozzle, move bed forward
G1 Z10             ; Raise Z 10 mm
G90            ; Absolute positioning
M106 S0        ; Turn off part cooling fan
M104 S0        ; Turn off hotend heater
M140 S0        ; Turn off heated bed
M84 X Y E      ; Disable X, Y and E steppers (Z held)
```

### G-code Command Reference

| Command | Function | Script |
|---------|----------|--------|
| `G28` | Home all axes | Start |
| `G29 S1` | Load saved bed leveling mesh | Start |
| `M104` | Set hotend temperature (async) | Start |
| `M140` | Set bed temperature (async) | Start / End |
| `M109` | Wait for hotend temperature | Start |
| `M190` | Wait for bed temperature | Start |
| `G92 E0` | Reset extruder position | Start |
| `G91` | Switch to relative positioning | End |
| `M106 S0` | Turn off part cooling fan | End |
| `M104 S0` | Turn off hotend heater | End |
| `M84` | Disable stepper motors | End |

---

## 3. Printing

1. Start the print job from the DWC job management panel. The start G-code will automatically execute axis homing, load the bed leveling mesh (`G29 S1`), heat the hotend and bed to target temperatures, and deposit a purge line before the print begins.

2. Monitor the **first layer** through DWC or directly at the machine. Verify that the first layer adheres uniformly to the bed surface with no lifting, gaps, or over-squish. If necessary, adjust the Z-offset in DWC using the **baby-stepping** feature without interrupting the print.

3. During printing, monitor the hotend and bed temperatures in the DWC temperature graph. Both should remain within **±2 °C** of the target values throughout the print.
   > Sustained deviation beyond this range indicates a PID tuning issue. Pause the print and investigate.

4. At the end of the print, the end G-code will automatically:
   - Retract the filament
   - Wipe the nozzle
   - Raise the Z-axis
   - Turn off heaters and fan
   - Disable X, Y, and E steppers while keeping the **Z stepper energized** to prevent bed drop

---

## 4. Load Cell Operation and Force Monitoring

1. Power on the Arduino Nano mounted on the extruder carriage by confirming that the Duet Maestro 2 auxiliary 5 V supply is active (verify the DC-DC converter LED indicator if present).

2. On the host computer, open the **Arduino IDE** and connect to the **receiving Arduino Nano** via USB. Open the Serial Monitor at **115,200 baud** to observe the real-time force data stream transmitted wirelessly by the NRF24L01 module from the extruder carriage.

3. Before any extrusion measurement, perform a **tare operation** by sending the tare command through the Serial Monitor with no load applied to the load cell. This resets the zero-load baseline (ADC_tare) to account for the weight of the extruder body and any pre-load in the bending beam.

4. To record extrusion force during a print or a manual extrusion event, open the Serial Monitor in the Arduino IDE at 115,200 baud while the `RF21RX_HX711.ino` sketch is running on the receiving Arduino Nano. The Serial Monitor displays timestamped force values at **10 Hz** in real time.
   > **Data is not saved automatically.** To save: select all output in the Serial Monitor window → copy → paste into a spreadsheet or text file of your choice.

5. **Interpret the force signal:**

   | Signal pattern | Interpretation |
   |---|---|
   | Smooth, stable plateau | Normal stable extrusion regime |
   | Periodic high-amplitude oscillations with force drops to near-zero | Extruder skip events |
   | R² < 0.92 combined with oscillatory morphology | Skip onset criterion |

   If skip events are detected during a print, reduce the feed speed or increase the nozzle temperature and repeat the affected section.

6. Use the table below as the reference for maximum recommended feed speeds to avoid operating in the skip regime:

   | Temperature | Stable up to | Skip onset | **Max recommended** |
   |-------------|-------------|-----------|---------------------|
   | 195 °C | 10 mm/s | ~20 mm/s | **10 mm/s** |
   | 200 °C | 10 mm/s | ~20 mm/s | **10 mm/s** |
   | 210 °C | 10 mm/s | ~20–33 mm/s | **20 mm/s** |

   > Limits are specific to the 3DV5 hotend, Bowden extruder geometry, and Generic PLA (1.75 mm).

---

## 5. Safe Shutdown

1. After the print is complete and the end G-code has executed, allow the **hotend to cool below 50 °C** before removing the printed part from the bed to avoid burns and to preserve bed adhesion.

2. Once hotend and bed temperatures have dropped below **40 °C**, execute the `M84` command in the DWC console to disable all stepper motors, including the Z-axis stepper.

3. Close the DWC session in the browser and disconnect the host computer from the network if no further prints are planned.

4. Switch off the 24 V power supply at the mains.
   > ⚠️ **Do not disconnect the power supply while the hotend is above 50 °C**, as this disables the thermal runaway protection managed by the Duet Maestro 2 firmware.

---

## 6. Maintenance Recommendations

| Interval | Task |
|----------|------|
| **Before each print** | Verify bed levelness with paper feeler gauge. Confirm Bowden tube connections are secure and free of debris. |
| **Every 20 print hours** | Clean nozzle exterior with IPA at operating temperature. Inspect GT2 belts for wear or loss of tension; re-tension if necessary. |
| **Every 50 print hours** | Perform load cell tare and verify calibration using a known reference mass (see [03_LoadCell_Calibration.md](03_LoadCell_Calibration.md)). Lubricate MGN12 linear rail carriage with a small amount of machine oil. |
| **Every 100 print hours** | Inspect all crimped wire connections at Duet Maestro 2 terminal blocks. Verify Z-axis lead screw alignment and anti-backlash nut preload. Perform PID auto-tune if temperature stability has degraded. |

---

*For load cell calibration procedure, see [03_LoadCell_Calibration.md](03_LoadCell_Calibration.md).*  
*For future development directions, see [04_Future_Work.md](04_Future_Work.md).*
