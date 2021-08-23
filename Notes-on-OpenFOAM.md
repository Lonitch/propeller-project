# Elementary Notes on OpenFOAM

## 1. Case File Structure
Each calculation case folder (i.e. parent folder) has three subfolders: "0" (or "0.orig" as a backup file), "constant", and "system".

### 1.1 In "0", we have

- `p` that contains initial info of pressure

    * The first 7 lines of each file give header information that has no effect on your physical system;

    * the array after `dimensions` [x x x x x x x], indicates orders of IS units,  `kg`, `m`, `s`,`K`,`kgmol`,`A`,`cd`;

    * `internalField` sets initial field state, e.g., `internalField uniform 0` sets initial pressure to be 0 everywhere in the domain of interest;

    * `boundaryField` sets boundary conditions;

    * both `internalField` and `boundaryField` can be set using **nested bracket**, which has a basic format of `{name-of-object-1 {type xxx;value xxx;} name-of-object-2 {type xxx; value xxx}}`；

    * To set "**Neumann boundary condition**, we can use `{type zeroGradient;}`；

    * To set "**Dirichlet boundary condition**", we can use `{type fixedValue;value uniform x}`；

    * we can also set boundary condition type to be `empty`；

- `U` that contains initial info of velocity field;

    * Unlike the `p` file, we specify `internalField` using vectors. For example, no flow at the beginning can be set as `internalField uniform (0 0 0)`;

    * We can still specify Neumann boundary condition using `zeroGradient`, and fixed vector `uniform (x x x)` for `fixedValue` (Dirichlet) boundary condition.

    * There is a special type called `empty` to ask solver not to solve eqns perpendicular to those boundaries.

### 1.2 In "constant", we have 

- `transportProperties` file to set property constant. Notice that we specify each constant in a form of `name [x x x x x x x] val` with the middle list and the `val` being unit and value, respectively.

### 1.3 In "system", we have 

- `controlDict` to set time step resolution.
- `setFieldsDict` sets initial conditions for specific regions in the domain. To activate the settings, **we need to run `setFields` after we run `blockMesh`**.
    * there are three major ways to define regions in a domain:
        * `boxToCell` defines rectangular prism region by specifying two end points of a diagonal;
        * `sphereToCell` defines spherical region by specifying center and radius;
        * `cylinderToCell` defines cylindrical region by specifying two end points of one side line , and radius of the cylinder.
> To check whether initial conditions are correctly set, you can first run `foamToVTK` can use paraView to visualize initial states of fields.

## 2. `blockMesh` functionalities

The inputs for `blockMesh` are stored in the file `blockMeshDict` in the "system" folder. In the file:

- `scale` (or "convertToMeters" in earlier versions) specifies relationships between input units and SI unit "meter", e.g., `scale 0.1` indicates inputs having a unit of `0.1m`;

- `vertices` dictionary includes coordinates that define domains. 

- `edges` dictionary includes information of arc/curves in the domain.

- `block` dictionary defines subdomains. each entry has a format of 

    `hex (v1 v2 v3 v4 v5 v6 v7 v8) (n1 n2 n3) simpleGrading (1 1 1)`

    * the first bracket includes vertices of the subdomain, the example above defines a rectangular prism using 8 coordinates of vertices. The vertices are arranged in a counter-clockwise sequence.

    * the second bracket sets number of cells at each direction. The subdomain in the example contains `n1*n2*n3` cells.
    * we can **refine mesh** by reducing the values in the bracket after "simpleGrading" or (edgeGrading). For example:
       > `simpleGrading (0.5 1 1)` makes x-dimention of cells in the block gradually reduces to 50% from the origin defined by the first vertice of the block to the first vertice shares the same x-coordinate with the origin.
       >`edgeGrading (x x x x x x x x x x x x)` sets expansion/shrinkage ratio of starting/ending cells at **each edge of a given block**.

- `boundary` dictionary sets boundaries that enclose the domain. Each entry has a format of 

```css
name
{
    type xxxx;
    faces
    (
        (v1 v2 v3 v4)
    );
}
```
where `type` could be `patch`, `wall`, and `symmetryPlane`(where geometry mirror applies, useful for creating semi-infinite shape). **The sequence of vertices follows the right-hand rule**(with the thumb pointing outwards).

> After running the command `blockMesh`, you can find additional entry of "defaultFaces" which bundles all the faces undefined in the file "blockMeshDict".

### 2.1 2D/1D geometry in OpenFOAM
In OpenFOAM, 2 dimensional geometries are currently treated by defining a mesh in 3 dimensions, where **the front and back plane** are defined as the `empty` boundary patch type. Similarly, 1D goemetries have their **front, back, left and right planes** defined as `empty` boundary patch type. Empty faces are stored in boundary card using a format of 
```css
boundary
(
     sides
    {
        type patch;
        faces
        (
            (1 2 6 5)
            (0 4 7 3)
        );
    }
    empty
    {
        type empty;
        faces
        (
            (0 1 5 4)
            (5 6 7 4)
            (3 7 6 2)
            (0 3 2 1)
        );
    }
);
```
The `sides` dictionary in the example above contains faces treated as boundary of the simulation.

## 3. Solvers

### 3.1 sonicFoam

Transient solver for trans-sonic/supersonic, laminar or turbulent flow of a compressible gas. It is for single-phase, non-isothermal simulations.
- we will need to set up energy equation in the simulation using `sonicFoam`

### 3.2 scalarTeansportFoam

Solves a transport equation for a passive scalar. Thus, this solver is suitable to solve diffusion-convection-reaction problems. The solver based on a theory that formulate transport equation for scalar field $T$ as:

$$\frac{\partial T }{\partial t}+\nabla\cdot\boldsymbol{u}T=D_{T}\Delta T$$

