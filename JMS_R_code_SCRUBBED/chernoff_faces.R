library(aplpack)

### Maybe try this for dead vs live cells, cancer vs healthy, different wells on a plate
c3_data <- read.csv("../screen_357_cell_plate_1_well_C3_original.JMS.csv", row.names = 1); # working directory: /Users/tswenson/Documents/Joels/Health_Data_Science/COMPANY_consulting_project/datasets/training_set/exploration_screen_357_cell_plate_1_well_C3_original
png(file = "c3_data_faces2.png")
faces(c3_data[1:10,],face.type=2)
dev.off()
