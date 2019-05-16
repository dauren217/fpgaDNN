import gen_nn
import genTestData
import genWegitsAndBias


numLayers = 5       #Number of layers of neural network including the input layer
neuronList = [784,30,30,10,10]
dataWidth = 16 #Bitwidth for weight, input data and sigmoid output
sigmoidWidth = 5 #Number of entries in the sigmoid LUT will be 2**sigmoidWidth
weightIntWidth = 4 #Number of integer bits used in the weight data including sign bit
inputIntWidth = 1 #Number of integer bits used in input data including sign bit

gen_nn.gen_nn(numLayers,neuronList,dataWidth,sigmoidWidth,weightIntWidth,inputIntWidth)
genTestData.genTestData(dataWidth,inputIntWidth,2)
genWegitsAndBias.genWaitAndBias(dataWidth,dataWidth-weightIntWidth,dataWidth-weightIntWidth-inputIntWidth)