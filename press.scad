include <BOSL2/constants.scad>
include <BOSL2/std.scad>
use <BOSL2/shapes.scad>

// $fa=1;
// $fs=0.1;
$fa=10;
$fs=1;

width = 1200;
length = 1760;
thickness = 20;
margin = 100;

pin_height = 20;
pin_diameter = 5;
pin_spacing = 100;
pin_depth = 10;



module pins() {
    echo(num_components=$children);
    up(pin_height/2)
    grid2d(size=[width, length], spacing=[pin_spacing, pin_spacing])
    cyl(l=pin_height, r=pin_diameter/2);
}

up(thickness-pin_depth)
pins();

module matrix() {
    difference() {
        cuboid([width + 2 * margin, length + 2 * margin, thickness], anchor=BOTTOM);
        up(thickness-1)
        cuboid([width, length, 2], anchor=BOTTOM);
        up(thickness-pin_depth)
        pins();
    }
}

matrix();


font = "Liberation Sans";

letter_size = 100;
letter_height = 2;
stamp_height = letter_size + 10;
stamp_width = letter_size;
stamp_thickness = 15;

module letter(l) {
	linear_extrude(height = letter_height) {
		text(l, size = letter_size, font = font, halign = "center", valign = "center", $fn = 16);
	}
}

module stamp(l) {
    difference() {
        union() {
            cuboid([stamp_width, stamp_height, stamp_thickness], anchor=BOTTOM);
            
            xflip()
            color( rands(0,1,3), alpha=1 )
            up(stamp_thickness)
            letter(l);
        }
        down(pin_height/2)
        pins();
    }

}

module stamps() {

    distribute(spacing=stamp_height, dir=FRONT) {
        distribute(spacing=stamp_width, dir=LEFT) {
            stamp("F");
            stamp("A");
            stamp("B");
            stamp("R");
            stamp("I");
            stamp("Q");
            stamp("U");
            stamp("E");
        }
        distribute(spacing=stamp_width, dir=LEFT) {
            stamp("D");
            stamp("E");
            stamp(" ");
            stamp("L");
            stamp("A");
        }
        distribute(spacing=stamp_width, dir=LEFT) {
            stamp("N");
            stamp("A");
            stamp("T");
            stamp("U");
            stamp("R");
            stamp("E");
        }
    }
}

translate([-200, -650, thickness])
stamps();

wheel_thickness = 20;
wheel_diameter = 500; // inner wheel, from paper to the top
wheel_axe_diameter = 35;
rail_height = stamp_thickness + thickness - 5;

wheel_batten_width = 15;
wheel_batten_height = 40;
wheel_n_batten = 40;

wheel_position_y = wheel_diameter / 2 + thickness + stamp_thickness;

module wheel_battens() {
    xrot_copies(n=wheel_n_batten, r=wheel_diameter/2)
    xrot(90)
    batten();
}

module wheel_in() {
    difference() {
        yrot(90)
        down(wheel_thickness/2)
        tube(h=wheel_thickness, od=wheel_diameter, id=wheel_axe_diameter);
        wheel_battens();
    }
}

xcopies((width + 2 * margin + wheel_thickness)/3, 2)
up(wheel_position_y)
wheel_in();


module batten() { // chevron / liteau
    cuboid([width + 2 * margin + 2 * wheel_thickness, wheel_batten_width, wheel_batten_height], anchor=BOTTOM);
}




#up(wheel_position_y)
wheel_battens();

module wheel_out() {
    difference() {
        yrot(90)
        down(wheel_thickness/2)
        tube(h=wheel_thickness, od=wheel_diameter + 2 * rail_height, id=wheel_axe_diameter);
        wheel_battens();
    }
}

xcopies(width + 2 * margin + wheel_thickness, 2)
up(wheel_position_y)
wheel_out();

// skin
skin_width = width + 2 * margin;
// color( rands(0,1,3), alpha=0.3 )
// up(wheel_position_y)
// yrot(90)
// down(skin_width/2)
// tube(id=wheel_diameter, od=wheel_diameter + 2, h=skin_width);

handle_width = 200;

module axe() {
    axe_width = width + 2 * margin + 2 * wheel_thickness + 2 * handle_width;
    up(wheel_position_y)
    yrot(90)
    cyl(l = axe_width, r=wheel_axe_diameter/2);
}

axe();