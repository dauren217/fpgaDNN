import cPickle
import gzip
import numpy as np

a = 6					#specify the number of a test data file you want to test
l = 16					#specify the number of bits in test data




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
	f = gzip.open('C:/users/ASER/Anaconda3/mnist.pkl.gz', 'rb') 		#change this location to the resiprositry where MNIST dataset sits
	training_data, validation_data, test_data = cPickle.load(f)
	f.close()
	return (training_data, validation_data, test_data)


tr_d, va_d, te_d = load_data()
test_inputs = [np.reshape(x, (1, 784)) for x in te_d[0]]
x = len(test_inputs[0][0])
d=l-1
f = open('validation_data.txt','w')
for i in range(0,x):
	myData = DtoB(test_inputs[a][0][i],d)
	f.write(myData+'\n')
f.close()
print('The output should be: '+str(te_d[1][a]))