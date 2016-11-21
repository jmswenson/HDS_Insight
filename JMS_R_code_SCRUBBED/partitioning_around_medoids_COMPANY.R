# working directory: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/training_set/exploration_screen_357_cell_plate_1_well_C3_original

c3_data <- read.csv("../screen_357_cell_plate_1_well_C3_original.JMS.csv", row.names = 1);
class(c3_data); # data_frame


# Useful websites:  http://www.sthda.com/english/wiki/partitioning-cluster-analysis-quick-start-guide-unsupervised-machine-learning#fviz_cluster-function
## http://www.unesco.org/webworld/idams/advguide/Chapt7_1_1.htm
## http://scikit-learn.org/stable/auto_examples/cluster/plot_kmeans_silhouette_analysis.html
##  Silhouette analysis can be used to study the separation distance between the resulting clusters. The silhouette plot displays a measure of how close each point in one cluster is to points in the neighboring clusters and thus provides a way to assess parameters like number of clusters visually. This measure has a range of [-1, 1].
##		Silhoette coefficients (as these values are referred to as) near +1 indicate that the sample is far away from the neighboring clusters. A value of 0 indicates that the sample is on or very close to the decision boundary between two neighboring clusters and negative values indicate that those samples might have been assigned to the wrong cluster.
##		In this example the silhouette analysis is used to choose an optimal value for n_clusters. The silhouette plot shows that the n_clusters value of 3, 5 and 6 are a bad pick for the given data due to the presence of clusters with below average silhouette scores and also due to wide fluctuations in the size of the silhouette plots. Silhouette analysis is more ambivalent in deciding between 2 and 4.
##		Also from the thickness of the silhouette plot the cluster size can be visualized. The silhouette plot for cluster 0 when n_clusters is equal to 2, is bigger in size owing to the grouping of the 3 sub clusters into one big cluster. However when the n_clusters is equal to 4, all the plots are more or less of similar thickness and hence are of similar sizes as can be also verified from the labelled scatter plot on the right.


library(cluster);
library(amap); # Library for 'Dist' function which has more distance measures than 'dist'

# Function to compute distance matrix
dist.pearson <- function(x) Dist(x, method = Dist_method);
Dist_method = "correlation"; # Distance metric for finding the relationship between rows of data, see help(Dist) for other options


### Make a copy of the data
original_c3_data <- c3_data;
### reset back to the copy
c3_data <- original_c3_data;
### Subsample the data for initial testing
c3_sub<-sample(1:nrow(c3_data),1000);
c3_data<-c3_data[c3_sub,];
#### End of sub-sampling


exp_dist<-Dist(as.matrix(c3_data), method = Dist_method, nbproc = 6);  # Compute the distance matrix between rows of c3_data using 6 cores


pam_obj <- pam(exp_dist, 5, diss = TRUE);
summary(pam_obj);
#plot(pam_obj);
pdf(file = "partitioning_around_medoids__well_c3__subsampled.csv.pdf");
clusplot(pam_obj);
dev.off();


#### Transpose the data
exp_dist<-Dist(as.matrix(t(c3_data)), method = Dist_method, nbproc = 6);  # Compute the distance matrix between rows of c3_data using 6 cores

for (k in 2:(ncol(c3_data)-1)) {
	pam_obj <- pam(exp_dist, k, diss = TRUE);
	pdf(file = paste("partitioning_around_",k,"_medoids__silhouetteplot__well_c3__subsampled.csv.pdf",sep=''));
	plot(silhouette(pam_obj), col = rainbow(k));
	dev.off();
	#summary(pam_obj);
	write.table(pam_obj$silinfo$widths, file = paste("partitioning_around_",k,"_medoids__silinfo__well_c3__tab__subsampled.txt",sep=''),sep="\t"); 
	#plot(pam_obj);
	pdf(file = paste("_partitioning_around_",k,"_medoids__well_c3__subsampled.csv.pdf",sep=''));
	clusplot(pam_obj);
	dev.off();
	print(k);
}

### Instead of looking through all the above pdfs you can use the following to calculate the number of clusters that you should use
library(fpc);
pamk.best <- pamk(exp_dist, diss = TRUE);
cat("number of clusters estimated by optimum average silhouette width:", pamk.best$nc, "\n");
plot(pam(exp_dist, pamk.best$nc));



### http://www.sthda.com/english/wiki/partitioning-cluster-analysis-quick-start-guide-unsupervised-machine-learning#fviz_cluster-function
#It can be seen that some samples have a negative silhouette. This means that they are not in the right cluster. We can find the name of these samples and determine the clusters they are closer, as follow:

### Compute silhouette
#sil <- silhouette(pam.res)[, 1:3]
### Objects with negative silhouette
#neg_sil_index <- which(sil[, 'sil_width'] < 0)
#sil[neg_sil_index, , drop = FALSE]

