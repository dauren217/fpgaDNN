import sys


try:
    import cPickle as pickle
except:
    import pickle
import gzip
import numpy as np

l = 8					#specify the number of bits in test data

try:
	testDataNum = int(sys.argv[1])
except:
	testDataNum = 1


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
		binary = binary 
	
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



def load_data():
	f = gzip.open('mnist.pkl.gz', 'rb') 		#change this location to the resiprositry where MNIST dataset sits
	training_data, validation_data, test_data = pickle.load(f,encoding='latin1')
	f.close()
	return (training_data, validation_data, test_data)


tr_d, va_d, te_d = load_data()
test_inputs = [np.reshape(x, (1, 784)) for x in te_d[0]]

x = len(test_inputs[0][0])
d=l-1
count = 0

for j in range(0,testDataNum):
	fileName = 'validation_data_'+str(te_d[1][j])+'.txt'
	f = open(fileName,'w')
	fileName = 'visual_data'+str(te_d[1][j])+'.txt'
	g = open(fileName,'w')
	for i in range(0,x):
		myData = DtoB(test_inputs[j][0][i],d)
		f.write(myData+'\n')
		g.write(myData)
		count += 1
		if count%28 == 0:
			g.write('\n')
	g.close()
	f.close()