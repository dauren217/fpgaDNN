import math

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
		binary = binary +''
	
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


for i in range(0,1024):
	x = 0.015625*i-8
	y = sigmoid(x)
	z = DtoB(y,15)
	print "mem[",i,"] = 16'b"+z+';'

