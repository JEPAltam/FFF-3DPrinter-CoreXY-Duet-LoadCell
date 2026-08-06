# 04 — Future Work


---

## Summary

The reactivated and upgraded FFF 3D printer platform has demonstrated its capability to produce parts with acceptable print quality, and the Duet Maestro 2-based control system has proven to be a reliable and scalable alternative for the recovery and reuse of legacy or out-of-service FFF devices.

The integrated load-cell module successfully enabled real-time extrusion force sensing, allowing the determination of operational limits for the current hardware configuration and the identification of rheological behavior and material-dependent constraints during filament feeding.

However, in the current version a direct communication link between the Duet Maestro 2 control system and the force data acquisition module was not implemented. This represents the most significant open development opportunity for groups building on this platform.


---

## Proposed Future Directions

### 1. Migration to Duet 3 and Closed-Loop Extrusion Force Control

**Priority: High**

The most impactful next step is to migrate the control architecture to a **Duet 3 6HC** board and implement direct communication between the load cell acquisition module and the RepRapFirmware motion controller.

This would enable **closed-loop, force-regulated extrusion control**, in which the measured extrusion force feeds back directly into the firmware to:
- Adjust feed speed or temperature in real time based on the rheological state of the material.
- Automatically prevent extruder skip events without operator intervention.
- Maintain a consistent deposition volume across varying material properties and environmental conditions.

**Implementation path:**
- [ ] Replace Duet Maestro 2 with Duet 3 6HC.
- [ ] Implement direct SBC (Single Board Computer) or CAN-bus interface between Arduino Nano HX711 reader and Duet 3.
- [ ] Develop a firmware plugin or `daemon.g` macro that reads force values and issues adaptive feed rate corrections via `M220` or `M221`.
- [ ] Characterize the control loop response time and tune PID/adaptive parameters.
- [ ] Validate closed-loop performance with the skip onset thresholds documented in the article (Table 12).

---

### 2. Automated Bed Leveling via Load-Cell Contact Sensing

**Priority: Medium**

The existing bending-beam load cell integrated into the extruder assembly can be repurposed as a **contact-based Z-probe** for automatic bed leveling, eliminating the need for manual feeler gauge adjustment.

**Concept:**
- Lower the nozzle toward the bed at slow speed.
- Detect the moment of contact by monitoring the load cell signal for a force threshold (e.g., > 0.5 N above tare).
- Record the Z-coordinate at contact for each probing point.
- Build a mesh compensation map in RepRapFirmware using `G29` routines.

**Advantages over conventional inductive or BLTouch probes:**
- No additional hardware required — uses the existing load cell.
- Direct nozzle-bed contact measurement eliminates probe offset calibration.
- Works on any bed surface material (glass, PEI, silicone).

**Implementation path:**
- [ ] Implement a threshold-based contact detection routine in the Arduino TX sketch.
- [ ] Establish a GPIO or serial communication channel from Arduino to Duet board for contact event signaling.
- [ ] Configure `G29` probing macro to trigger on contact signal.
- [ ] Validate levelness repeatability (target: < 0.05 mm variation across the 200 mm bed diameter).

---

### 3. Load Cell Geometry Optimization for FFF Print Heads

**Priority: Medium**

The current 75 mm commercial bending-beam load cell, while effective, adds mass and volume to the extruder carriage. A purpose-designed load cell geometry would:
- Reduce sensor footprint and mass (target: < 5 g sensor mass).
- Improve integration compatibility with compact direct-drive extruder designs.
- Reduce signal noise by shortening the mechanical path between the drive gear and the sensing element.
- Minimize thermal conduction from the hotend to the strain gauge zone.

**Design directions to explore:**
- S-type or shear-beam geometries machined from aluminum 6061 or titanium.
- MEMS-based force sensors for ultra-compact integration.
- Flexible PCB-mounted strain gauges directly bonded to the extruder body.

**Implementation path:**
- [ ] FEA simulation of candidate geometries under expected extrusion force range (0–25 N).
- [ ] Prototype fabrication via CNC machining or EDM.
- [ ] Calibration and noise characterization vs. current 75 mm beam sensor.
- [ ] Integration into a revised extruder carriage CAD assembly.

---

### 4. Rheological Model Integration

**Priority: Low–Medium**

With a calibrated force sensor and a direct firmware link (Direction 1), it becomes possible to develop and validate **real-time rheological models** that use the measured extrusion force as an input to estimate melt viscosity and predict optimal process parameters.

**Research questions:**
- Can the force–velocity relationship measured at steady state be used to identify a Power Law or Carreau viscosity model for a given material?
- Can transient force signatures during acceleration and deceleration phases be used to identify viscoelastic relaxation times?
- Can these models be updated in real time during printing to compensate for batch-to-batch material variability?

**Implementation path:**
- [ ] Collect force–velocity datasets across a wider temperature and material range (PETG, ABS, flexible TPU).
- [ ] Fit rheological models (Power Law, Carreau–Yasuda) to steady-state force data.
- [ ] Implement model-based feed forward control in firmware to pre-compensate for expected back-pressure changes.
- [ ] Validate printed part dimensional accuracy and surface quality vs. open-loop baseline.

---

### 5. Multi-Material and Advanced Material Printing

**Priority: Low**

The modular Duet 3 toolboard expansion capability (CAN-bus) and the reconfigurable hotend interface position this platform for:
- **Dual-extrusion** with independent temperature zones.
- **High-temperature polymers**: PEEK (≥ 400 °C nozzle), PEI/ULTEM, PPS.
- **Low-melting-point metal alloys**: Bi-Sn, In-Bi (Bowden-compatible at < 200 °C).
- **Fiber-reinforced filaments**: continuous carbon fiber, glass fiber.

Each of these directions would benefit from extrusion force monitoring to characterize the unique rheological behavior of the material and set appropriate operational limits.

---

## Contributing

If you build on this platform and implement any of the directions above, contributions are welcome:

1. Fork this repository.
2. Create a feature branch: `git checkout -b feature/closed-loop-force-control`
3. Commit your changes with descriptive messages.
4. Open a Pull Request with a description of what was implemented and validated.

Please include:
- Updated CAD files (STEP format) if mechanical changes were made.
- Updated firmware configuration files if RRF macros were modified.
- A brief description of experimental results or validation data.

---

## Contact

**Jhon E. Puerta Altamiranda** — jhon.puerta@upb.edu.co  
**Hader V. Martinez Tejada** — hader.martinez@upb.edu.co  
Universidad Pontificia Bolivariana, School of Engineering, Medellín, Colombia

---

*For build instructions, see [01_Build_Instructions.md](01_Build_Instructions.md).*  
*For operation instructions, see [02_Operation.md](02_Operation.md).*  
*For load cell calibration, see [03_LoadCell_Calibration.md](03_LoadCell_Calibration.md).*
