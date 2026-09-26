---
type: topic
updated: 2026-09-26
sources: [cad/mobo-gpu-psu-tray.scad, cad/README.md]
---

# Slide-out Mobo/GPU/PSU Tray

v0.3 parametric OpenSCAD draft (`cad/mobo-gpu-psu-tray.scad`), rebuilt
around a "rear panel" model: this front face functions like a standard PC
case's rear panel (IO shield + PSU cutout + expansion-slot brackets), just
facing the rack's front. Four tiled, color-coded segments in both the
OpenSCAD preview and the interactive web viewer:

- **Structural (blue)** — base plate, rack ears (the flanges that screw
  the whole unit into the rack), spine divider, slide-rail tabs.
- **Motherboard (red)** — left column, IO cutout, unpunched standoff zone.
- **PSU (purple)** — top-right, real ATX cutout (150×86mm) + support shelf.
- **GPU (green)** — below the PSU, two stacked card cutouts sized from the
  [[fleet-nodes|nova-linux]] RTX 5080's real dimensions (338×140×50mm,
  sourced) — **the 4070 Ti was never looked up separately**, same numbers
  reused as a placeholder for it.

## History

- v0.1: flat/horizontal motherboard mount — wrong once the IO shield
  needed to be front-facing.
- v0.2: switched to vertical mounting (matches the current acrylic-plate
  build), added the IO cutout, still a floor-plan layout with the PSU as
  a separate floor cradle.
- v0.3: reframed as a case rear-panel layout per explicit front-panel
  description (PSU top-right, GPUs below with slot-down orientation, mobo
  + spine in the remaining column, gaps filled, mounting flanges). Found
  that the real PSU + 2 GPU stack needs ~384mm, ~28mm more than the
  requested 8U (355.6mm) — the model sizes ears/panel to the larger
  number rather than silently shrinking sourced dimensions to fit.

Also caught and documented a rendering pitfall: `openscad -o file.png`
without `--render` uses preview mode, which can silently fail to show a
real, correctly-differenced cutout (STL export was right the whole time —
only the PNG preview was misleading).

Full list of sourced-vs-placeholder dimensions: `cad/README.md`.

## See Also

- [[fleet-nodes]]
- [[rack-enclosure]]
