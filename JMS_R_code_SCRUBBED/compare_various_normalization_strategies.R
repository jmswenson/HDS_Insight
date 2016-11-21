library(data.table);
#all_rob_norm_and_unnorm_data <- fread("/Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/screen_525_cell_plate_1__all_wells_combined__robustly_normalized_and_unnormalized.csv", header = TRUE);
all_rob_norm_and_unnorm_data <- fread("/Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/screen_525_cell_plate_1__all_wells_combined__normalized_and_unnormalized.csv", header = TRUE);

head(as.data.frame(all_rob_norm_and_unnorm_data));
all_rob_norm_and_unnorm_data <- as.data.frame(all_rob_norm_and_unnorm_data)[,-1]; # Get rid of the first column and convert to a data.frame
head(as.data.frame(all_rob_norm_and_unnorm_data));
tail(all_rob_norm_and_unnorm_data);




unique(all_rob_norm_and_unnorm_data$well);
length(which(all_rob_norm_and_unnorm_data$well == "well_c03"));
length(which(all_rob_norm_and_unnorm_data$well == "well_c03" & all_rob_norm_and_unnorm_data$cell_label == "healthy")); # matches wc -l (- the header)
length(which(all_rob_norm_and_unnorm_data$well == "well_c03" & all_rob_norm_and_unnorm_data$cell_label == "blast")); # matches wc -l (- the header)

#type_of_norm <- "robust_scale";
type_of_norm <- "zscore";
# Identify the normalized and unnormalized columns
norm_cols <- grep(type_of_norm, colnames(all_rob_norm_and_unnorm_data));
print(paste("I found the following normalized columns",colnames(all_rob_norm_and_unnorm_data)[norm_cols]));
print("unnorm columns and meta columns are currently not choosen very intelligently");
unnorm_cols <- 1:(min(norm_cols)-1);
print(paste("I found the following UNnormalized columns",colnames(all_rob_norm_and_unnorm_data)[unnorm_cols]));
meta_cols <- (max(norm_cols)+1):ncol(all_rob_norm_and_unnorm_data);
print("note that the index of the meta columns is currently hardcoded in, double-check them")
print(paste("I found the following meta data columns",colnames(all_rob_norm_and_unnorm_data)[meta_cols]));
print("maybe Width shouldn't be meta data????");



# Subset the data by a few different wells and by healthy vs blast and by normalized vs unnormalized
c03_all <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_c03"),]
c03_healthy <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_c03" &
	 all_rob_norm_and_unnorm_data$cell_label == "healthy"),];
c03_blast <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_c03" &
	 all_rob_norm_and_unnorm_data$cell_label == "blast"),];

# And one more subset for comparasion
i12_all <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_i12"),]
i12_healthy <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_i12" &
	 all_rob_norm_and_unnorm_data$cell_label == "healthy"),];
i12_blast <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_i12" &
	 all_rob_norm_and_unnorm_data$cell_label == "blast"),];


# And one more subset for comparasion
g20_all <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_g20"),]
g20_healthy <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_g20" &
	 all_rob_norm_and_unnorm_data$cell_label == "healthy"),];
g20_blast <- all_rob_norm_and_unnorm_data[which(all_rob_norm_and_unnorm_data$well == "well_g20" &
	 all_rob_norm_and_unnorm_data$cell_label == "blast"),];


cherry<-rgb(1,0,0,.5);
grn<-rgb(0,1,0,.5);
blue<-rgb(0,0,1,.5);

#### This code errors out because you can't take log of a negative number and areas (and z-scores) can be negative
for (i in (c(unnorm_cols, norm_cols))) {
	pdf(file=paste(colnames(all_rob_norm_and_unnorm_data)[i],"-c3_i12_g20_log_data-hist.pdf",sep=""));
	hist(log(g20_all[,i]), freq=FALSE, breaks=150, col=cherry, 
		main=paste("Histogram of log",colnames(all_rob_norm_and_unnorm_data)[i], 
			"  Max = ", max(g20_all[,i])),xlab=colnames(g20_all)[i],
			xlim=c(min(min(log(g20_all[,i]),na.rm=TRUE),min(log(i12_all[,i]),na.rm=TRUE), min(log(c03_all[,i]),na.rm=TRUE)), 
			max(max(log(g20_all[,i]),na.rm=TRUE),max(log(i12_all[,i]),na.rm=TRUE), max(log(c03_all[,i]),na.rm=TRUE)))
			);
	hist(log(i12_all[,i]), freq=FALSE, breaks=150, col=blue,add=TRUE)
	hist(log(c03_all[,i]), freq=FALSE, breaks=150, col=grn,add=TRUE)
	legend("topright",c("g20","c03","i12"),cex=0.8,col=c("red","green","blue"),pch=19)
#	lines(density(log(g20_all[,i])), col="red",lwd=2);
	dev.off()
}


