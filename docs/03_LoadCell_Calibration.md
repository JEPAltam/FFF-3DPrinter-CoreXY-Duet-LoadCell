# 03 — Load Cell Calibration

---

## Table of Contents

1. [Hardware Overview](#1-hardware-overview)
2. [Required Equipment](#2-required-equipment)
3. [Calibration Procedure](#3-calibration-procedure)
4. [Scale Factor Equation](#4-scale-factor-equation)
5. [Verification](#5-verification)
6. [Data Acquisition](#6-data-acquisition)
7. [Interpreting Force Signals](#7-interpreting-force-signals)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. Hardware Overview

The force sensing module consists of three components:

| Component | Description | Location |
|-----------|-------------|----------|
| `Load_cell_75mm` | Bending-beam load cell, 75 mm, 1 kg capacity, ±0.05% FS | Mounted between `Sensors_support_arm` (fixed end) and `Extruder_body` (free end) |
| `HX711` | 24-bit ADC amplifier board | Mounted on `Sensors_support` plate on extruder carriage |
| Arduino Nano (TX) | Microcontroller running `RF21TX_HX711.ino` | Mounted on `Sensors_support` plate on extruder carriage |
| Arduino Nano (RX) | Microcontroller running `RF21RX_HX711.ino` | Stationary receiver connected to host computer via USB |
| NRF24L01 + antenna | Wireless 2.4 GHz transceiver | One on each Arduino Nano |

**Measurement principle:**  
The load cell is clamped at its fixed end to the `Sensors_support_arm` and coupled at its free end to the extruder body. When the drive gear feeds filament, the reaction force bends the load cell beam. The HX711 amplifies the Wheatstone bridge differential signal and outputs a 24-bit ADC count proportional to the applied force.

---

## 2. Required Equipment

| Item | Specification |
|------|--------------|
| Calibrated digital scale | Truper, 5 kg capacity, 1 g resolution (or equivalent) |
| Reference weights | 200 g, 500 g, 800 g (or known masses) |
| Support bracket for weights | Custom printed bracket to hang weights below the nozzle |
| Host computer | With Arduino IDE installed |
| USB cable | For Arduino Nano (RX) connection |
| Arduino IDE | Version 2.x recommended |

**Required Arduino libraries:**
```
HX711 by Bogdan Necula
RF24 by TMRh20
```
Install via Arduino IDE → Tools → Manage Libraries.

---

## 3. Calibration Procedure

> 📁 Calibration sketch: `firmware/arduino/hx711_calibration.ino`  
> Perform calibration **before** first use and **every 50 print hours**.

### Step 1 — Upload the calibration sketch
Open the Arduino IDE and upload `hx711_calibration.ino` to the **transmitting Arduino Nano** mounted on the extruder carriage. Open the Serial Monitor at **115,200 baud**.

### Step 2 — Determine the print head baseline weight
Place the calibrated digital scale on the heated bed platform, centered below the nozzle. Lower the print head until it rests on the scale platform and record:
- The scale reading in grams → this is the **baseline weight** of the print head.

### Step 3 — Record the zero-load baseline (tare)
With **no additional load applied** to the load cell (print head in free air, not touching the scale), record the raw HX711 ADC output from the Serial Monitor. This is **ADC_tare**.

### Step 4 — Apply reference loads
Design and print the `Load_bracket` support to hang reference weights below the nozzle. Apply the following reference loads in sequence and record the ADC output for each:

| Reference load | Expected ADC output |
|---------------|---------------------|
| 200 g | Record as ADC_200 |
| 500 g | Record as ADC_500 |
| 800 g | Record as ADC_800 |

### Step 5 — Compute the scale factor

For each reference load, compute k using:

```
k = F_ref / (ADC_raw - ADC_tare)
```

where:
- **F_ref** = reference force in Newtons = m × g = m × 9.81 m/s²
- **ADC_raw** = HX711 24-bit output under load
- **ADC_tare** = no-load baseline recorded in Step 3

Average the three values of k obtained from the 200 g, 500 g, and 800 g loads.

### Step 6 — Enter the scale factor into the sketches
Open `RF21TX_HX711.ino` and `RF21RX_HX711.ino`. Locate the scale factor variable (typically named `SCALE_FACTOR` or `calibration_factor`) and enter the averaged value of k. Re-upload both sketches to their respective Arduino Nano boards.

---

## 4. Scale Factor Equation

$$k = \frac{F_{\text{ref}}}{\text{ADC}_{\text{raw}} - \text{ADC}_{\text{tare}}}$$

| Variable | Description | Unit |
|----------|-------------|------|
| k | Scale factor | N / ADC count |
| F_ref | Reference force = m × 9.81 | N |
| ADC_raw | HX711 24-bit output under load | counts |
| ADC_tare | HX711 output with no load | counts |

**Example:**

```
Reference mass: 500 g
F_ref = 0.500 kg × 9.81 m/s² = 4.905 N
ADC_tare = 12,450,000
ADC_raw  = 12,890,000

k = 4.905 / (12,890,000 - 12,450,000)
k = 4.905 / 440,000
k = 1.115 × 10⁻⁵ N/count
```

---

## 5. Verification

After entering the scale factor, verify calibration accuracy:

1. Apply three independent reference loads of different magnitudes (different from those used in calibration).
2. Read the force value from the Serial Monitor.
3. Confirm agreement with the scale reading to within **±1 g**.

| Condition | Action |
|-----------|--------|
| All readings within ±1 g | ✅ Calibration complete |
| Any reading exceeds ±1 g | ❌ Repeat from Step 3 with a fresh tare measurement |

> If repeated calibrations show high variability, inspect the load cell mounting bolts for looseness and check that the thermal isolation parts (`Load_cell_heat_skin_support` and `Load_cell_heat_skin_fastening`) are correctly fitted.

---

## 6. Data Acquisition

### Wireless force data stream

The transmitting Arduino Nano (`RF21TX_HX711.ino`) running on the extruder carriage:
- Reads the HX711 ADC output continuously.
- Applies the scale factor to compute force in Newtons.
- Transmits timestamped force values wirelessly at **10 Hz** via NRF24L01.

The receiving Arduino Nano (`RF21RX_HX711.ino`) connected to the host computer:
- Receives the wireless data stream.
- Outputs timestamped force values to the **Serial Monitor** at 115,200 baud.

### Saving data

Data is **not saved automatically**. To record a measurement session:

1. Open the Serial Monitor in the Arduino IDE.
2. Start the extrusion event or print job.
3. When the event is complete, **select all** text in the Serial Monitor window.
4. **Copy** (Ctrl+C) and **paste** into a spreadsheet (Excel, LibreOffice Calc) or text file.
5. The data format is: `timestamp_ms, force_N`

### Recommended data format (spreadsheet)

| Column A | Column B | Column C |
|----------|----------|----------|
| Time (ms) | Force (N) | Notes |
| 0 | 0.00 | Tare |
| 100 | 0.12 | Ramp-up |
| ... | ... | ... |

---

## 7. Interpreting Force Signals

### Stable extrusion regime

- Smooth, stable plateau in the force–time profile.
- High fit quality: **R² ≥ 0.97**
- Three repetitions show good agreement.

```
Force (N)
  |        ________
  |       /        \
  |      /          \
  |_____/            \____
  |
  +------------------------> Time (s)
       Stable plateau
```

### Skip / unstable regime

- Periodic high-amplitude oscillations.
- Force drops to **near-zero between peaks** (characteristic sawtooth pattern).
- Degraded fit quality: **R² < 0.92**

```
Force (N)
  |   /\    /\    /\
  |  /  \  /  \  /  \
  | /    \/    \/    \
  |/                  \___
  |
  +------------------------> Time (s)
    Sawtooth = extruder skip
```

### Operating limits (Generic PLA, 0.4 mm nozzle, Bowden configuration)

| Temperature | Stable regime | Skip onset | Max recommended |
|-------------|--------------|-----------|-----------------|
| 195 °C | ≤ 10 mm/s | ~20 mm/s | **10 mm/s** |
| 200 °C | ≤ 10 mm/s | ~20 mm/s | **10 mm/s** |
| 210 °C | ≤ 10 mm/s | ~20–33 mm/s | **20 mm/s** |

> These limits are material- and configuration-specific. Characterize for other materials by running the same protocol across temperatures and feed speeds of interest.

---

## 8. Troubleshooting

| Symptom | Likely cause | Solution |
|---------|-------------|---------|
| No data in Serial Monitor | Arduino Nano (RX) not connected / wrong COM port | Check USB connection and COM port in Arduino IDE |
| Force reads constant zero | Failed tare / HX711 not powered | Re-tare; verify 5 V supply to HX711 |
| Very noisy signal at rest | Loose load cell mounting bolts | Tighten M3×16 bolts at fixed and free ends |
| Calibration factor drifts between sessions | Thermal influence from hotend | Verify `Load_cell_heat_skin_support` and `Load_cell_heat_skin_fastening` are correctly fitted |
| R² always < 0.92 even at low speeds | Load cell beam deformed or overloaded | Check that applied forces did not exceed 1 kg capacity during previous use |
| NRF24L01 not transmitting | Antenna orientation / distance | Ensure antennas are parallel and distance < 10 m; reduce interference sources |

---

*For operation instructions, see [02_Operation.md](02_Operation.md).*  
*For future development directions, see [04_Future_Work.md](04_Future_Work.md).*
