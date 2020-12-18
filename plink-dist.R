##the the directery s
setwd("./")
#List all the .hom.indiv files and store them in one list
Lsub <- Sys.glob("./*.hom" ) ##RAD_sub
Lwgs <- Sys.glob("./wgs/*.hom" ) ##WGS

#loop through the files by using the function "uniting_data"
uniting_data <- function(list_names){
  #Create an emtpy matrix
  x <-matrix(nrow = 0 , ncol = 8)
  #Transform this matrix in dataframe
  y <- as.data.frame(x)
  #change the names of the columns
  colnames(y) <- c("Sim_ID","NB_RAD_FRAG","Replicate" ,"IID" , "chr" ,"POS1" , "POS2" , "KB")
  ##fill the dataframe "y" by a for loop within the ".indiv" files
  for (file in list_names){
    #extract just the Sim_ID from each file name
    Sim_ID <- strsplit(file , split="_")[[1]][2]
    #extract just the NB_RAD_FRAG from each file name
    NB_RAD_FRAG <- strsplit( file, split = "_")[[1]][3]
    #extract just the number of Replicate from each file name by deleting the "."
    Replicate1 <- strsplit(file , split = "[.]")[[1]][2]
    #extract just the number of Replicate from each file name by deleting the "_"
    Replicate <- strsplit (Replicate1 , split = "_" )[[1]][4]
    
    
    #Load the files
    df <- read.table(file , header = T)[,c(2,4,7,8,9)] 
    
    #Create 3 vectors with Sim_ID; NB_RAD_FRAG; Replicate value wich have the same length of df rows
    vec_Sim <-rep(Sim_ID , nrow(df))
    vec_FRag <-rep(NB_RAD_FRAG , nrow(df))
    vec_Replicate <-rep(Replicate , nrow(df))
    
    #Bind these vectors to the dataframe
    dt <- cbind(vec_Sim , vec_FRag , vec_Replicate , df )
    
    #change the names of the columns
    colnames(dt) <- c("Sim_ID" , "NB_RAD_FRAG" , "Replicate" , "IID" , "chr" ,"POS1" , "POS2" , "KB" )
    
    #bind the dataframe dt to the dataframe that we create in the begining y
    y<- rbind(y , dt)
    
  }
  return(y)
}

##use the function for each RAD_sub

##launch the function to generate RAD_sub result
sub_result <- (uniting_data(Lsub))
##launch the function to generate WGS result
wgs_resullt <- uniting_data(Lwgs)
##bind the WGS and RAD_sub result 
final_result <- rbind(sub_result , wgs_result )
#Save your final dataframe
write.table(final_result ,"my_out_dis.txt" , col.names = T , row.names = F , quote = F )

#go to the directory when the files are
setwd("~/Downloads/")

#Read the dataframe
dta = read.table("my_out_dis.txt", header = T)

#Add a column, filled with 0, to be the future ROH-CLASS column
dta = cbind(dta, ROH_CLASS=vector(mode = "numeric", length = nrow(dta)))

#Loop through the rows, to assign a class to each ROH depending on its size
for(row in 1:nrow(dta)) {
  
  if(dta$KB[row] < 2000) {
    
    dta$ROH_CLASS[row] = 1
    
  } else if(dta$KB[row] >= 2000 & dta$KB[row] < 4000) {
    
    dta$ROH_CLASS[row] = 2
    
  } else if(dta$KB[row] >= 4000 & dta$KB[row] < 6000) {
    
    dta$ROH_CLASS[row] = 3
    
  } else if(dta$KB[row] >= 6000 & dta$KB[row] < 8000) {
    
    dta$ROH_CLASS[row] = 4
    
  } else if(dta$KB[row] >= 8000 & dta$KB[row] < 16000) {
    
    dta$ROH_CLASS[row] = 5
    
  } else if(dta$KB[row] >= 16000) {
    
    dta$ROH_CLASS[row] = 6
  }
}

##convert variables of each dataframe columns to factor
dta$Sim_ID <- as.factor(dta$Sim_ID)
dta$IID <- as.factor(dta$IID)
dta$Replicate <- as.factor(dta$Replicate)
dta$NB_RAD_FRAG <- as.factor(dta$NB_RAD_FRAG)

#Calculate the sum of ROHs for each roh class, for each Replicate, in each individual, for each Sequencing technique and Simulation
x = aggregate(dta$KB, by = list(SimID=dta$Sim_ID, INDIV=dta$IID, CLASS=dta$ROH_CLASS, REP=dta$Replicate, SEQ_TECH=dta$NB_RAD_FRAG), FUN = sum)

#Create an emtpy dataframe that we wil fill
dta_final = as.data.frame(matrix(nrow = 0, ncol = 5))
names(dta_final) = c("SimID","SEQ_TECH","REP","ROH_CLASS","Mean_KB_per_Indiv")

