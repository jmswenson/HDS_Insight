print("Please see 'browseVignettes('flowMeans')' or 'flowMeans.pdf'")
library(flowMeans)

############ READ IN REAL DATA ############
# i12
library(data.table);
print("Check that data input looks right. Note that fread args are different depending on where the data came from");
all_unnorm_data_i12 <- fread("/Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/LABELLED_by_cell_type_screen_525_cell_plate_1_well_i12_PCAd.csv", header = TRUE); # working dir: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/
head(as.data.frame(all_unnorm_data_i12)[,1:8]);
all_unnorm_data_i12 <- as.data.frame(all_unnorm_data_i12)[,-1]; # Get rid of the first column and convert to a data.frame

### Do flowMeans
flow_out_unnorm_i12_Mah_TRUE <- flowMeans(all_unnorm_data_i12[,1:5], MaxN = 10)
flow_out_unnorm_i12_Mah_FALSE <- flowMeans(all_unnorm_data_i12[,1:5], MaxN = 10, Mahalanobis = FALSE)

### Quick check of results
table(paste(all_unnorm_data_i12$cell_label,flow_out_unnorm_i12_Mah_TRUE@Label,sep='_'));
#blast_1    healthy_1 unlabelled_1 unlabelled_2 unlabelled_3 unlabelled_4 
#         164          333         7368           11           36           12 
#unlabelled_5 
#          55 

table(paste(all_unnorm_data_i12$cell_label,flow_out_unnorm_i12_Mah_FALSE@Label,sep='_'));
#blast_1    healthy_1    healthy_2 unlabelled_1 unlabelled_2 unlabelled_3 
#         164          332            1         7355           13           36 
#unlabelled_4 unlabelled_5 
#          66           12 

###### Mahalanobis = TRUE seems slightly better, both worked great for screen_525_cell_plate_1_well_i12_PCAd
library(flowMeans)
library(data.table);


####### Try on G20
all_unnorm_data_g20 <- fread("/Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/LABELLED_by_cell_type_screen_525_cell_plate_1_well_g20_PCAd.csv", header = TRUE); # working dir: 
print("Check that data input looks right. Note that fread args are different depending on where the data came from");
head(as.data.frame(all_unnorm_data_g20)[,1:11]);
all_unnorm_data_g20 <- as.data.frame(all_unnorm_data_g20)[,-1]; # Get rid of the first column and convert to a data.frame

### Do flowMeans
flow_out_unnorm_g20_Mah_TRUE <- flowMeans(all_unnorm_data_g20[,1:5], MaxN = 10);
#Error in solve.default(cov, ...) : 
#  system is computationally singular: reciprocal condition number = 1.80013e-19

flow_out_unnorm_g20_Mah_FALSE <- flowMeans(all_unnorm_data_g20[,1:5], MaxN = 10, Mahalanobis = FALSE);

### Quick check of results
table(paste(all_unnorm_data_g20$cell_label,flow_out_unnorm_g20_Mah_TRUE@Label,sep='_')); # Not found because of above error
table(paste(all_unnorm_data_g20$cell_label,flow_out_unnorm_g20_Mah_FALSE@Label,sep='_'));
#     blast_4    healthy_4 unlabelled_1 unlabelled_2 unlabelled_3 unlabelled_4 
#          82           64            5           74            2         4451 


######## try c03
all_unnorm_data_c03 <- fread("/Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/LABELLED_by_cell_type_screen_525_cell_plate_1_well_c03_PCAd.csv"
	, header = TRUE); # working dir: 
print("Check that data input looks right. Note that fread args are different depending on where the data came from");
head(as.data.frame(all_unnorm_data_c03)[,1:11]);
all_unnorm_data_c03 <- as.data.frame(all_unnorm_data_c03)[,-1]; # Get rid of the first column and convert to a data.frame

### Do flowMeans
flow_out_unnorm_c03_Mah_TRUE <- flowMeans(all_unnorm_data_c03[,1:5], MaxN = 10);
#Error in solve.default(cov, ...) : 
#  system is computationally singular: reciprocal condition number = 1.80013e-19

flow_out_unnorm_c03_Mah_FALSE <- flowMeans(all_unnorm_data_c03[,1:5], MaxN = 10, Mahalanobis = FALSE);

for (i in 5:15){
	print(i);
	try(flow_out_unnorm_c03_Mah_TRUE <- flowMeans((all_unnorm_data_c03[,1:i]), MaxN = 10, Mahalanobis = FALSE, Standardize = TRUE));
}



### Quick check of results
table(paste(all_unnorm_data_c03$cell_label,flow_out_unnorm_c03_Mah_TRUE@Label,sep='_')); # Not found because of above error
table(paste(all_unnorm_data_c03$cell_label,flow_out_unnorm_c03_Mah_FALSE@Label,sep='_'));






### g20 doesn't work well...first combin it with i12 and see if that is better





##### On an entire plate

