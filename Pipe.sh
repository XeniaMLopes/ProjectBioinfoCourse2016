#! /bin/bash

#=====================================================================================================================================================
#Vania E. Rivera-Leon and Xenia M. Lopes
#28/jan/2016
#
#The pipe line uses R to conduct exploratory population genetic analysis and if HW equilibrium can't be detected for most of the loci, it runs structure
#The inputfile and Structure should be on the working directory
#The scripts: Microsat.R, Map.R, HW.py, Coordinates.py are necessary
#The user has to provide information in the following order when calling the function:
#1- Input file (microsat and lat/long information on structure format) - mandatory
#2- Number of individuals -mandatory
#3- Number of loci - mandatory
#4- Number of clusters to test on structure - optional
#5- Number of iterations (runs) to test on structure - optional
#6- Lable to name the outputfiles (without extension/it will be used as part of all the outputs) - optional
#======================================================================================================================================================

popGen(){

#Shortcut to the working directory
ProjectPATH=~/Documents/Project/
#Makes sure that the pipeline is run on the working directory
cd $ProjectPATH

#Number of clusters to test on structure
#If there is no input, it will consider 5
Maxk=5
if [ $4 ]
then
	Maxk=$4
fi

#Number of runs to test on structure
#If there is no input, it will consider 5
Iter=5
if [ $5 ]
then
	Iter=$5
fi

#Name to identify the outputs
#If there is no input, it will consider "output"
outfile=output
if [ $6 ]
then
	outfile=$6
fi

#
#two arguments (input file, output file name)
Coordinates.py $1 LatLon_$6

#run R script Microsat.R
#four arguments (input file, number of individuals, number of loci, output file name)
Microsat.R $1 $2 $3 $6
Map.R LatLon_$6 $6

#run python script HW.py
#one argument (output file name)
HW.py HW_$6
NotHW=$(tail -n 1 HW_$6)

#To print to the screen the percentage of loci not in HW
#echo $NotHW

#run structure if more then 70% of the loci are not in HW
if [ $NotHW -ge 70 ]
then
	#run structure from 1 to "Iter" times, per number of clusters
	for i in $(seq 1 $Iter)
	do
		#run structure from 1 to "Maxk" number of clusters
		for K in $(seq 1 $Maxk)
		do
			#echo "Run for K = $K"
			./structure -i $1 -K $K -l $3 -N $2 -o $6_$K.$i 
		done
	done
fi
}



