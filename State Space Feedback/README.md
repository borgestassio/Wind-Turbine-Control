# State Space Controllers

In here we focus solely on building the simple state space feedback controllers, this means that EVERY state is available through a sensor, which is clearly not the case for a real-world application. The goal is to start with something simple and then we move to more complex techniques.

The state space equation for a linear system has the form:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/Linearization/images/eqn1.png "Eq1")


We saw how to obtain the A,B,C and D matrices from the linearization. 

Now, we extract that information to create our own model and design the feedback controller.

## 1 State Model

Using the Lineazation guide, we get the 1 state model (single DOF - Rotor - *GenDOF*), we can see that the system was linearized with the following parameters for the OP:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/eq2.png "Eq2")

The matricies extracted from the linearization are:
* A = -0.37035;
* B = -0.39467;
* C = 1;
* D = 0;

*Note: the xop variable from the linearization includes the blade pitch on the first line and the rot speed (rad/s) in the second line, therefore only the 4th element from the AvgAMat is used here, because it's the only element that has a direct relationship with the rotor speed*
*The same approach will be used from now on, we'll only use the elements from the AvgAMat that relates to the states of the model. On the .m files we'll index them accordingly.*

This is the *AvgAMat*: 

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/eq3.png "Eq3")

This is the *x*:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/eq4.png "Eq4")

I hope you can see the reason why only the element *A22* on this 1-State model.

### Simulation

Now we work our way to Simulink, but before we do, let's learn a little bit more about interfacing Fast and Simulink.

#### Indexing

This is Simulink model (available on the *files* folder):

![alt text](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/1_state.PNG "1 state model")

In order to index the rotor speed, a expression block is needed. Inside the block, this is the expression you should enter to get the rotor speed:
`u(strmatch('QD_GeAz', OutList))`

The output `QD_GeAz` is the rotor speed in rad/s.

#### Filtering

The next block is a *Discrete State-Space* block, where a filter is implemented. The corner frequency, defined in the [Definition of a 5-MW Reference Wind Turbine for Offshore System Development](http://www.nrel.gov/docs/fy09osti/38060.pdf), is set at 0.25Hz.
On this block we implement the low-pass filter as described on the section 7.1 of the technical report.

#### Implementing the controller

You're well aware that the linearized system represents the WT around that specific OP, but what does it mean from the control point-of-view?
It means that the system aims to keep the 'variation' of its states as '0', therefore the input and output of this type of system is the variation from the OP.
When representing on Block Diagram, the feedback controller for the 1-state system looks like this:

![alt text](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/1_state_block.PNG "1 state model")

Here we can see that we need to pass the rotor speed variation to the controller and it'll output the pitch variation.

On the simulink model we achieve that by subtracting the measured rotor speed from the OP rotor speed.
As for the pitch, we sum the OP pitch to the controller output:

![alt text](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/1_state_feedback.PNG "1 state feedback")

Please note the pitch is in radians, as it's the input unit used by FAST.
We have a saturation and a rate limiter block copied from the PID baseline to keep it within operation limits.

#### Pole Placement

In here we implement a Full State Feedback controller.
We can easily see that the pole for this system is *-0.37035*.
You can see that using the `pzmap(sys1)` command after running the *test_1_state.m* file available [here](./State%20Space%20Feedback/files).

We'll place the pole at *-1* using the following function: 
`pole = -1;`

`G = -place(A,B,pole);`

#### Running the simulation

The wind profile used for all the simulations here is a 2 m/s step from 12m/s to 18m/s:

![alt text](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/windprofile.png "wind profile")

You just need to press play and wait for the simulation to finish.
On the *1_state.m* file you'll find some commands to print the results:

![alt text](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/1_state_pitch.png "1 state pitch") 

![alt text](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/1_state_rot.png "1 state rotor") 

We can see that while the wind speed is 12 m/s, i.e. OP, the rotor speed is also kept around the OP (1.26 rad/s).

You can find all the data on the variable named Outdata and the list of ouputs on OutList.

## 2 States Model