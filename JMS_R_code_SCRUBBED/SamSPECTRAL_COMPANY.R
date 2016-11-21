library(data.table);
library(SamSPECTRAL);


# Do SamSPECTRAL using defaults
L <- SamSPECTRAL(data.points=as.matrix(all_unnorm_data_i12[,1:5]),dimensions=c(1,2,3,4,5), normal.sigma = 200, separation.factor = 0.39);
plot(as.matrix(all_unnorm_data_i12[,1:5]), pch='.', col= L);
table(L);
table(paste(all_unnorm_data_i12$cell_label,L,sep='_'))
#### All points found by SamSPECTRAL to be in cluster 1 were also in 1 cluster by flowMeans (but not vice versa)
####  Note that this means that SamSPECTRAL returns the results in the same order you input them


# Try separation.factor in the range of 0.3 to 1.2
# The large the 'normal.sigma' is the algorithm with find smaller clusters 
# Precision = TP/(TP+FP)
# Recall = TP/(TP+FN)

for (i in 1:10){
	sep.fac <- 0.2+i/10
	for (j in 1:10){
		norm.sig <- 50*j
		print(paste("norm ",norm.sig,"   sep.fac ",sep.fac))
		L <- SamSPECTRAL(data.points=as.matrix(all_unnorm_data_i12[,1:5]),dimensions=c(1,2,3,4,5), normal.sigma = norm.sig, separation.factor = sep.fac, talk=FALSE)
		print(table(paste(all_unnorm_data_i12$cell_label,L,sep='_')));
		print("---------------NEXT---------------")
	}
}
##### See file SamSPECTRAL_parameters_combination.txt for the output of the above loop. Not very informative

# Do another iteration on: L which had "norm  500    sep.fac  1.2"
L1 <- SamSPECTRAL(data.points=as.matrix(all_unnorm_data_i12[L==1,1:5]),dimensions=c(1,2,3,4,5), normal.sigma = norm.sig, separation.factor = sep.fac, talk=FALSE);
#> print(table(paste(all_unnorm_data_i12$cell_label[which(L==1)],L1,sep='_')));
#
#      blast_1      blast_10      blast_11       blast_2       blast_4 
#           68             1             5            39            37 
#      blast_5       blast_6     healthy_1     healthy_2     healthy_4 
#           10             1           255            53             1 
#    healthy_5     healthy_6     healthy_7  unlabelled_1 unlabelled_10 
#           19             1             1          6267            13 
#unlabelled_11 unlabelled_12  unlabelled_2  unlabelled_3  unlabelled_4 
#            8             3           218           303            60 
# unlabelled_5  unlabelled_6  unlabelled_7  unlabelled_8  unlabelled_9 
#           63            36            27            25            16 
#unlabelled_NA 
#           28 
L1 <- SamSPECTRAL(data.points=as.matrix(all_unnorm_data_i12[which(L==1),1:5]),dimensions=c(1,2,3,4,5), normal.sigma = 200, separation.factor = 0.39);
#> print(table(paste(all_unnorm_data_i12$cell_label[which(L==1)],L1,sep='_')));
#
#      blast_1       blast_3     healthy_1  unlabelled_1  unlabelled_2 
#          160             1           330          7020            28 
# unlabelled_3 unlabelled_NA 
#            8            11 
