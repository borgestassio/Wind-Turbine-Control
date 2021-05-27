## 3 States - State Estimator

We know that some measurements are not available, whether it's due to technological challenges or simply prohibitive costs, but a more accurate model of the system has all the states present. Therefore, to allow the state feedback we need to estimate the unmeasured states.
On the 3 States model we extracted, the only state directly available is the rotor speed, so we need to use this variable to estimate the other two (Drivetrain Torsion and its derivative).
There are a number of textbooks that explain this topic, we'll limit to present only the expression for the state space representation with the state estimator.

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/estimator.PNG "Estimator")

Where:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/estimator2.PNG "Estimator2")

The estimator gain K can be obtained either by pole placement or by LQR.
In this example we'll use pole placement, you can find the LQR method on the *states_3_estimator.m* file.

We also look into using the Disturbance Accommodating Control (DAC) to allow the system to react when facing a disturbance, this would take the system closer to its OP, thus allowing a better perfomance in controlling the rotor speed. I won't go into details about this technique as we focus on implementing the controllers, but if you want to learn more, I based this controller on the one developed by Alan Wright on [Modern Control Design for Flexible Wind Turbines](https://www.nrel.gov/docs/fy04osti/35816.pdf).

The DAC approach is under the state estimator section because it's an augmentation of the estimator, where we estimate the wind speed.

When including the disturbances, the state space representation is:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/estimator4.PNG "Estimator4")

Bd is provided with the linearization as well.

We need to find a standard space state representation that includes the disturbance, so we have:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/estimator3.PNG "Estimator3")

Where Ke is the estimator gain, Kd is the wind disturbance estimator gain, Gd is the feedback gain for the wind disturbance estimator.
These values can either calculated from a pole placement or LQR.

In order to allow the easier implementation of this method, we simplify the representation to a regular state space:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/estimator6.PNG "Estimator6")

Where:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/State%20Space%20Feedback/images/estimator5.PNG "Estimator5")

You can see the implentation of this controller on *states_3_estimator.m*.