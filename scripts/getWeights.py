import json

dataWidth = 8
biasFracBits = 3
weightFracBits = 4

def DtoB(num,dataWidth,fracBits):						#funtion for converting into two's complement format
	if num >= 0:
		num = num * (2**fracBits)
		num = int(num)
		e = bin(num)[2:]
	else:
		orig = num
		num = -num
		num = num * (2**fracBits)		#number of fractional bits
		num = int(num)
		if num == 0:
			d = 0
		else:
			d = 2**dataWidth - num
		e = bin(d)[2:]
	return e


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
		f = open(fi,'w')
		for weights in range(0,len(myWeights[layer][neuron])):
			if 'e' in str(myWeights[layer][neuron][weights]):
				p = '0'
			else:
				p = DtoB(myWeights[layer][neuron][weights],dataWidth,weightFracBits)
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
			res = DtoB(p,dataWidth,biasFracBits)
		f = open(fi,'w')
		f.write(res)
		f.close()
