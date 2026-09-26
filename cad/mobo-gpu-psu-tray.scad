// mobo-gpu-psu-tray.scad
//
// v0.3 — rebuilt around a "rear panel" model: this front face functions
// like a standard PC case's rear panel (IO shield + PSU cutout + expansion
// slot brackets), just facing the rack's front. Four tiled segments:
//   - mobo segment (red):  left column, IO cutout, standoff zone
//   - psu segment  (purple): top-right, PSU cutout + support shelf
//   - gpu segment  (green): below PSU, 2 stacked card cutouts
//   - structural   (blue): base plate, rack ears, spine rib, slide tabs
// Mounts to purchased steel drawer slides (NOT printed rails).
//
// ============ VERIFY THESE BEFORE PRINTING ============

render_part = "all"; // "all" | "structural" | "mobo" | "gpu" | "psu"

// --- Rack ---
rack_clear_width  = 460;   // mm — INTERIOR clear width. PLACEHOLDER, MEASURE YOURS.
                            // Bumped again this revision: left column (mobo, 277mm)
                            // + spine + right column (PSU-width-driven, ~160mm) no
                            // longer fits in the earlier 350mm placeholder.
rack_usable_depth = 260;   // mm — front rail to back rail, from Tecmojo's 10.23in spec
u_pitch           = 44.45; // mm — EIA-310 rack unit, standard, do not change
tray_u_height     = 8;     // U's requested. See actual_panel_height below — real
                            // component stack needs more; ears/panel are sized to
                            // whichever is larger so nothing physically overlaps.
hole_a            = 6.35;  // mm — EIA-310 hole positions within a U, standard
hole_c            = 25.4;

// --- Motherboard (MSI MEG X670E ACE — sourced from MSI/Micro Center specs) ---
board_w = 277;
board_d = 304.8;
mount_plate_depth = 12; // mm, standoff/gusset depth placeholder

// --- IO shield cutout (standard ATX/EATX size — sourced, genuinely universal) ---
io_w = 158.75;
io_h = 44.45;
io_top_margin = 8; // PLACEHOLDER — verify against the board's actual IO offset

// --- PSU (Corsair RM850e — W/H fixed by ATX spec) ---
psu_w = 150;  // sourced, fixed ATX standard
psu_h = 86;   // sourced, fixed ATX standard
psu_d = 140;  // ESTIMATE — verify against your RM850e
psu_margin = 3; // mm clearance around the cutout, each side

// --- GPU cutouts (RTX 5080 Gaming Trio dimensions — SOURCED for the 5080 only.
// The 4070 Ti was never looked up separately; these numbers are reused as a
// placeholder for it too, flagged here explicitly.) ---
gpu_card_length    = 338; // mm — extends into depth (Y), like the mobo overhang
gpu_card_height    = 140; // mm — vertical extent on the panel (Z)
gpu_card_thickness = 50;  // mm — horizontal extent on the panel (X, the bracket-width side)
gpu_margin = 3; // mm clearance around each cutout, each side
slot_pitch = 20.32; // mm — real standard, expansion-slot spacing (reference only here)

// --- Derived stack height: what the real components actually need ---
psu_seg_height = psu_h + 2*psu_margin;
gpu_row_height = gpu_card_height + 2*gpu_margin;
gpu_seg_height = 2 * gpu_row_height;
right_col_width = psu_w + 2*psu_margin; // PSU governs (150mm) over GPU cutout width (~56mm)

requested_panel_height = tray_u_height * u_pitch;      // 355.6mm at 8U
required_panel_height  = psu_seg_height + gpu_seg_height; // real component stack, zero extra slack
actual_panel_height = max(requested_panel_height, required_panel_height);
// At current values: requested=355.6mm, required=384mm — the 8U ask is ~28mm
// short of what PSU + 2 real-sized GPUs need with only fitting clearance
// between them. actual_panel_height uses the larger number so nothing
// overlaps; this is a flag, not a silent override — see cad/README.md.

spine_width = 10; // mm, structural divider rib between columns
left_col_width = board_w + 2*6; // mobo footprint + margin

// --- Structure ---
plate_t = 6;
wall_t  = 4;
ear_t   = 4;

// --- Slide hardware (off-the-shelf steel, ball-bearing, full-extension) ---
slide_hole_pitch  = 32;   // PLACEHOLDER — verify against your slides
slide_tab_height  = 20;
slide_tab_screw_d = 5;

$fn = 48;

// ============ derived ============
tray_width = rack_clear_width;
tray_depth = rack_usable_depth;
right_col_x0 = tray_width - right_col_width;

