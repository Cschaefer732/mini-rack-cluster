// mobo-gpu-psu-tray.scad
//
// v0.4 — corrected layout from the actual rack photo (not my earlier guess),
// plus real sourced mounting holes for PSU and (adapted) motherboard, plus a
// reference rack frame to check the fit against, per direct request.
//
// Layout (matches docs/photos/rack-front.jpg):
//   top-left:     PSU, open bracket, exposed face, real ATX screw holes
//   top-right:    motherboard IO shield + standoff plate (full height —
//                 the board's own PCB runs behind/through the row below)
//   bottom, full width: 2 GPUs side by side, open brackets, coolers
//                 exposed, slot/connector end down
//   center spine + outer flanges tie it together and screw into the rack
//
// ============ VERIFY THESE BEFORE PRINTING — see cad/README.md ============

render_part = "all"; // "all" | "structural" | "mobo" | "gpu" | "psu" | "rack_reference"

// --- Rack — Tecmojo 12U 10in (ASIN B0F4JWMY4T), sourced from mfr spec ---
rack_overall_w       = 280;   // mm, sourced
rack_overall_d       = 260;   // mm, sourced (10.23in)
rack_overall_h       = 635.8; // mm, sourced (25.03in)
rack_u_count         = 12;
rack_rail_end_offset = 33;    // mm, sourced (1.3in, top/bottom to first usable U)
rack_clear_width     = 270;   // mm — REASONED, not sourced: mfr diagram had an
                                // uncaptioned 210mm figure the research agent flagged
                                // as uncertain, and it contradicts the photo (a 277mm
                                // board is visibly mounted). Using overall width minus
                                // an assumed ~5mm rail wall each side instead. MEASURE
                                // THE REAL ONE before printing — this is still a guess,
                                // just a better-reasoned one.
u_pitch    = 44.45; // mm — EIA-310, sourced (matches this rack's mfr-stated U pitch)
hole_a     = 6.35;  // mm — EIA-310 intra-U hole positions. NOTE: confirmed as this
hole_b     = 15.875; // rack's convention only by inference (10-32 tapped + cage-nut
hole_c     = 25.4;  // kit strongly implies EIA-310, but not stated explicitly for this SKU)

tray_u_height = 8; // U's requested. See actual_panel_height below.

// --- Motherboard (MSI MEG X670E ACE) ---
board_w = 277;    // mm, sourced (MSI/Micro Center)
board_d = 304.8;  // mm, sourced
mount_plate_depth = 12; // mm placeholder, standoff/gusset depth

// Standard ATX 9-hole mounting pattern, sourced from Intel ATX Spec 2.01
// Fig. 3 (bitsavers.org), for a 305x244mm board, hole positions in inches
// from the board's top-left corner (X right, Y down):
atx_std_w_in = 12.0;
atx_holes_in = [
    [0.650, 0.400], [5.550, 0.400],                 // A, C
    [11.750, 1.300],                                  // F
    [0.650, 6.500], [5.550, 6.500], [11.750, 6.500], // G, H, J
    [0.650, 7.950], [5.550, 7.950], [10.950, 7.950]  // K, L, M
];
// ADAPTED for this board: X scaled by board_w/standard_width (277/305mm) since
// the board is narrower than standard ATX and 3 of the 9 holes would fall off
// the edge unscaled. Y is left unscaled — EATX boards conventionally keep the
// standard hole positions near the IO edge and add extra length below, rather
// than stretching everything proportionally. NOT VERIFIED against MSI's actual
// drawing — cross-check against the existing acrylic plate before drilling.
mobo_hole_scale_x = board_w / (atx_std_w_in * 25.4);
mobo_hole_d = 3.2; // mm, clearance-ish; cut as small slots for tolerance, not tight holes

// --- IO shield cutout (standard ATX/EATX size — sourced, genuinely universal) ---
// io_w/io_h are the shield's own dimensions. On a normal desktop case the
// board lies with its width axis horizontal, so io_w (158.75mm) runs
// left-right. This build mounts the board rotated 90 degrees (confirmed
// against docs/photos/rack-front.jpg: the USB/audio/net ports stack
// top-to-bottom, not side-by-side) — so the cutout is rotated 90 degrees
// too: io_h (44.45mm) is the cut's width, io_w (158.75mm) is its height.
io_w = 158.75;
io_h = 44.45;
io_margin = 8; // mm, margin above/below the rotated cutout within its own column — placeholder

