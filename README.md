# FFF-3DPrinter-CoreXY-Duet-LoadCell

[![License: CERN OHL v2](https://img.shields.io/badge/Hardware-CERN%20OHL%20v2-blue)](https://ohwr.org/cern_ohl_s_v2.txt)
[![License: GPL v3](https://img.shields.io/badge/Software-GPL%20v3-green)](https://www.gnu.org/licenses/gpl-3.0)
[![HardwareX](https://img.shields.io/badge/Journal-HardwareX-orange)](https://www.journals.elsevier.com/hardwarex)

Reactivation and upgrading of a legacy CubeX Duo 3D printer into a fully open-source CoreXY Fused Filament Fabrication (FFF) platform with integrated load-cell extrusion force sensing.

**Authors:** Jhon E. Puerta Altamiranda, Luis M. Aristizabal Gomez, Hader V. Martinez Tejada, Carlos A. Zuluaga, Nicolas R. Ortiz, Luis F. Lalinde,  
**Institution:** Universidad Pontificia Bolivariana, School of Engineering, Medellín, Colombia  
**Article:** Submitted to HardwareX (Elsevier), 2025

---

## Overview

Rather than constructing a new printer from scratch, this project demonstrates a reproducible methodology for **reactivating legacy FFF devices** using open-source hardware. Reusable components from the original CubeX Duo — including NEMA 17 stepper motors, structural steel tubes, and linear shafts — are retained and integrated into a fully redesigned CoreXY platform controlled by a **Duet Maestro 2** board running RepRapFirmware 3.

<<<<<<< HEAD
The platform integrates a **bending-beam load cell** directly into the extruder assembly for real-time extrusion force measurement. Force data are transmitted wirelessly via an NRF24L01 module, enabling untethered acquisition during full-range CoreXY motion. This allows characterization of nozzle back-pressure, detection of extruder skip events, and determination of operational feed speed limits.
=======
This work is submitted for publication in **HardwareX** (Elsevier).

**Authors:** Jhon E. Puerta Altamiranda, Luis M. Aristizabal Gomez, Hader V. Martinez Tejada, Carlos A. Zuluaga
**Institution:** Universidad Pontificia Bolivariana, School of Engineering, Medellín, Colombia  

---

## Key Features

- Reproducible reactivation methodology for legacy FFF printers
- CoreXY kinematic architecture on reused CubeX Duo structural frame
- 450 mm MGN12H linear guide for the extruder carriage
- Bending-beam load cell (75 mm, 1 kg) for real-time extrusion force measurement
- Wireless force data transmission via NRF24L01 (untethered during printing)
- Duet Maestro 2 + RepRapFirmware 3 control system
- Extrusion force characterization: 195–210 °C, 5–50 mm/s, Generic PLA
- All files released under open-source licenses

---

## Hardware Summary

| Parameter | Value |
|-----------|-------|
| Printer type | CoreXY FFF |
| Build volume | ~200 × 200 × 200 mm |
| Control board | Duet Maestro 2 |
| Firmware | RepRapFirmware 3 |
| X/Y motors | NEMA 17, 0.6 N·m (×2) |
| Z motor | NEMA 23, 1.3 N·m |
| Extruder motor | NEMA 17, Bowden |
| X-axis guide | MGN12H, 450 mm |
| Hotend | 3DV5, 0.4 mm nozzle, 24 V |
| Heated bed | Round, 200 mm dia., 24 V / 120 W |
| Load cell | Bending beam, 75 mm, 1 kg, ±0.05% FS |
| ADC amplifier | HX711, 24-bit |
| Wireless module | NRF24L01 + antenna |
| Power supply | MeanWell LRS-350-24, 24 V / 14.6 A |
| Estimated cost | ~$960 USD |

---

## Extrusion Force Results

| Temperature | Stable regime | Skip onset | Max recommended speed |
|-------------|--------------|-----------|----------------------|
| 195 °C | ≤ 10 mm/s | ~20 mm/s | **10 mm/s** |
| 200 °C | ≤ 10 mm/s | ~20 mm/s | **10 mm/s** |
| 210 °C | ≤ 10 mm/s | ~20–33 mm/s | **20 mm/s** |

Skip onset identified by periodic force oscillations and fit quality R² < 0.92.

---

## Repository Structure

```
FFF-3DPrinter-CoreXY-Duet-LoadCell/
│
├── README.md
├── LICENSE                           # CERN OHL v2
├── CONTRIBUTING.md
│
├── docs/                             # Human-readable documentation
│   ├── 01_Build_Instructions.md
│   ├── 02_Operation.md
│   ├── 03_LoadCell_Calibration.md
│   ├── 04_Future_Work.md
│   └── images/                       # Photos and illustrations
│
├── mechanical/
│   ├── CAD/                          # Native Solid Edge files (.par / .asm
│   │    ├── 1.1_Parts/
│   │    │   ├── 1.1.1_Frame/             # Corner brackets, motor mounts, pulley supports, Z-axis parts
│   │    │   ├── 1.1.2_Print_head/        # Extruder carriage, hotend, cooling ducts, load cell parts
│   │    │   ├── 1.1.3_Electronic/        # Duet mount, sensor support, wire clips, endstop triggers
│   │    │   ├── 1.1.4_Motors_pulleys/    # Stepper motors, GT2 pulleys, belts, lead screw, coupling
│   │    │   ├── 1.1.5_Sliding_rail/      # MGN12H linear guide components
│   │    │   ├── 1.1.6_Bed/               # Heated bed mount, centring brackets, bed support
│   │    │   └── 1.1.7_Extruder/          # Extruder body, idler mechanism, Bowden assembly, spool holder
│   │    └── 1.2_Assemblys/
│   │        ├── 1.2.1_AMS/               # Full system assembly
│   │        └── 1.2.2_STEP/              # Full system assembly (.step, cross-platform)                  
│   ├── drawings/                     # Dimensioned technical drawings (PDF)
│   └── bom/
│       └── BOM.xlsx                  # Complete bill of materials
│
├── electronics/
│   ├── wiring_diagrams/              # Wiring schematic PDFs
│   └── schematics/                   # electronics schematics (PDF files or other sources)
|
├── firmware/
│   ├── duet/
│   │   └── sys/                      # config.g, bed.g, homeall.g, etc.
│   └── arduino/
│       ├── RF21TX_HX711.ino          # Transmitter: load cell + NRF24L01
│       └── RF21RX_HX711.ino          # Receiver: wireless force data logging
│
└── media/                            # Visual assets
    ├── photos/
    │   ├── assembly/
    │   ├── print_head/
    │   └── finished_machine/
    └── videos/                       # Assembly or test videos
```

---

## Getting Started

### 1. CAD Files
Open the assembly in **Solid Edge 2025** (`mechanical/cad/solide/`) or import the **STEP file** (`mechanical/cad/step/`) into any compatible CAD environment (Fusion 360, FreeCAD, SolidWorks).

### 2. Firmware
Copy the contents of `firmware/duet/sys/` to the `/sys` folder on the Duet Maestro 2 SD card. Connect via Ethernet and access **Duet Web Control (DWC)** to upload macros and verify the configuration.

Full documentation: https://docs.duet3d.com/Duet3D_hardware/Duet_2_family/Duet_2_Maestro

### 3. Arduino Sketches
Open in **Arduino IDE 2.x**. Upload `firmware/arduino/RF21TX_HX711.ino` to the Arduino Nano on the extruder carriage and `RF21RX_HX711.ino` to the receiving Arduino Nano. Run `hx711_calibration.ino` first to determine the HX711 scale factor.

Required libraries: `HX711` by Bogdan Necula · `RF24` by TMRh20

### 4. Documentation
See the `docs/` folder for the full build, operation, and calibration guides:

- [01 — Build Instructions](docs/01_Build_Instructions.md)
- [02 — Operation Instructions](docs/02_Operation.md)
- [03 — Load Cell Calibration](docs/03_LoadCell_Calibration.md)
- [04 — Future Work](docs/04_Future_Work.md)

---

## Licenses

| Content | License |
|---------|---------|
| Hardware (CAD, drawings, schematics) | [CERN OHL v2](https://ohwr.org/cern_ohl_s_v2.txt) |
| Firmware and software | [GPL v3](https://www.gnu.org/licenses/gpl-3.0) |
| Documentation | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) |

Reference geometry files for commercial components are included for assembly reference only and carry no open-source license.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute to this project.

---

