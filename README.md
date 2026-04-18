# Productivity Index Calculator

**Darcy Radial Flow — Steady State**

Interactive tool for calculating the **Productivity Index (PI)** of oil wells using Darcy's radial flow equation under steady-state conditions.

![Productivity Index Diagram](docs/pi_diagram.png)

---

## Equations

**Productivity Index:**

```
PI = 0.00708 × h × k / [ B × μ × (ln(R/rw) + S) ]
```

**Flow Rate:**

```
Q = PI × (P_R − P_BH)
Q_BH = Q × B
```

### Variable Definitions

| Symbol | Description | Unit |
|--------|-------------|------|
| `h` | Reservoir thickness | ft |
| `k` | Effective permeability | mD |
| `B` | Formation volume factor | rb/stb |
| `μ` | Viscosity | cp |
| `R` | Well drainage radius | ft |
| `rw` | Wellbore radius | ft |
| `S` | Skin factor | dimensionless |
| `P_R` | Reservoir pressure | psi |
| `P_BH` | Bottom hole flowing pressure | psi |
| `Q` | Stock tank flow rate | stb/day |
| `Q_BH` | Bottom hole flow rate | rb/day |

---

## Project Structure

```
productivity-index-calculator/
├── index.html                  # Web application (standalone)
├── matlab/
│   ├── productivity_index.m    # Core PI calculation function
│   ├── sensitivity_analysis.m  # Sensitivity analysis & plots
│   └── run_examples.m          # Example runner script
├── docs/
│   └── pi_diagram.png          # Reference diagram
└── README.md
```

---

## Web Application

Open `index.html` in any modern browser. No dependencies or build step required.

### Features

- **Real-time calculation** — results update as you type
- **IPR Curve** — Inflow Performance Relationship with operating point and AOF
- **Sensitivity Analysis** — Multi-curve IPR for k, h, S, μ, B
- **Skin Analysis** — PI vs Skin factor bar chart with damage/stimulation zones
- **Responsive** — Works on desktop and mobile

### Deploy to GitHub Pages

```bash
# In your repo settings, enable GitHub Pages from the main branch
# The app will be available at https://<user>.github.io/productivity-index-calculator/
```

---

## MATLAB Scripts

### Requirements

- MATLAB R2018b or later (tested on R2024a)

### Quick Start

```matlab
% Run all examples
run_examples

% Or calculate directly
params.h = 50; params.k = 100; params.B = 1.2;
params.mu = 0.8; params.R = 1000; params.rw = 0.328;
params.S = 0; params.P_R = 4000; params.P_BH = 2000;

results = productivity_index(params);
```

### Scripts

| File | Description |
|------|-------------|
| `productivity_index.m` | Core function: calculates PI, Q, Q_BH with input validation |
| `sensitivity_analysis.m` | Generates IPR curves, skin sensitivity, permeability sensitivity, PI vs Skin charts |
| `run_examples.m` | Runs 4 example cases (no damage, damaged, stimulated, low perm) with comparison table |

---

## Theory

The productivity index relates the well's flow rate to the pressure drawdown. It depends on reservoir properties (h, k), fluid properties (B, μ), well geometry (R, rw), and completion quality (S).

- **S < 0**: Stimulated well (acidized or fractured)
- **S = 0**: Ideal well, no formation damage
- **S > 0**: Damaged well (mud invasion, clay swelling, etc.)

The constant `0.00708` comes from unit conversion in field units:

```
0.00708 = 2π / (ln(10) × 887.22)  [field unit conversion]
```

---

## Author

**Enrique Philippe Gutiérrez Fedoruk**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/enrique-philippe-guti%C3%A9rrez-fedoruk-493060123/)

---

## License

MIT License — free to use, modify, and distribute. **Attribution required**: you must keep the copyright notice and author credit in all copies or substantial portions of the code.

See [LICENSE](LICENSE) for full text.
