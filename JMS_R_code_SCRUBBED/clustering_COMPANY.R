# working directory: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/training_set/exploration_screen_357_cell_plate_1_well_C3_original

c3_data <- read.csv("../screen_357_cell_plate_1_well_C3_original.JMS.csv", row.names = 1);
class(c3_data); # data_frame




#### Load libraries and define some functions for making the heatmap
library(gplots); # Library for heatmap.2 function
library(amap); # Library for 'Dist' function which has more distance measures than 'dist'
library(gtools); # required for heatmap.2.multibar
library(gplots); # required for heatmap.2.multibar

# Function to compute distance matrix
dist.pearson <- function(x) Dist(x, method = Dist_method);
Dist_method = "correlation"; # Distance metric for finding the relationship between rows of data, see help(Dist) for other options

# Function for organizing the dendogram using "average" clustering
hclust.average <- function(x) hclust(x, method = "average");


### Make a copy of the data
original_c3_data <- c3_data;
### reset back to the copy
c3_data <- original_c3_data;
### Subsample the data for initial testing
c3_sub<-sample(1:nrow(c3_data),3000);
c3_data<-c3_data[c3_sub,];
#### End of sub-sampling

# Opens a PNG for the heatmap
png("heatmap_example_scaledbyRow_averageLink_lhei_correlation__SUBSAMPLED-10perc.png", width = 1500,  height = 10*1500, res = 300, pointsize = 8);

# Create heatmap
heatmap.2(as.matrix(c3_data),
  lhei =c(0.35,4),		# Change the height of the area the key will be plotted and where the column dendrogram would be plotted
  keysize = 2.5,		# Make the key bigger
  distfun = dist.pearson,  # use Pearson correlation as the distance measure
  scale = "row",		# scale by row, doesnt affect clustering
  main = "Heatmap",     # heat map title
  density.info="none",  # turns off density plot inside color legend
  trace="none",         # turns off trace lines inside the heat map
  margins =c(10,10),     # increase margins outside of plot
#  col=my_colors,	    # colors to use for the heatmap
  col=bluered(300),	    # colors to use for the heatmap
#  labCol = colN,			# Make column names prettier
  hclustfun = hclust.average, # Use "average" to compute the hierarchical clustering
#  RowSideColors = cbind(side_colors), # Add colors for phyla (leftmost bar) and cluster distances < pearson_dist_cutoff (rightmost bar)
  dendrogram="row",     # only compute dendrogram and reorder for rows
  Colv="F"            # turn off column clustering
);

   
## Add a legend
#par(lend = 1)           # square line ends for the color legend
#legend("topright",      # location of the legend on the heatmap plot
#    legend = as.character(uniq_phy), # category labels
#    col = list_of_colors,  # color key for category labels
#    lty= 1,             # line style
#    lwd = 10            # line width (i.e. make it really thick....a rectangle)
#);

dev.off()               # close the PNG device










