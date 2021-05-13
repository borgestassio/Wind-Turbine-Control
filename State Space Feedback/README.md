# State Space Controllers

In here we focus solely on building the simple state space feedback controllers, this means that EVERY state is available through a sensor, which is clearly not the case for a real-world application. The goal is to start with something simple and then we move to more complex techniques.

The state space equation for a linear system has the form:

![equation]http://www.sciweavers.org/tex2img.php?eq=%0A%5Cbegin%7Bcases%7D%5Cdot%20%5CDelta%20x%20%3D%20A%20%5CDelta%20x%20%2B%20B%20%5CDelta%20u%20%2BB_d%20%5CDelta%20u_d%20%5C%5C%20%5CDelta%20y%3DC%20%5CDelta%20x%20%2B%20D%20%5CDelta%20u%20%2B%20D_d%20%5CDelta%20u_d%5Cend%7Bcases%7D%20%20%20%20&bc=White&fc=Black&im=png&fs=12&ff=arev&edit=0


We saw how to obtain the A,B,C and D matrices from the linearization. 

Now, we extract that information to create our own model and design the feedback controller.

### 1 State Model

Using the same model created on the Lineazation guide(single DOF - Rotor - *GenDOF*), we can see that the system was linearized with the following parameters for the OP:

![equation]http://www.sciweavers.org/tex2img.php?eq=%20%5Cbegin%7Bcases%7Dv_0%20%3D%2012m%2Fs%20%5C%5C%20%20%5Cbeta_0%20%3D%204.04%20%20%5E%5Ccirc%20%5C%5C%20%20%5COmega_0%20%3D%2012.1%20RPM%20%5Cend%7Bcases%7D%20&bc=White&fc=Black&im=jpg&fs=12&ff=arev&edit=0

This is important to know because the Wind Turbine model 