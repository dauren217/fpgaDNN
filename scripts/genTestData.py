import sys

outputPath = "../imp/fpnn.sim/sim_1/behav/xsim/"

try:
    import cPickle as pickle
except:
    import pickle
import gzip
import numpy as np

dataWidth = 16					#specify the number of bits in test data
IntSize = 1 #Number of bits of integer portion including sign bit

try:
	testDataNum = int(sys.argv[1])
except:
	testDataNum = 3

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


def load_data():
	f = gzip.open('mnist.pkl.gz', 'rb') 		#change this location to the resiprositry where MNIST dataset sits
	training_data, validation_data, test_data = pickle.load(f,encoding='latin1')
	f.close()
	return (training_data, validation_data, test_data)

def genTestData(dataWidth,IntSize,testDataNum):
	tr_d, va_d, te_d = load_data()
	test_inputs = [np.reshape(x, (1, 784)) for x in te_d[0]]
	
	x = len(test_inputs[0][0])
	d=dataWidth-IntSize
	count = 0
	fileName = 'validation_data.txt'
	f = open(outputPath+fileName,'w')
	fileName = 'visual_data'+str(te_d[1][testDataNum])+'.txt'
	g = open(outputPath+fileName,'w')
	for i in range(0,x):
		myData = DtoB(test_inputs[testDataNum][0][i],dataWidth,d)
		f.write(myData+'\n')
		g.write(myData)
		count += 1
		if count%28 == 0:
			g.write('\n')
	g.close()
	f.close()
		
if __name__ == "__main__":
	genTestData(dataWidth,IntSize,testDataNum=0)