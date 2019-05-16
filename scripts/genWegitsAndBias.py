import json

dataWidth = 32
dataIntWidth = 1
weightIntWidth = 4
dataFracWidth = dataWidth-dataIntWidth
weightFracWidth = dataWidth-weightIntWidth
biasIntWidth = dataIntWidth+weightIntWidth
biasFracWidth = dataWidth-biasIntWidth
outputPath = "../imp/fpnn.sim/sim_1/behav/xsim/"

def DtoB(num,dataWidth,fracBits):						#funtion for converting into two's complement format
	if num >= 0:
		num = num * (2**fracBits)
		num = int(num)
		e = bin(num)[2:]
	else:
		num = -num
		num = num * (2**fracBits)		#number of fractional bits
		num = int(num)
		if num == 0:
			d = 0
		else:
			d = 2**dataWidth - num
		e = bin(d)[2:]
	return e

def genWaitAndBias(dataWidth,weightFracWidth,biasFracWidth):
	myDataFile = open("WeigntsAndBiases.txt","r")
	myData = myDataFile.read()
	myDict = json.loads(myData)
	myWeights = myDict['weights']
	myBiases = myDict['biases']
	
	for layer in range(0,len(myWeights)):
		for neuron in range(0,len(myWeights[layer])):
			if neuron <10:
				fi = 'w_'+str(layer+1)+'_0'+str(neuron)+'.txt'
			else:
				fi = 'w_'+str(layer+1)+'_'+str(neuron)+'.txt'
			f = open(outputPath+fi,'w')
			for weights in range(0,len(myWeights[layer][neuron])):
				if 'e' in str(myWeights[layer][neuron][weights]):
					p = '0'
				else:
					p = DtoB(myWeights[layer][neuron][weights],dataWidth,weightFracWidth)
				f.write(p+'\n')
			f.close()
			
			
	for layer in range(0,len(myBiases)):
		for neuron in range(0,len(myBiases[layer])):
			if neuron <10:
				fi = 'b_'+str(layer+1)+'_0'+str(neuron)+'.txt'
			else:
				fi = 'b_'+str(layer+1)+'_'+str(neuron)+'.txt'
			p = myBiases[layer][neuron][0]
			if 'e' in str(p): #To remove very small values with exponents
				res = '0'
			else:
				res = DtoB(p,dataWidth,biasFracWidth)
			f = open(outputPath+fi,'w')
			f.write(res)
			f.close()

			
if __name__ == "__main__":
	genWaitAndBias(dataWidth,weightFracWidth,biasFracWidth)