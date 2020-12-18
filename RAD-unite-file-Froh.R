######### RAD_sub unite file for Froh measurement
files_1 <- Sys.glob("./*_F_RzooROH_TMP.txt")

#Create an emtpy matrix
x <-matrix(nrow = 0 , ncol = 5)
#Transform this matrix in dataframe
y <- as.data.frame(x)
#change the names of the columns
colnames(y) <- c("Sim_ID","ID","Froh","NB_RAD_FRAG","Replicate")

##start binding all the files with the
for (f in files_1) {
    #extract just the Sim_ID from each file name
    Sim_ID <- strsplit(file , split="_")[[1]][1]
    #extract just the NB_RAD_FRAG from each file name
    NB_RAD_FRAG <- strsplit( file, split = "_")[[1]][3]
    #extract just the number of Replicate from each file name by deleting the "."
    Replicate1 <- strsplit(file , split = "[.]")[[1]][2]
    #extract just the number of Replicate from each file name by deleting the "_"
    Replicate <- strsplit (Replicate1 , split = "_" )[[1]][2]

  ##create a df
  df <- read.table(f ,header = T )

  ##rename the columns
  colnames(df) <- c("Sim_ID","ID","Froh","NB_RAD_FRAG","Replicate")
  
  ##rbind function between matrix + TMP files
  y <- rbind(y , df)
}
# Save the file
write.table(y ,"my_final_F_RAD_Rzoo_out",col.names = T , row.names = F , quote = F )