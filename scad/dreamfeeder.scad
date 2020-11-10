//   Copyright 2020, Niclas Hedhman
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

include <NopSCADlib/lib.scad>

$fn=100;

WIDTH=8;
TAPE_THICKNESS=2.0;
GUIDE_SHELF=3.5;
GUIDE_BASE=2.0;
GUIDE_WALL=2.0;

if($preview)
  main_assembly();

module main_assembly() pose([20,0,70],[-5.17,-19.54,-31.74])
  assembly("main") {
  z_off = is_undef($explode) || !$explode ? 0 : 10;
  *translate([0,0,-1.6 -z_off]) pcb();
  translate([0,0,z_off]) guide1_stl();
  color("#FF8080") guide2_stl();
  translate([-25,-10,0]) pusher();
  translate([5,-45,6.3]) rotate([90,0,-90]) servo_mg90s();
}
module pusher() {
  translate([0,0,3.7]) rotate([90,0,30]) color("blue") cylinder(18,0.5,0.5);
  color("pink") pusher_stl();
}

module pusher_stl() {
  stl("pusher");
  difference() {
    translate([3.05,-25,GUIDE_BASE]) cube([9,15,5]);
    translate([7.5,-28,GUIDE_BASE-0.05]) cube([3,20,1.2]);
    hull() {
      translate([0,0,3.7]) rotate([90,0,30]) color("blue") cylinder(20,0.5,0.5);
      translate([0,0,0]) rotate([90,0,30]) color("blue") cylinder(20,0.5,0.5);
    }
  
    translate([6,-20,0.75]) linear_extrude(4) {
      translate([0,0,0]) circle(1.5);
      translate([0,-3.5,0]) square([1,6], center=true);
    }
  }
}

module servo_mg90s() {
  color("lightblue"){
    cube([23, 12.6,23], center=true);
    translate([0,0,6.65]) linear_extrude(2.85) {
      difference() {
        square([32.5,12.6],center=true);
        translate([13.75,0,0]) circle(1.1);
        translate([-13.75,0,0]) circle(1.1);
      }
    }
    translate([5.75,0,11.5]) cylinder(6,6,6);
    translate([0,0,11.5]) cylinder(5.5,2.5,2.5);
  }
  color("lightgray") translate([5.75,0,16.5]) cylinder(5.5,2.3,2.3);
  color("gray") translate([5.75,0,19]) wing1();
}

module wing1() {
    
    cylinder(4.65,3.4,3.4);
    hull() {
      translate([0,0,2.75]) cylinder(1.9,3.4,3.4);
      translate([-6,0,2.75]) cylinder(1.9,2.25,2.25);
    }
}

module guide1_stl() {
  stl("guide1");
  translate([0,0,WIDTH+GUIDE_BASE+0.5]) linear_extrude(GUIDE_BASE*2) {
    guide_2d(TAPE_THICKNESS+2*GUIDE_WALL,0);
  }
  translate([0,0,GUIDE_BASE+WIDTH+0.5-GUIDE_SHELF]) linear_extrude(GUIDE_SHELF) {
    guide_2d(GUIDE_WALL,-(TAPE_THICKNESS+GUIDE_WALL)/2);
  }
  translate([0,0,3*GUIDE_BASE+WIDTH+0.5]) {

    translate([-18+GUIDE_WALL/2+(TAPE_THICKNESS+GUIDE_WALL)/2,5,0]) rotate([180,0,0]) screw_receptor();
    translate([40,45-GUIDE_WALL-TAPE_THICKNESS,0]) rotate([180,0,0]) screw_receptor();
    translate([11+GUIDE_WALL/2,-95+(TAPE_THICKNESS+GUIDE_WALL)/2,0]) rotate([180,0,0]) screw_receptor();
  }
}

module guide2_stl() {
  stl("guide2");
  linear_extrude(GUIDE_BASE) {
    guide_2d(TAPE_THICKNESS+2*GUIDE_WALL,0);
  }
  translate([0,0,GUIDE_BASE]) linear_extrude(GUIDE_SHELF) {
    difference() {
      guide_2d(GUIDE_WALL,-(TAPE_THICKNESS+GUIDE_WALL)/2);
      translate([-20.5-TAPE_THICKNESS/2,0])
      polygon([[0,-14],[-GUIDE_WALL-1,-10],[-GUIDE_WALL-1,-30],[0,-34]]);
    }
  }
  translate([0,0,0]) linear_extrude(2) {
    difference() {
      translate([8.5,0]) rotate(180) square([33.5,100]);
      hull() {
        translate([-28,-51]) circle(1);
        translate([10,-107-TAPE_THICKNESS+2*GUIDE_WALL*0.75-1.5]) circle(1);
        translate([-50,-120]) circle(1);
      }
      translate([-15,-39]) rotate(180) square([5,15]);
      translate([16.8,-33.25]) rotate(180) square([23.5,23.5]);
      translate([-1.6,-28.5]) rotate(180) square([3,33]);
      
      translate([-11.5,-20]) difference() {
        square([30,30]);
        circle(20);
      }
    }
  }
  translate([-17.35,-39,GUIDE_BASE]) rotate([0,0,0]) #cube([2.8,25,1]);

  translate([0,0,GUIDE_BASE]) linear_extrude(WIDTH+0.5) {
    difference() {
      guide_2d(GUIDE_WALL,(TAPE_THICKNESS+GUIDE_WALL)/2);
      translate([-24.5-TAPE_THICKNESS/2,0]) {
        polygon([[0,7],[-GUIDE_WALL-1,3],[-GUIDE_WALL-1,-10],[0,-6]]);
      }
    }
  }
  translate([-18+GUIDE_WALL/2+(TAPE_THICKNESS+GUIDE_WALL)/2,5,0]) screw_receptor();
  translate([40,45-GUIDE_WALL-TAPE_THICKNESS,0]) screw_receptor();
  translate([11+GUIDE_WALL/2,-95+(TAPE_THICKNESS+GUIDE_WALL)/2]) screw_receptor();
}

module screw_receptor() {
  linear_extrude(GUIDE_BASE+GUIDE_SHELF-2.4) difference() {
    circle(8);
    circle(3.2);
  }
  translate([0,0,GUIDE_BASE+GUIDE_SHELF-2.4]) linear_extrude(2.4) difference() {
    circle(8);
    circle(5.6, $fn=6);
  }

}

module guide_2d(width,offset) {
  points1 = [[47,50-width/2+offset],[47,50+width/2+offset],[25,50+width/2+offset],[25,50-width/2+offset]];
  points2 = [[-25-width/2-offset,0],[-25+width/2-offset,0],[-25+width/2-offset,-51],[10,-107+width*0.75-1.5*offset],[10,-107-width*0.75-1.5*offset],[-25-width/2-offset,-51]];
  union() {
    polygon(points1);
    polygon(points2);
    translate([25,0]) difference() {
      circle(50+width/2+offset);
      circle(50-width/2+offset);
      translate([0,-25-width]) square([75+width+offset,150]);
      translate([75,0]) rotate([180,0,-90]) square([50+width+offset,150]);      
      children();
    }
  }
}

module pcb() {
    
  points = [[0,30],[30,30],[30,-10],[0,-10],[0,-50], [40,-50], [40,-110], [-10,-110],[-30,-90], [-30,0]];
  color("#00C000") linear_extrude(1.6) union() {
    polygon(points);
    difference() {
      circle(30,$fn=100);
      translate([0,-30]) square([30,60]);
      translate([-30,-31]) square(31);
    }
  }
}