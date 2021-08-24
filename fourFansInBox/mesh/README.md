This folder generates mesh for multi-propeller simulations. The script `Allrun.pre` runs a series of jobs, including transferring newly-generated mesh files to the `case` folder.

- Store your geometries in `constant/triSurface`. If you use Blender, make sure you export your scene into `.stl` files

- You will need to modify `surfaceFeatureExtractDict`, `blockMeshDict`, `createPatchDict`, `snappyHexMeshDict` to fit your needs