#Loop through Simulations for RAD_sub
for(sim in levels(dta$Sim_ID)) {
  
  #Loop through Sequencing techniques
  for(seqtech in levels(dta$NB_RAD_FRAG)[1:3]) {
    
    #Loop through replicate
    for(repl in sort(unique(dta$Replicate))) {
      
      #Create an emtpy dataframe that we wil fill within info from x BUT with mean per individual if exists or 0 if no ROHs have been called
      dta_roh = as.data.frame(matrix(data = 0, nrow = length(unique(dta$ROH_CLASS)), ncol = 5))
      names(dta_roh) = c("SimID","SEQ_TECH","REP","ROH_CLASS","Mean_KB_per_Indiv")
      
      #Fill the Sim, Se tech, Replicate & ROH class columns
      dta_roh$SimID = rep(sim, nrow(dta_roh))
      dta_roh$SEQ_TECH = rep(seqtech, nrow(dta_roh))
      dta_roh$REP = rep(repl, nrow(dta_roh))
      dta_roh$ROH_CLASS = 1:nrow(dta_roh)
      
      #Loop through ROH classes to fill the MeanKb per indiv column
      for(roh_class in 1:length(unique(dta$ROH_CLASS))) {
        
        #Here we divide the tot sum of KB for each class by the number of individual in which ROHs have been detected in this simulation (because varies among simulations & replicate)
        dta_roh$Mean_KB_per_Indiv[roh_class] <- sum(x$x[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl & x$CLASS == roh_class])/as.numeric(as.character(sort(unique(x$INDIV[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl]))[length(unique(x$INDIV[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl]))-1]))
        
      }
      
      #rbind what we just calculated with dta_final
      dta_final = rbind(dta_final, dta_roh)
    }
  }
}

#Loop through Simulations for WGS
for(sim in levels(dta$Sim_ID)) {
  
  #Loop through Sequencing techniques
  for(seqtech in levels(dta$NB_RAD_FRAG)[4]) {
    
    repl = 1
    #Create an emtpy dataframe that we wil fill within info from x BUT with mean per individual if exists or 0 if no ROHs have been called
    dta_roh = as.data.frame(matrix(data = 0, nrow = length(unique(dta$ROH_CLASS)), ncol = 5))
    names(dta_roh) = c("SimID","SEQ_TECH","REP","ROH_CLASS","Mean_KB_per_Indiv")
    
    #Fill the Sim, Se tech, Replicate & ROH class columns
    dta_roh$SimID = rep(sim, nrow(dta_roh))
    dta_roh$SEQ_TECH = rep(seqtech, nrow(dta_roh))
    dta_roh$REP = rep(repl, nrow(dta_roh))
    dta_roh$ROH_CLASS = 1:nrow(dta_roh)
    
    #Loop through ROH classes to fill the MeanKb per indiv column
    for(roh_class in 1:length(unique(dta$ROH_CLASS))) {
      
      #Here we divide the total sum of KB for each class by the number of individual in which ROHs have been detected in this simulation (because varies among simulations & replicate)
      dta_roh$Mean_KB_per_Indiv[roh_class] = sum(x$x[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl & x$CLASS == roh_class])/as.numeric(as.character(sort(unique(x$INDIV[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl]))[length(unique(x$INDIV[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl]))-1]))
      
    }
    
    #rbind what we just calculated with dta_final
    dta_final = rbind(dta_final, dta_roh)
  }
}

#Calculate mean KB per individual by CLASS & SEQ TECH
barplot_df = aggregate(dta_final$Mean_KB_per_Indiv, by = list(CLASS=dta_final$ROH_CLASS, SEQ_TECH=dta_final$SEQ_TECH), FUN = mean)

#Class & SeqTECH as factor
barplot_df$CLASS = as.factor(barplot_df$CLASS)
barplot_df$SEQ_TECH = factor(barplot_df$SEQ_TECH, levels = c("120000", "140000", "160000", "WGS"))

write.table(barplot_df, file = "./barplot_out_2", col.names = T, row.names = F, quote = F)

#########################

barplot_df = read.table("./barplot_out_2", header = T)


#add axis label
classesROH = c("1Mb - 2Mb", "2Mb - 4Mb","4Mb - 6Mb","6Mb - 8Mb","8Mb - 16Mb", "> 16Mb")

#Order the dataframe so that the bars in bar plot are in the good order
barsub_Ordered = barplot_df[order(barplot_df$CLASS),]
#Plot mean KB ~ Seq tech & CLASS
barplot(barsub_Ordered$x/1000, col = c("red", "orange", "blue", "green"),
        space = c(1,0,0,0),ylab = "Mean Mb (among individuals)", xlab = "ROHs Length Classes")
#Add the x axis labels
axis(1, at = c(3,8,13,18,23,28), labels = classesROH, cex = 1.2)
#Add the axes titles
title(cex.lab = 1.3, mgp = c(5,5,5))
