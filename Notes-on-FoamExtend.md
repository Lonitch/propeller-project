# Notes on Foam Extend 4.1
Foam extend is a good extension to OpenFOAM but it requires a separate installation. To use OpenFOAM and FoamExtend on the same machine, right after your installation complete, add the following two lines in the file `.bashrc`:

```bash
alias of21 = 'source path/to/openfoam/etc/bashrc'
alias fe41 = 'source path/to/foamextend/etc/bashrc'
```
These commands set up environment variables for OpenFOAM and FoamExtend, respectively. Run command of `of21` (or `fe41`) before you run OpenFOAM case (or FoamExtend case). The alias names in the example above are arbitrary.

## Some shortcuts
- Go to **tutorial folder**: `tut`

## Case file structure
- Unlike OpenFOAM, the file `blockMeshDict` for FoamExtend case is stored in `constant/polyMesh` folder.

## Log and output
- To **record logs** of a simulation, simply use
    * `solverName > log.xxxx`
- To **extract info from log file**:
    * `grep [option] "keyWord" log.original > log.new`
    * `[option]` above could be `-i` (case insensitive)
- **Find names of files that contain info you want**:
    * `grep -l "foam" *` shows filenames that contain the string of `foam`