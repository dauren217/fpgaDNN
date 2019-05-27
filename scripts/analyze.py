import os
import re
import genAll

numLayers = 5       #Number of layers of neural network including the input layer
neuronList = [784,30,30,10,10]
sigmoidWidth = 5 #Number of entries in the sigmoid LUT will be 2**sigmoidWidth
weightIntWidth = 4 #Number of integer bits used in the weight data including sign bit
inputIntWidth = 1 #Number of integer bits used in input data including sign bit
dataWidth = 8

f = open("data/Resource Utilization.csv","w")
f.write("Data Width,LUTs,FFs,BRAMs,DSP\n")

g = open("data/Timing Performance.csv","w")
g.write("Data Width,WNS,Fmax(MHz)\n")

re1='(Slice LUTs)'	# Variable Name 1
re2='(Slice Registers)'
re3='(Block RAM Tile)'
re4='(DSPs)'
re5='.*?'	# Non-greedy match on filler
re6='(\\d+)'	# Integer Number 1
re7='.*?'	# Non-greedy match on filler
re8='([+-]?\\d*\\.\\d+)(?![-+0-9\\.])'	# Float 1


rg1 = re.compile(re1+re5+re6+re7+re8,re.IGNORECASE|re.DOTALL)
rg2 = re.compile(re2+re5+re6+re7+re8,re.IGNORECASE|re.DOTALL)
rg3 = re.compile(re3+re5+re6+re7+re8,re.IGNORECASE|re.DOTALL)
rg4 = re.compile(re4+re5+re6+re7+re8,re.IGNORECASE|re.DOTALL)
rg5 = re.compile(re7+re8,re.IGNORECASE|re.DOTALL)

for sigmoidWidth in range(5,11,1):
	genAll.genAll(numLayers,neuronList,dataWidth,sigmoidWidth,weightIntWidth,inputIntWidth)
	os.system("vivado -mode tcl -source runScript.tcl")
	f.write(str(dataWidth)+',')
	with open('utilization.log') as fp:
		line = fp.readline()
		while line:
			m = rg1.search(line)
			if m:
				#print ('LUTs: ',m.group(2),'Ratio: ',m.group(3),"%")
				f.write(m.group(2)+',')
			m = rg2.search(line)
			if m:
				#print ('FFs: ',m.group(2),'Ratio: ',m.group(3),"%")
				f.write(m.group(2)+',')
			m = rg3.search(line)
			if m:
				#print ('BRAMs: ',m.group(2),'Ratio: ',m.group(3),"%")
				f.write(m.group(2)+',')
			m = rg4.search(line)
			if m:
				#print ('DSPs: ',m.group(2),'Ratio: ',m.group(3),"%")
				f.write(m.group(2)+'\n')
			line = fp.readline()
	
	with open('timing.log') as fp:
		line = fp.readline()
		while line:
			if 'WNS(ns)' in line:
				fp.readline() #dummyline
				line = fp.readline()
				m = rg5.search(line)
				if m:
					g.write(str(dataWidth)+',')
					slack = float(m.group(1))
					g.write(str(slack)+',')
					fmax = (1*1000)/(10-slack)
					g.write(str(fmax)+'\n')
					break
			line = fp.readline()
f.close()
g.close()