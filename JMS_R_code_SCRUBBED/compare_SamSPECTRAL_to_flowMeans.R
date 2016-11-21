library(data.table);
library(flowMeans);
library(SamSPECTRAL);

all_unnorm_data_i12 <- fread("/Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/merged_csvs/LABELLED_by_cell_type_screen_525_cell_plate_1_well_i12_10PCAd-robustly.csv", header = TRUE);
all_unnorm_data_i12 <- as.data.frame(all_unnorm_data_i12)[,-1]; # Get rid of the first column and convert to a data.frame


# Do flowMeans:
flow_out_unnorm_i12_Mah_TRUE <- flowMeans(all_unnorm_data_i12[,1:5], MaxN = 10);
table(paste(all_unnorm_data_i12$cell_label,flow_out_unnorm_i12_Mah_TRUE@Label,sep='_'));

# Do SamSPECTRAL using defaults
L <- SamSPECTRAL(data.points=as.matrix(all_unnorm_data_i12[,1:5]),dimensions=c(1,2,3,4,5), normal.sigma = 200, separation.factor = 0.39);
plot(as.matrix(all_unnorm_data_i12[,1:5]), pch='.', col= L);
L_not1<-which(L!=1);
flow_out_not1<-which(flow_out_unnorm_i12_Mah_TRUE@Label!=1);
intersect(L_not1,flow_out_not1);
length(intersect(L_not1,flow_out_not1));
length(L_not1);
table(paste(all_unnorm_data_i12$cell_label,L,sep='_'));
#### All points found by SamSPECTRAL to be in cluster 1 were also in 1 cluster by flowMeans (but not vice versa)
####  Note that this means that SamSPECTRAL returns the results in the same order you input them

#### I need to play with SamSPECTRAL more


