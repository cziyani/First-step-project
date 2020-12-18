
#set the directory
setwd("")

##List all the F_RAD files and store them in one list
files <- read.table("my_final_F_RAD_Rzoo_out" , header = T)

##List all the F_WGS files and store them in one list
files_1 <- read.table("my_final_F_WGS_Rzoo_out", header = T)

##Unite both files by the SIM_ID and ID
final_result <- merge(files , files_1 , by = c("Sim_ID" , "ID" ))

##Subset from the final dataframe the NB_RAD_FRAG for WGS because it will be the same for all the value "WGS" and the replicate 
##because it is 1 for all the values
df = subset(final_result, select = -c(NB_RAD_FRAG.y,Replicate.y))

##Rename the dataframe columns
colnames(df) <- c("Sim_Id" , "IID","KB_RAD","RAD_Frag" , "Replicate" , "KB_wgs")

##Save the file
write.table(df ,"my_final_F_Rzoo_out" , col.names = T , row.names = F , quote = F )