module rack_ear(h) {
    // Front mounting ear — the flange that screws the whole unit into the
    // rack. Standing tab, h tall, EIA-310 3-hole-per-U pattern repeated.
    ear_depth = 20;
    n_u = ceil(h / u_pitch);
    difference() {
        cube([ear_t, ear_depth, h]);
        for (u = [0 : n_u - 1]) {
            if (u*u_pitch + hole_a < h)
                translate([-1, ear_depth/2, u*u_pitch + hole_a]) rotate([0,90,0]) cylinder(d=6.4, h=ear_t+2);
            if (u*u_pitch + hole_c < h)
                translate([-1, ear_depth/2, u*u_pitch + hole_c]) rotate([0,90,0]) cylinder(d=6.4, h=ear_t+2);
        }
    }
}

module base_plate() {
    cube([tray_width, tray_depth, plate_t]);
}

module spine() {
    // Structural rib dividing the mobo column from the PSU/GPU column, and
    // stiffening the tiled front-panel segments against each other.
    translate([right_col_x0 - spine_width, 0, plate_t])
        cube([spine_width, mount_plate_depth, actual_panel_height]);
}

module slide_tab(x) {
    translate([x, tray_depth/2 - 40, 0])
        difference() {
            cube([wall_t, 80, slide_tab_height]);
            translate([wall_t/2, 40 - slide_hole_pitch/2, -1])
                cylinder(d=slide_tab_screw_d, h=slide_tab_height+2);
            translate([wall_t/2, 40 + slide_hole_pitch/2, -1])
                cylinder(d=slide_tab_screw_d, h=slide_tab_height+2);
        }
}

module mobo_segment() {
    // Left column. Standoff holes deliberately left unpunched — transfer
    // from the existing acrylic plate rather than a guessed ATX table.
    io_x0 = (left_col_width - io_w)/2;
    difference() {
        translate([0, 0, plate_t]) cube([left_col_width, wall_t, actual_panel_height]);
        translate([io_x0, -1, plate_t + actual_panel_height - io_h - io_top_margin])
            cube([io_w, wall_t+2, io_h]);
    }
    translate([(left_col_width-board_w)/2, wall_t + 0.5, plate_t])
        %cube([board_w, 0.5, board_d]); // ghosted reference outline only
    translate([(left_col_width-board_w)/2 + 10, wall_t + 1, plate_t + 10])
        rotate([90, 0, 0])
            linear_extrude(0.6) text("TRANSFER HOLES FROM OLD PLATE", size=6);
}

module psu_segment() {
    // Top-right. PSU cutout sized to the real ATX rear face (150x86mm) plus
    // fitting clearance, with a support shelf behind it — the front panel
    // alone shouldn't cantilever the PSU's weight.
    z0 = actual_panel_height - psu_seg_height;
    cx0 = right_col_x0 + psu_margin;
    difference() {
        translate([right_col_x0, 0, plate_t + z0]) cube([right_col_width, wall_t, psu_seg_height]);
        translate([cx0, -1, plate_t + z0 + psu_margin])
            cube([psu_w, wall_t+2, psu_h]);
    }
    // support shelf, screws into the PSU's bottom face
    translate([cx0, wall_t, plate_t + z0 + psu_margin])
        cube([psu_w, psu_d, wall_t]);
}

module gpu_segment() {
    // Below the PSU. Two stacked card-bracket cutouts, zero-margin stack
    // (see actual_panel_height derivation) — dry-fit and adjust.
    for (i = [0:1]) {
        row_z0 = i * gpu_row_height;
        cx0 = right_col_x0 + (right_col_width - (gpu_card_thickness + 2*gpu_margin))/2;
        difference() {
            translate([right_col_x0, 0, plate_t + row_z0]) cube([right_col_width, wall_t, gpu_row_height]);
            translate([cx0, -1, plate_t + row_z0 + gpu_margin])
                cube([gpu_card_thickness + 2*gpu_margin, wall_t+2, gpu_card_height]);
        }
    }
}

module tray() {
    if (render_part == "all" || render_part == "structural") {
        color("SteelBlue") {
            base_plate();
            translate([-ear_t, 0, plate_t]) rack_ear(actual_panel_height);
            translate([tray_width, 0, plate_t]) rack_ear(actual_panel_height);
            spine();
            slide_tab(0);
            slide_tab(tray_width - wall_t);
        }
    }
    if (render_part == "all" || render_part == "mobo") {
        color("FireBrick") mobo_segment();
    }
    if (render_part == "all" || render_part == "gpu") {
        color("SeaGreen") gpu_segment();
    }
    if (render_part == "all" || render_part == "psu") {
        color("MediumPurple") psu_segment();
    }
}

tray();
