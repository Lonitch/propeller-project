# Notes on Blender

## Key Combos for Shortcuts
- **selects everything** in a scene: `a`
- **add new object**: `shift`+`a` 
- **switch between `object` and `edit` mode**: `tab` 
- **open snap panel** to snap cursor/object to grid/origin: `shift`+`s` 
- **grab a selected surface**: `g` 
    * To make constrained drag along primary axes, we can press and hold `x`, `y`, or `z` while we drag the surface.
- **extrude from any surface**: `e`
    * Extruding action will create additional block which can be recognized by **blockMesh**
- **align surfaces**:
    1. In the dropdown manu of "transform pivot point", select "`Active element`"
    2. press `shift` and select two surfaces you want them aligned at the same level
    3. press `s` so that the surfaces are able to scale according to each others' position/size
    4. press `x`, `y`, or `z` to constrain the direction along which the scaling is happening
    5. type `0` and hit `enter` to align the two surfaces.
- **create face based on vertices**:
    1. press `shift` while click `vertices` under `edit` mode
    2. press `s` to create one face based on selected vertices
- **delete face/edge/vertices**:
    1. selecte the object you want to delete in `edit` mode
    2. press `delete`, a menu will jump out for you to select which element of your selection needs to be deleted.
- **merge face/edge/vertices**
    1. select two objects you want to merge
    2. press `m` to open merge menu, the options are 
        * "at first": merge at the first selection
        * "at last": merge at the last selection
        * "at center": merge at the middle point
        * "at distance": merge objects when the distance between them are less than an user-defined number. We can specify such number at the menu showing at the lower left corner
- **merge vertices (an easier way)**:
    1. select one vertex
    2. turn on `auto merge` at the upper right corner on the screen
    3. press `g` twice to make the selection slide along edges
    4. once the selected object is close to another alike object, e.g., vertex to vertex, the two will merge automatically

## Uses of `swiftblock` add-on
`swiftblock` is an add-on in blender for us to create mesh that can be read and analyzed by `blockMesh`. A general workflow of `swiftblock` is:

1. **save the geometry** you just created
2. **initialize object** (you might consider select the whole geometry before clicking the button)
3. click `build` to **generate clocks**. Unwanted blocks might be generated, but you can delete them by
    * select the block and find its name using `Get block from selection`
    * unselect the block,
4. **set number of cells** along each edge:
    * Choose an edge
    * type a number in `Cells`
    * click `set params`
5. **set number of cells at parallel edges**:
    * select a edge
    * click `select group`
    * repeat steps in (4)
6. **get cell number at an edge**:
    * select a edge
    * click `Get params`
7. **add boundary patches**:
    * select a set of surfaces
    * add them as single patch by clicking `+` in `Boundary Patches` card
    * rename the patch and select its nature as `wall`(if you don't wanna do anything), `patch`(if you gonna do smt),`empty`(for 2d/1d geometry),`symmetry`(surfaces as mirrors)
8. **export mesh files**:
    * simply click `export`, a folder will be created within which two subfolders, `constant` and `system`, can be found

9. **set initial/boundary condition on mesh**:
    * run `blockMesh` to first generate `polyMesh` folder in `constant`
    * set initial/boundary conditions by copying names of patches to the files in `0` folder