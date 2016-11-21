# working directory: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/training_set/exploration_screen_357_cell_plate_1_well_C3_original

c3_data <- read.csv("../screen_357_cell_plate_1_well_C3_original.JMS.csv", row.names = 1);
class(c3_data); # data_frame
c3_data_mat <- cor(as.matrix(c3_data));

###### Look at basic statistics
summary(c3_data);

###### Look at relationships between matrices
print("Note that debris and dead cells may make corrplot hard to interpret");

library("corrplot");

pdf("corrplot-lower_screen_357_cell_plate_1_well_C3_original.JMS.csv.pdf");
corrplot(c3_data_mat, method ="ellipse", type="lower");
dev.off();

## reorder the matrices to better see hidden patterns

pdf("corrplot-ellipse-lower_hclust-average_screen_357_cell_plate_1_well_C3_original.JMS.csv.pdf");
corrplot(c3_data_mat, method ="ellipse", type="lower", order = "hclust", hclust.method = "average", number.cex = 0.5);
dev.off();

#### Make histograms of all columns


################################ BELOW CODE NEEDS TO BE FIXED ######################
c3_data <- read.csv("../screen_357_cell_plate_1_well_C3_original.JMS.csv", row.names = 1);


cherry<-rgb(1,0,0,.5);
#grn<-rgb(0,1,0,.5);
#blue<-rgb(0,0,1,.5);

for (i in 1:ncol(c3_data)) {
#for (i in 1:3){
	pdf(file=paste(colnames(c3_data)[i],"-c3_data-hist.pdf",sep=""));
	hist(c3_data[,i], freq=FALSE, breaks=150, col=cherry, 
		main=paste("Histogram of log",colnames(c3_data)[i], "  Max = ", max(c3_data[,i])),xlab=colnames(c3_data)[i]);
	lines(density(c3_data[,i]), col="red",lwd=2);
	dev.off()
}


#### log normalizations of the histograms
for (i in 1:ncol(c3_data)) {
#for (i in 1:3){
	pdf(file=paste("log-transformed__", colnames(c3_data)[i],"-c3_data-hist.pdf",sep=""));
	hist(log(c3_data[,i]), freq=FALSE, breaks=150, col=cherry,   
		main=paste("Histogram of log",colnames(c3_data)[i], "  Max = ", max(c3_data[,i])),xlab=colnames(c3_data)[i]);
	lines(density(c3_data[,i]), col="red",lwd=2);
	dev.off()
}




