dt_Plink <- read.table("my_out_KB.txt", header = T)

dt_Rzoo <- read.table("my_final_F_Rzoo_out", header = T)


final_result <- merge(dt_Plink ,dt_Rzoo, by=c("Sim_Id" , "IID"))

write.table(final_result, "PLINK_RZOO_FROH" , col.names = T , row.names = F , quote = F)

plot(final_result$KB_wgs.x/3000000, final_result$KB_wgs.y , pch = 20,col="darkblue" , xlab = "PLINK WGS FROH", ylab = "RZooROH WGS FROH",
     xlim=c(0 , 0.6) , ylim=c(0 , 0.7))
abline(0 , 1, col="red")