// --- PSU (Corsair RM850e — real ATX PSU mechanical spec, sourced) ---
psu_w = 150; // mm, sourced, fixed ATX standard
psu_h = 86;  // mm, sourced, fixed ATX standard
psu_d = 140; // mm — ESTIMATE, verify against your RM850e
psu_margin = 3;
// Real 4-hole ATX PSU mounting pattern, sourced from Intel ATX Spec 2.01 Fig. 9,
// origin = bottom-left of the 150x86mm rear face (X right, Y up):
psu_holes = [
    [6.0, 16.0],   // bottom-left
    [6.0, 80.0],   // top-left
    [144.0, 74.0], // top-right
    [120.0, 6.0]   // bottom-right
];
psu_hole_d = 4.0; // mm, clearance for 6-32 screws

// --- GPU cutouts (RTX 5080 Gaming Trio — SOURCED for the 5080 only; the 4070 Ti
// was never looked up separately, these numbers are a placeholder for it too) ---
gpu_card_length    = 338;
gpu_card_height    = 140;
gpu_card_thickness = 50;
gpu_margin = 3;
slot_pitch = 20.32; // mm, sourced — Protocase ATX/PCI enclosure design guide
                     // (Fig. 9, "PCI position pitch"), confirms this figure
gpu_bracket_hole_d = 3.5; // mm, clearance for a 6-32 screw. Protocase's spec
                           // gives 2.71mm (0.1065in) as the TAP drill for
                           // cutting 6-32 threads directly into sheet metal —
                           // sized up here for a clearance hole through
                           // printed plastic (screw + nut or heat-set insert)
                           // rather than tapping the plastic itself.
gpu_shelf_depth = gpu_card_thickness + 2*gpu_margin; // real support ledge —
                           // the card rests on this, not just on a screw

// --- Derived heights ---
psu_seg_height = psu_h + 2*psu_margin;
io_bezel_height = io_w + 2*io_margin; // io_w is now the cutout's VERTICAL span (rotated 90deg)
top_row_height = max(psu_seg_height, io_bezel_height);
gpu_row_height = gpu_card_height + 2*gpu_margin;
requested_panel_height = tray_u_height * u_pitch;
required_panel_height  = top_row_height + gpu_row_height;
actual_panel_height = max(requested_panel_height, required_panel_height);

spine_width = 10;
half_width = (rack_clear_width - spine_width) / 2;

// --- Structure ---
plate_t = 6;
wall_t  = 4;
ear_t   = 4;

// --- Slide hardware ---
slide_hole_pitch  = 32;   // PLACEHOLDER — verify against your slides
slide_tab_height  = 20;
slide_tab_screw_d = 5;

$fn = 48;

// ============ derived ============
tray_width = rack_clear_width;
tray_depth = rack_overall_d;

module rack_ear(h) {
    // L-bracket, not a free-standing post: a vertical leg (holes, faces the
    // rack rail) plus a horizontal foot that overlaps the tray's edge for
    // its full height, so the ear is volumetrically bonded to the tray
    // instead of touching it along a single zero-area edge.
    ear_depth = 20;
    foot_len = 12;
    n_u = ceil(h / u_pitch);
    difference() {
        union() {
            cube([ear_t, ear_depth, h]);
            cube([ear_t + foot_len, wall_t, h]);
        }
        for (u = [0 : n_u - 1]) {
            for (hh = [hole_a, hole_b, hole_c])
                if (u*u_pitch + hh < h)
                    translate([-1, ear_depth/2, u*u_pitch + hh]) rotate([0,90,0]) cylinder(d=6.4, h=ear_t+2);
        }
    }
}

module base_plate() {
    cube([tray_width, tray_depth, plate_t]);
}

