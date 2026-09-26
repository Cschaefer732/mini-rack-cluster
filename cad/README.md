# CAD — mobo/GPU/PSU slide-out tray

`mobo-gpu-psu-tray.scad` — parametric OpenSCAD model. Every dimension that
matters is a named variable at the top of the file with a comment saying
whether it's a sourced spec or a placeholder you need to verify.

**Status: v0.2 draft, not print-ready.** Renders clean and exports manifold
STLs (checked — `NoError` on the combined model and all 4 per-part
exports), but it has not been dry-fit against real hardware. Do not print
at these defaults.

## v0.2 changes

- **Motherboard mount switched from flat/horizontal to vertical.** v0.1 laid
  the board flat on the tray floor; that's wrong once the IO shield needs
  to be front-facing (a flat-mounted board's ports project sideways at
  deck height, not usably). v0.2 stands the board up, matching how the
  current acrylic-plate build already mounts it — the mounting plate
  itself is now also the front face, with the IO cutout through it.
- **`tray_u_height` raised to 8U** (was 6, an unmeasured guess from the
  build photo).
- **IO shield cutout added** — 158.75×44.45mm, the real ATX/EATX standard
  size (genuinely universal, high confidence). Position along the board's
  width is centered by default and **not verified** against the X670E
  ACE's actual IO shield offset — check before printing.
- **Per-subsystem color coding**, both in the OpenSCAD preview
  (`color()`) and as 4 separate STL exports for the web viewer: structural
  parts blue, motherboard mount red, GPU bracket green, PSU cradle purple.
- **`rack_clear_width` placeholder raised to 350mm** (was 300) — 300 put
  the board's zone at a negative X coordinate once combined with the GPU
  offset, which only happened to go unnoticed because the old preview
  render was silently using OpenSCAD's throwntogether mode (see below).
  Still a placeholder either way — measure the real number.

## A rendering pitfall worth knowing about

The v0.1 preview PNGs looked structurally plausible but were wrong: an IO
cutout that's genuinely in the geometry (confirmed by the STL export being
a valid manifold with the correct hole) didn't show up in the PNG at all.
Cause: `openscad -o file.png` without `--render` uses OpenSCAD's preview
mode, which can render overlapping/differenced solids without properly
resolving the boolean for display. **STL export always fully evaluates the
CSG tree — it was trustworthy the whole time — but PNG preview needs the
`--render` flag to be trustworthy too.** Both export commands below now use
it.

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
3. **Verify the IO cutout position** against the X670E ACE's actual IO
   shield offset — the cutout size (158.75×44.45mm) is a real standard,
   but its position (centered on the board's width, 8mm from the top) is
   a placeholder.
4. **Dry-fit the GPU bracket.** `slot_count`/`slot_pitch` on the vertical
   fin are a starting fixture sized to standard expansion-slot spacing
   (20.32mm — that part's a real spec), not measured against your actual
   riser cable routing. Adjust after a physical test fit.
5. **Verify `psu_d`** (140mm assumed) against the actual RM850e — modular
   ATX PSU depth varies by wattage/model.
6. **Confirm slide hardware and `slide_hole_pitch`** against whatever
   drawer slides you actually buy — the model assumes off-the-shelf steel
   ball-bearing full-extension slides (not printed rails; plastic can't
   reliably carry mobo + 2 GPUs + PSU through repeated slide cycles), but
   the mounting-tab hole spacing is a placeholder.

## Sourced (trustworthy) vs. placeholder (verify) dimensions

| Variable | Value | Confidence |
|---|---|---|
| `board_w` / `board_d` | 277 × 304.8mm | Sourced — MSI/Micro Center spec for the X670E ACE |
| `u_pitch`, `hole_a`/`hole_c` | EIA-310 standard | Sourced — universal rack standard |
| `slot_pitch` | 20.32mm | Sourced — standard expansion-slot spacing |
| `psu_w` / `psu_h` | 150 × 86mm | Sourced — fixed ATX spec |
| `io_w` / `io_h` | 158.75 × 44.45mm | Sourced — standard ATX/EATX IO shield opening |
| `rack_clear_width` | 350mm | **Placeholder — measure yours** |
| `psu_d` | 140mm | Estimate — typical modular ATX, verify against RM850e |
| `board_offset_right` | 63.5mm | Your "2-3in" ask, midpoint — adjust to taste |
| `tray_u_height` | 8U | Estimate — GPU cooler stack clearance above/below the board, not measured |
| `io_top_margin`, IO cutout X position | 8mm / centered | Placeholder — verify against the board's actual IO shield offset |
| `mount_plate_depth` | 12mm | Placeholder — verify it clears riser cable bend radius |
| `slide_hole_pitch` | 32mm | Placeholder — match your actual purchased slides |

## Render / export

```
openscad --render -o preview-top.png --imgsize=1600,1100 --autocenter --viewall \
  --projection=ortho --colorscheme=Tomorrow mobo-gpu-psu-tray.scad

# Combined model
openscad --render -o mobo-gpu-psu-tray.stl mobo-gpu-psu-tray.scad

# Per-subsystem parts (for colored printing or the web viewer)
for part in structural mobo gpu psu; do
  openscad -D "render_part=\"$part\"" -o "part-$part.stl" mobo-gpu-psu-tray.scad
done
```

Always pass `--render` for PNG preview exports — see the pitfall note
above. STL export doesn't need the flag (it always fully evaluates), but
it doesn't hurt to include it either.
