---
type: topic
updated: 2026-09-26
sources: [cad/mobo-gpu-psu-tray.scad, cad/README.md]
---

# Slide-out Mobo/GPU/PSU Tray

v0.1 parametric OpenSCAD draft (`cad/mobo-gpu-psu-tray.scad`) for a rack
shelf that mounts the [[fleet-nodes|nova-linux]] motherboard offset from
the right edge, a vertical GPU bracket in the remaining strip, and a PSU
cradle — all on one tray that pulls out on off-the-shelf steel ball-bearing
drawer slides.

Not print-ready. Renders clean, exports a manifold STL, but several
dimensions are sourced specs (board size, EIA-310 rack standard, expansion-
slot pitch, ATX PSU width/height) while others are placeholders pending
real measurement (rack interior clear width — the generic "10-inch rack"
figure contradicts the fact that a 277mm board already fits this rack) or
physical dry-fit (GPU bracket slot position, motherboard standoff holes —
deliberately left unpunched, to be transferred from the existing working
acrylic plate rather than guessed from a generic ATX table).

Full list of sourced-vs-placeholder dimensions: `cad/README.md`.

## See Also

- [[fleet-nodes]]
- [[rack-enclosure]]
