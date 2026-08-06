# 01 — Build Instructions

> **Platform:** Reactivation and Upgrading of a Legacy FFF 3D Printer Using an Open-Source Duet Framework with Integrated Load-Cell Extrusion Force Sensing  
> **Repository:** [FFF-3DPrinter-CoreXY-Duet-LoadCell](https://github.com/JEPAltam/FFF-3DPrinter-CoreXY-Duet-LoadCell)  
> **Reference article:** HardwareX (submitted 2025)

---

## Table of Contents

1. [Reactivation and Upgrading Strategy](#1-reactivation-and-upgrading-strategy)
2. [Tools Required](#2-tools-required)
3. [Slicer Settings](#3-slicer-settings)
4. [Assembly](#4-assembly)
   - [4.1 Extruder and Load-Cell Module](#41-extruder-and-load-cell-module)
   - [4.2 Main Frame](#42-main-frame)
   - [4.3 Z-Axis Drive](#43-z-axis-drive)
   - [4.4 Heated Bed](#44-heated-bed)
   - [4.5 Full System Integration](#45-full-system-integration)
5. [Electrical Build](#5-electrical-build)
6. [Firmware Configuration](#6-firmware-configuration)

---

## 1. Reactivation and Upgrading Strategy

The build process follows four sequential stages:

```
System Assessment → Architectural Redesign → Electronics Migration → Commissioning & Validation
```

### Stage 1 — System Assessment
- Fully disassemble the legacy CubeX Duo printer.
- Evaluate and catalogue all components.
- Conduct a metrological study on mechanical elements.
- Retain verified parts: NEMA 17 stepper motors, structural frame tubes, linear shafts, electrical harnesses.
- Discard damaged or incompatible components.

### Stage 2 — Architectural Redesign
- Define the new CoreXY kinematic architecture.
- Model all new components in CAD (Solid Edge 2025 — files in `1.2_Assemblys/`).
- Manufacture or modify parts as required:
  - FFF-printed parts: fabricated in PLA on any standard FFF printer.
  - Precision interfaces (bushing bores): finish-machined on a vertical milling machine.
- Integrate the load-cell force sensing module and auxiliary sensors.

### Stage 3 — Electronics Migration
- Replace the legacy control board with the **Duet Maestro 2**.
- Back up legacy firmware using **YAT serial terminal** before removal.
- Install Duet Maestro 2 in the lower chassis compartment.
- Crimp and route all wiring through the cable drag chain.
- Connect HX711 load cell amplifier and Arduino Nano data acquisition module.
- Run a verification test to confirm all actuators and sensors are recognized.

### Stage 4 — Commissioning and Validation
- Configure **RepRapFirmware 3 (RRF)** on the Duet Maestro 2 (see `1.5_Duet_configuration/sys/`).
- PID auto-tune hotend and heated bed.
- Validate motion: endstops, homing sequences, axis smoothness, belt tension.
- Run the Benchy benchmark print to verify dimensional accuracy.

---

## 2. Tools Required

| No. | Tool | Where Used |
|-----|------|-----------|
| 1 | Hex key (Allen) set, metric M2–M5 | All M3×5 to M3×50, M4×10, M5×12 socket cap screws |
| 2 | Phillips screwdriver PH1/PH2 | Microswitch screws (M1.6×10), panel fasteners |
| 3 | Adjustable wrench / spanner set | M3 hex nuts (DIN 934), M5 round-head screws |
| 4 | Digital caliper, 150 mm | Dimensional metrology, bushing bore inspection |
| 5 | **Vertical milling machine** | Finish-machine `Linear_slide_bush_L/R` and `Z-sliding_bushing_L/R` bores |
| 6 | Bench vise | Supporting parts during drilling and press-fitting |
| 7 | Hand drill / drill press, HSS bits 2–8 mm | Clearance holes in reused CubeX frame elements |
| 8 | Wire stripper and cutter | All wiring harness preparation |
| 9 | Crimping tool + bootlace ferrule assortment | Duet Maestro 2 terminal block connections |
| 10 | Multimeter (DC voltage / continuity) | Wiring continuity and 24 V output verification |
| 11 | Soldering iron + solder 60/40 | Load cell signal cable connections to HX711 |
| 12 | Heat-shrink tubing + heat gun | Insulating soldered joints |
| 13 | Cable tie gun + cable ties 2.5 mm | Securing wiring along the cable drag chain |
| 14 | Spirit level, 300 mm | Frame plumb and bed levelness verification |
| 15 | Steel ruler and measuring tape | Belt length, frame squareness, lead screw alignment |
| 16 | Medium-grit sandpaper (120) | Smoothing FFF-printed parts and sliding surfaces |
| 17 | Isopropyl alcohol (IPA) + lint-free cloth | Bed surface cleaning and metal interface degreasing |
| 18 | Laptop / PC with Ethernet | Duet Web Control (DWC) firmware upload and commissioning |
| 19 | YAT serial terminal (software) | Legacy firmware backup before board migration |
| 20 | Arduino IDE (software) | Upload HX711 acquisition sketches |

> ⚠️ The **only machine tool** required is a vertical milling machine, used exclusively to finish-machine the four custom linear bushing bores (~10 mm material removal).

---

## 3. Slicer Settings

All structural and functional PLA parts were sliced with **Creality Print 7.0**.

| Parameter | Setting |
|-----------|---------|
| Material | Generic PLA |
| Nozzle diameter | 0.4 mm |
| Layer height | 0.2 mm |
| Infill density | 70 % |
| Nozzle temperature | 210 °C |
| Bed temperature | 60 °C |
| Cooling fan | 100 % |
| Support material | Tree supports (selective) |

Parts with self-supporting geometries were printed without supports to reduce material use and post-processing time.

---

## 4. Assembly

> 📁 All assembly drawings are in `mechanical/drawings/Assembly_drawing.pdf`.  
> 📁 Full CAD assembly: `mechanical/cad/solide/` (Solid Edge) or `mechanical/cad/step/` (STEP).

### 4.1 Extruder and Load-Cell Module

> Reference: Figure 4 in the article / `Assembly_drawing.pdf` page 1.

Five sub-assemblies in recommended build order:

**Step 1 — Sensors module (item 1)**
- Mount HX711 amplifier board, Arduino Nano, and NRF24L01 antenna onto the `Sensors_support` base plate using M3×5 set screws.
- Pre-wire all boards **before** attaching to the carriage — underside access becomes restricted once the arm is installed.

**Step 2 — Load cell and sensor arm (item 2)**
- Attach `Sensors_support_arm` to the rear face of the extruder carriage plate.
- Mount the 75 mm bending-beam load cell between the fixed end of the arm and the extruder body interface using M3×16 screws — leave the strain gauge zone unobstructed.
- Secure the sensors module (Step 1) to the top of the support arm.
- Route load cell signal wires (shielded 4-wire) **before** installing the extruder body.

**Step 3 — Extruder body and drive mechanism (item 3)**
- Mount NEMA 17 stepper motor to `Extruder_body` with four M3×12 socket head cap screws.
- Slide hobbed MK8 drive gear onto motor shaft and secure with set screw, aligning the hobbed groove with the filament path.
- Assemble idler tension arm, idler pivot bearing, and spring-loaded tensioning mechanism.
- Bolt assembled extruder body to the carriage plate and to the **free end of the load cell beam** using M3×25 screws — this completes the force-sensing mechanical loop.

**Step 4 — Print head and cooling assembly (item 4)**
- Insert 3DV5 hotend into `Extruder_mount` and secure with M3×16 screws.
- Attach 40×20 mm radial blower fan (`4020TB`) to `4020TB_support` bracket.
- Clip `Duct_Blower1` and `Duct_Blower2` around the nozzle tip.
- Mount 40×10 mm axial fan (`Fan4010`) on the hotend heatsink face.
- Attach complete print head sub-assembly to the bottom face of the extruder carriage plate.

**Step 5 — Hotend and nozzle assembly (item 5)**
- Thread heat break into heat block and torque at operating temperature (210 °C).
- Install 0.4 mm nozzle into heat block, torqued hot.
- Fit `Load_cell_heat_skin_support` and `Load_cell_heat_skin_fastening` isolators between hotend and load cell mount.
- Thread PC4-M6 pneumatic PTFE coupler (`Fitting`) into the top of the heat break.

> Once all five sub-assemblies are integrated, route the wiring harness through `Energy_chain` and verify all connectors before installing the carriage on the MGN12 rail.

---

### 4.2 Main Frame

> Reference: Figure 5 in the article / `Assembly_drawing.pdf` page 2.

Three critical interface zones (A, B, C):

**Detail A — Leveling foot and vertical post interface**
- Terminate each vertical post with an adjustable leveling foot (M5×12 + M5 nut).
- Verify plumb with a spirit level in two orthogonal directions before tightening.
- Insert horizontal frame tubes and clamp with M3×20 screws.
- Assemble all four corners simultaneously, finger-tight, until squareness is confirmed (diagonal measurement). Torque in a diagonal sequence.

**Detail B — Corner bracket and motor mount assembly**
- Fit printed `Corner_bracket` parts (FL, FR, L, R) at the top corners.
- Secure with M3×30 socket head cap screws and M3 hex nuts in the printed nut traps.
- Bolt `Motor_mount_bracket` (L and R) to the top face of the corner bracket assembly using M3×25 screws — leave partially loose until GT2 belt routing and tensioning are complete.

**Detail C — MGN12 linear rail and pulley mount assembly**
- Align 450 mm MGN12H linear rail along the front top cross-tube and secure with M3×12 screws.
- Verify rail straightness with a digital caliper before final tightening.
- Assemble idler pulley stacks (16-tooth toothed idler + spacers + M3 shoulder bolt) and insert into `Pulley_mount_bracket` before attaching to the frame.
- Slide MGN12H carriage block onto rail **before** installation — do not remove afterward.

**Belt routing (after A, B, C are complete)**
- Lower belt: motor A → carriage block → idler B.
- Upper belt: motor B → carriage block → idler A.
- Adjust tension symmetrically by sliding motor mounts; verify by audible tone (plucking).
- Confirm squareness: diagonal difference < 1 mm before proceeding.

---

### 4.3 Z-Axis Drive

> Reference: Figure 6 in the article / `Assembly_drawing.pdf` page 5.

| Sub-assembly | Key steps |
|---|---|
| **Motor mount** | Bolt `Z_Motor_mount1` and `Z_Motor_mount2` to lower chassis using M3×25 + M3 nuts. Verify co-axial alignment with spirit level. |
| **Stepper motor** | Insert NEMA 23 (57 mm, 1.2 N·m) from below; secure with four M3×12 screws. Route cables before fully tightening. |
| **Flexible coupling** | Slide `Flexible_coupling_6mm` onto motor shaft; secure with set screw (1.5 mm hex key). Leave 1–2 mm axial gap inside coupling for thermal expansion. |
| **Lead screw** | Insert T10 trapezoidal lead screw into upper half of coupling; secure. Verify zero radial runout by hand rotation. Thread T10 anti-backlash nut before installation; bolt to underside of `Heat_bed_mount` using M3×12 screws. |
| **Smooth rods** | Insert two 8 mm hardened steel rods (`Z-smooth_rod`) through `Linear_slide_bush_L/R`. Fix at top and bottom with M3×20 screws through rod end clamps. Verify parallelism with digital caliper: variation < 0.3 mm over full travel. |

---

### 4.4 Heated Bed

> Reference: Figure 7 in the article / `Assembly_drawing.pdf` page 3.

| Sub-assembly | Key steps |
|---|---|
| **Bed mount plate** | Bolt anti-backlash lead screw nut to underside. Press `Linear_slide_bush_L/R` machined bushings into rod guide holes (confirm orientation before pressing). |
| **Centering brackets** | Bolt two `Bed_support` triangular brackets to top face using M3×20 + M3 nuts. Verify equal distance from each bracket to plate edge with digital caliper. |
| **Heated bed** | Place circular `Heat_bed` (200 mm, 24 V, 120 W) on brackets. Position `Clamp_centering_bracket` parts over bed rim and secure with M3×16 screws. Route power and thermistor cables through the clearance slot before tightening. |
| **Leveling system** | Fit M3×50 socket head cap screw + `Leveling_spring` + M3 nut at each corner. Leave screws partially loose for leveling adjustment during commissioning. |

---

### 4.5 Full System Integration

> Reference: Figure 8 in the article / `Assembly_drawing.pdf` page 6.

Two critical integration zones (D, E):

**Detail D — Z-endstop, cable drag chain, and electronics mount**
- Bolt `Z-Endswitch_trigger` to left lateral post at Z-home height (nozzle clearance ~0.1–0.2 mm). Adjust by sliding vertically before final tightening.
- Mount `Duet3D_board_separator` spacer on lower chassis panel; secure Duet Maestro 2 on top with M3×5 set screws.
- Anchor `Energy_chain` fixed end to the left lateral frame member and moving end to the extruder carriage plate. Route: stepper motor, hotend heater, thermistor, fans, load cell signal cable.

**Detail E — Heated bed integration on Z-axis platform**
- Slide `Linear_slide_bush_L/R` bushings over smooth rods from above; engage anti-backlash nut onto lead screw.
- Leave four spring-loaded leveling screws partially loose for commissioning adjustment.
- Route bed power and thermistor cables downward along the left Z-axis rod to Duet Maestro 2 heater and thermistor terminals.

**Electronics enclosure**
- Left side of lower chassis panel: Duet Maestro 2 control board (M3×12).
- Right side: MeanWell LRS-350-24 power supply (`Power_supply_24v`, M3×12).
- Adjacent to Duet: DC-DC buck converter (`DC-DC_3A_converter`) for 5 V Arduino/NRF24L01 logic rail.
- Crimp all power connections with bootlace ferrules before inserting panel into chassis.
- Route Ethernet cable from Duet Maestro 2 to rear of enclosure for DWC access.

**Bowden tube routing**
- Cut PTFE Bowden tube to required length (extruder coupler to hotend coupler) with sufficient slack for full XY travel.
- Route through `Energy_chain` alongside carriage wiring.
- Mount filament spool on `Filament_spool_holder_support` rods at rear of frame.

**Final wiring verification**
- Verify all connections with multimeter (continuity + correct polarity).
- Confirm stepper motor phase pairs.
- Measure 24 V at Duet Maestro 2 VIN terminals.
- Power on only after verification passes.

---

## 5. Electrical Build

> 📁 Wiring schematics: `electronics/wiring_diagrams/`
> 🔗 Official Duet Maestro 2 documentation: https://docs.duet3d.com/Duet3D_hardware/Duet_2_family/Duet_2_Maestro

Three wiring documents included:

| File | Content |
|------|---------|
| `Wiring_diagram_Duet.pdf` | Power distribution, stepper driver connections, endstops, heater/thermistor assignments, fan outputs |
| `Wiring_diagram_LoadCell_HX711.pdf` | Load cell 4-wire connection to HX711, wiring to Arduino Nano, NRF24L01 wireless interface |
| `Duet2Maestro_Connectors.pdf` | Connector and pinout overview of the Duet Maestro 2 board (adapted from Duet3D CC-BY-SA 3.0) |

**Key wiring assignments summary:**

| Subsystem | Connection |
|-----------|-----------|
| CoreXY motors A and B | X and Y driver outputs |
| Extruder motor | E driver output |
| Z-axis motor (NEMA 23) | Z driver output |
| X/Y endstops | Dedicated endstop inputs (NO configuration) |
| Z endstop | Z endstop input (NO configuration) |
| Hotend heater (24 V) | Heater output E0 |
| Hotend thermistor | Thermistor input E0 |
| Heated bed (24 V, 120 W) | Bed heater output |
| Bed thermistor | Bed thermistor input |
| Hotend heatsink fan | Always-on fan output |
| Part-cooling fan | Controllable fan output |
| Load cell | HX711 amplifier → Arduino Nano → NRF24L01 wireless |
| Power supply | MeanWell 24 V → Duet VIN terminals |
| 5 V logic rail | DC-DC buck converter (24 V → 5 V) → Arduino / NRF24L01 |

---

## 6. Firmware Configuration

> 📁 Configuration files: `firmware/duet/sys/`

| File | Purpose |
|------|---------|
| `config.g` | CoreXY kinematics, axis mapping, steps/mm, motor currents, acceleration limits, thermal parameters, Ethernet settings |
| `bed.g` | Bed leveling mesh routine |
| `homeall.g` | Combined full-system homing sequence |
| `homex.g` | X-axis homing macro |
| `homey.g` | Y-axis homing macro |
| `homez.g` | Z-axis homing macro |

**First-time setup steps:**
1. Copy contents of `firmware/duet/sys/` to the `/sys` folder on the Duet Maestro 2 SD card.
2. Connect to the board via Ethernet and open **Duet Web Control (DWC)** in a web browser.
3. Upload macros through the DWC interface.
4. Run `homeall.g` to verify homing sequences.
5. Perform PID auto-tune for hotend and heated bed from DWC.
6. Verify steps/mm using a known-length reference move and a digital caliper.

---

*For operation instructions, see [02_Operation.md](02_Operation.md).*  
*For load cell calibration, see [03_LoadCell_Calibration.md](03_LoadCell_Calibration.md).*