where $\boldsymbol{u}$ amd $D_T$ are velocity field and diffusivity of scalar field. 


### 3.3 pisoFoam
This is a transient solver for incompressible flow, which can be used both for laminar and turbulent flow in single phase. Also, the solver assoumes **isothermal** condition. The moment equation that `pisoFoam` solves is

$$\frac{\partial \boldsymbol{u}}{\partial t}+\nabla\cdot(\boldsymbol{uu})=-\frac{1}{\rho}\nabla\bar{p}+\nabla\cdot\nu[2S]+F_t$$
where $F_t$ is the turbulence term. In the settings of boundary/initial conditions, pressure has a unit of [pressure/density].

## 4. Discretization
In CFD, we use Gauss's theorem to transform integrals of divergence terms into sum of inner products on surfaces of each cell (see below). Such inner product requires values of variables at cell surfaces (e.g., $\phi_f$ in the equation below). Thus, we need to choose scheme that decides the strategy of choosing variable values at cell surfaces
$$
\iiint_{V}(\nabla \cdot \mathbf{u}\phi) \mathrm{d} V=\oiint_{S}(\phi\mathbf{u} \cdot \hat{\mathbf{n}}) \mathrm{d} S \simeq \sum_f \phi_f \mathbf{u}_f \cdot \hat{\mathbf{n}}_f.
$$

### 4.1 fvSchemes
For each term in governing equation, OpenFOAM provides options for discretizing partial derivatives. The information of discretization scheme (i.e., names of discretization methods) is stored in the file `fvSchemes`

> If we wish to use the same scheme for all the terms, we can simply use `default xxxx` in each scheme card.

- The shceme cards include: `ddtSchemes`, `gradSchemes`,`divSchemes`,`laplacianSchemes`,`interpolationSchemes`, and `snGradSchemes`(Component of gradient normal to a cell face)
- Each card has a format of
    ```css
    name
    {
        default xxxx;
        term1 xxxx;
        term2 xxxx;
        .
        .
        .
    }
    ```
- OpenFOAM uses `phi` to represent **flux** coming in/out at cell surfaces.
### 4.2 fvSolution
The file `fvSolution` encodes all the information of solvers for solving different fields (e.g., T, p, U,...).

## 5. Numerical Issue to Consider
### 5.1 Courant Number
The Courant number is defined as

$$C=\Delta t\frac{u_{x_i}}{\Delta x_{i}}\leq C_{max}$$

where $\Delta t$ is the time step, and $C_{max}$ is the largest Courant number your simulation can tolerate. In OpenFoam, the distance travelled by fluid at dimension $x_i$ within one time step, $u_{x_i}\Delta t$, divided by the spacial increment at the same dimention, $\Delta x_i$ must be less than 1 (i.e., $C_{max}<1$).

### 5.2 Numerical/False diffusion

Extra attention should be paid to so-called "numerical diffusion" phenomena. Discretized PDE in [Eulerian simulation](https://en.wikipedia.org/wiki/Euler_method) is known to be more diffusive than the original differential equations. 

A simple workaround could be replacing `upwind` scheme with `central difference` scheme for the **convection** term when [Peclet number](https://en.wikipedia.org/wiki/P%C3%A9clet_number) is less than 2. Because of this limitation, the central difference scheme is not a general-purpose scheme for CFD problems.

Another solution is making the mesh finer, but one should always be cautious when the diffusivity of your fluid is small, especially when it is smaller than the diffusivity of false diffusion.

In OpenFOAM, we have options of `Gauss GQUICK`,`Gauss upwind`, `Gauss linearUpwind`, `Gauss linear`, and `Gauss cubic` for discretization schemes of divergence terms in the file `fvSchemes`. 

> The option `Gauss cubic` tends to reflect unwanted oscillation at boundary, so be careful when using it.

> When `Gauss linearUpwind` is used, make sure you set up default gradient scheme by using `gradSchemes` card, e.g., `gradSchemes {default Gausss linear}`, and set divergence scheme using: 
```css
divSchemes
{
    default         none;
    div(phi,T)      Gauss linearUpwind grad(T);
}
```
> where `T` in `grad()` can be replaced by other scalar field.

In general, **`linearUpwind` scheme is arguably the best compromise btw stability and accuracy for most of CFD simulations.**

## 6. Postprocessing
we can convert data to VKT format using the command of `foamToVTK`

Before creating new filters, select a pipline in "Pipeline Browser" and click "Apply" in "Properties" menu below the browser.

### 6.1 Data sampling functionality

We can sample data points in our domain using the command of `sample`. The information of sampling procedures is recorded in the file `sample` (or `sampleDict`) in `system` folder. An example of such file can be found at `$FOAM_TUTORIALS/compressible/sonicFoam/laminar/shockTube/system`.

- Since OpenFOAM6, `sample` binary file is no longer available. To run postprocess jobs, we can still define data sampling procedures in a dictionary, and run the command of 
        `postProcess -func xxxx` at the parent case folder
    * where `xxxx` is the name of sampling dictionary
    * we can also append `-noZero` at the end of command to no sampling data at time step 0.

## 7. Runtime Settings
### 7.1 Change settings between a series of simulations
- Change `startFrom` to `latestTime`
- Consider deleting `phi` in the latest output folder, if you want to change initial velocity settings. This is because for some solvers `phi` overwrites `U` after simulation starts
- Change `writeControl` to `runTime`, and `writeInterval` to appropriate simulation time
- Increase `endTime` to allow OpenFOAM to start a new simulation in the series

### 7.2 Parallel computation settings
You might want to consider deleting `decomposePairDict` if you run into trouble when running tutorial using parallel settings.