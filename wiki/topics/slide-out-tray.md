---
type: topic
updated: 2026-09-26
sources: [cad/mobo-gpu-psu-tray.scad, cad/README.md, docs/photos/rack-front.jpg]
---

# Slide-out Mobo/GPU/PSU Tray

v0.4 parametric OpenSCAD draft (`cad/mobo-gpu-psu-tray.scad`). Layout
verified against the actual build photo, not guessed: PSU top-left (open
bracket, exposed face), motherboard IO shield top-right, two GPUs
full-width below (open brackets, coolers exposed, slot-down), center
spine, outer mounting flanges. Real sourced mounting holes for the PSU
(genuinely universal 4-hole ATX pattern) and an adapted version of the
real 9-hole ATX standoff pattern for the motherboard (scaled for the
X670E ACE's non-standard width — not verified against MSI's own drawing).
A reference rack frame, modeled at the Tecmojo 12U rack's real sourced
dimensions, lets the fit be checked visually.

## History

- v0.1: flat/horizontal motherboard mount.
- v0.2: switched to vertical mounting, added the IO cutout.
- v0.3: reframed as a case rear-panel layout — but guessed the
  arrangement (PSU top-right, GPUs stacked under it, mobo full left
  column) instead of checking the photo. Wrong.
- v0.4: corrected against `docs/photos/rack-front.jpg` after being called
  out for not looking at it. Added real sourced mounting holes (PSU
  4-hole, mobo 9-hole adapted) and a rack reference frame. Caught a real
  bug mid-build: the motherboard's visible panel was sized to a 130mm
  half-column but the real board is 277mm wide, so most of the 9
  standoff holes computed to positions outside the panel. Fixed by
  splitting the motherboard into a narrow front-facing IO bezel (matches
  what's visible in the photo) and a full-board-width standoff plate set
  back in depth.

## [[fleet-nodes]] cross-reference

PSU: Corsair RM850e. Motherboard: MSI MEG X670E ACE (277×304.8mm — the
sourced standard-ATX hole table is for 305×244mm, hence the adaptation).
GPUs: RTX 5080 (real dims sourced) + RTX 4070 Ti (unsourced, reuses the
5080's numbers as a placeholder).

Full sourced-vs-placeholder table: `cad/README.md`.

## See Also

- [[fleet-nodes]]
- [[rack-enclosure]]