module spine() {
    translate([half_width, 0, plate_t])
        cube([spine_width, mount_plate_depth, actual_panel_height]);
}

module slide_tab(x) {
    translate([x, tray_depth/2 - 40, 0])
        difference() {
            cube([wall_t, 80, slide_tab_height]);
            translate([wall_t/2, 40 - slide_hole_pitch/2, -1]) cylinder(d=slide_tab_screw_d, h=slide_tab_height+2);
            translate([wall_t/2, 40 + slide_hole_pitch/2, -1]) cylinder(d=slide_tab_screw_d, h=slide_tab_height+2);
        }
}

module mobo_segment() {
    // Two pieces, deliberately at different depths:
    //  1. A narrow front-facing IO bezel strip in the top-right (matches
    //     the photo — that's all that's visible from the front).
    //  2. The actual standoff plate, full real board size (277x304.8mm),
    //     set back in depth. It's wider than the top-right column alone
    //     (the board is 277mm; the column is only ~half_width) so it has
    //     to sit behind the PSU bracket too, not collide with it — this
    //     matches how the board's real footprint relates to what's
    //     actually visible from the front in the photo.
    // IO cutout rotated 90deg from the shield's own w/h (see io_w/io_h
    // comment above) — io_h is the cut's width, io_w is its height.
    io_col_x0 = tray_width - half_width;
    io_cut_x0 = io_col_x0 + (half_width - io_h)/2; // centered in the column
    plate_top = plate_t + actual_panel_height;
    io_bezel_z0 = actual_panel_height - io_bezel_height; // bezel column is flush top
    io_cut_z0 = io_bezel_z0 + (io_bezel_height - io_w)/2; // centered in the column

    difference() {
        translate([io_col_x0, 0, plate_t + io_bezel_z0]) cube([half_width, wall_t, io_bezel_height]);
        translate([io_cut_x0, -1, plate_t + io_cut_z0])
            cube([io_h, wall_t+2, io_w]);
    }

    plate_x0 = tray_width - board_w; // right-aligned; may run slightly past
                                       // the tray's left edge if board_w >
                                       // tray_width — rack_clear_width is
                                       // still an unverified placeholder
    plate_y = mount_plate_depth; // set back from the PSU/GPU brackets at y=0
    translate([plate_x0, plate_y, plate_t])
        difference() {
            cube([board_w, wall_t, board_d]);
            for (h = atx_holes_in) {
                hx = h[0]*25.4*mobo_hole_scale_x;
                hz = board_d - h[1]*25.4; // measured down from the board's top (IO) edge
                translate([hx, -1, hz])
                    rotate([-90,0,0])
                        hull() { // small slot, not a tight hole — adaptation tolerance
                            cylinder(d=mobo_hole_d, h=wall_t+2);
                            translate([1.5,0,0]) cylinder(d=mobo_hole_d, h=wall_t+2);
                        }
            }
        }
    translate([plate_x0 + 10, plate_y + wall_t + 1, plate_t + 10])
        rotate([90, 0, 0])
            linear_extrude(0.6) text("ADAPTED ATX HOLES - CROSS-CHECK OLD PLATE", size=5);
}

module psu_segment() {
    // Top-left, open bracket — PSU's own face stays exposed, no blanking
    // panel in front of it (matches the photo). Real 4-hole ATX pattern.
    z0 = actual_panel_height - psu_seg_height;
    cx0 = psu_margin;
    // frame: just a border + support shelf, not a solid panel
    difference() {
        translate([0, 0, plate_t + z0]) cube([half_width, wall_t, psu_seg_height]);
        translate([cx0, -1, plate_t + z0 + psu_margin]) cube([psu_w, wall_t+2, psu_h]);
    }
    for (h = psu_holes)
        translate([cx0 + h[0], wall_t/2, plate_t + z0 + psu_margin + h[1]])
            rotate([90,0,0]) cylinder(d=psu_hole_d, h=wall_t+1, center=true);
    // support shelf behind, screws into the PSU's bottom face
    translate([cx0, wall_t, plate_t + z0 + psu_margin])
        cube([psu_w, psu_d, wall_t]);
}

