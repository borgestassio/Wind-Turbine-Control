# State Observer

We'll learn how to implement the state space observers in this section.
A more detailed mathematical model, i.e. greater number of states, allows the system to be better represented thus allowing the controller to take into consedarion more aspects of the system and provide better results. However, some states cannot be measured, either limited by the technology availability or costs.

To solve the issue and allow the system to be controllable with a grater number of states but with limited measurements, we use a state observer.
Again, I won't go in details about this method on this tutorial, but you can find information about this in any control engineering textbook.

We start with the 3 States system because we use the Drive Train Torsion and its derivative which is usually not available as a measurement in a WT (someone correct me, if I'm wrong, please).

## 3 States + Disturbance Accomodating Control (DAC)

We know that some measurements are not available, whether it's due to technological challenges or simply prohibitive costs, but a more accurate model of the system contains a number of states that cannot be measured. Therefore, to allow the use of a state feedback controller,we need to estimate the unmeasured states.
On the 3 States model we've extracted, the only state directly available is the rotor speed, so we need to use this variable to estimate the other two (Drivetrain Torsion and its derivative). 
The block diagram for this controller:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/3states_obs.PNG "block 3")

There are several textbooks that explain this topic, we'll limit to present only the expression for the state space representation with the state observer.

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/observer.PNG "observer")

Where:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/observer2.PNG "observer2")

The observer gain Ke can be obtained either by pole placement or by LQR.
In this example we'll use pole placement, and you can find the LQR method on the *states_3_observer.m* file.

We also look into using the Disturbance Accommodating Control (DAC) to allow the system to react when facing a disturbance, this would take the system closer to its OP, thus allowing a better perfomance in controlling the rotor speed. I won't go into details about this technique as we focus on implementing the controllers, but if you want to learn more, I based this controller on the one developed by Alan Wright on [Modern Control Design for Flexible Wind Turbines](https://www.nrel.gov/docs/fy04osti/35816.pdf).

The DAC approach is under the state observer section simply because it's an augmentation of the observer, where we estimate the wind speed.

When including the disturbances, the state space representation is:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/observer4.PNG "observer 4")

Bd is provided with the linearization as well. So we need to find Kd and Gd, which are the observer and feedback gain, respectively, to the wind disturbance. This is achieved by:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/observer7.PNG "observer 7")

We need to find a standard space state representation that includes the disturbance, so we have:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/observer3.PNG "observer 3")

Where Ke is the observer gain, Kd is the wind disturbance observer gain, Gd is the feedback gain for the wind disturbance observer.
These values can either calculated from a pole placement or LQR.

In order to allow the easier implementation of this method, we simplify the representation to a regular state space:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/observer6.PNG "observer 6")

Where:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/observer5.PNG "observer 5")

You can see the design of this observer and controller + DAC on *states_3_estimator.m*.



## 5 States + DAC

We already understand the 5 States model, so we assume only rotor speed is measured and we estimate the other states.
I won't go into details about this because it's the same principle as the previous controller and the states were described in the other section.

## 9 States Model CPC + DAC

Note: In here, we keep using a collective pitch controller (CPC), but we'll see Individual pitch controller (IPC) later.

The 9 states model is fairly interesting because we use the Multi-Blade Coordinate Transformation (MBC) to change the coordinate systemfrom the a rotating frame to a non-rotating frame.
This transformation is used to attenuate the problem caused by the linearization method, where the matrices are calculated several times during a single rotor rotation and their averages are used to create the state space representation of the linearized system. The main problem with this approach is that by using the average, the periodic terms that contribute to the system dynamics are eliminated. The proposed technique is that the average only be calculated after the MBC transformation. [User’s Guide to MBC3 : Multi-Blade Coordinate Transformation Code for 3-Bladed Wind Turbines ](https://www.nrel.gov/docs/fy10osti/44327.pdf) by Bir has a more detailed explanation and is worth reading.

The MBC transformation alters the DOFs from the rotational plan to the non-rotational plan coordinates (Xnr, Ynr and Znr) as in the figure below extracted from the aforementioned MBC3 User's Guide:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/mbc.PNG "mbc3")

The states obtained from the MBC are:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/mbc_states.PNG "mbc3 states")

Where q0 is the rotor collective lag, qc is the horizontal displacement of the rotor center-of-mass in the rotor plane and qs is the vertical displacement of the rotor center-of-mass in the rotor plane.
These are the states we'll have for the 9 states model:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Observer/images/9states.PNG "mbc 9 states")


The files necessary to implement this controller are available on this repository, under the files folder, as usual.


## 11 States Model CPC + DAC
