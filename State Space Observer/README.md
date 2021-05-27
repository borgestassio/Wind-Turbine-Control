# State Observer

We'll learn how to implement the state space observers in this section.

## 3 States

## 5 States


## 9 States Model

The 9 states model is fairly interesting because we use the Multi-Blade Coordinate Transformation (MBC) to change the coordinate systemfrom the a rotating frame to a non-rotating frame.
This transformation is used to attenuate the problem caused by the linearization method, where the matrices are calculated several times during a single rotor rotation and their averages are used to create the state space representation of the linearized system. The main problem with this approach is that by using the average, the periodic terms that contribute to the system dynamics are eliminated. The proposed technique is that the average only be calculated after the MBC transformation. [User’s Guide to MBC3 : Multi-Blade Coordinate Transformation Code for 3-Bladed Wind Turbines ](https://www.nrel.gov/docs/fy10osti/44327.pdf) by Bir has a more detailed explanation and is worth reading.

The MBC transformation alters the DOFs from the rotational plan to the non-rotational plan coordinates (Xnr, Ynr and Znr) as in the figure below extracted from the aforementioned MBC3 User's Guide:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/mbc.PNG "mbc3")

The states obtained from the MBC are:


![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/mbc_states.PNG "mbc3 states")

Where q0 is the rotor collective lag, qc is the horizontal displacement of the rotor center-of-mass in the rotor plane and qs is the vertical displacement of the rotor center-of-mass in the rotor plane.
These are the states we'll have for the 9 states model:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/9states.PNG "mbc 9 states")