module gpu_bracket(x0) {
    // Open bracket, full width of its half-column — card sits with slot/
    // connector down, cooler fully exposed (no blanking panel), matching
    // the photo. Two guide fins, PLUS a real support shelf the card's PCB
    // actually rests its weight on (a screw alone doesn't hold a GPU up),
    // PLUS one real bracket screw hole per fin sized from Protocase's
    // ATX/PCI enclosure guide (gpu_bracket_hole_d above). Shelf position
    // along the depth and the hole's height are still placeholders — real
    // positions need a dry-fit against the actual riser routing.
    shelf_y0 = 20;
    hole_y = shelf_y0 + gpu_shelf_depth/2;
    hole_z = gpu_row_height * 0.65;
    difference() {
        union() {
            cube([wall_t, tray_depth, plate_t]);
            cube([wall_t, tray_depth, gpu_row_height]);
            translate([half_width - wall_t, 0, 0]) cube([wall_t, tray_depth, gpu_row_height]);
            translate([0, shelf_y0, 0]) cube([half_width, gpu_shelf_depth, wall_t]);
        }
        translate([-1, hole_y, hole_z]) rotate([0,90,0]) cylinder(d=gpu_bracket_hole_d, h=wall_t+2);
        translate([half_width - wall_t - 1, hole_y, hole_z]) rotate([0,90,0]) cylinder(d=gpu_bracket_hole_d, h=wall_t+2);
    }
}

module rack_reference() {
    // NOT a printable part — a reference frame at the rack's real sourced
    // dimensions, to check the tray's fit against. Render only, semi-
    // transparent, excluded from "structural"/"mobo"/"gpu"/"psu" exports.
    post_w = 15; post_t = 3;
    color("Gray", 0.35) {
        for (side = [0, 1]) {
            x = side == 0 ? -post_w - 5 : rack_clear_width + 5;
            translate([x, 0, 0])
                difference() {
                    cube([post_w, rack_overall_d, rack_overall_h]);
                    for (u = [0:rack_u_count-1])
                        for (hh = [hole_a, hole_b, hole_c])
                            translate([post_w/2, 5, rack_rail_end_offset + u*u_pitch + hh])
                                rotate([-90,0,0]) cylinder(d=6.4, h=post_t+2);
                }
        }
        translate([-post_w - 5, 0, 0]) cube([rack_clear_width + 2*post_w + 10, rack_overall_d, 4]);
    }
}

module structural_group() {
    color("SteelBlue") {
        base_plate();
        translate([-ear_t, 0, plate_t]) rack_ear(actual_panel_height);
        translate([tray_width + ear_t, 0, plate_t]) mirror([1,0,0]) rack_ear(actual_panel_height);
        spine();
        slide_tab(0);
        slide_tab(tray_width - wall_t);
    }
}

module printable_group() {
    structural_group();
    color("FireBrick") mobo_segment();
    color("SeaGreen") {
        translate([0, 0, plate_t]) gpu_bracket(0);
        translate([half_width + spine_width, 0, plate_t]) gpu_bracket(0);
    }
    color("MediumPurple") psu_segment();
}

module tray() {
    if (render_part == "all" || render_part == "structural") structural_group();
    if (render_part == "all" || render_part == "mobo") color("FireBrick") mobo_segment();
    if (render_part == "all" || render_part == "gpu") {
        color("SeaGreen") {
            translate([0, 0, plate_t]) gpu_bracket(0);
            translate([half_width + spine_width, 0, plate_t]) gpu_bracket(0);
        }
    }
    if (render_part == "all" || render_part == "psu") color("MediumPurple") psu_segment();
    if (render_part == "rack_reference" || render_part == "fit_check") rack_reference();
    if (render_part == "fit_check") {
        // Lifted to the rack's real first usable U so the ears' holes line
        // up with rack_reference's holes in the render — visualization
        // only, doesn't change the printed geometry (ear holes are cut
        // relative to the tray's own bottom, which repeats every U_pitch
        // so it lines up at any U row once actually installed).
        translate([0, 0, rack_rail_end_offset]) printable_group();
    }
}

tray();
