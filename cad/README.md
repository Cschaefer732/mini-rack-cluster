# CAD — mobo/GPU/PSU slide-out tray

`mobo-gpu-psu-tray.scad` — parametric OpenSCAD model. Every dimension that
matters is a named variable at the top of the file with a comment saying
whether it's a sourced spec or a placeholder you need to verify.

**Status: v0.4 draft, not print-ready.** Manifold STLs export clean
(`NoError` on the combined model and all per-part exports, including the
new rack reference frame). Real sourced mounting holes for PSU and
(adapted) motherboard are now cut into the geometry. Still not dry-fit
against real hardware.

## v0.4 — real mounting holes, rack reference frame, layout fixed from the photo

- **Layout corrected against the actual build photo**
  (`docs/photos/rack-front.jpg`), not a guess: PSU top-left (open bracket,
  exposed face, no blanking panel — matches the photo), motherboard IO
  shield top-right, two GPUs full-width below as open brackets with
  coolers exposed and slot/connector end down, center spine, outer
  mounting flanges. Everything before this was wrong — PSU was in the
  wrong corner and the whole thing used solid blanked panels instead of
  open bracket/shelf mounting like the real build.
- **Real PSU screw holes.** Sourced from Intel ATX Spec 2.01, Fig. 9 — the
  actual 4-hole pattern (asymmetric, not a rectangle) for a standard
  150×86mm ATX PSU rear face. High confidence — this is a genuinely
  universal spec.
- **Adapted motherboard standoff holes.** Sourced the real standard-ATX
  9-hole table from the same spec, Fig. 3 — but it's for a 305×244mm
  board, and the X670E ACE is 277×304.8mm. Applying the coordinates
  unscaled would put 3 of 9 holes off the board's edge. X is scaled by
  277/305; Y is left unscaled (EATX boards conventionally keep the
  standard hole positions near the IO edge and add length below rather
  than stretching everything). Cut as small slots, not tight holes, for
  adaptation tolerance. **Not verified against MSI's actual drawing —
  cross-check against the existing acrylic plate before drilling.**
- **Rack reference frame** (`render_part="rack_reference"`), modeled at
  the Tecmojo 12U 10in rack's real sourced dimensions (280×260×635.8mm,
  44.45mm U-pitch, 33mm rail end offset) so the tray's fit can be checked
  visually, not just assumed. Not a printable part.
- **`rack_clear_width` reasoning changed.** The research pass found an
  uncaptioned 210mm figure on the manufacturer's diagram, explicitly
  flagged as uncertain — and it contradicts the photo (a 277mm board is
  visibly mounted). Using 270mm instead (overall width minus an assumed
  rail-wall thickness). Still a placeholder either way.
- **Caught and fixed a real geometry bug during this pass**: the first
  draft sized the motherboard's visible panel to `half_width` (130mm) and
  positioned the real 9-hole pattern relative to that column — but the
  board is 277mm wide, so most holes computed to X positions outside the
  visible panel entirely. Fixed by splitting the motherboard into two
  pieces: a narrow front-facing IO bezel (matches what's actually visible
  in the photo) and a separate full-board-width standoff plate set back
  in depth (runs behind both the PSU and IO columns, which is physically
  necessary since the real board is wider than either column alone).

## Before printing

1. **Measure `rack_clear_width`.** Currently 270mm, reasoned from overall
   width minus assumed wall thickness — not measured.
2. **Cross-check the adapted motherboard holes** against the existing
   acrylic plate. They're derived from a real spec but scaled for a
   different board size than the source table covers.
3. **Verify the IO cutout position** — size (158.75×44.45mm) is a real
   universal standard; its position on the board is still a placeholder.
4. **Verify the PSU holes** land correctly relative to your specific
   RM850e — the 4-hole ATX pattern is genuinely universal, but confirm
   `psu_d` (140mm, estimated) against the real unit too.
5. **Source the 4070 Ti's real dimensions** — the GPU segment still uses
   the 5080's numbers (338×140×50mm) for both cutouts.
6. **Dry-fit the GPU bracket** slot positions — still a placeholder
   fixture, not measured against real riser routing.
7. **Confirm slide hardware and `slide_hole_pitch`.**
8. **Resolve the 8U vs. ~384mm gap** (see below) before committing to ear
   height.

## Sourced (trustworthy) vs. placeholder (verify) dimensions

| Variable | Value | Confidence |
|---|---|---|
| `board_w` / `board_d` | 277 × 304.8mm | Sourced — MSI/Micro Center |
| `u_pitch` | 44.45mm | Sourced — matches this rack's mfr spec + EIA-310 |
| `rack_overall_w/d/h`, `rack_rail_end_offset` | 280×260×635.8mm, 33mm | Sourced — Tecmojo mfr spec |
| `atx_holes_in` (9-hole mobo pattern) | see table in .scad | Sourced (Intel ATX 2.01 Fig. 3) for a 305×244mm board — **adapted**, not verified, for this 277×304.8mm board |
| `psu_holes` (4-hole PSU pattern) | see table in .scad | Sourced (Intel ATX 2.01 Fig. 9) — genuinely universal, high confidence |
| `io_w` / `io_h` | 158.75 × 44.45mm | Sourced — standard ATX/EATX IO shield opening |
| `gpu_card_length/height/thickness` | 338 × 140 × 50mm | Sourced for the **5080 only** — 4070 Ti reuses these as a placeholder |
| `rack_clear_width` | 270mm | **Placeholder — measure yours**; see reasoning above |
| `psu_d` | 140mm | Estimate — verify against RM850e |
| `tray_u_height` (requested) vs. `actual_panel_height` (used) | 8U (355.6mm) vs. ~355.6mm now (PSU/IO row height dropped once decoupled from the GPU row) | Recompute if row proportions change |
| `hole_a`/`hole_b`/`hole_c` (EIA-310 intra-U spacing) | 6.35/15.875/25.4mm | Standard convention — not explicitly confirmed for this specific rack SKU (inferred from its 10-32 tapped + cage-nut hardware kit) |
| `mount_plate_depth` | 12mm | Placeholder |
| `slide_hole_pitch` | 32mm | Placeholder |

## Render / export

```
openscad --render -o preview-top.png --imgsize=1800,1300 --autocenter --viewall \
  --projection=ortho --colorscheme=Tomorrow mobo-gpu-psu-tray.scad

# Combined printable model (excludes the rack reference frame)
openscad -o mobo-gpu-psu-tray.stl mobo-gpu-psu-tray.scad

# Per-subsystem parts, plus the non-printable rack reference frame
for part in structural mobo gpu psu rack_reference; do
  openscad -D "render_part=\"$part\"" -o "part-$part.stl" mobo-gpu-psu-tray.scad
done

# Combined view with the rack reference frame overlaid, for fit-checking only
openscad -D 'render_part="fit_check"' -o fit-check.png ...
```

Always pass `--render` for PNG preview exports — `openscad -o file.png`
without it uses preview mode, which can silently fail to display a real,
correctly-differenced cutout (bit the v0.1 IO cutout once already).
