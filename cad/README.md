# CAD — mobo/GPU/PSU slide-out tray

`mobo-gpu-psu-tray.scad` — parametric OpenSCAD model. Every dimension that
matters is a named variable at the top of the file with a comment saying
whether it's a sourced spec or a placeholder you need to verify.

**Status: v0.6 draft, not print-ready, and now honestly blocked on one
real measurement.** Manifold STLs export clean (`NoError` on the combined
model and all per-part exports). Every panel's cutout is now checked to
actually fit inside the panel it's cut from. But the floorplan this
round surfaced a real physical conflict: **the PSU and IO shield, sized
to what they actually need, require ~341mm side by side — the rack is
only ~270-280mm.** See "v0.6" below before printing anything.

## v0.6 — floorplan rebuilt from real sizes, found a real width conflict

v0.5 shipped with two more defects, on top of the ones it claimed to
fix:

- **The IO rotation in v0.5 was wrong.** It was based on the photo
  showing ports "stacked vertically" and concluding the whole board was
  mounted rotated 90&deg;. Cropped and zoomed into the actual photo this
  round: that's just the MSI X670E ACE's completely standard rear IO
  panel — a 2-row USB grid, side-by-side WiFi antennas, a row of audio
  jacks. Totally normal, unrotated layout. Worse, the v0.5 fix only
  rotated the *cutout* and left the *standoff hole pattern* on the old
  unrotated mapping — even if the board really had been rotated, holes
  and cutout are rigidly on the same PCB and can't be rotated
  independently. Reverted to the standard orientation.
- **The PSU cutout (150mm) was being cut from a panel sized to
  `half_width` (130mm)** — narrower than the cutout itself. Same class
  of bug as the v0.4 IO overflow, just never caught because nobody
  checked the numbers against the panel bounds, only glanced at a
  render. Both the PSU (150mm) and the IO shield (158.75mm) need more
  than half of any width this tray plausibly has — the "split into two
  equal half-columns" floorplan never actually fit either real
  component, all the way back to when it was introduced.

Fix: columns are now sized bottom-up from each component's real
footprint (`psu_col_w`, `io_col_w`) instead of an assumed 50/50 split,
and both cutouts are re-verified to sit fully inside their own panel
(checked by rendering each part alone and looking, not just the combined
assembly).

