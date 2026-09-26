// mobo-gpu-psu-tray.scad
//
// Slide-out rack tray: EATX motherboard (offset right), vertical GPU bracket
// in the remaining space, PSU cradle. Mounts to purchased steel drawer slides
// (NOT printed rails — a printed sliding joint can't reliably carry mobo +
// 2 GPUs + PSU through repeated cycles).
//
// ============ VERIFY THESE BEFORE PRINTING ============
// Everything below is a named variable for exactly this reason: measure your
// actual hardware, edit these numbers, re-render. Do not print on defaults.

// --- Rack ---
rack_clear_width  = 300;   // mm — INTERIOR clear width, rail-to-rail or panel-to-panel.
                            // PLACEHOLDER. Generic "10-inch rack" specs say ~222mm clear,
                            // but that can't be right here — your board is 277mm wide and
                            // already fits. Measure the real number and replace this.
rack_usable_depth = 260;   // mm — front rail to back rail, from Tecmojo's 10.23in spec
u_pitch           = 44.45; // mm — EIA-310 rack unit, standard, do not change
tray_u_height     = 6;     // U's of vertical clearance the ears mount across —
                            // matches roughly what the current build occupies (from
                            // the rack photo). Adjust once GPU cooler stack height
                            // is confirmed.
hole_a            = 6.35;  // mm — EIA-310 hole positions within a U, standard
hole_b            = 15.875;
hole_c            = 25.4;

// --- Motherboard (MSI MEG X670E ACE — W x D sourced from MSI/Micro Center specs) ---
board_w = 277;    // mm
board_d = 304.8;  // mm — longer than rack_usable_depth, so it overhangs the back on purpose
board_offset_right = 63.5; // mm (~2.5in, midpoint of your 2-3in ask) — gap reserved on the
                            // right edge for the GPU bracket. Adjust to taste.

// --- GPU bracket zone (vertical fin, expansion-slot bracket screws) ---
gpu_zone_width  = board_offset_right; // mm — the strip right of the board
slot_pitch      = 20.32;  // mm — standard expansion-slot spacing, real spec
slot_count      = 4;      // number of slot positions to provide — DRY-FIT AND ADJUST.
                            // Riser cable routing determines the real bracket height/position;
                            // this is a starting fixture, not a final measurement.
slot_screw_d    = 4.5;    // mm — clearance for M4/6-32 slot screws

// --- PSU (Corsair RM850e — W/H fixed by ATX spec, depth is the modular-PSU variable) ---
psu_w = 150; // mm — fixed ATX standard, do not change
psu_h = 86;  // mm — fixed ATX standard, do not change
psu_d = 140; // mm — typical modular ATX depth. VERIFY against your RM850e (measure it).

// --- Structure ---
plate_t = 6;  // mm — base plate thickness. Use PETG or ABS, not PLA, for sustained load.
wall_t  = 4;  // mm — rib/wall thickness
ear_t   = 4;  // mm — front rack-ear thickness

// --- Slide hardware (off-the-shelf steel, ball-bearing, full-extension) ---
// Reference part: 10-12in full-extension slide, ~100lb/pair rated (e.g. TCH/quikdrawers-
// style). Confirm your purchased slide's actual hole spacing before printing the tabs.
slide_hole_pitch  = 32;   // mm — typical inner-member screw spacing, VERIFY against your slides
slide_tab_height  = 20;   // mm
slide_tab_screw_d = 5;    // mm, slotted for adjustment

$fn = 48;

// ============ derived ============
tray_width = rack_clear_width;
tray_depth = rack_usable_depth;

module rack_ear(n_u) {
    // Front mounting ear: a vertical tab standing up from the tray's front
    // edge, n_u rack-units tall, with the EIA-310 3-hole pattern repeated
    // at the bottom of each U. Thin in Y (20mm) so it reads as a flange
    // against the rack's front rail, not a full-depth wall.
    ear_depth = 20;
    difference() {
        cube([ear_t, ear_depth, n_u * u_pitch]);
        for (u = [0 : n_u - 1]) {
            translate([-1, ear_depth/2, u*u_pitch + hole_a]) rotate([0,90,0]) cylinder(d=6.4, h=ear_t+2);
            translate([-1, ear_depth/2, u*u_pitch + hole_c]) rotate([0,90,0]) cylinder(d=6.4, h=ear_t+2);
        }
    }
}

module base_plate() {
    cube([tray_width, tray_depth, plate_t]);
}

module mobo_zone_marker() {
    // No pre-drilled standoff holes — transfer these from your existing acrylic
    // plate by tracing, then drill. See file header.
    x0 = tray_width - board_offset_right - board_w;
    translate([x0, 0, plate_t])
        %cube([board_w, board_d, 0.5]); // ghosted reference outline only
    translate([x0 + 10, 10, plate_t])
        linear_extrude(0.6) text("TRANSFER HOLES FROM OLD PLATE", size=6);
}

module gpu_bracket() {
    // Vertical fin along the right-edge strip, with a slotted screw column
    // for the expansion-slot brackets. Height/position of slots is a
    // starting point — dry-fit your actual risers and adjust slot_count /
    // spacing before final print.
    fin_x = tray_width - gpu_zone_width;
    difference() {
        union() {
            cube([wall_t, tray_depth, plate_t]); // base flange, part of plate
            translate([fin_x, 0, 0])
                cube([wall_t, tray_depth, tray_u_height * u_pitch]); // vertical fin, spans the same clearance as the ears
        }
        for (i = [0:slot_count-1])
            translate([fin_x - 1, 20 + i*slot_pitch, 20 + i*10])
                rotate([0, 90, 0])
                    cylinder(d=slot_screw_d, h=wall_t+2);
    }
}

module psu_cradle() {
    // 3-wall pocket (bottom handled by base plate) sized to the PSU
    // footprint, positioned in the leftover front-left corner. Reposition
    // after dry-fitting the mobo + GPU bracket — this is a placeholder slot.
    translate([0, tray_depth - psu_d, 0]) {
        // left wall
        cube([wall_t, psu_d, psu_h]);
        // front wall (rack-front side)
        translate([0, psu_d - wall_t, 0]) cube([psu_w + wall_t, wall_t, psu_h]);
        // right wall
        translate([psu_w, 0, 0]) cube([wall_t, psu_d, psu_h]);
    }
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

module tray() {
    base_plate();
    translate([-ear_t, 0, plate_t]) rack_ear(tray_u_height); // left ear, standing up from front edge
    translate([tray_width, 0, plate_t]) rack_ear(tray_u_height); // right ear
    mobo_zone_marker();
    gpu_bracket();
    psu_cradle();
    slide_tab(0);
    slide_tab(tray_width - wall_t);
}

tray();
