---
type: topic
updated: 2026-09-26
sources: [cad/mobo-gpu-psu-tray.scad, cad/README.md]
---

# Slide-out Mobo/GPU/PSU Tray

v0.2 parametric OpenSCAD draft (`cad/mobo-gpu-psu-tray.scad`) for a rack
shelf that mounts the [[fleet-nodes|nova-linux]] motherboard vertically
(matching the current acrylic-plate build, not flat), offset from the
right edge, with a vertical GPU bracket in the remaining strip and a PSU
cradle on the floor — all on one tray that pulls out on off-the-shelf steel
ball-bearing drawer slides. Color-coded by subsystem (structural blue,
motherboard red, GPU bracket green, PSU purple) in both the OpenSCAD
preview and the 4 separate STL exports used by the interactive web viewer.

v0.1 mounted the board flat/horizontal; switched to vertical in v0.2 once
the IO shield needed to be front-facing — a flat mount puts the ports at
deck height facing sideways, unusable. The mounting plate now doubles as
the front IO bezel, with a cutout at the real ATX/EATX standard size
(158.75×44.45mm).

Not print-ready. Sourced specs (board size, EIA-310 standard, expansion-
slot pitch, ATX PSU footprint, IO shield cutout size) are trustworthy;
placeholders pending real measurement or dry-fit include rack interior
clear width (generic "10-inch rack" figures contradict a 277mm board
already fitting this rack), the IO cutout's exact position on the board,
GPU bracket slot position, and PSU depth. Motherboard standoff holes are
deliberately left unpunched — transfer from the existing working acrylic
plate rather than trust a generic ATX hole table.

Also caught a rendering pitfall worth remembering: `openscad -o file.png`
without `--render` uses preview mode, which can silently fail to show a
real, correctly-differenced cutout (the STL export was right the whole
time — only the PNG preview was misleading). Always pass `--render` for
preview images.

Full list of sourced-vs-placeholder dimensions: `cad/README.md`.

## See Also

- [[fleet-nodes]]
- [[rack-enclosure]]
