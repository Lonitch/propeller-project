# Notes on Turbulence Modelling in OpenFOAM
One of the ends of turbulence modelling spectrum is **Direct Numerical Simulation** (DNS) in which Navier-stokes equation along other governing equations are solved directly. The key to using DNS is discretizing the domian of interest into cells of **Komologorov scale** (Re~1). At such scale, viscous effects of fluid become dominant, and fluid dynamics become simple. Unfortunately, applying Komologorov scale in CFD simulation is not feasible as it is about 1mm in a simulation of global climate. For some special cases, DNS is still possible through some simplification process, e.g., turbulent mixing in a rocket engin combustion chamber.

The other end on the spectrum is **Reynolds Average Simulation** (RAS), which use simple variables to describe turbulent eddies: turbulent viscosity and turbulent kinetic energy. RAS treats chaotic time denpendence of turbulence in an averaging manner, and only average behavior is modelled. The biggest advantage of RAS over DNS is that it's much less computationally intensive, at the expense of lossing details. Nevertheless, Many RAS models are **stationary** (e.g. $k-\epsilon$ and $k-\omega$), which contains no time-dependence in its governing equations.

At the middle ground, we have **Large Eddy Simulation** (LES) which is designed to keep useful info without making much computational efforts. LES focuses on large scale turbulent behaviour and does not force cell size to microscopic levels, producing results similar to DNS. Simulation of Aeroelastic flutter usually uses LES.

## Stationary RAS: k-epsilon Model (simpleFoam)
The k-epsilon model is one of the most common turbulence models, although it just doesn't perform well in cases of large adverse pressure gradients. It is a two equation model, that means, it includes **two extra transport equations to represent the turbulent properties of the flow**. This allows a two equation model to account for history effects like convection and diffusion of turbulent energy. 

The first transported variable is **turbulent kinetic energy**, $k$. The second transported variable in this case is the **turbulent dissipation**, $\epsilon$. **It is the variable that determines the scale of the turbulence, whereas the first variable, $k$, determines the energy in the turbulence.**

 The k-epsilon model has been shown to be useful for **free-shear layer flows with relatively small pressure gradients**. Similarly, for wall-bounded and internal flows, the model gives good results only in cases where **mean pressure gradients are small**; accuracy has been shown experimentally to be reduced for flows containing large adverse pressure gradients. 

 ### Turbulent energy $k$
 The turbulent energy, $k$ can be computed as:
$$
k=\frac{3}{2}(U I)^{2}\tag{1}
$$
Where $U$ is the mean flow velocity and $I$ is the **turbulence intensity**.

### Estimating the turbulence intensity $I$
When setting boundary conditions for a CFD simulation it is often necessary to estimate the turbulence intensity on the inlets. To do this accurately it is good to have some form of measurements or previous experince to base the estimate on. Here are a few examples of common estimations of the incoming turbulence intensity:

1. **High-turbulence case**: High-speed flow inside complex geometries like heat-exchangers and flow inside rotating machinery (turbines and compressors). Typically the turbulence intensity is **between 5% and 20%**

2. **Medium-turbulence case**: Flow in not-so-complex devices like large pipes, ventilation flows etc. or low speed flows (low Reynolds number). Typically the turbulence intensity is **between 1% and 5%**

3. **Low-turbulence case**: Flow originating from a fluid that stands still, like external flow across cars, submarines and aircrafts. Very high-quality wind-tunnels can also reach really low turbulence levels. Typically the turbulence intensity is very low, **well below 1%**. 

### Dissipation rate
The turbulent dissipation rate, $\epsilon$, can be computed using the **turbulence length scale**:
$$
\epsilon=C_{\mu} \frac{k^{\frac{3}{2}}}{l}
$$
$k$ is the turbulent energy and $l$ is the **turbulent length scale**. $C_{\mu}$ is a turbulence model constant which usually has a value of $0.09$. In some CFD codes, such as Fluent, Phoenics and CFD-ACE for example, uses a different length-scale definition based on the mixing-length, and therefore the following formula should be used:

$$\epsilon = C_\mu^\frac{3}{4} \, \frac{k^\frac{3}{2}}{l}.\tag{2}$$

### Estimating turbulence length scale $l$
It is common to set the turbulence length scale to a certain percentage of a typical dimension of the problem. For example, at the inlet to a turbine stage a typical turbulence length scale could be say **5% of the channel height**. In grid-generated turbulence the turbulence length scale is often set to something **close to the size of the grid bars**. 

### Stationary RAS: k-omega model
$k-\omega$ model is a modification to standard $k-\epsilon$ model. Instead of using dissipation rate $\epsilon$, $k-\omega$ model uses **specific dissipation rate**, which can be determined from turbulence length scale and kinetic energy $k$ as
$$\omega = \frac{\sqrt{k}}{l}.\tag{3}$$

