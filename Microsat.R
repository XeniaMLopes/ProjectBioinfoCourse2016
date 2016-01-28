#!/usr/bin/env Rscript

#===========================================================================================
#  Vania E. Rivera-Leon and Xenia M. Lopes
#  28/jan/2016
#  Exploratory population genetic analysis/Using adgenet package
#===========================================================================================

# ENABLE command line arguments
#args[numb] seen through the code "calls" the arguments in the order they were added in Pipe.sh
args <- commandArgs(TRUE)

library(adegenet)

microsat<-read.structure(args[1], n.ind=(as.double(args[2])), n.loc=(as.double(args[3])), 
                         onerowperind=TRUE, col.lab=1, col.pop=2, 
                         row.marknames=1, NA.char="-9", pop = NULL, sep = NULL, ask=FALSE)

Divfile <- paste("diversity", args[4], sep = "_")
sink(Divfile, append = TRUE, type = c("output"))
Smicro<-summary(microsat)
mean(Smicro$Hobs)
mean(Smicro$Hexp)
sink()

#===================================
#Testing for deviations from HW
#===================================
library(pegas)

BpHWE <- hw.test(microsat, B=100, hide.NA=TRUE, 
                         res.type="matrix")
#Sink is used to send the output to a file
HWfile <- paste("HW", args[4], sep = "_")
sink(HWfile, append = TRUE, type = c("output"))
BpHWE
sink()

#Plots 
HW_plots <- paste("HW_plots", args[4], sep = "_")
pdf(HW_plots)
par(mar = rep(5,4),mfrow=c(1,2))
barplot(apply(BpHWE < 0.05, 1, mean, na.rm = TRUE),
        ylab = "Proportion of departures from HWE", main = "By population")
barplot(apply(BpHWE < 0.05, 2, mean, na.rm = TRUE),
        ylab = "Proportion of departures from HWE", main = "By marker")
dev.off()

#======================================
#Population structure
#====================================
library(hierfstat)
fstat(microsat, pop=NULL, fstonly=FALSE)

#=======================================
#Genetic Distance Tree
#=======================================
#First replace missing values
Y <-tab(microsat, NA.method="zero")

#Estimate Euclidean distances
D <- dist(Y)
hca <- hclust(D, method="complete")
Completelink <- paste("Complete_linkage", args[4], sep = "_")
pdf(Completelink)
par(mar = rep(5,4),mfrow=c(1,1))
plot(hca, main = "Complete linkage")
dev.off()

library(ape)
tree <- nj(D)
myPop <- rainbow(4)[as.integer(pop(microsat))]
Tree <- paste("Distance_Tree", args[4], sep = "_")
pdf(Tree)
plot(tree, type = "unr", show.tip.lab = FALSE, main = "NJ tree based on genetic distance")
tiplabels(col = myPop, pch = 20)
dev.off()

############################################
#Population Level
###########################################

#Convert genind to genpop
Pop <- genind2genpop(microsat)

#===================================
#Genetic distances between populations
#=====================================
#method an integer from 1 to 5, 1=Nei's distance
Distpop<-dist.genpop(Pop, method = 1, diag = FALSE, upper = FALSE)
Distpop


#===================================================
#Multivariate Analysis
#==================================================
#Principal Component Analysis
pcaX <- dudi.pca(Y, cent = TRUE, scale = FALSE, scannf = FALSE, nf = 3)
barplot(pcaX$eig[1:50], main = "Eigenvalues", col=heat.colors(50))
pcaX
#Plot
myPop <- rainbow(length(levels(pop(microsat))))
par(bg = "white")
s.class(pcaX$li, pop(microsat), sub="PCA 1-2", csub=2, col=transp(myPop),
axesell=TRUE, cstar=1, cpoint=2, grid=TRUE)
title("PCA")
add.scatter.eig(pcaX$eig[1:15], nf=3, xax=1, yax=2, posi="top")

#===============================
#Discriminant Analyses of Principal Components
#=====================================
dapc2 <- dapc(microsat, pop = NULL, n.pca = 40, n.da = 2, 
              all.contr = TRUE)
Dpcaplot <- paste("DAPC", args[4], sep = "_")
pdf(Dpcaplot)
scatter(dapc2)
title("DAPC")
dev.off()

Density <- paste("DAPC_densities", args[4], sep = "_")
pdf(Density)
scatter(dapc2, xax = 1, yax = 1)
dev.off()

#END

