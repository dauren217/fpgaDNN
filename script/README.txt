file trainNN.py is for training the neural network. Files netowrk2.py and mnist_loader.py are used to generate the neural network. The weight and bias values are stored in the text file named WeightAndBiases.txt


File getWeights.py is for converting the weight and bias values into the binary format and storing in respective file. The weight values for a first neuron in the first hidden layer are stored in the file "16_0_00.txt". The first zero is for number of layer and the second one is for number of neuron. Bias values are stored in files with similar filenames. Letter 'b' stands in the beginning of the filename to distinguish the files.

The scripts are written for 16-bit model. If needed to change the number of bits, please, change the code in the files where it asked to


File TestGenerator.py is for creating test data in binary format. You can specify the number of a test data file and number of bits. The correct result for the respective test data file shall be printed while running the file