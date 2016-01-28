#! /usr/bin/env python

#==================================================================================================================
#Vania E. Rivera-Leon and Xenia M. Lopes
#28/jan/2016
#Extract the geographical information from a structure file and creates a new file that can be use as input of Map.R 
#===================================================================================================================

import re#regular expression module
import sys#system-specific parameters and functions module

#define a function that retrieves part of the information on a line of the file
def hw(HWstring):
	SearchStr='[\w\d]+\s+[\d\.\w\+\-]+\s+[\d]+\s+[\d\.\w\+\-]+\s+([\d\.]+)'
	Result=re.search(SearchStr, HWstring)
	HWfloat=float(Result.group(1))#get the captured character group (p-values for HW), and convert it to float
	return HWfloat

FileName=str(sys.argv[1])#Input file (retrieved as arguments from shell - Pipe.sh (it is the one of the outputs of Microsat.R))

InFile=open(FileName, 'r')#open the input file to read
OutFile=open(FileName, 'a')#the input file is also open to append information

LineNumber=0
NonEq=0
#Loop for each line in the file
for Line in InFile:
	if LineNumber>0:#Avoid the header of the input file
		Line=Line.strip('\n')#Remove line ending characters
		HWfinal=hw(Line)#call the function to selecte the wanted information
		if HWfinal<0.05:#counts the number of loci for which HW equilibrium was not detected
			NonEq+=1
	LineNumber+=1

Percentage=(float(NonEq)/(LineNumber-1))*100#calculate the percentage of loci not in HW
PercentInt=int(Percentage)#change the percentage to an integer (to loose the decimal digits)
PercentStr=str(PercentInt)#change the percentage to a string so that it can be added to the file with '\n'
OutFile.write(PercentStr+'\n')
#Close the file
InFile.close()
OutFile.close()
#print NonEq
#print LineNumber
#print PercentInt

