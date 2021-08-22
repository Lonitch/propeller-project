# Notes on snappyHexMesh
Perhaps the easiest tutorial on snappyHexMesh is `$FOAM_TUTORIALS/incompressible/simpleFoam/motorBike`.

## Case file settings
- Geometry files are stored in the folder of `constant/triSurface`

- Settings in `snappyHexMeshDict` and `surfaceFeaturesDict` are important

>**Q:** How to check if we arranged our objects at the right places?
**A:** Just run `blockMesh` before `snappyHexMesh`
 and check the configuration in ParaView

## Workflow that uses `blockMesh` and `snappyHexMesh`

`surfaceFeatures`-->`blockMesh`-->`decomposePar`(optional))-->`snappyHexMesh -overwrite`-->run solver-->(`reconstructParMesh -constant`-->`reconstructPar -latestTime`)

- Run `snappyHexMesh` without `-overwrite` option will store information of each interation of `snappyHexMesh` calculation, and separate folders with their names being `1`,`2`,... will show up. The final mesh information replaces initial mesh in `0` folder if run with `-overwrite` option.

## Understanding snappyHexMesh
`snapplyHexMesh` works in three steps:
1. **Create castellated mesh**: disect the domain into cubes of different sizes (base mesh), e.g., create small cubes near complicated geometry.
2. **Snap little cubes to geometry of interest**: distort small cubes within complicated geometry
3. **Create boundary mesh**: add boundary layers that make boundaries of complicated geometry smooth

## Notes on `snappyHexMeshDict` and `surfaceFeaturesExtractDict`
0. In earlier version of openFOAM, `surfaceFeaturesExtractDict` was named as `surfaceFeaturesDict`

1. A **geometry** dictionary in `snappyHexMeshDict` could look like 
```bash
geometry
{
    objectOfInterest.stl
    {
        type triSurfaceMesh;
        name object;
    }
    refinementBox ## interface btw object and the rest of the domain
    {
        type box;
        min (x1 xy z1);
        max (x2 y2 z2);
    }
}
```

2. `surfaceFeaturesDict` specifies what kind of geometric features that `snappyHexMesh` should be careful with, and create castellated mesh upon.

## Import and manipulate geometry
If you're using **blender**, you can export your geometry in the format of `.stl`, which encodes information of 3D points in the geometry. To import the geometry, you simply:

1. change info of `geometry` card regarding the object of interest in `snappyHexMeshDict`, and change name of `xxx.emesh` in the file. (`.emesh` is what we feed to `snappyHexMesh`);

2. change info of the object in `surfaceFeaturesExtractDict`.

If the configuration of your object is off, you can use `surfaceTransformPoints` function to manipulate points encoded in `xxx.stl` file. For example, the following command translate all the points by a vector of `(3.5 0 4)` in the file `sphere.stl` and create a new file named as `sphere1.stl`:
 ```bash
 surfaceTransformPoints sphere.stl -translate "(3.5 0 4)" sphere1.stl
 ```
