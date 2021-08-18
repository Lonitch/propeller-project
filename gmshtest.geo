// Gmsh project created on Wed Aug 18 16:37:40 2021
SetFactory("OpenCASCADE");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
SetFactory("Built-in");
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {1, 0, 0, 1.0};
//+
Point(3) = {0, 1, 0, 1.0};
//+
Point(4) = {1, 1, 0, 1.0};
//+
Line(1) = {3, 4};
//+
Line(2) = {4, 2};
//+
Line(3) = {2, 1};
//+
Line(4) = {1, 3};
//+
Curve Loop(1) = {1, 2, 3, 4};
//+
Plane Surface(1) = {1};
//+
Extrude {0, 0, 0.1} {
  Surface{1}; 
  Layers{1};
  Recombine;
}
//+
Physical Surface("sides", 30) = {1, 26};
//+
Physical Surface("left", 31) = {25};
//+
Physical Surface("right", 32) = {17};
//+
Physical Surface("top", 33) = {13};
//+
Physical Surface("bottom", 34) = {21};
//+
Physical Volume("volume", 35) = {1};
//+
Transfinite Curve {6, 1, 8, 3} = 10 Using Progression 1;
//+
Transfinite Curve {7, 2, 9, 4} = 15 Using Progression 1;
//+
Transfinite Curve {11, 12, 16, 20} = 1 Using Progression 1;
//+
Transfinite Surface {1} = {1, 3, 4, 2};
//+
Transfinite Surface {26} = {14, 10, 6, 5};
//+
Recombine Surface {28};
//+
Recombine Surface {6};