$\omega$ can also be determined from the **eddy viscosity ratio** as
$$
\omega=\frac{\rho k}{\mu}\left(\frac{\mu_{t}}{\mu}\right)^{-1}\tag{4}
$$
Where $k$ is the turbulent energy, $\rho$ is the density, $\mu$ is the **molecular dynamic viscosity** and $\mu_{t}$ is the **turbulence dynamic viscosity**.

### Estimating $\mu_t/\mu$ (or $\tilde{\nu}/\nu$)
The main advantage with using the eddy viscosity ratio is that **this directly says something about how strong the influence of the turbulent viscosity is compared to the molecular viscosity**. The eddy viscosity ratio is especially **convenient to use in low-turbulence cases** where it is difficult to guess any characteristic turbulent length scale. **Typical examples are external aerodynamics, like flow around cars, aircrafts and submarines**. For internal flows and flows where the origin of the turbulence can be related to some physical features of the problem it is often better to instead estimate the turbulent length scale. However, also when the turbulent length scale is used it is often good to double-check the resulting eddy viscosity ratio in order to make sure that the values are reasonable. 

In OpenFOAM, **when `SpalartAllmares` or `k-omega` model is used, we need to specify the modified turbulent viscosity**, $\tilde{\nu}$, which can be computed using the following formulas:
$$
\tilde{\nu}=\sqrt{\frac{3}{2}}(U I l)\tag{5}
$$
Where $U$ is the mean flow velocity, $I$ is the turbulence intensity and $l$ is turbulence length scale.

Ideally with the Spalart-Allmaras model $\tilde{\nu}=0$, but it is **recommended to set $\tilde{\nu}<=\frac{1}{2} \nu$.** This is as if the trip term is used to "start up" the model. A convenient option is to **set $\tilde{\nu}=5 \nu$ in the freestream**. The model then provides fully turbulent results and any regions like boundary layers that contain shear become fully turbulence.

The **turbulence eddy viscosity** $\nu_t$ can be related to $\tilde{\nu}$ through a **model-specific factor**, $f$ as
$$\nu_t=\tilde{\nu}f,$$

and the **turbulence dynamic viscosity** is then
$$\mu_t = \rho\tilde{\nu}f.$$

Turbulence eddy viscosity can be directly calculated from $k$ and $\epsilon$ ($\omega$) as:
$$\nu_t=0.09\frac{k^2}{\epsilon}=\frac{k}{\omega}.\tag{6}$$
In OpenFOAM, an effective viscosity is defined as:
$$\nu_{eff}=\tilde{\nu}+\nu,$$
which is used in `simpleFoam` source code.

## Boundary/initial conditions for stationary RAS models
1. At **inlet**, we use eqn.(1) and (2) to calculate initial values of $k$ and $\epsilon$, respectively. The type of these conditions should be `fixedValue`;

2. At **outlet**,the type of boundary consitions could be `zeroGradient`, and the initial value of $k$ and $\epsilon$ need not be set;

3. At **boundaries**, we need to set 
- the type of `epsilonWallFunction` for $\epsilon$ with initial value calculated using eqn.(2), 
- `omegaWallFunction` for $\omega$ with initial value claculated from eqn.(3), 
- `nutkWallFunction` for $\nu_t$ with initial value being `uniform 0`, 
- and `kqRwallFunction` for turbulent fields $k$, $q$, and $R$ (LRR model). 

You can consult the relevant directories for a full list of wall function models:

```bash
find $FOAM_SRC/TurbulenceModels -name wallFunctions
```

## Transient Models: LES
The effective turbulence viscosity in transient models is defined as:
$$\nu_{eff}=\nu+\nu_{sgs}$$
where $\nu_{sgs}$ is **sub-grid scale** viscosity, and it is calculated by

$$\nu_{sgs}=0.094\cdot\Delta\cdot\sqrt{k}\tag{7}$$
with $\Delta$ being **cutoff length scale**. $\Delta$ is given by **cubic root of the volume of single cell.**

In OpenFOAM, simple tutorials for using LES can be found at `$FOAM_TUTORIAL/pisoFoam/les/`

### Transient, one-equation model: SpalartAllmares
Spalart-Allmaras model is a one equation model which solves a transport equation for a viscosity-like variable $\tilde{\nu}$. In OpenFOAM, the model usually uses with `simpleFoam` solver, which is good for incompressible and turbulent flow (without energy equation).

`SpalartAllmaras` is a good model for **incompressible aerospace** simulation, but it is **not for internal flow**. We need to set up $\nu_t$ and $\tilde{\nu}$ with the model, their definitions are given [here](https://www.cfd-online.com/Wiki/Spalart-Allmaras_model). Notice that, **initial values for $\nu_t$ and $\tilde{\nu}$ should be small positive values (~0.001 to 0.2)**.

### Boundary/initial conditions for LES models
1. settings for $k$ and $\epsilon$ are similar to those for stationary RAS
2. settings for $\nu_{sgs}$ can simply be `zeroGradient` everywhere in the domain.

## Some "Rules of thumb"
- Inlet and outlet should be distant from the domain of interest;
- turbulence length scale $l$ can be roughly estimated as $0.07L$ with $L$ being characteristic length scale.
