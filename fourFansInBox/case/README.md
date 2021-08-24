This folder contains case files for running multi-propeller simulation using `komegaSST` model. 

- The folder `0.100255` contains final results of a 0.1s laminar-flow simulation, you can use paraView to check it

- Before you run the simulation, please run the command `./Allclean` to clean residual files

- Use `./Allrun` to do the simulation, you might consider changing variables in `turbulenceProperties`, `transportProperties`, `dynamicMeshDict`, `controlDict`, and `fvSolution`