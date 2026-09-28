# Log

## [2026-09-26] ingest | Fleet Nodes
Sourced from personal-pc-config wiki entities (nova-linux, machub, spark-a81e)
plus live SSH hardware query on nova-win for exact NVMe/RAM models.

## [2026-09-26] ingest | Network Gear
Sourced from personal-pc-config/network (UX7, MikroTik CRS310).

## [2026-09-26] ingest | Pricing
Sourced from user-provided Amazon order screenshots, user-confirmed paid
prices, and web research for MSRP/current market on major components.

## [2026-09-26] ingest | LinkedIn Post
Draft written to docs/LINKEDIN_POST.md, technical-showcase angle per user choice.

## [2026-09-26] ingest | Slide-out Tray CAD
v0.1 parametric OpenSCAD model drafted: mobo (offset right), GPU bracket
fin, PSU cradle, front rack ears, slide-rail mounting tabs. Caught and
fixed an ear-orientation bug during first render. Flagged rack_clear_width
and motherboard standoff holes as needing real measurement before print.

## [2026-09-26] ingest | Slide-out Tray CAD v0.2
Switched motherboard mount from flat/horizontal to vertical after the IO
shield needed to be front-facing (matches the current acrylic-plate
build's orientation). Added ATX-standard IO cutout (158.75x44.45mm),
raised tray_u_height 6->8, color-coded 4 subsystems (structural/mobo/
gpu/psu), exported per-part STLs. Caught and documented a --render vs
preview-mode PNG export pitfall that hid a real, correctly-cut IO
cutout from the v0.1 preview image (STL export was trustworthy the
whole time).

## [2026-09-26] ingest | Slide-out Tray CAD v0.3
Rebuilt around a "rear panel" model per front-panel layout description:
PSU top-right, GPUs stacked below (sized from RTX 5080's real 338x140x50mm,
4070 Ti unsourced/reused placeholder), mobo + spine in remaining column,
mounting flanges confirmed. Found real PSU+2GPU stack needs ~384mm vs
requested 8U (355.6mm) - flagged rather than silently shrinking sourced
dimensions. Fixed a leftover nonsense algebra bug in the GPU cutout width
expression caught during review before export.

## [2026-09-26] ingest | Slide-out Tray CAD v0.4
Corrected layout against docs/photos/rack-front.jpg after v0.3's guessed
arrangement was wrong (PSU top-right vs actual top-left, solid blanked
panels vs actual open bracket/shelf mounting). Sourced real Intel ATX
Spec 2.01 mounting hole tables: PSU 4-hole pattern (genuinely universal,
implemented directly) and motherboard 9-hole pattern (for a 305x244mm
board, adapted/scaled for the X670E ACE's 277x304.8mm size - not
verified against MSI's own drawing). Added a rack reference frame
modeled at the Tecmojo 12U rack's real sourced dimensions. Caught and
fixed a bug where the mobo panel was sized to a 130mm half-column but
the holes were computed for the real 277mm board, landing most holes
outside the visible panel - split into a front IO bezel + full-width
standoff plate set back in depth.


## [2026-09-28] ingest | Slide-out Tray CAD v0.5
Called out for three defects still present in v0.4's actual render, not
caught before shipping it. (1) IO cutout was cut in desktop-case
orientation (158.75mm wide) and didn't fit its own 130mm bezel column -
re-checked the photo, ports stack vertically, rotated the cutout 90deg
and gave the bezel its own column height. (2) Rack ears touched the base
plate along a single zero-area edge, not a real bonded joint - rebuilt
rack_ear() as an L-bracket with a foot overlapping the tray's full
height, and fixed the fit_check render sitting 33mm below the rack's
real first U (rack_rail_end_offset), which made the flanges look
disconnected from the rack's hole line in the visualization even though
the print geometry itself was periodic-correct. (3) GPU brackets had no
real mounting structure - added a support shelf the card's PCB rests on
plus a bracket screw hole sized from Protocase's ATX/PCI enclosure
design guide (2.71mm/0.1065in 6-32 tap, sized up to 3.5mm clearance for
plastic), which also independently confirmed the 20.32mm slot_pitch
already in the file. Re-exported all STLs (still NoError/manifold),
republished the viewer (v6).


## [2026-09-28] ingest | Slide-out Tray CAD v0.6
User: "you need to fucking scrap the design you made, its fucking
dogshit." Asked scope via clarifying question - user chose keep the
goal, restart the design from zero. Before rebuilding, re-checked the
v0.5 IO rotation against a zoomed crop of the real photo: it's a
completely standard MSI X670E ACE rear IO panel (2-row USB grid,
side-by-side WiFi antennas, audio row) - not rotated. v0.5's "fix" was
based on misreading normal port stacking as rotation evidence. Reverted.
Separately, re-checking every cutout against its own panel bounds (never
actually done before - only glanced at renders) found the PSU cutout
(150mm) was being cut from a 130mm-wide panel, same overflow class as
the IO bug, sitting undetected since v0.4. Root cause: the "two 130mm
half-columns" floorplan never fit either real component - not PSU
(150mm), not IO shield (158.75mm). Rebuilt column widths bottom-up from
real sourced sizes instead of an assumed 50/50 split. This surfaced a
real, previously-hidden conflict: psu_col_w + spine + io_col_w =
340.75mm, but rack_clear_width (the assumed rack interior width) is only
270mm - a 70mm gap. Made this visible instead of silently absorbing it:
rack_reference() still renders at the 270mm placeholder while the tray
sizes itself to what it actually needs, so fit_check now shows the tray
overhanging the rack posts. This is now the real blocker - needs an
actual rack measurement and a straight-on (not 3/4 angle) photo to
confirm PSU and mobo genuinely share one depth plane. Re-exported all
STLs (NoError/manifold), republished viewer (v7).
