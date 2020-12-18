
##set the directory
setwed("./")

##read the file and assign it to a variable
dt_Plink <- read.table("my_out_KB.txt", header = T)

##read the file and assign it to a variable
dt_Rzoo <- read.table("my_final_F_Rzoo_out", header = T)

##2)merge the files by Sim_ID and ID 
final_result <- merge(dt_Plink ,dt_Rzoo, by=c("Sim_Id" , "IID"))

##Save the file
write.table(final_result, "PLINK_RZOO_FROH" , col.names = T , row.names = F , quote = F)

##plot the WGS-Froh VS RZooROH-Froh
plot(final_result$KB_wgs.x/3000000, final_result$KB_wgs.y , pch = 20,col="darkblue" , xlab = "PLINK WGS FROH", ylab = "RZooROH WGS FROH",
     xlim=c(0 , 0.6) , ylim=c(0 , 0.7))
abline(0 , 1, col="red")