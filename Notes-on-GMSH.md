# Notes on GMSH
GMSH is another mesh generator that works well with openFOAM, and provides precise control options for complicated geometries.

## Some alerts
There are some pitfalls along the way of using GMSH. The arguably most significant one is no `undo` option in GUI.

## Examples of creating objects in GMSH
Geometry info is collected in a file named as `xxxx.geo`, it has a file header as:
    `// Gmsh project created on Wed Aug 18 16:37:40 2021
SetFactory("OpenCASCADE");`

Any changes made in file `xxxx.geo` will be reflected in GMSH.

- Create point

```css
Point(1) = {0, 0, 0, 1.0};
Point(2) = {1, 0, 0, 1.0};
```
    the last number `1.0` gives the weight of mesh at the point

- Create line/loop **using indices of points**
```css
Line(3) = {2, 1};
Curve Loop(1) = {1, 2, 3, 4};
```

- Create plane **using indices of loops**
```css
Plane Surface(1) = {1};
```

- Extrude surface into polyhedron 

```css
//extrude surface at z direction by 0.1 unit
//and set number of layers to be 1 to indicate 
//no dynamics allowed at the z direction

Extrude {0, 0, 0.1} {
  Surface{1}; 
  Layers{1};
  Recombine; // good for building structured mesh
}
```