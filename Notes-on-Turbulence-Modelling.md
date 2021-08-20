## Notes on Turbulence Modelling in OpenFOAM
One of the ends of turbulence modelling spectrum is **Direct Numerical Simulation** (DNS) in which Navier-stokes equation along other governing equations are solved directly. The key to using DNS is discretizing the domian of interest into cells of **Komologorov scale** (Re~1). At such scale, viscous effects of fluid become dominant, and fluid dynamics become simple. Unfortunately, applying Komologorov scale in CFD simulation is not feasible as it is about 1mm in a simulation of global climate. For some special cases, DNS is still possible through some simplification process, e.g., turbulent mixing in a rocket engin combustion chamber.

The other end on the spectrum is **Reynolds Average Simulation** (RAS), which use simple variables to describe turbulent eddies: turbulent viscosity and turbulent kinetic energy. RAS treats chaotic time denpendence of turbulence in an averaging manner, and only average behavior is modelled. The biggest advantage of RAS over DNS is that it's much less computationally intensive, at the expense of lossing details.

At the middle ground, we have **Large Eddy Simulation** (LES) which is designed to keep useful info without making much computational efforts. LES focuses on large scale turbulent behaviour and does not force cell size to microscopic levels, producing results similar to DNS. Simulation of Aeroelastic flutter usually uses LES.

## SpalartAllmares Model:
The model uses with `simpleFoam` solver
- `simpleFoam`: incompressible and turbulent flow (without energy equation)
     * A `turbulenceProperties` is prepared in `constant` folder with a general format of 
     ```bash
        FoamFile
        {
            version     2.0;
            format      ascii;
            class       dictionary;
            object      turbulenceProperties;
        }
        // * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

        simulationType          RAS;

        RAS
        {
            RASModel            SpalartAllmaras;

            turbulence          on;

            printCoeffs         on;
        }
        // ************************************************************************* //
     ```
`SpalartAllmaras` is a good model for **incompressible aerospace** simulation, but it is **not for internal flow**. We need to set up $\nu_t$ and $\tilde{\nu}$ with the model, their definitions are given [here](https://www.cfd-online.com/Wiki/Spalart-Allmaras_model). Notice that, **initial values for $\nu_t$ and $\tilde{\nu}$ should be small positive values (~0.001 to 0.2)**.