#### Sample dataset for initial testing
#dtaa_sub<-sample(1:nrow(dtaa),100);
#dtaa<-dtaa[dtaa_sub,];
#### End of sub-sampling
library(flowMeans);
library(data.table);
print("Check that data input looks right. Note that fread args are different depending on where the data came from");
#all_rob_norm <- fread("/Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/screen_525_cell_plate_1__all_wells_combined__robustly_normalized_only_auto_PCAd.csv", header = TRUE); # working dir: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/
all_rob_norm <- fread("/Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/screen_525_cell_plate_1__all_wells_combined__unnormalized_only_auto_PCAd-rob-scale.csv", header = TRUE); # working dir: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/
head(as.data.frame(all_rob_norm));
all_rob_norm <- as.data.frame(all_rob_norm)[,-1]; # Get rid of the first column and convert to a data.frame
#all_rob_norm<-(all_rob_norm[1:864022,]);
head(as.data.frame(all_rob_norm));
tail(all_rob_norm);
#colnames(all_rob_norm)[8]<- "cell_plate__UNnormalized";

# Get a well by well summary
#for (i in unique(all_rob_norm$well)){
#	uq_wells<-grep(i,all_rob_norm$well)
#	print(i)
#	print(summary(all_rob_norm[uq_wells,1:5]))
#	print("")
#}


### Do flowMeans
set.seed(11); flow_out_rob_norm_PCAd_ALLs525plate1_Mah_TRUE <- flowMeans(all_rob_norm[,1:6], MaxN = 10, iter.max=50);
# Quick-TRANSfer stage steps exceeded maximum (= 59328800)
set.seed(11); flow_out_rob_norm_PCAd_ALLs525plate1_Mah_FALSE <- flowMeans(all_rob_norm[,1:6], MaxN = 10, iter.max=50, Mahalanobis = FALSE);
# Quick-TRANSfer stage steps exceeded maximum (= 59328800)

### Quick check of results
### For robustly normalized, then unscaled PCA (95% var)
table(paste(all_rob_norm$cell_label,flow_out_rob_norm_PCAd_ALLs525plate1_Mah_TRUE@Label,sep='_'));
#          _1           _2           _3           _4           _5           _6 
#         505         5298          262          152      1180080          279 
#     blast_2      blast_5    healthy_5 unlabelled_1 unlabelled_2 unlabelled_3 
#           1         3539         4530           71         1043           32 
# unlabelled_4 unlabelled_5 unlabelled_6 
#          17       142020           42 
table(paste(all_rob_norm$cell_label,flow_out_rob_norm_PCAd_ALLs525plate1_Mah_FALSE@Label,sep='_'));
#          _1           _2           _3           _4           _5      blast_2 
#         767      1184989          279          152          389         3540 
#   healthy_2 unlabelled_1 unlabelled_2 unlabelled_3 unlabelled_4 unlabelled_5 
#        4530          103       143017           42           17           46 
### For unnormalized, then robustly_scaled PCA (95% var)
table(paste(all_rob_norm$cell_label,flow_out_rob_norm_PCAd_ALLs525plate1_Mah_TRUE@Label,sep='_'));
#          _1           _2           _3           _4           _5      blast_1 
#     1033712          381          227          241          720         3540 
#   healthy_1 unlabelled_1 unlabelled_2 unlabelled_3 unlabelled_4 unlabelled_5 
#        4530       142980           60           31           57           97 
table(paste(all_rob_norm$cell_label,flow_out_rob_norm_PCAd_ALLs525plate1_Mah_FALSE@Label,sep='_'));
#          _1           _2           _3           _4      blast_2    healthy_2 
#          20      1034802          227          232         3540         4530 
#unlabelled_1 unlabelled_2 unlabelled_3 unlabelled_4 
#           2       143147           31           45 

##### robustly normalized, then unscaled PCA (95% var) -- Mah=TRUE seems to work the 
#####    best for pre-processing (as measured by number of cells not in the same cluster as blast),
#####	 followed by Mah=FALSE, then unnormalized, then robustly_scaled PCA (95% var) -- Mah=TRUE




######## All healthy and cancer cells are in one cluster ....subset that cluster and cluster it with flowMeans
# First select those cells
which_cl <- 1;
cl1 <- all_rob_norm[which(flow_out_rob_norm_PCAd_ALLs525plate1_Mah_TRUE@Label == which_cl),];
data_cols<-grep("*[0-9]",colnames(all_rob_norm));


# Now actually do flowmeans on all of the cluster of interest
flow_out_cluster1 <- flowMeans(cl1[,data_cols], MaxN = 10, Mahalanobis = TRUE);
# Map the output
table(paste(cl1$cell_label,flow_out_cluster1@Label,sep='_'));
# robustly normalized, then unscaled PCA (95% var) -- Mah=TRUE clustering again yielded still little 
# 	separation between blast and healthy, 
#          _1           _2           _3           _4           _5      blast_1 
#        5034      1162352          113        12359          222            1 
#     blast_2    healthy_1    healthy_2    healthy_4 unlabelled_1 unlabelled_2 
#        3538            3         4439           88          743       139757 
#unlabelled_3 unlabelled_4 unlabelled_5 
#          12         1458           50 
# I actually clustered one more time and then blast and healthy split into subsets, but not just blast or just healthy
#          _1           _2           _3           _4      blast_1      blast_2 
#     1110831        16559          797        34165         2868          645 
#     blast_3      blast_4    healthy_1    healthy_4 unlabelled_1 unlabelled_2 
#           1           24         3165         1274       134735         1531 
#unlabelled_3 unlabelled_4 
#         135         3356 
 


