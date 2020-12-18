################### R

## Measure the inbreeding coefficient 

##the the directery which contains the files

setwd("./..")

#List all the .hom.indiv files and store them in one list
Lsub <- list.files(pattern = ".hom.indiv" , full.names = T)
Lwgs <- list.files(path="./wgs/",pattern=".hom.indiv" , full.names = T)

#loop through the files by creating a function "uniting_data"
uniting_data <- function(list_names){
  #Create an emtpy matrix
  x <-matrix(nrow = 0 , ncol = 5)
  #Transform this matrix in dataframe
  y <- as.data.frame(x)
  #change the names of the columns
  colnames(y) <- c("Sim_ID","NB_RAD_FRAG","Replicate" ,"IID","KB")
  ##fill the dataframe "y"
  for (file in list_names){
    #extract just the Sim_ID from each file name
    Sim_ID <- strsplit(file , split="_")[[1]][2]
    #extract just the NB_RAD_FRAG from each file name
    NB_RAD_FRAG <- strsplit( file, split = "_")[[1]][3]
    #extract just the number of Replicate from each file name by deleting the "."
    Replicate1 <- strsplit(file , split = "[.]")[[1]][2]
    #extract just the number of Replicate from each file name by deleting the "_"
    Replicate <- strsplit (Replicate1 , split = "_" )[[1]][4]
    
    
    #Load the file
    df <- read.table(file , header = T)[,c(2,5)] 
    
    #Create 3 vectors with Sim_ID; NB_RAD_FRAG; Replicate value wich have the same length of df rows
    vec_Sim <-rep(Sim_ID , nrow(df))
    vec_FRag <-rep(NB_RAD_FRAG , nrow(df))
    vec_Replicate <-rep(Replicate , nrow(df))
    
    #Bind these vectors to the dataframe
    dt <- cbind(vec_Sim , vec_FRag , vec_Replicate , df )
    
    #Rename the columns
    colnames(dt) <- c("Sim_ID" , "NB_RAD_FRAG" , "Replicate" , "IID" , "KB")
    
    #bind the dataframe dt to the dataframe that we create in the begining y
    
    y<- rbind(y , dt)
    
  }
  return(y)
}

##launch the function to generate RAD_sub result
sub_result <- (uniting_data(Lsub))
##launch the function to generate WGS result
wgs_resullt <- uniting_data(Lwgs)
##unite both result by the Sim_ID and ID informations using "merge" function
final_result <- merge(sub_result , wgs_resullt , by = c("Sim_ID" , "IID" ))
##subset from the final dataframe the NB_RAD_FRAG for WGS because it will be the same for all the value "WGS" and the replicate 
##because it is 1 for all the values
df = subset(final_result, select = -c(NB_RAD_FRAG.y,Replicate.y))
##renames df columns
colnames(df) <- c("Sim_Id" , "IID","RAD_Frag" , "Replicate" , "KB_rad" , "KB_wgs")
##Save the file
write.table(df ,"my_out_KB.txt" , col.names = T , row.names = F , quote = F )


#Froh plot :

#Load the file from the directory
df <- read.table("my_out_KB.txt", header = T)

#assign levels to RADsub fragment
df$RAD_Frag <- factor(df$RAD_Frag , levels = c(120000 ,140000 , 160000))

#show the 3 plot in one row, 3 Columns 
par(mfrow=c(1,3))

## loop through RAD_FRAG levels
for (i in levels(df$RAD_Frag)){
  df_lev <- df[df$RAD_Frag == i ,]
  ##calculate the mean each levels of fragment depending on the SIM_ID and ID for each individulate for WGS and RAD_sub
  F_mean_sub <- aggregate(df_lev$KB_rad , by = list(df_lev$Sim_Id , df_lev$IID) , mean)
  F_mean_wgs <- aggregate(df_lev$KB_wgs , by = list(df_lev$Sim_Id , df_lev$IID) , mean)
  ## plot the inbreeding coefficient by devinding x and y by 3000000
  plot(F_mean_wgs$x/3000000 , F_mean_sub$x/3000000 , xlim = c(0 , 0.6) , ylim = c(0,0.6) , xlab = "WGS inbreeding coefficient Froh",
       ylab = "RADseq inbreeding coefficient" ,col.main="red", pch = 20 , col="darkblue", 
      col.sub="black")
  
  abline(0 , 1 , col= "red")
