print("Please see 'browseVignettes('flowMeans')' or 'flowMeans.pdf'")
library(flowMeans)
c3_data <- read.csv("../screen_357_cell_plate_1_well_C3_original.JMS.csv", row.names = 1); # working directory: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/training_set/exploration_screen_357_cell_plate_1_well_C3_original
class(c3_data); # data_frame

# Don't use "Width" or "Time" column, set 10 clusters as the maximum
set.seed(11);
print("check that set.seed does what you think that it does")
flow_out <- flowMeans(c3_data[,1:26], MaxN = 10)
plot(c3_data[,1:2], flow_out, colnames(c3_data[1:2]))

# > flow_out <- flowMeans(c3_data[,1:26], MaxN = 10,iter.max = 5)
# Error in solve.default(cov, ...) : 
#  system is computationally singular: reciprocal condition number = 2.95261e-21
### Info on the error is below

### It means your design matrix is not invertible and therefore can't be used to develop 
#### a regression model. This results from linearly dependent columns, i.e. strongly 
#### correlated variables. Examine the pairwise covariance (or correlation) of your 
#### variables to investigate if there are any variables that can potentially be 
#### removed. You're looking for covariances (or correlations) >> 0. Alternatively, 
#### you can probably automate this variable selection by using a forward stepwise regression.

# 
# In solve(), use a smaller tolerance, like solve(..., tol = 1e-17). This should be 
# fine since you get reciprocal condition number = 1.16873e-16. More info in the help file and this related question.

# Also see this link for the best explanation: http://stackoverflow.com/questions/22134398/mahalonobis-distance-in-r-error-system-is-computationally-singular
# And maybe the best: http://r.789695.n4.nabble.com/system-is-computationally-singular-reciprocal-condition-number-td4647472.html

# Potential solutions: 
# 1) Decrease the tol in solve to < 2.95261e-21; 2) Do feature reduction (forward stepwise regression, PCA, ICA);
# 3) Add MORE random noise; 4) Instead of trying to solve the inverse matrix do some optimization (optim() with "BFGS" or "CG" maybe. https://stat.ethz.ch/pipermail/r-help/2004-December/062528.html)
# 5) To start just don't use Mahalanobis distance; 6) Get rid of any matrix that is more than 90% correlated with another (keep one though)

# Note for debugging: flowMeans:::distanceMatrix and flowMeans
# https://rdrr.io/bioc/flowMeans/ for list of packages in flowMeans


c3_data <- read.csv("../screen_357_cell_plate_1_well_C3_original.JMS.csv", row.names = 1); # working directory: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/training_set/exploration_screen_357_cell_plate_1_well_C3_original
# Don't use "Width" or "Time" column, set 10 clusters as the maximum
set.seed(11);
library(flowMeans);
print("check that set.seed does what you think that it does. Also, currently using straight-up K-means")
flow_out <- flowMeans(c3_data[,1:26], MaxN = 10, Mahalanobis = FALSE)
plot(c3_data[,1:2], flow_out, colnames(c3_data[1:2]))
head(flow_out@Label)
dev.off()

# Show the iterations of number of clusters and how they were choosen
png(file = "c3_how_k_choosen.png")
plot(flow_out@Mins, xlab = ' ', ylab= ' ', xlim = c(1,flow_out@MaxN), ylim = c(0,max(flow_out@Mins)))
ft <- changepointDetection(flow_out@Mins);
abline(ft$l1);
abline(ft$l2);
#par(new=TRUE);
#plot(ft$MinIndex+1, flow_out@Mins[ft$MinIndex+1], col='red', xlab='Iteration', ylab='Distance')
dev.off()
# Distance is the minimum distance between merged clusters

###### try again because plotting that change point isn't working
png(file = "c3_how_k_choosen_noline.png")
ft <- changepointDetection(flow_out@Mins);
plot(flow_out@Mins, xlab='Iteration', ylab='Distance', xlim = c(1,flow_out@MaxN), ylim = c(0,max(flow_out@Mins)))
#abline(ft$l1);
#abline(ft$l2);
#points(
#par(new=TRUE);
#plot(ft$MinIndex+1, flow_out@Mins[ft$MinIndex+1], col='red')
dev.off();
######

#### Below take a long time to run, but looks ok for one well
png(file = "c3_data_1.png", width = 2500,  height = 2500, res = 300, pointsize = 2)
plot(c3_data[,1:26], flow_out, colnames(c3_data)[1:26], pch = '.', cex = 0.05)
dev.off()


############ READ IN REAL DATA ############

library(data.table);
all_norm_data <- fread("../../merged_csvs/screen_525_cell_plate_1__all_wells_combined__normalized_only.csv"); # working dir: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/training_set/exploration_screen_357_cell_plate_1_well_C3_original
all_norm_data <- as.data.frame(all_norm_data)[,-1]; # Get rid of the first column and convert to a data.frame
flow_out_norm_Mah_FALSE <- flowMeans(all_norm_data[,1:30], MaxN = 10, Mahalanobis = FALSE)
flow_out_norm_Mah_TRUE <- flowMeans(all_norm_data[,1:30], MaxN = 10)

############ READ IN MORE DATA ############
library(data.table);
all_norm_and_unnorm_data <- fread("../../merged_csvs/screen_525_cell_plate_1__all_wells_combined__normalized_and_unnormalized.csv"); # working directory: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/training_set/exploration_screen_357_cell_plate_1_well_C3_original
all_norm_and_unnorm_data <- as.data.frame(all_norm_and_unnorm_data)[,-1]; # Get rid of the first column and convert to a data.frame

# Identify the normalized and unnormalized columns
norm_cols <- grep("zscore", colnames(all_norm_and_unnorm_data));
print("unnorm columns and meta columns are currently not choosen very intelligently");
unnorm_cols <- 1:(min(norm_cols)-1);
meta_cols <- (max(norm_cols)+1):ncol(all_norm_and_unnorm_data);


# Subset the data by a few different wells and by healthy vs blast and by normalized vs unnormalized
c03_all <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_c03"),]
c03_healthy <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_c03" &
	 all_norm_and_unnorm_data$cell_label == "healthy"),];
c03_blast <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_c03" &
	 all_norm_and_unnorm_data$cell_label == "blast"),];

# And one more subset for comparasion
i12_all <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_i12"),]
i12_healthy <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_i12" &
	 all_norm_and_unnorm_data$cell_label == "healthy"),];
i12_blast <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_i12" &
	 all_norm_and_unnorm_data$cell_label == "blast"),];


# And one more subset for comparasion
g20_all <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_g20"),]
g20_healthy <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_g20" &
	 all_norm_and_unnorm_data$cell_label == "healthy"),];
g20_blast <- all_norm_and_unnorm_data[which(all_norm_and_unnorm_data$well == "well_g20" &
	 all_norm_and_unnorm_data$cell_label == "blast"),];

###### Do k-means clustering
flow_out_unnorm_i12_all_Mah_FALSE <- flowMeans(i12_all[,unnorm_cols
	], MaxN = 10, Mahalanobis = FALSE);
table(paste(i12_all$cell_label,flow_out_unnorm_i12_all_Mah_FALSE@Label,sep='_'));

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




