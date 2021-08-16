# Propeller Design for Root Growth: A OpenFOAM Project
Computational Fluid Dynamics (CFD) should be a suitable tool for designing agricultural machinery but has not found its application in research of plant root growth. A set of experiments showed that suspending roots grow with the fastest speed when the speed of propellers 20cm below suspensive platform is within a certain range. To understand this phenomenon, and to find the optimum propeller speed for root growth, we first made the following hypotheses:

1. Nutrients can perfectly be mixed near the propellers when rotating within optimized range of speed;

2. The same effect can be achieved by using different rotating speed and propeller geometries.

## A Brief Workflow

To prevent reinventing the wheel, OpenFOAM will be used to perform CFD simulations due to its intuitive syntax and versatile solvers. Thus, the project will start with learning OpenFOAM and its functionalities. The goals of learning process are:

- Know how to choose proper solvers for mixing problems
- Know how to set up proper initial and boundary condition
- Know how to postprocess scalar/vector field data
- Know how to design/alter propeller geometry (might use other CAD software like blender)

The primary outcome of this learning process is a series of MarkDown notes on OpenFOAM and CAD software. Afterwards, we will streamline our workflow by repeating the following steps:

(1) design/alter geometry of propeller system
(2) adjust simulation settings
(3) run simulations
(4) postprocess data

### Hypotheses Verification

Hypothesis #1 can be verified if 
- volume-averaged nutrient concentration near propellers varies with rotating velocity, and the max concentration appears within a velocity range that matches experiments

- vaiance of concentrations near propellers is significantly smaller than the same quantity calculated far from propellers

Hypothesis #2 can be verified if
- We find another velocity-geometry combination that yields similar mixing phenomenon near propellers.

### Expected Conclusions

1. Propellers geometry and locations cast significant effects on plat root growth

2. A set of design principles for suspensive platform that has nutrient perfectly mixed in electrolyte.