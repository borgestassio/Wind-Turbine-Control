# Linearization
In this section we cover the Linearization using Fast V7 (Files and short guide available here: https://github.com/borgestassio/FASTv7).
I used V7 simply because it's easier to perform the linearization and I followed the instructions on [FAST User’s Guide](https://drive.google.com/file/d/1d_-vRRK3sXlunf1I1tDmtSWUveed91gg/view), where it explains how to achieve the linearization using the numerical pertubation method.
If you want to learn more about the symbolic method, I suggest you read the [Modern Control Design for Flexible Wind Turbines](https://www.nrel.gov/docs/fy04osti/35816.pdf) technical report by Alan Wright.


According to Wright:

>In the numerical method, values for the mass, damping and stiffness matrices are calculated directly in FAST, during runtime. The code is first run for steady winds, i.e., no turbulence. Once a steady-state solution has been reached, the equations of motion are numerically perturbed with respect to each DOF (Degree of Freedom) and its derivative.
 
And quoting the FAST User's Guide, this is what the linearization method does:

>Once a periodic steady state solution has been found, FAST numerically linearizes the complete nonlinear aeroelastic model about the  operating point.

I strongly suggest you to read both documents to have a better understanding of the linearization procedure.

We proceed with a simple explanation of it does before we move to how to do it.

In order to extract the state matrices, FAST reaches a stead-state solution and then adds smalls perturbations until a linear response is obtained from these perturbations. It's important to note that the Operating Point (OP) is periodic, so it depends on the rotor azimuth position.
The User's guide also states:
>It is important to determine an accurate operating point because the linearized model is only accurate for values of the DOFs and inputs that are close to the operating point values.

The objective of the linearization is to extract the state matrices and have the state-space representation of the Wind Turbine model:
![equation]http://www.sciweavers.org/tex2img.php?eq=%0A%5Cbegin%7Bcases%7D%5Cdot%20%5CDelta%20x%20%3D%20A%20%5CDelta%20x%20%2B%20B%20%5CDelta%20u%20%2BB_d%20%5CDelta%20u_d%20%5C%5C%20%5CDelta%20y%3DC%20%5CDelta%20x%20%2B%20D%20%5CDelta%20u%20%2B%20D_d%20%5CDelta%20u_d%5Cend%7Bcases%7D%20%20%20%20&bc=White&fc=Black&im=png&fs=12&ff=arev&edit=0

Where: 
Δx is the state vector;
Δu is the control input vector;
Δu_d is the disturbance input vector;
Δy is the control (or measured) output;
A represents the state matrix;
B the control input gain matrix;
B_d is the disturbance input gain matrix;
C relates the measured output  Δy to the turbine states;
D relates the control input to the output;
D_d relates the measured output to the disturbance states.

That being said, we focus on how to acquire these matrices.

## CONFIGURATION FILES AND PARAMETERS

For the linearization, the process will follow the instructions presented in [Advanced Control Design for
Wind Turbines](https://www.nrel.gov/docs/fy08osti/42437.pdf), despite its use of a 2 bladed turbine, the process is almost the same, and for the parameters regarding the 5 MW Wind Turbine, we’ll follow [Definition of a 5-MW Reference
Wind Turbine](https://www.nrel.gov/docs/fy09osti/38060.pdf), which contains all definitions and configurations of the turbine.
Inside your .fst file, in this case, “NRELOffshrBsline5MW_Onshore.fst”, go to the FEATURE FLAGS (LINE 54). Now we begin to modify the configuration file to obtain the results needed, the appropriate Degrees of Freedom (DOF) will be used for the linearization:
•	FlapDOF1;
•	DrTrDOF;
•	GenDOF;
•	CompAero.
The others DOFs must be set to False, so your file will look like this:

![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization.png "Linear1")

To perform the simulation, we will need to change some lines in the *SIMULATION CONTROL* part:
•	ADAMSPREP should be set to 1 (Run FAST);
•	AnalMode should be 2 (which is to create a periodic linearized model);
•	NumBl remains the same, as we’re working with 3 blades;
•	TMax is advised to be 1200, although the linearization will be achieved before that;
•	DT is set to 0.006 for no particular reason described in any document.

The SIMULATION CONTROL portion of your file should be similar to this:
![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization2.png "Linear2")



The linearization process utilizes the turbine parameters to perform the calculations, therefore, in order to successful linearize the model, we must pass to FAST the correct parameters to the turbine control, which is done in the TURBINE CONTROL portion:
•	YCMode must be 0;
•	PCMode is set to 0;
•	VSContrl is activated, set to 1;
•	VS_RtGnSp must be 121.6805;
•	VS_RtTq is 43093.55;
•	VS_Rgn2K is set to 2.332287;
•	VS_SlPc is equal to 10.0;
•	GenModel is 3;

The others parameters remain the same, so your file should be similar to this:
![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization3.png "Linear3")

I might be mistaken, but I believe all other parameters are already set correctly, so it is time to move to other file, at this point, specifically to the NRELOffshrBsline5MW_Linear.dat file, where the linearization properties are.

Here, the changes are:
•	VelTol to 0.00001;
•	NAzimStep to 24;
•	NInputs to 1;
•	CntrlInpt to 4;
•	NDisturbs to 1;
•	Disturbnc to 1;
![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization4.png "Linear4")


With these changes, the parameters are all set, however, one more thing is necessary, the wind profile. To make things easier, we will use the simplest wind profile file, a Hub-Height file, this file implements a 12 m/s wind profile, suitable for model linearization in FAST v7, Jason Jonkman made this file available in the NREL Forum in a topic about the 5 MW Wind Turbine (https://wind.nrel.gov/forum/wind/viewtopic.php?f=4&t=621). Although the file extension attached in the topic is .txt, the usual extension is .wnd.
The file format is quite simple, in the file one can see that the data is divided into columns, and in this case, all we need is the time and wind speed, so the file looks exactly like this: 

![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization5.png "Linear5")

Along with the wind profile, we have to tell FAST which file it will use for the wind, we do this by changing the AeroDyn file (NRELOffshrBsline5MW_AeroDyn.ipt), as shown in the Figure below.


![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization6.png "Linear6")

These files are in the folder *Files* here, so if do not want to change every file, and have trust in me, you can use the files provided here or [here](https://github.com/borgestassio/FASTv7).

##	LINEARIZATION

The configuration files and wind profile must be in the same folder as the FAST executable in order to execute the simulation and find the linear model.
Once you have all files and the executable in the same folder, open the command prompt (Here, I assume you are using windows to makes things easier for me), or the new Windows PowerShell, directly in the folder you are currently working by holding shift and right-click, select “Open Command Window here”.
Type `FAST.EXE` (or `.\FAST.exe` ) followed by the input file, in this case: 

`.\FAST.exe NRELOffshrBsline5MW_Onshore.fst`

![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization7.png "Linear7")

The final output should be similar to this:

![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization8.png "Linear8")


##	POST-PROCESSING WITH MBC3

The FAST outputs the .lin file with the linearization results, to easily extract them we can use a post-processing tool, espeficially the MBC3, also developed by NREL (https://nwtc.nrel.gov/MBC and on GitHub https://github.com/NWTC/MBC). 

To obtain the desired matrices we must use one function from the MBC3, I leave you to choose where to extract the files from MBC3, but make sure you execute the function in the same folder where your .lin file is located. The instructions to extract the matrices from the .lin file follows:

1.	Download MBC3 and extract it on your Matlab folder;
2.	Go to the folder where your .lin file is located;
3.	Execute the following command: GetMats ;

The command window on Matlab will as for the .lin file

![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization9.png "Linear9")

4.	Enter the name of the file without the .lin extension, in my case it is: NRELOffshrBsline5MW_Onshore

5.	If everything went fine, you will see the message: 


![alt text](https://raw.githubusercontent.com/borgestassio/5MW-NREL-Controllers---Simulink/master/Linearization/images/_fst_linearization10.png "Linear10")

6.	Your matrices are now available, as described in [User’s Guide to MBC3](https://www.nrel.gov/docs/fy10osti/44327.pdf), as the azimuth-averaged state matrices:
	a.	AvgAMat = A 
	b.	AvgBMat = B
	c.	AvgBdMat = Bd
	d.	AvgCMat = C
	e.	AvgDMat = D
	f.	AvgDdMat = Dd

In possession of these matrices, you now have a linearized model that can be used to design the controllers described in [Advanced Control Design for Wind Turbines](https://www.nrel.gov/docs/fy08osti/42437.pdf). Refer to the other folders to find the guide for each type of controller.

