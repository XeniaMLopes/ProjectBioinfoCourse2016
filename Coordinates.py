#! /usr/bin/env python

#==================================================================================================================
#Vania E. Rivera-Leon and Xenia M. Lopes
#28/jan/2016
#Extract the geographical information from a structure file and creates a new file that can be use as input of Map.R
#==================================================================================================================

import re#regular expression module
import sys#System-specific parameters and functions module

#Input and output files (retrieved as arguments from shell - Pipe.sh)
FileName = str(sys.argv[1])
OutFileName = str(sys.argv[2])

InFile = open(FileName, 'r')#Open input file on read mode

HeaderLine = 'Id\tPop\tLat\tLong'
#print HeaderLine
OutFile=open(OutFileName, 'w')#Open output file to write
OutFile.write(HeaderLine + '\n')#add the header to the output dile

LineNumber=0
#Loop for each line in the file
for Line in InFile:
	if LineNumber>0:#Avoid the header of the input file
		Line = Line.strip('\n')#Remove line ending characters
		ElementList = Line.split()#Split the line in ElementList, usin space as delimiter
		#Variables are assigned from ElemenList 
		Id = ElementList[0]
		Pop = ElementList[1]
		Long = ElementList[2]
		Lat = ElementList[3]
		OutString = "%s\t%s\t%s\t%s" % (Id,Pop,Lat,Long)#Create a string with the variables
 		#print OutString
		OutFile.write(OutString +'\n')#write the OutString to the output file
	LineNumber+=1

#Close the input and output files
InFile.close()
OutFile.close()

