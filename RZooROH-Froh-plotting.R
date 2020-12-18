####plotting 

#Froh plot :
setwd("./")

##Read the file
df <- read.table("my_final_F_Rzoo_out", header = T)

##define RAD_FRAG numbers levels 
df$RAD_Frag <- factor(df$RAD_Frag , levels = c(120000 ,140000 , 160000))

##have the plot on the same row and different columns
par(mfrow=c(1,3))

## loop through RAD_FRAG levels
for (i in levels(df$RAD_Frag)){
  df_lev <- df[df$RAD_Frag == i ,]
  ##calculate the mean each levels of fragment depending on the SIM_ID and ID for each individulate for WGS and RAD_sub
  F_mean_sub <- aggregate(df_lev$KB_RAD , by = list(df_lev$Sim_Id , df_lev$ID) , mean)
  F_mean_wgs <- aggregate(df_lev$KB_wgs , by = list(df_lev$Sim_Id , df_lev$ID) , mean)

  ## plot the inbreeding coefficient of RAD_sub and WGS
  plot(F_mean_wgs$x , F_mean_sub$x  , xlab = "WGS inbreeding coefficient",
       ylab = "RAD inbreeding coeficient"  , pch = 20 , ylim=c(0,0.6), xlim = c(0,0.7) , col="darkblue")
  abline(0 , 1, col="red")
