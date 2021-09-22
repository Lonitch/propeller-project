This folder contains case files for running multi-propeller simulation using `komegaSST` model. 

- Please copy the `polyMesh` folder to `case/constant/` after you generate the mesh using the settings in `mesh` folder.

- Before you run the simulation, please run the command `./Allclean` to clean residual files

- Use `./Allrun` to do the simulation, you might consider changing variables in `turbulenceProperties`, `transportProperties`, `dynamicMeshDict`, `controlDict`, and `fvSolution`