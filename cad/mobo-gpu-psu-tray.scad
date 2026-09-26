// mobo-gpu-psu-tray.scad
//
// Slide-out rack tray: EATX motherboard mounted VERTICALLY (matches the
// current physical build — board stands up like a normal case, not flat on
// the tray floor), offset from the right edge. Vertical GPU bracket in the
// remaining strip. PSU cradle on the floor behind. Mounts to purchased steel
// drawer slides (NOT printed rails — a printed sliding joint can't reliably
// carry mobo + 2 GPUs + PSU through repeated cycles).
//
// v0.2 — switched mobo mount from flat/horizontal to vertical after
// confirming the IO shield needs to be front-facing: a flat-mounted board's
// IO shield projects sideways at deck height, which doesn't make sense to
// plug into from a rack's front face. Vertical mounting is also what the
// current acrylic-plate build already does.
//
// ============ VERIFY THESE BEFORE PRINTING ============

// --- Part selector, for per-subsystem STL export / color preview ---
render_part = "all"; // "all" | "structural" | "mobo" | "gpu" | "psu"

// --- Rack ---
rack_clear_width  = 350;   // mm — INTERIOR clear width, rail-to-rail or panel-to-panel.
                            // PLACEHOLDER. Generic "10-inch rack" specs say ~222mm clear,
                            // but that can't be right here — your board is 277mm wide and
                            // already fits. Measure the real number and replace this.
rack_usable_depth = 260;   // mm — front rail to back rail, from Tecmojo's 10.23in spec
u_pitch           = 44.45; // mm — EIA-310 rack unit, standard, do not change
tray_u_height     = 8;     // U's of vertical clearance the ears mount across
hole_a            = 6.35;  // mm — EIA-310 hole positions within a U, standard
hole_c            = 25.4;

// --- Motherboard (MSI MEG X670E ACE — dimensions sourced from MSI/Micro Center specs) ---
board_w = 277;    // mm — runs left-right (X)
board_d = 304.8;  // mm — the board's long dimension. Mounted VERTICALLY, so this
                    // runs top-to-bottom (Z), not front-to-back. Needs ~7U (311mm)
                    // of clearance; tray_u_height=8 gives headroom for the IO
                    // cutout margin and GPU cooler stack above/below.
board_offset_right = 63.5; // mm (~2.5in, midpoint of your 2-3in ask) — gap reserved on
                            // the right edge for the GPU bracket. Adjust to taste.
mount_plate_depth  = 12;   // mm — how deep the vertical mounting plate's standoff/gusset
                            // structure runs (Y). Thin on purpose; verify it clears
                            // whatever the GPU riser cables' bend radius needs.

// --- IO shield cutout (standard ATX/EATX size — genuinely universal, sourced) ---
io_w = 158.75;  // mm — 6.25in, standard
io_h = 44.45;   // mm — 1.75in, standard
io_top_margin = 8; // mm from the top of the board to the top of the IO cutout —
                     // PLACEHOLDER, MSI's exact IO shield offset isn't confirmed.
                     // Cutout is centered on the board's width by default — verify
                     // both against your board before printing.

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
psu_d = 140; // mm — typical modular ATX depth. VERIFY against your unit (measure it).

// --- Structure ---
plate_t = 6;  // mm — base plate thickness. Use PETG or ABS, not PLA, for sustained load.
wall_t  = 4;  // mm — rib/wall thickness
ear_t   = 4;  // mm — front rack-ear thickness

// --- Slide hardware (off-the-shelf steel, ball-bearing, full-extension) ---
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
    // at the bottom of each U.
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

module mobo_mount_plate() {
    // Vertical mounting plate, standing up from the tray floor at the front
    // edge. Doubles as the IO bezel — ports project through the cutout at
    // the rack's front face while the tray is pushed in. Standoff holes are
    // deliberately left unpunched: transfer them from the existing acrylic
    // plate rather than trust a generic ATX hole table.
    x0 = tray_width - board_offset_right - board_w;
    io_x0 = x0 + (board_w - io_w)/2; // centered under the board footprint — VERIFY

    difference() {
        translate([x0, 0, plate_t]) cube([board_w, mount_plate_depth, board_d]);
        translate([io_x0, -1, plate_t + board_d - io_h - io_top_margin])
            cube([io_w, mount_plate_depth + 2, io_h]);
    }
    translate([x0, mount_plate_depth + 0.5, plate_t])
        %cube([board_w, 0.5, board_d]); // ghosted reference outline only
    translate([x0 + 10, mount_plate_depth + 1, plate_t + 10])
        rotate([90, 0, 0])
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
                cube([wall_t, tray_depth, tray_u_height * u_pitch]); // vertical fin, spans the same clearance as the mobo plate
        }
        for (i = [0:slot_count-1])
            translate([fin_x - 1, 20 + i*slot_pitch, 20 + i*10])
                rotate([0, 90, 0])
                    cylinder(d=slot_screw_d, h=wall_t+2);
    }
}

module psu_cradle() {
    // 3-wall pocket (bottom handled by base plate) sized to the PSU
    // footprint, toward the rear of the floor — clear of the vertical mobo
    // plate's now-small footprint. Reposition after dry-fitting.
    translate([0, tray_depth - psu_d, 0]) {
        cube([wall_t, psu_d, psu_h]); // left wall
        translate([0, psu_d - wall_t, 0]) cube([psu_w + wall_t, wall_t, psu_h]); // front wall
        translate([psu_w, 0, 0]) cube([wall_t, psu_d, psu_h]); // right wall
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
    if (render_part == "all" || render_part == "structural") {
        color("SteelBlue") {
            base_plate();
            translate([-ear_t, 0, plate_t]) rack_ear(tray_u_height);
            translate([tray_width, 0, plate_t]) rack_ear(tray_u_height);
            slide_tab(0);
            slide_tab(tray_width - wall_t);
        }
    }
    if (render_part == "all" || render_part == "mobo") {
        color("FireBrick") mobo_mount_plate();
    }
    if (render_part == "all" || render_part == "gpu") {
        color("SeaGreen") gpu_bracket();
    }
    if (render_part == "all" || render_part == "psu") {
        color("MediumPurple") psu_cradle();
    }
}

tray();