for (i in (c(unnorm_cols, norm_cols))) {
	pdf(file=paste(colnames(all_rob_norm_and_unnorm_data)[i],"-c3_i12_g20_data-hist.pdf",sep=""));
	hist((g20_all[,i]), freq=FALSE, breaks=150, col=cherry, 
		main=paste("Histogram of ",colnames(all_rob_norm_and_unnorm_data)[i], 
			"  Max = ", max(g20_all[,i])),xlab=colnames(g20_all)[i],
			xlim=c(min(min((g20_all[,i]),na.rm=TRUE),min((i12_all[,i]),na.rm=TRUE), min((c03_all[,i]),na.rm=TRUE)), 
			max(max((g20_all[,i]),na.rm=TRUE),max((i12_all[,i]),na.rm=TRUE), max((c03_all[,i]),na.rm=TRUE)))
			);
	hist((i12_all[,i]), freq=FALSE, breaks=150, col=blue,add=TRUE)
	hist((c03_all[,i]), freq=FALSE, breaks=150, col=grn,add=TRUE)
	legend("topright",c("g20","c03","i12"),cex=0.8,col=c("red","green","blue"),pch=19)
#	lines(density((g20_all[,i])), col="red",lwd=2);
	dev.off()
}

i <- 4;
#	pdf(file=paste(colnames(all_rob_norm_and_unnorm_data)[i],"-c3_i12_g20_data-hist.pdf",sep=""));
	png(file=paste(colnames(all_rob_norm_and_unnorm_data)[i],"-c3_i12_g20_data-hist.png",sep=""));
	hist((g20_all[,i]), freq=FALSE, breaks=8500, col=cherry, 
		main=paste("Histogram of ",colnames(all_rob_norm_and_unnorm_data)[i], 
			"  Max = ", max(g20_all[,i])),xlab=colnames(g20_all)[i],
			xlim=c(min(min((g20_all[,i]),na.rm=TRUE),min((i12_all[,i]),na.rm=TRUE), min((c03_all[,i]),na.rm=TRUE)), 
			20000),
			ylim=c(0,0.00015),
			);
	hist((i12_all[,i]), freq=FALSE, breaks=8500, col=blue,add=TRUE)
	hist((c03_all[,i]), freq=FALSE, breaks=8500, col=grn,add=TRUE)
	legend("topright",c("g20","c03","i12"),cex=0.8,col=c("red","green","blue"),pch=19)
#	lines(density((g20_all[,i])), col="red",lwd=2);
#	lines(density((i12_all[,i])), col="blue",lwd=2);
#	lines(density((c03_all[,i])), col="green",lwd=2);
	dev.off()

# For robust scale
i <- 34;
#	pdf(file=paste(colnames(all_rob_norm_and_unnorm_data)[i],"-c3_i12_g20_data-hist.pdf",sep=""));
	png(file=paste(colnames(all_rob_norm_and_unnorm_data)[i],"-c3_i12_g20_data-hist.png",sep=""));
	hist((g20_all[,i]), freq=FALSE, breaks=10000, col=cherry, 
		main=paste("Histogram of ",colnames(all_rob_norm_and_unnorm_data)[i], 
			"  Max = ", max(g20_all[,i])),xlab=colnames(g20_all)[i],
			xlim=c(-1,2),
			ylim=c(0,1),
			);
	hist((i12_all[,i]), freq=FALSE, breaks=4000, col=blue,add=TRUE)
	hist((c03_all[,i]), freq=FALSE, breaks=20000, col=grn,add=TRUE)
	legend("topright",c("g20","c03","i12"),cex=0.8,col=c("red","green","blue"),pch=19)
#	lines(density((g20_all[,i])), col="red",lwd=2);
#	lines(density((i12_all[,i])), col="blue",lwd=2);
#	lines(density((c03_all[,i])), col="green",lwd=2);
	dev.off()

##### For z-score
i <- 34;
#	pdf(file=paste(colnames(all_rob_norm_and_unnorm_data)[i],"-c3_i12_g20_data-hist.pdf",sep=""));
	png(file=paste(colnames(all_rob_norm_and_unnorm_data)[i],"-c3_i12_g20_data-hist.png",sep=""));
	hist((g20_all[,i]), freq=FALSE, breaks=4000, col=cherry, 
		main=paste("Histogram of ",colnames(all_rob_norm_and_unnorm_data)[i], 
			"  Max = ", max(g20_all[,i])),xlab=colnames(g20_all)[i],
			xlim=c(-0.6,0.5),
			ylim=c(0,5),
			);
	hist((i12_all[,i]), freq=FALSE, breaks=1600, col=blue,add=TRUE)
	hist((c03_all[,i]), freq=FALSE, breaks=8000, col=grn,add=TRUE)
	legend("topright",c("g20","c03","i12"),cex=0.8,col=c("red","green","blue"),pch=19)
#	lines(density((g20_all[,i])), col="red",lwd=2);
#	lines(density((i12_all[,i])), col="blue",lwd=2);
#	lines(density((c03_all[,i])), col="green",lwd=2);
	dev.off()
