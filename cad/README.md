# CAD — mobo/GPU/PSU slide-out tray

`mobo-gpu-psu-tray.scad` — parametric OpenSCAD model. Every dimension that
matters is a named variable at the top of the file with a comment saying
whether it's a sourced spec or a placeholder you need to verify.

**Status: v0.3 draft, not print-ready.** Manifold STLs export clean
(`NoError` on the combined model and all 4 per-part exports), but it has
not been dry-fit against real hardware. Do not print at these defaults.

## v0.3 — rebuilt around a "rear panel" model

Rethought as what it actually is: a standard PC case's **rear panel**
layout (IO shield + PSU cutout + expansion-slot brackets), just facing the
rack's front instead of a desk's back. Four tiled segments instead of the
v0.2 floor-plan approach:

- **Structural (blue)** — base plate, rack ears (the flanges that screw
  the whole unit into the rack), a spine rib dividing the two columns,
  slide-rail tabs.
- **Motherboard segment (red)** — left column, full height. IO shield
  cutout, standoffs left unpunched (transfer from the existing acrylic
  plate).
- **PSU segment (purple)** — top-right. Real ATX cutout (150×86mm) plus a
  support shelf behind it, since the front panel alone shouldn't
  cantilever the PSU's weight.
- **GPU segment (green)** — below the PSU, two stacked card-bracket
  cutouts sized from the RTX 5080 Gaming Trio's real dimensions
  (338×140×50mm, sourced). **The 4070 Ti was never looked up separately —
  these numbers are reused as a placeholder for it too.**

## A real finding: 8U isn't quite enough for the real stack

You asked for 8U (355.6mm). Stacking the real PSU height (86mm) + two real
GPU heights (140mm each) with only fitting clearance between them —
already zero margin, no slack to cut — needs ~384mm. That's ~28mm short.
`actual_panel_height` in the model uses `max(requested, required)`, so the
ears and panel are sized to 384mm rather than silently shrinking sourced
component dimensions to force an 8U fit. If you want to stay at exactly
8U, something has to give: no room left to trim margins further, so
either a component needs to change or a different height needs to be
accepted.

## A rendering pitfall worth knowing about (still applies)

`openscad -o file.png` without `--render` uses preview mode, which can
silently fail to display a real, correctly-differenced cutout — this bit
the v0.1 IO cutout. STL export always fully evaluates the CSG tree and was
trustworthy the whole time; only PNG preview needs `--render`. Both
commands below use it.

## Before printing

1. **Measure `rack_clear_width`.** Bumped to 460mm this revision — the
   left column (mobo, 277mm) + spine + right column (PSU-width-driven,
   ~156mm) no longer fits the earlier 350mm placeholder. Still a
   placeholder either way.
2. **Transfer motherboard standoff holes from the existing acrylic plate**
   by tracing — don't trust a generic ATX hole-coordinate table; I
   couldn't source MSI's exact EATX hole positions with confidence.
3. **Verify the IO cutout position** against the X670E ACE's actual IO
   shield offset — size (158.75×44.45mm) is a real standard, position is
   a placeholder.
4. **Source the 4070 Ti's real dimensions** and update `gpu_card_height`/
   `gpu_card_thickness`/`gpu_card_length` if they differ meaningfully from
   the 5080's — right now both cutouts assume identical card sizes.
5. **Verify `psu_d`** (140mm assumed) against the actual RM850e.
6. **Confirm slide hardware and `slide_hole_pitch`** — the model assumes
   off-the-shelf steel ball-bearing full-extension slides (not printed
   rails), but the mounting-tab hole spacing is a placeholder.
7. **Decide on the 8U vs. 384mm gap** above before committing to ear
   height.

## Sourced (trustworthy) vs. placeholder (verify) dimensions

| Variable | Value | Confidence |
|---|---|---|
| `board_w` / `board_d` | 277 × 304.8mm | Sourced — MSI/Micro Center spec for the X670E ACE |
| `u_pitch`, `hole_a`/`hole_c` | EIA-310 standard | Sourced — universal rack standard |
| `slot_pitch` | 20.32mm | Sourced — standard expansion-slot spacing (reference only) |
| `psu_w` / `psu_h` | 150 × 86mm | Sourced — fixed ATX spec |
| `io_w` / `io_h` | 158.75 × 44.45mm | Sourced — standard ATX/EATX IO shield opening |
| `gpu_card_length/height/thickness` | 338 × 140 × 50mm | Sourced for the **5080 only** — 4070 Ti reuses these as a placeholder |
| `rack_clear_width` | 460mm | **Placeholder — measure yours** |
| `psu_d` | 140mm | Estimate — typical modular ATX, verify against RM850e |
| `tray_u_height` (requested) vs. `actual_panel_height` (used) | 8U (355.6mm) vs. 384mm | Real component stack needs more — see finding above |
| `io_top_margin`, IO cutout X position | 8mm / centered | Placeholder — verify against the board's actual IO shield offset |
| `mount_plate_depth` | 12mm | Placeholder — verify it clears riser cable bend radius |
| `slide_hole_pitch` | 32mm | Placeholder — match your actual purchased slides |

## Render / export

```
openscad --render -o preview-top.png --imgsize=1600,1200 --autocenter --viewall \
  --projection=ortho --colorscheme=Tomorrow mobo-gpu-psu-tray.scad

# Combined model
openscad -o mobo-gpu-psu-tray.stl mobo-gpu-psu-tray.scad

# Per-subsystem parts (for colored printing or the web viewer)
for part in structural mobo gpu psu; do
  openscad -D "render_part=\"$part\"" -o "part-$part.stl" mobo-gpu-psu-tray.scad
done
```
