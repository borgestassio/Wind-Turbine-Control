## Comparing the RBF NN and the Baseline Controllers IEC 61400

We developed a good number of controllers to get to the RBF NN controller, but now how do we know that this controller will respond to a real-world scenario?
In order to conduct a more thorough analysis, we evaluate the controller following the requirements outlined by the IEC 61400. This standard defines the turbulent profile for normal operation among other scenarios for evaluating the general response of a Horizontal Axis Wind Turbine (HAWT) onshore.

Using the controller presented previously, two different scenarios are taken into consideration. The first one consists of an Extreme Operating Gust (EOG), where a wind gust occurs inside the cut-in and cut-out speeds of the HAWT in order to evaluate its behaviour, called Design Load Case 1.3 . For the second case, a turbulent wind profile is applied to the HAWT to analyse the responses when operating in a turbulent full field and to evaluate the fatigue on the components, called DLC 1.1.

The EOG wind profile is generated using the [IECWind](https://www.nrel.gov/wind/nwtc/iecwind.html) for the DLC 1.3 and the [Turbsim](https://www.nrel.gov/wind/nwtc/turbsim.html) is used to create the NTM (Normal Turbulence model) wind profile for DLC 1.1.

### DCL 1.1

The DLC 1.1 is defined by a NTM wind profile. Using the Turbsim, we have the following wind profile:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Comparing%20Controllers/images/NTM.PNG "NTM profile")


The results for the rotor speed, rotor torque and generator power follow:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Comparing%20Controllers/images/rot_rbfxpid.png "NTM profile")

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Comparing%20Controllers/images/tor_rbfxpid.png "NTM profile")

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Comparing%20Controllers/images/gen_rbfxpid.png "NTM profile")


Look at this, the RBF NN makes the generator power have less troughs, so it keeps the generator working for longer thus producing energy more consistenly.
Cool, right? We have other analysis to run, like blade deflection and tower fore-aft displacement, but I'll add that later.


### DCL 1.4

The DLC 1.4 is defined by an EOG, where the wind profile used for this analysis is:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Comparing%20Controllers/images/EOG.PNG "NTM profile")


Under the EOG, these are the results we obtained:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Comparing%20Controllers/images/rot_rbfxpid_eog.png "EOG profile")

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Comparing%20Controllers/images/tor_rbfxpid_eog.png "EOG profile")

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Comparing%20Controllers/images/gen_rbfxpid_eog.png "EOG profile")

Note how the controller reacts better to the wind gust and keeps the generator going.

I'll perform some more analysis regarding the loads and deflections caused by the EOG and how the controllers perform.