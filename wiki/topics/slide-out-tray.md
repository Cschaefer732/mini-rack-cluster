---
type: topic
updated: 2026-09-28
sources: [cad/mobo-gpu-psu-tray.scad, cad/README.md, docs/photos/rack-front.jpg]
---

# Slide-out Mobo/GPU/PSU Tray

v0.5 parametric OpenSCAD draft (`cad/mobo-gpu-psu-tray.scad`). Layout
verified against the actual build photo, not guessed: PSU top-left (open
bracket, exposed face), motherboard IO shield top-right (cutout rotated
90&deg; — ports stack vertically in the photo, not side by side), two GPUs
full-width below (open brackets, coolers exposed, slot-down, now with a
real support shelf + sourced screw hole each), center spine, outer
mounting flanges (rebuilt as bonded L-brackets, not floating posts). Real
sourced mounting holes for the PSU (genuinely universal 4-hole ATX
pattern) and an adapted version of the real 9-hole ATX standoff pattern
for the motherboard (scaled for the X670E ACE's non-standard width — not
verified against MSI's own drawing). A reference rack frame, modeled at
the Tecmojo 12U rack's real sourced dimensions, lets the fit be checked
visually.

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
- v0.5: three more defects caught by actually re-rendering and looking,
  called out directly after v0.4 shipped with them still present. (1) IO
  cutout was cut in desktop-case orientation and didn't even fit its own
  column — rotated 90&deg; to match the photo's vertically-stacked ports.
  (2) Rack ears touched the base plate along a single zero-area edge —
  rebuilt as real L-brackets with a foot that bonds the full ear height,
  plus fixed the fit-check visualization sitting 33mm below the rack's
  real first U, which made the flanges look disconnected from the rack's
  hole line even though the print geometry was fine. (3) GPU brackets had
  no actual mounting structure — no shelf bearing the card's weight, no
  real screw spec. Added a support shelf plus a bracket screw hole sized
  from Protocase's ATX/PCI enclosure design guide (also independently
  confirms the 20.32mm slot pitch already in the file).

## [[fleet-nodes]] cross-reference

PSU: Corsair RM850e. Motherboard: MSI MEG X670E ACE (277×304.8mm — the
sourced standard-ATX hole table is for 305×244mm, hence the adaptation).
GPUs: RTX 5080 (real dims sourced) + RTX 4070 Ti (unsourced, reuses the
5080's numbers as a placeholder).

Full sourced-vs-placeholder table: `cad/README.md`.

## See Also

- [[fleet-nodes]]
- [[rack-enclosure]]
