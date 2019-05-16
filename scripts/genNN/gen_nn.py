import sys
import math

arglen = len(sys.argv)

sourceFilePath = "../../src/fpga/rtl/"

f = open(sourceFilePath+"include.v","w")

numLayers = 5
neuronList = [784,30,30,10,10]
dataWidth = 16
sigmoidSize = 5
weightIntSize = 4
inputIntSize = 1
stepSize = 2**(weightIntSize+inputIntSize)/(2**sigmoidSize)

i=1
while 1:
	if i >= arglen:
		break
	elif sys.argv[i] == 'numLayers': #Number of layers in the NN including the input layer
		try:
			numLayers = int(sys.argv[i+1])
			i += 2
		except:
			print("Error in number of layers")
			break
	elif sys.argv[i] == 'numNeurons': #Number of neurons in each layer including the input layer
		try:
			neuronList = sys.argv[i+1].split(',')
			i += 2
		except:
			print("Error in the list of number of neurons")
			break
	elif sys.argv[i] == 'dataWidth':
		try:
			dataWidth = int(sys.argv[i+1])
			i += 2
		except:
			print("Error in datawidth")
			break
	else:
		print("Invalid argument ",sys.argv[i])
		break
		
f.write("`define numLayers "+str(numLayers)+'\n')
for j in range(0,numLayers):
	f.write("`define numNeuronLayer"+str(j)+" "+str(neuronList[j])+'\n')
f.write("`define dataWidth "+str(dataWidth)+'\n')
	
f.close()
f = open(sourceFilePath+"nn_autoGen_top.v","w")

g = open("db/moduleTemplate")
data = g.read()
g.close()
f.write(data)

f.write("""localparam IDLE = 'd0,
           SEND = 'd1;\n""") 
#Instantiate the layers
for i in range(1,numLayers):
    f.write("wire [`numNeuronLayer%d-1:0] o%d_valid;\n"%(i,i));
    f.write("wire [`numNeuronLayer%d*`dataWidth-1:0] x%d_out;\n"%(i,i));
    f.write("reg [`numNeuronLayer%d*`dataWidth-1:0] holdData_%d;\n"%(i,i))
    if i < numLayers-1:
        f.write("reg [`dataWidth-1:0] out_data_%d;\n"%(i))
        f.write("reg data_out_valid_%d;\n\n"%(i))
    else:
        f.write("\n")

    if i == 1: #First layer input is connected to AXI
        f.write("Layer #(.NN(`numNeuronLayer%d),.numWeight(`numNeuronLayer%d),.layerNum(%d)) l%d(\n\t.clk(s_axi_aclk),\n\t.rst(!s_axi_aresetn),\n\t.weightValid(weightValid),\n\t.biasValid(biasValid),\n\t.weightValue(weightValue),\n\t.biasValue(biasValue),\n\t.config_layer_num(config_layer_num),\n\t.config_neuron_num(config_neuron_num),\n\t.x_valid(axis_in_data_valid),\n\t.x_in(axis_in_data),\n\t.o_valid(o%d_valid),\n\t.x_out(x%d_out)\n);\n\n"%(i,i-1,i,i,i,i))
    else: #All other layers
        f.write("Layer #(.NN(`numNeuronLayer%d),.numWeight(`numNeuronLayer%d),.layerNum(%d)) l%d(\n\t.clk(s_axi_aclk),\n\t.rst(!s_axi_aresetn),\n\t.weightValid(weightValid),\n\t.biasValid(biasValid),\n\t.weightValue(weightValue),\n\t.biasValue(biasValue),\n\t.config_layer_num(config_layer_num),\n\t.config_neuron_num(config_neuron_num),\n\t.x_valid(data_out_valid_%d),\n\t.x_in(out_data_%d),\n\t.o_valid(o%d_valid),\n\t.x_out(x%d_out)\n);\n\n"%(i,i-1,i,i,i-1,i-1,i,i))
    if i < numLayers-1:
        f.write("//State machine for data pipelining\n\n")
        f.write("reg       state_%d;\n"%(i))
        f.write("integer   count_%d;\n"%(i))
        f.write("always @(posedge s_axi_aclk)\n")
        f.write("begin\n\
    if(!s_axi_aresetn)\n\
    begin\n\
        state_%d <= IDLE;\n\
        count_%d <= 0;\n\
        data_out_valid_%d <=0;\n\
    end\n\
    else\n\
    begin\n\
        case(state_%d)\n\
            IDLE: begin\n\
                count_%d <= 0;\n\
                data_out_valid_%d <=0;\n\
                if (o%d_valid[0] == 1'b1)\n\
                begin\n\
                    holdData_%d <= x%d_out;\n\
                    state_%d <= SEND;\n\
                end\n\
            end\n\
            SEND: begin\n\
                out_data_%d <= holdData_%d[`dataWidth-1:0];\n\
                holdData_%d <= holdData_%d>>`dataWidth;\n\
                count_%d <= count_%d +1;\n\
                data_out_valid_%d <= 1;\n\
                if (count_%d == `numNeuronLayer%d)\n\
                begin\n\
                    state_%d <= IDLE;\n\
                    data_out_valid_%d <= 0;\n\
                end\n\
            end\n\
        endcase\n\
    end\n\
end\n\n"%(i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i))
    else:
        f.write("assign axi_rd_data = holdData_%d[`dataWidth-1:0];\n\n"%(i))
        f.write("always @(posedge s_axi_aclk)\n\
begin\n\
    if (o%d_valid[0] == 1'b1)\n\
        holdData_%d <= x%d_out;\n\
    else if(axi_rd_en)\n\
    begin\n\
        holdData_%d <= holdData_%d>>`dataWidth;\n\
    end\n\
end\n\n\n"%(i,i,i,i,i))

f.write("maxFinder #(.numInput(`numNeuronLayer%d),.inputWidth(`dataWidth))\n\
mFind(\n\
    .i_clk(s_axi_aclk),\n\
    .i_data(x%d_out),\n\
    .i_valid(o%d_valid),\n\
    .o_data(out),\n\
    .o_data_valid(out_valid)\n\
);\n"%(numLayers-1,numLayers-1,numLayers-1))



f.write("endmodule")


f.close()


f = open(sourceFilePath+"sigContent.mif","w")

def DtoB(num, k):
	binary = ""
	Integer = int(num)
	fractional = num - Integer
	if Integer == 0:
		binary = '0'
	else:
		while(Integer):
			rem = Integer%2
			binary = binary + str(rem)
			Integer = Integer //2
		binary = binary[ : : -1]

	
	while(k):
		fractional = fractional*2
		f_bit = int(fractional)
		if (f_bit == 1):
			fractional = fractional - f_bit
			binary = binary+'1'
		else:
			binary = binary + '0'
		k = k-1
	return binary


def sigmoid(x):
	return 1 / (1+math.exp(-x))


for i in range(0,2**sigmoidSize):
	x = stepSize*i-2**(weightIntSize+inputIntSize-1)
	y = sigmoid(x)
	z = DtoB(y,dataWidth-1)
	f.write(z+'\n')
	
f.close()