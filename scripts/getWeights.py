import json

def Conv(num,k):					#function to convert weight values into signed mangitude binary format
	binary = ''
	if num < 0:
		a = -num
		b = int(a)
		f = a-b
		if b == 0:
			binary = '100'
		elif b == 1:
			binary = '101'
		elif b == 2:
			binary = '110'
		else :
			binary = '111'
		while (k):
			f=f*2
			f_bit = int(f)
			if f_bit == 1:
				f = f - f_bit
				binary = binary +'1'
			else :
				binary = binary + '0'
			k = k - 1
			
	else :
		b = int(num)
		f = num-b
		if b == 0:
			binary = '000'
		elif b == 1:
			binary = '001'
		elif b == 2:
			binary = '010'
		else:
			binary = '011'

		while (k):
			f=f*2
			f_bit = int(f)
			if f_bit == 1:
				f = f - f_bit
				binary = binary +'1'
			else :
				binary = binary + '0'
			k = k - 1
			
	return binary
	
	
def DtoB2(num):						#funtion for converting bias values into two's complement format
	if num > 0:
		a = int(num)
		a = bin(a)[2:]
		num = num * (2**24)   #change this value to the needed number of fractional bits here and later
		num = int(num)
		d = bin(num)[2:]
		if a == '0':
			f = 24 - len(d)
			while (f):
				d = '0'+d
				f = f-1
			c = 4				#number of bits designated for sign and integer parts
			while (c):
				d = '0'+d
				c = c-1
		else:
			f = len(d) - len(a)
			if f < 24:
				f = 24 - f
				while(f):
					d = d+'0'
					f = f-1
			c = 4 - len(a)
			while(c):
				d = '0'+d
				c = c-1
		d = d[0:28]   #specify here the number of needed bits for bias values
	else:
		num = - num
		a = int(num)
		a = bin(a)[2:]
		num = num * (2**24)		#number of fractional bits
		num = int(num)
		d = 0b10000000000000000000000000000 - num   #number of zeros in the value should be equal to the required number of bits for the bias
		d = bin(d)[2:]
	return d


myDataFile = open("WeigntsAndBiases.txt","r")
myData = myDataFile.read()
myDict = json.loads(myData)
myWeights = myDict['weights']
myBiases = myDict['biases']

for layer in range(0,len(myWeights)):
	for neuron in range(0,len(myWeights[layer])):
		if neuron <10:
			fi = '16'+str(layer+1)+'_0'+str(neuron)+'.txt'
		else:
			fi = '16'+str(layer+1)+'_'+str(neuron)+'.txt'
		f = open(fi,'w+')
		for weights in range(0,len(myWeights[layer][neuron])):
			if 'e' in str(myWeights[layer][neuron][weights]):
				p = '0000000000000000'								#should be equal to the number of required bits for weights
			else:
				p = Conv(myWeights[layer][neuron][weights], 13)
			f.write(p+'\n')
		f.close()
		
		
for layer in range(0,len(myBiases)):
	for neuron in range(0,len(myBiases[layer])):
		if neuron <10:
			fi = 'b16_'+str(layer+1)+'_0'+str(neuron)+'.txt'
		else:
			fi = 'b16_'+str(layer+1)+'_'+str(neuron)+'.txt'
		p = myBiases[layer][neuron][0]
		if 'e' in str(p):
			res = '0000000000000000000000000000'				#should be equal to the number of required bits for bias
		else:
			res = DtoB2(p)
		f = open(fi,'w')
		f.write(res)
		f.close()
