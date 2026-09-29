---
type: topic
updated: 2026-09-29
sources: [cad/tray-v1/README.md, cad/tray-v1/report.json, docs/photos/rack-front.jpg]
---

# Slide-out Mobo/GPU/PSU Tray

**Current: v1.0, rebuilt from zero** (`cad/tray-v1/`; source and audit in `asset-forge/3d-design/assets/rack-tray/`).
An 8U, 10-inch faceplate with corrected EIA-310 ear holes and a printed chassis behind it. The
board stands edge-on like in a PC tower: IO edge to the front, portrait IO window, a printed frame
carrying the ten ATX standoff holes, hanging out the back. PSU top-left on a shelf with four
screw holes and a window; two GPUs bottom-left, fingers down, bracket ports through windows, tab
screws to a ledge. 280 numeric checks pass, nine deliberate sabotages of the builder are each
caught. Still needs: a measured rack opening (222.25 mm assumed), slide hardware, PSU depth and
screw-pattern handedness, GPU B dimensions, a dry fit. See [[fleet-nodes]] for the components.

The OpenSCAD v0.1-0.6 below are kept as history only.

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
- v0.6: user called the whole design "dogshit" and asked for the mobo
  mount rebuilt from zero. Re-examining before rebuilding found the v0.5
  IO rotation was itself wrong — a zoomed crop of the photo shows a
  completely standard MSI ACE rear IO panel (2-row USB grid, side-by-side
  antennas), not a rotated one; reverted. Independently, re-checking
  panel-vs-cutout bounds (which nobody had actually done, just eyeballed
  renders) found the PSU cutout (150mm) was being cut from a 130mm-wide
  panel — same overflow bug as the IO cutout, never caught. Root cause:
  the "two 130mm half-columns" floorplan never fit either real
  component. Rebuilt column widths bottom-up from real part sizes
  (`psu_col_w`=156mm, `io_col_w`=174.75mm), which surfaced a genuine
  width conflict: side by side they need 340.75mm, and the rack's
  assumed clear width is only 270mm (itself unmeasured). Made this
  visible rather than hidden: `rack_reference()` still draws its posts
  at the 270mm placeholder while the tray is sized to what it actually
  needs, so the fit_check render now shows the tray overhanging the
  posts. Blocking on a real rack-width measurement and a straight-on
  plan-view photo to confirm the PSU and mobo really share one depth
  plane.

## [[fleet-nodes]] cross-reference

PSU: Corsair RM850e. Motherboard: MSI MEG X670E ACE (277×304.8mm — the
sourced standard-ATX hole table is for 305×244mm, hence the adaptation).
GPUs: RTX 5080 (real dims sourced) + RTX 4070 Ti (unsourced, reuses the
5080's numbers as a placeholder).

Full sourced-vs-placeholder table: `cad/README.md`.

## See Also

- [[fleet-nodes]]
- [[rack-enclosure]]
- v1.0 (2026-09-29): scrapped and rebuilt with a verification-first workflow after being told the
  design was wrong. Root cause of everything before: the photo was read, not measured. The IO strip
  in the photo measures ~59 x 152 mm next to a PSU face of known 150 x 86 mm, which puts the board
  edge-on with a portrait shield; every earlier version modelled a flat plate facing the front, so
  each "fix" (rotate the cutout, split the columns, add a spine) patched a wrong model. v0.6's
  341 mm-versus-270 mm "width conflict" was an artifact of that misreading. Also wrong before and
  fixed now: EIA-310 hole positions (6.35 / 22.225 / 38.1 mm, not 6.35 / 15.875 / 25.4), the board
  axes (304.8 mm is the IO edge, 277 the depth) so the scaled "adapted" ATX hole table was
  invalid, and the ATX hole table itself (10 holes, read from the Protocase drawing at 300 dpi).
  The new checker's first run caught two more of my mistakes before printing: two bolts landing in a
  lightening cut-out and a cutter nicking a plate by 1 mm.
