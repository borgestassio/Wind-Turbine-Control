# Wind Turbine Controllers with NREL Fast and Matlab/Simulink
This repository has a few controllers for the 5-MW Reference Wind Turbine for Offshore System Development.
The controllers are implemented through Matlab / Simulink.

We start with a simple 1-DOF controller, where we consider only the rotor.
The complexity of the system is increased up to 11 DOF, where we use MBC techniques to extract important features, don't worry, the details will be on the appropriate folder.
On the control side, we start with a simple feedback controller until we reach an Artificial Neural Network based controller. In the process, we'll see state estimator (Kalman Filter), disturbance rejection and gain scheduling, all in due time.

Ok, let's cut to the chase, you're here to see some pretty graphs and poor explanation.

These are the topics covered in this tutorial:

1. [Set-up Environment](./Set-up%20Environment)
2. [Linearization](./Linearization)
3. [State Space Feedback](./State%20Space%20Feedback)
4. [State Space Observer](./State%20Space%20Observer)
5. [Artificial Neural Network based Gain Scheduling](./ANN%20GS)
6. [Comparing Controllers](./Comparing%20Controllers)




## Other info and disclaimers:

Controllers designed to the 5MW NREL wind turbine using the MATLAB Simulink and FAST V8.
Note: OpenFAST is already available and it's open-source, the reason I'm still using FAST V8 is that my MATLAB is an older version not supported on the most recent FAST distribution.

The [FAST](https://nwtc.nrel.gov/FAST) software is distributed by the National Renewable Energy Laboratory 

Matlab and Simulink are property of [Mathworks](http://www.mathworks.com/);

The Matlab version used in this project is the Matlab R20017b

The FAST version used was FAST V8(v8.16.00a-bjj)

For Linearization, I used FAST V7 mainly because the output file (.lin) is easier to extract the desired information.

Although this is an individual repository maintained by the only author, some of the files contained here are modified by the members of the Laboratoire de Mécanique de Normandie (LMN) from the INSA Rouen freely made available as example for anyone who is interested in this topic.

Useful links:

The parameters used for the turbine are given by NREL in here: [Definition of a 5-MW Reference Wind Turbine for Offshore System Development](http://www.nrel.gov/docs/fy09osti/38060.pdf)

Some controllers are adapted from [Advanced Control Design for Wind Turbines; Part I: Control Design, Implementation, and Initial Tests](http://www.mapcruzin.com/wind-power-publications/research-development/42437.pdf)


Fell free to contact me anytime for help, suggestions, critics and insults as well :)

These files are provided without warranty. Use them at your own risk.