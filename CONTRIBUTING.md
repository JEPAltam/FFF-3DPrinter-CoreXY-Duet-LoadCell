# Contributing

Thank you for your interest in contributing to this open-source hardware project. All types of contributions are welcome: bug fixes, design improvements, firmware changes, documentation, and experimental results from independent builds.

---

## How to Contribute

1. **Fork** the repository and create a feature branch:
   ```bash
   git checkout -b feature/your-description
   # Examples: fix/z-motor-mount-clearance, docs/petg-calibration-data
   ```

2. **Make your changes** following the guidelines below.

3. **Commit** with a short, descriptive message:
   ```bash
   git commit -m "fix: correct bore diameter in Z_Motor_mount2"
   ```

4. **Push** and open a **Pull Request** targeting `main`. Describe what was changed and how it was tested.

---

## Guidelines by Contribution Type

### CAD and Mechanical Files
- Provide files in **STEP format** (`.step`) as the primary exchange format. Native Solid Edge (`.par` / `.asm`) files are welcome as a supplement.
- Place native Solid Edge files in `mechanical/cad/solide/` and STEP exports in `mechanical/cad/step/`.
- Follow the existing naming convention: `Part_name_descriptor.par` (underscores, no spaces).
- If modifying a printed part, state the tested print settings (layer height, infill, material) in the PR description.

### Firmware and Sketches
- Test on physical hardware before submitting.
- Include a comment header with purpose, author, date, and tested version.
- Keep the HX711 sampling rate at **10 Hz** and the NRF24L01 RF channel unchanged unless a change is explicitly proposed and justified.

### Documentation
- Write in **American English**.
- Place new images in `docs/images/` as `.png` or `.jpg`.
- Follow the existing Markdown structure of the other docs files.

### Experimental Results
If you built this platform and collected force characterization data with a different material, nozzle, or hotend, share your results by opening an issue or PR. Include: material, nozzle diameter, hotend, temperatures tested, feed speeds, plateau forces (F_pl), R² values, and observed skip onset.

---

## Licenses

By contributing, you agree your work will be released under the same licenses as the existing content:

| Content | License |
|---------|---------|
| Hardware (CAD, schematics, drawings) | CERN OHL v2 |
| Firmware and software | GPL v3 |
| Documentation | CC BY 4.0 |

---

## Contact

**Jhon E. Puerta Altamiranda** — jhon.puerta@upb.edu.co  
**Hader V. Martinez Tejada** — hader.martinez@upb.edu.co  
Universidad Pontificia Bolivariana, School of Engineering, Medellín, Colombia