######## It happened again #####
######## All healthy and cancer cells are in one cluster ....subset that cluster and cluster it with flowMeans
# First select those cells
which_cl <- 1;
cl2 <- cl1[which(flow_out_cluster1@Label == which_cl),];
data_cols<-grep("*[0-9]",colnames(all_rob_norm));


# Now actually do flowmeans on all of the cluster of interest
flow_out_cluster2 <- flowMeans(cl2[,data_cols], MaxN = 10, Mahalanobis = TRUE);
# Map the output
table(paste(cl2$cell_label,flow_out_cluster2@Label,sep='_'));





### Automatically calc precision and recall
for (i in unique(){
DO STUFF
TP/(TP+FP)
























############ BELOW NOT IMPLEMENTED ###########
# Make matrix where rows are: unlabelled, normal, blast. columns are clusters. values are how many cluster in that label.
flow_out_mat <- matrix(nrow=3, ncol=5);
print("making grouped barcharts is currently done by hardcoding things, make programatic");
rownames(flow_out_mat) <-c("unlabelled","healthy","blast");
flow_out_mat[1,]<-c(175, 7242, 40, 13, 12);
flow_out_mat[2,]<-c(0,333,0,0,0);
flow_out_mat[3,]<-c(0,164,0,0,0);

cherry<-rgb(1,0,0,.5);
grn<-rgb(0,1,0,.5);
blue<-rgb(0,0,1,.5);

png(file = "i12_flowMeans_results.png")
barplot(flow_out_mat+0.00001, main="Cell Distribution by Cluster",
  xlab="Cell type", col=c(cherry,grn,blue),
 	legend = rownames(flow_out_mat), beside=TRUE, log='y', args.legend = list(x = "topright"));
# In python/pandas the above would be: #groupby and then value_counts. dplyr it would be easy too
dev.off()


### All healthy and cancer cells are in cluster 2....subset that cluster and cluster it with flowMeans
# First select those cells
cl2 <- i12_all[which(flow_out_unnorm_i12_all_Mah_FALSE@Label == 2),unnorm_cols];

cl2 <- cbind(cl2, i12_all[which(flow_out_unnorm_i12_all_Mah_FALSE@Label == 2),grep("cell_label", colnames(all_norm_and_unnorm_data))])
# "which" here is returning a vector of values indicating the rownumber of i12_all which
##   belonged to cluster 2. Note that this index starts at 1, unlike the original i12_all
###  which starts at 132759

# Now actually do flowmeans on all of cluster 2
flow_out_unnorm_i12_all_Mah_FALSE_cluster2 <- flowMeans(cl2[,1:(ncol(cl2)-1)], MaxN = 10, Mahalanobis = FALSE);
# Map the output
table(paste(cl2[,ncol(cl2)],flow_out_unnorm_i12_all_Mah_FALSE_cluster2@Label,sep='_'));
flow_out_unnorm_i12_all_Mah_FALSE_cluster2_cl_out <- 
	cbind(as.character(cl2[,ncol(cl2)]),flow_out_unnorm_i12_all_Mah_FALSE_cluster2@Label)
### Automatically calc precision and recall
for (i in unique(flow_out_unnorm_i12_all_Mah_FALSE_cluster2_cl_out[,1])){
DO STUFF


# Graph the results
# Make matrix where rows are: unlabelled, normal, blast. columns are clusters. values are how many cluster in that label.
flow_out_mat <- matrix(nrow=3, ncol=6);
print("making grouped barcharts is currently done by hardcoding things, make programatic");
rownames(flow_out_mat) <-c("unlabelled","healthy","blast");
flow_out_mat[1,]<-c(454, 1760, 165, 4420, 384, 59);
flow_out_mat[2,]<-c(11,143,0,1,178,0);
flow_out_mat[3,]<-c(60,56,0,0,48,0);

cherry<-rgb(1,0,0,.5);
grn<-rgb(0,1,0,.5);
blue<-rgb(0,0,1,.5);

png(file = "i12_flowMeans_2nd_iteration_results.png")
barplot(flow_out_mat+0.00001, main="Cell Distribution by Cluster from cluster 2",
  xlab="Cell type", col=c(cherry,grn,blue),
 	legend = rownames(flow_out_mat), beside=TRUE, args.legend = list(x = "topright"));
# In python/pandas the above would be: #groupby and then value_counts. dplyr it would be easy too
dev.off()




