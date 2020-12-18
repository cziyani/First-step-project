##################### WGS

##go to files directory
setwd("C:/Users/chaym/Desktop/FSP/firststep/RzooROH/WGS/")
library(RZooRoH)
library(foreach)
library(doParallel)

#List all the TMP files and store them in one list 
files_WGS <- Sys.glob("./*.gen")

##use 3 cores of the computer to do parrallel work
registerDoParallel(cores = 3) 
foreach(file=1:length(files_WGS),.packages = "RZooRoH") %dopar% {

  ##read the data using "zoodata" function
  data_Rohs<- zoodata(files_WGS[file], zformat = "gp", samplefile = "./output_Sim1669119579366_160000_1.sample")
  ##choose the model
  Mod5R <- zoomodel(K=6)
  ##find the HBD locus with zoorun function
  loc_mod5r <- zoorun(Mod5R, data_Rohs, localhbd = TRUE)
  ##the local autozygosity estimation/ estimate realized inbreeding by "@realized" (HBD per class)
  HBD_class <- loc_mod5r@realized
  ##data frame with one line per identified HBD segment
  loc_table <- loc_mod5r@hbdseg
  
  #extract just the Sim_ID from each file name
  Sim_ID <- strsplit(files_WGS[file] , split="_")[[1]][2]
  #extract just the NB_RAD_FRAG from each file name
  NB_RAD_FRAG <- strsplit(files_WGS[file], split = "_")[[1]][3]
  #extract just the number of Replicate from each file name by deleting the "."
  Replicate1 <- strsplit(files_WGS[file] , split = "[.]")[[1]][2]
  #extract just the number of Replicate from each file name by deleting the "_"
  Replicate <- strsplit (Replicate1 , split = "_" )[[1]][4]
  
  ##create 3 vecteur with Sim_ID; NB_RAD_FRAG; Replicate value wich have the same length of df rows
  vec_Sim <-rep(Sim_ID , nrow(loc_table))
  vec_Frag <-rep(NB_RAD_FRAG , nrow(loc_table))
  vec_Replicate <-rep(Replicate , nrow(loc_table))
  
  ##Bind these vectors to the dataframe
  dt <- cbind(vec_Sim , vec_Frag , vec_Replicate , loc_table)
  
  ##rename the columns
  colnames(dt) <- c("Sim_ID" , "NB_RAD_FRAG" ,"Replicate" , "ID" , "chrom" , "start_snp", "end_snp" , "start_pos" , 
                    "end_pos" , "number_snp" , "length" , "HBD")
  
  ##Save the file
  write.table(dt,paste0("./" , Sim_ID , "_", Replicate ,"_" , NB_RAD_FRAG , "_dis_RzooROH_TMP.txt"), 
              col.names = T , row.names = F , quote = F)
  
  ####### FROH

  ## create 2 vectors with the inbreeding coefficient for each individual, ID
  x <- 1-HBD_class[,6]
  ID <- c(1000,1:(loc_mod5r@nind -1))
  ##define a dataframe with The Froh and ID
  df <- data.frame(ID,x )
 
  ##bind the df to the 3 vectors
  dt_1 <- cbind(Sim_ID, df, NB_RAD_FRAG ,Replicate )
  
  ##rename the datframe
  colnames(dt_1) <- c("Sim_ID" , "ID" , "Froh" , "NB_RAD_FRAG" , "Replicate") 
 
  
  ##Save the file
  write.table(dt_1,paste0("./" , Sim_ID , "_", Replicate ,"_" , NB_RAD_FRAG , "_F_RzooROH_TMP.txt"), 
              col.names = T , row.names = F , quote = F)