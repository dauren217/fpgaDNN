Run trainNN.py is for training the neural network. 
Files netowrk2.py and mnist_loader.py are used to generate the neural network. 
After training, the weight and bias values are stored in the text file named WeigntsAndBiases.txt

File gen_nn.py is used for generating Verilog code for the neural network with specified number of layers, neurons and datawidth
The output is stored in /src/fpga/rtl directory

File genWegitsAndBias.py is for converting the weight and bias values into the binary format and storing in respective file.
You can specify the total datawidth and the size (number of bits) of integer field for weights and biases.
It uses WeigntsAndBiases.txt as input.
The output is stored in /imp/fpnn.sim/sim_1/behav/xsim directory.


File genTestData.py is for creating test data in binary format. 
The output is stored in /imp/fpnn.sim/sim_1/behav/xsim directory as validation_data.txt.

genAll.py script runs all the above scripts.