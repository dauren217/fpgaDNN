import sys
from math import log
from math import ceil


arglen = len(sys.argv)

f = open("include.v","w")

i=1
while 1:
	if i >= arglen:
		break
	elif sys.argv[i] == 'numLayers':
		try:
			numLayers = int(sys.argv[i+1])
			f.write("`define numLayers "+str(numLayers)+'\n')	
			i += 2
			f.write("`define layerNumWidth "+str(int(ceil(log(numLayers)/log(2))))+'\n')
		except:
			print("Error in number of layers")
			break
	elif sys.argv[i] == 'numNeurons':
		try:
			neuronList = sys.argv[i+1].split(',')
			i += 2
			for j in range(0,numLayers):
				f.write("`define numNueuronLayer"+str(j)+" "+str(neuronList[j])+'\n')
		except:
			print("Error in the list of number of neurons")
			break
	elif sys.argv[i] == 'dataWidth':
		try:
			dataWidth = int(sys.argv[i+1])
			i += 2
			f.write("`define dataWidth "+str(dataWidth)+'\n')
		except:
			print("Error in datawidth")
			break
	else:
		print("Invalid argument ",sys.argv[i])
		break
f.close()
f = open("nn_top.v","w")

g = open("db/moduleTemplate")
data = g.read()
g.close()
f.write(data)


for i in range(1,numLayers):
	if i == 1: #First layer input is connected to AXI
		f.write("Layer #(.NN(`numNeuronLayer%d),.numWeight(`numNueuronLayer%d),.layerNum(%d)) l%d\n.clk(s_axi_aclk),\n.rst(!s_axi_aresetn),\n.weightValid(weightValid),\n.biasValid(biasValid),\n.weightValue(weightValue),\n.biasValue(biasValue),\n.config_layer_num(config_layer_num),\n.config_neuron_num(config_neuron_num),\n.x_valid({`numNeuronLayer%d{axis_in_data_valid}}),\n.x_in({`numNeuronLayer%d{axis_in_data}}),\n.o_valid(o%d_valid),\n.x_out(x%d_out)\n);\n\n"%(i,i-1,i,i,i,i,i,i))
	else: #All other layers
		f.write("Layer #(.NN(`numNeuronLayer%d),.numWeight(`numNueuronLayer%d),.layerNum(%d)) l%d\n.clk(s_axi_aclk),\n.rst(!s_axi_aresetn),\n.weightValid(weightValid),\n.biasValid(biasValid),\n.weightValue(weightValue),\n.biasValue(biasValue),\n.config_layer_num(config_layer_num),\n.config_neuron_num(config_neuron_num),\n.x_valid({`numNeuronLayer%d{data_out_valid_%d}}),\n.x_in({`numNeuronLayer%d{out_data_%d}}),\n.o_valid(o%d_valid),\n.x_out(x%d_out)\n);\n\n"%(i,i-1,i,i,i,i-1,i,i-1,i,i))


f.close()