That surfaced the real problem: `psu_col_w + spine_width + io_col_w` =
**340.75mm**, computed from real, mostly-sourced dimensions — but
`rack_clear_width` (270mm) is itself only a reasoned placeholder. The
model now makes this conflict visible instead of hiding it:
`rack_reference()` still draws its posts at the assumed 270mm, while the
tray itself is sized to whatever it actually needs
(`tray_width = max(rack_clear_width, required_tray_width)`) — so in the
`fit_check` render, the tray now visibly overhangs the rack posts on the
right side. That gap is real information, not a rendering bug: **either
the real rack is wider than 270mm, or the PSU and motherboard don't
actually sit fully side-by-side at the same depth in the real build (the
photo could be foreshortening an overlap that isn't there in plan view),
or the layout needs to change from side-by-side to stacked.** This can't
be resolved with more reasoning from a photo — it needs the actual rack
interior width measured, and ideally a straight-on plan-view photo (not
the current angled 3/4 shot) to check whether the PSU and IO shield
really share the same depth plane.

## v0.5 — IO orientation fixed, real flanges, real GPU mount

v0.4 still had three real defects, caught by re-checking the actual
render (not just trusting the code) against the photo:

- **IO cutout was 90&deg; wrong.** v0.4 cut it in the desktop-case
  orientation (158.75mm wide, 44.45mm tall) — but this build mounts the
  board rotated 90&deg;, and `docs/photos/rack-front.jpg` clearly shows
  the USB/audio/network ports stacked top-to-bottom, not side by side.
  Worse, at 158.75mm wide the old cutout didn't even fit inside the
  130mm-wide bezel column — it would've overflowed sideways. Now the cut
  is 44.45mm wide × 158.75mm tall, and the bezel column has its own
  height (independent of the PSU row) sized to fit it.
- **Rack ears were floating posts, not bonded flanges.** The v0.4 ear
  touched the base plate along a single zero-area edge — geometrically
  it exported as one manifold, but it's not a real load-bearing joint.
  Rewrote `rack_ear()` as a proper L-bracket: a vertical leg (holes,
  faces the rack rail) plus a horizontal foot that overlaps the tray's
  edge for the ear's *full height*, so there's real volumetric contact.
  Also: the `fit_check` render now lifts the tray to `rack_rail_end_offset`
  so the ears' holes visually line up with the rack reference frame's
  holes — v0.4 had the tray sitting at the rack's absolute floor (Z=0),
  33mm below the first real U, which made the flanges look disconnected
  from the rack's actual hole line even though the print geometry itself
  was fine (U-pitch is periodic, so it lines up once actually installed —
  but the *visualization* was misleading).
- **GPU brackets had nothing to actually mount a card to.** v0.4's fins
  had 4 guessed holes with no real spacing/size rationale and no
  structure bearing the card's weight — just two open fins. Added a real
  support shelf (`gpu_shelf_depth`) each card's PCB rests on, plus one
  bracket screw hole per fin sized from a real source: Protocase's
  ATX/PCI enclosure design guide gives 2.71mm (0.1065in) as the 6-32 tap
  drill size for a PCI bracket screw hole, and separately confirms the
  20.32mm PCI slot pitch already in this file (`slot_pitch`). Hole is
  sized up to 3.5mm clearance since this prints in plastic (screw + nut
  or heat-set insert, not tapped directly). Shelf/hole *position* is
  still a placeholder pending dry-fit — the source only gives real sizes,
  not this custom riser-mounted layout's positions.

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

0. **Blocking: measure the real rack interior width and resolve the
   341mm-vs-270mm conflict** (see v0.6 above). Everything else in this
   list assumes a side-by-side PSU+mobo layout that may not survive that
   measurement.
1. **Measure `rack_clear_width`.** Currently 270mm, reasoned from overall
   width minus assumed wall thickness — not measured, and known to be
   too narrow for what the layout currently needs (see item 0).
2. **Cross-check the adapted motherboard holes** against the existing
   acrylic plate. They're derived from a real spec but scaled for a
   different board size than the source table covers.
3. **Verify the IO cutout position** — size (158.75×44.45mm, standard
   unrotated orientation) is a real universal standard; its position
   within the bezel column is still a placeholder.
4. **Verify the PSU holes** land correctly relative to your specific
   RM850e — the 4-hole ATX pattern is genuinely universal, but confirm
   `psu_d` (140mm, estimated) against the real unit too.
5. **Source the 4070 Ti's real dimensions** — the GPU segment still uses
   the 5080's numbers (338×140×50mm) for both cutouts.
6. **Dry-fit the GPU bracket** shelf position and screw hole height —
   the shelf/hole *sizes* are sourced (see below), their *position*
   along the tray depth and row height is still a placeholder fixture,
   not measured against real riser routing.
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
| `slot_pitch` | 20.32mm | Sourced — Protocase ATX/PCI enclosure design guide, Fig. 9 |
| `gpu_bracket_hole_d` | 3.5mm | Sourced size (Protocase: 2.71mm/0.1065in 6-32 tap), sized up for a plastic clearance hole — **position still a placeholder** |
| `rack_clear_width` | 270mm | **Placeholder — measure yours**; the layout as sized needs 340.75mm (`required_tray_width`), 70mm more than this — blocking, see v0.6 above |
| `psu_col_w` / `io_col_w` | 156mm / 174.75mm | Derived from real sourced PSU/IO sizes + margin — replaces the old `half_width` 50/50 split, which fit neither |
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
