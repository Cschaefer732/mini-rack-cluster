# CAD — mobo/GPU/PSU slide-out tray

`mobo-gpu-psu-tray.scad` — parametric OpenSCAD model. Every dimension that
matters is a named variable at the top of the file with a comment saying
whether it's a sourced spec or a placeholder you need to verify.

**Status: v0.1 draft, not print-ready.** Renders clean and exports a
manifold STL (checked — `NoError`, genus 26, 5640 verts), but it has not
been dry-fit against real hardware. Do not print at these defaults.

## Before printing

1. **Measure `rack_clear_width`.** This is the one number that changes the
   whole layout and I don't have it — generic "10-inch rack" specs (~222mm
   clear) contradict the fact that a 277mm-wide board already fits in this
   rack, so the real number is almost certainly wider than the generic
   spec. Measure interior width (rail-to-rail or panel-to-panel) and update
   the variable.
2. **Transfer motherboard standoff holes from the existing acrylic plate**
   by tracing — don't trust a generic ATX hole-coordinate table for this;
   I couldn't source MSI's exact EATX hole positions with confidence, and a
   wrong guess wastes a print. The model leaves this zone unpunched on
   purpose (marked, not drilled).
3. **Dry-fit the GPU bracket.** `slot_count`/`slot_pitch` on the vertical
   fin are a starting fixture sized to standard expansion-slot spacing
   (20.32mm — that part's a real spec), not measured against your actual
   riser cable routing. Adjust after a physical test fit.
4. **Verify `psu_d`** (140mm assumed) against the actual RM850e — modular
   ATX PSU depth varies by wattage/model.
5. **Confirm slide hardware and `slide_hole_pitch`** against whatever
   drawer slides you actually buy — the model assumes off-the-shelf steel
   ball-bearing full-extension slides (not printed rails; plastic can't
   reliably carry mobo + 2 GPUs + PSU through repeated slide cycles), but
   the mounting-tab hole spacing is a placeholder.

## Sourced (trustworthy) vs. placeholder (verify) dimensions

| Variable | Value | Confidence |
|---|---|---|
| `board_w` / `board_d` | 277 × 304.8mm | Sourced — MSI/Micro Center spec for the X670E ACE |
| `u_pitch`, `hole_a/b/c` | EIA-310 standard | Sourced — universal rack standard |
| `slot_pitch` | 20.32mm | Sourced — standard expansion-slot spacing |
| `psu_w` / `psu_h` | 150 × 86mm | Sourced — fixed ATX spec |
| `rack_clear_width` | 300mm | **Placeholder — measure yours** |
| `psu_d` | 140mm | Estimate — typical modular ATX, verify against RM850e |
| `board_offset_right` | 63.5mm | Your "2-3in" ask, midpoint — adjust to taste |
| `tray_u_height` | 6U | Estimate from the current build's photo, not measured |
| `slide_hole_pitch` | 32mm | Placeholder — match your actual purchased slides |

## Render / export

```
openscad -o preview-top.png --imgsize=1400,1000 --autocenter --viewall \
  --projection=ortho --colorscheme=Tomorrow mobo-gpu-psu-tray.scad

openscad -o mobo-gpu-psu-tray.stl mobo-gpu-psu-tray.scad
```
