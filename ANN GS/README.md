# Artificial Neural Network and Gain Scheduling

So far, we only used the linearized model for the wind speed of 12m/s, however it's well known the coupling between the states vary with the wind speed.
We can develop controllers for each wind speed and change the gains based on the wind speed to make use of a range of linearized models that best represent the wind turbine. A well known technique is the Gain Scheduling, where the gain is scheduled to change according to the OP the system is currently operating under, this allows the system to be controlled used the gains that better represent the system and adjust the gains based on different objctives for each OP.

To select the gains, there are a number of techniques available, I decided to implement an Artificial Neural Network that uses radial basis functions as activation functions, called a RBF NN.

First, we linearized the WT in different OPs:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/ANN%20GS/images/ops.PNG "OPS for linearization")


We use the same methods applied before to calculate the linearized model, reference value and gains for each of these OPs.

In order to use the gain scheduling, we need to define a parameter to be used to determine in which OP the WT is operating, we'll use the collective pitch angle (B0) and the tower displacement, because they have a direct relationship with the wind speed. 
By the way, the collective pitch angle can only be used as a scheduling parameter thanks to the integral term that we added to the model because it ensured the rotor speed is always on the desired value by simply increasing the collective angle.
As for the tower displacement, it can be calculated from the tower acceleration.

We take the following values from the linearizations and use them as input to the RBF NN:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/ANN%20GS/images/xrbf.PNG "OPS for linearization")

The outputs are gains Kbar and Gbar for each OP, but to make it easier to implement I make the output be the OP, so it ranges from 1 to 7, then the result is used to combine the output from each controller to pass it the WT. We'll see the details of this implementation later in this section.


The first step is to calculate the gains for every OP, we perform the calculations by taking all *.lin* files and executing the very same code we did (with a few adjustment for better resource management) for every controller before this one. You can find the script to do that on the file *RBF_NN_GAINS.m* under the [files folder](https://github.com/borgestassio/Wind-Turbine-Control/tree/master/ANN%20GS/files).

The second step is to train the RBF NN. 

Although the training process employed here is discussed in details in [Three learning phases for radial-basis-function networks](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.109.312&rep=rep1&type=pdf#:~:text=It%20consists%20of%20three%20neural,combination%20of%20the%20basis%20functions.), we must clarify how the training is performed using the two-phase learning technique. In the first phase, the hidden neurons’ centres or centroids (***c***) are calculated using the k-means technique for clustering the input data. Using the clusters’ data points, each cluster width (𝜎) is computed as the mean distance to its centre (***c***). The second phase is simply a linear combination of the neuron activation in the hidden layer, i.e. it takes the output from the hidden layer and linearly combine them to find the gains for achieving the target value.

The RBF-NN acts as the Gain Scheduling. The block diagram for this system is exhibited below:

![equation](https://raw.githubusercontent.com/borgestassio/Wind-Turbine-Control/master/ANN%20GS/images/rbf_block.PNG "rbf system block diagram")

