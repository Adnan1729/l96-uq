# l96-uq

Systematic uncertainty quantification for Lorenz-96 subgrid emulators.

A two-level Lorenz-96 system is used as a controlled testbed in which every source
of uncertainty in a learned subgrid closure can be switched on independently at a
known magnitude, and the true predictive distribution `p(U | X)` can be computed
exactly. The aim is not to compare UQ methods but to ask a prior question: when an
emulator reports uncertainty, which source is actually in that number?

## Setup

```bash
bash tasks.sh setup
```

Creates `.venv`, installs the package in editable mode with dev extras, and
verifies the import. Reload VS Code afterwards so it picks up the interpreter.

## Tasks

```bash
bash tasks.sh test        # full suite
bash tasks.sh test-fast   # skip long trajectory runs
bash tasks.sh lint
bash tasks.sh fmt
bash tasks.sh freeze      # pin requirements.txt
```

## Layout

| Path | Purpose |
|---|---|
| `src/l96uq/dynamics.py` | L96 truth model, integrator, diagnostics |
| `src/l96uq/sources.py` | the eight-source uncertainty registry and injectors |
| `src/l96uq/data.py` | `(X, U)` generation, splits, oracle `p(U\|X)` |
| `src/l96uq/predictive.py` | predictive-distribution abstraction |
| `src/l96uq/models.py` | deterministic / heteroscedastic / ensemble / GP |
| `src/l96uq/calibration.py` | split conformal, CQR |
| `src/l96uq/metrics.py` | CRPS, PIT, coverage, sharpness, spread–skill |
| `src/l96uq/attribution.py` | misattribution matrix |
| `src/l96uq/experiments/` | phase 0 (verification), phase 1 (attribution) |

## Status

Work in progress.
