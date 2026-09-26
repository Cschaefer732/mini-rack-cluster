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
