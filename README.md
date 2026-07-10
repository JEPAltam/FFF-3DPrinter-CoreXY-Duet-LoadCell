# FFF-3DPrinter-CoreXY-Duet-LoadCell
Open-source reactivation of a legacy CubeX Duo FFF 3D printer into a CoreXY platform with Duet Maestro 2 control and integrated load-cell extrusion force sensing. CAD files, RepRapFirmware config, and Arduino sketches. 
# Reactivation and Upgrading of a Legacy FFF 3D Printer Using an Open-Source Duet Framework with Integrated Load-Cell Extrusion Force Sensing

## Overview

This repository contains all design files, firmware configurations, electrical schematics, and data acquisition code associated with the reactivation and upgrading of a legacy CubeX Duo 3D printer (3D Systems, 2012–2013) into a fully open-source CoreXY Fused Filament Fabrication (FFF) platform. The system is controlled by a Duet Maestro 2 board running RepRapFirmware 3 and incorporates a bending-beam load cell for real-time extrusion force sensing with wireless data transmission via NRF24L01.

This work is submitted for publication in **HardwareX** (Elsevier).

**Authors:** Jhon E. Puerta Altamiranda, Luis M. Aristizabal Gomez, Hader V. Martinez Tejada, Carlos A. Zuluaga
**Institution:** Universidad Pontificia Bolivariana, School of Engineering, Medellín, Colombia  
**Funding:** MINCIENCIAS, project No. 106389933103565, Convocatoria 933 of 2023

---

## Key Features

- Reproducible methodology for reactivating legacy FFF printers using open-source hardware
- CoreXY kinematic architecture built on reused CubeX Duo structural components
- MGN12H 450 mm linear guide for the extruder carriage
- Integrated bending-beam load cell (75 mm, 1 kg) for real-time extrusion force measurement
- Wireless force data transmission via NRF24L01 (untethered measurement during printing)
- Duet Maestro 2 control board with RepRapFirmware 3
- Extrusion force characterisation across 195–210 °C and 5–50 mm/s for Generic PLA
- All files released under open-source licenses (CERN OHL v2 / GPL v3)

---

## Repository Structure

```
├── 1.1_Parts/
│   ├── 1.1.1_Frame/             # Corner brackets, motor mounts, pulley supports, Z-axis parts
│   ├── 1.1.2_Print_head/        # Extruder carriage, hotend, cooling ducts, load cell parts
│   ├── 1.1.3_Electronic/        # Duet mount, sensor support, wire clips, endstop triggers
│   ├── 1.1.4_Motors_pulleys/    # Stepper motors, GT2 pulleys, belts, lead screw, coupling
│   ├── 1.1.5_Sliding_rail/      # MGN12H linear guide components
│   ├── 1.1.6_Bed/               # Heated bed mount, centring brackets, bed support
│   └── 1.1.7_Extruder/          # Extruder body, idler mechanism, Bowden assembly, spool holder
├── 1.2_Assemblys/
│   ├── 1.2.1_AMS/               # Full system assembly (.asm, Solid Edge 2025)
│   └── 1.2.2_STEP/              # Full system assembly (.step, cross-platform)
├── 1.3_Drawings/                # Dimensioned technical drawings (PDF)
├── 1.4_Wiring_diagram/          # Electrical schematics (PDF)
│   ├── Wiring_diagram_Duet3.pdf
│   └── Wiring_diagram_LoadCell_HX711.pdf
├── 1.5_Duet_configuration/
│   └── sys/                     # RepRapFirmware 3 config and macro files (.g)
│       ├── config.g
│       ├── bed.g
│       ├── homeall.g
│       ├── homex.g
│       ├── homey.g
│       └── homez.g
├── 1.6_Arduino_configuration/   # Arduino sketches (.ino)
│   ├── RF21TX_HX711.ino         # Transmitter: load cell acquisition + NRF24L01
│   ├── RF21RX_HX711.ino         # Receiver: wireless force data logging
│   └── hx711_calibration.ino    # Load cell calibration routine
└── README.md
```

---

## Hardware Summary

| Parameter | Value |
|---|---|
| Printer type | CoreXY FFF |
| Build volume | ~200 × 200 × 200 mm |
| Control board | Duet Maestro 2 |
| Firmware | RepRapFirmware 3 |
| X/Y motors | NEMA 17 (×2), 0.6 N·m |
| Z motor | NEMA 23, 1.3 N·m |
| Extruder motor | NEMA 17 (Bowden) |
| X-axis guide | MGN12H, 450 mm |
| Hotend | 3DV5, 0.4 mm nozzle, 24 V |
| Heated bed | Round, 200 mm dia., 24 V / 120 W |
| Load cell | Bending beam, 75 mm, 1 kg, ±0.05% FS |
| ADC amplifier | HX711, 24-bit |
| Wireless module | NRF24L01 + antenna |
| Power supply | MeanWell LRS-350-24, 24 V / 14.6 A |
| Estimated cost | ~960 USD (see BOM in article) |

---

## Getting Started

### 1. CAD Files
Open the assembly files in **Solid Edge 2025** (`.asm`) or import the neutral **STEP files** (`.step`) into any compatible CAD environment (Fusion 360, FreeCAD, SolidWorks, etc.).

### 2. Firmware Configuration
Copy the contents of `1.5_Duet_configuration/sys/` to the `/sys` folder on the Duet Maestro 2 SD card. Access the board via **Duet Web Control (DWC)** through the Ethernet interface to upload macros and verify configuration.

> Full documentation: https://docs.duet3d.com/Duet3D_hardware/Duet_2_family/Duet_2_Maestro

### 3. Arduino Sketches
Open the sketches in **Arduino IDE 2.x**. Upload `RF21TX_HX711.ino` to the Arduino Nano mounted on the extruder carriage and `RF21RX_HX711.ino` to the receiving Arduino Nano. Run `hx711_calibration.ino` first to determine the HX711 scale factor.

**Required libraries:**
- `HX711` by Bogdan Necula
- `RF24` by TMRh20

### 4. Printing
Slice models in **OrcaSlicer 2.3.2** using the settings in Table 8 of the article. Use the start and end G-code provided in Section 5.6 of the article.

---

## Extrusion Force Results Summary

| Temperature | Stable regime | Skip onset | Max recommended speed |
|---|---|---|---|
| 195 °C | ≤ 10 mm/s | ~20 mm/s | **10 mm/s** |
| 200 °C | ≤ 10 mm/s | ~20 mm/s | **10 mm/s** |
| 210 °C | ≤ 10 mm/s | ~20–33 mm/s | **20 mm/s** |

Skip onset identified by periodic force oscillations and fit quality R² < 0.92.

---
