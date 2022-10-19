
#Read the file
dta <- read.table("my_final_RAD_dis_Rzoo_out", header = T)

#Add a column, filled with 0, to be the future ROH-CLASS column
dt = cbind(dta, ROH_CLASS=vector(mode = "numeric", length = nrow(dta)))

#Loop through the rows, to assign a class to each ROH depending on its size
for(row in 1:nrow(dt$length)) {
  
  if(dt$length[row] < 2000000) {
    
    dt$ROH_CLASS[row] = 1
    
  } else if(dt$length[row] >= 2000000 & dt$length[row] < 4000000) {
    
    dt$ROH_CLASS[row] = 2
    
  } else if(dt$length[row] >= 4000000 & dt$length[row] < 6000000) {
    
    dt$ROH_CLASS[row] = 3
    
  } else if(dt$length[row] >= 6000000 & dt$length[row] < 8000000) {
    
    dt$ROH_CLASS[row] = 4
    
  } else if(dt$length[row] >= 8000000 & dt$length[row] < 16000000) {
    
    dt$ROH_CLASS[row] = 5
    
  } else if(dt$length[row] >= 16000000) {
    
    dt$ROH_CLASS[row] = 6
  }
}

#Calculate the sum of ROHs for each roh class, for each Replicate, in each individual, for each Sequencing technique and Simulation
x <- aggregate(dt$length, by = list(SimID=dt$Sim_ID, INDIV=dt$ID, CLASS=dt$ROH_CLASS, REP=dt$Replicate, SEQ_TECH=dt$NB_RAD_FRAG), FUN = sum)
head(x)
View(x)
#Create an emtpy dataframe that we wil fill
dt_final = as.data.frame(matrix(nrow = 0, ncol = 5))
names(dt_final) = c("SimID","SEQ_TECH","REP","ROH_CLASS","Mean_KB_per_Indiv")


dt$Sim_ID <- as.factor(dt$Sim_ID)
dt$ID <- as.factor(dt$ID)
dt$Replicate <- as.factor(dt$Replicate)
dt$NB_RAD_FRAG <- as.factor(dt$NB_RAD_FRAG)


#Loop through Simulations FOR SUB
for(sim in levels(dt$Sim_ID)) {
  
  #Loop through Sequencing techniques
  for(seqtech in levels(dt$NB_RAD_FRAG)[1:3]) {
    
    #Loop through replicate
    for(repl in sort(unique(dt$Replicate))) {
      
      #Create an emtpy dataframe that we wil fill within info from x BUT with mean per individual if exists or 0 if no ROHs have been called
      dt_roh = as.data.frame(matrix(data = 0, nrow = length(unique(dt$ROH_CLASS)), ncol = 5))
      names(dt_roh) = c("SimID","SEQ_TECH","REP","ROH_CLASS","Mean_KB_per_Indiv")
      
      #Fill the Sim, Se tech, Replicate & ROH class columns
      dt_roh$SimID = rep(sim, nrow(dt_roh))
      dt_roh$SEQ_TECH = rep(seqtech, nrow(dt_roh))
      dt_roh$REP = rep(repl, nrow(dt_roh))
      dt_roh$ROH_CLASS = 1:nrow(dt_roh)
      
      #Loop through ROH classes to fill the MeanKb per indiv column
      for(roh_class in 1:length(unique(dt$ROH_CLASS))) {
        
        #Here we divide the tot sum of KB for each class by the number of individual in which ROHs have been detected in this simulation (because varies among simulations & replicate)
        dt_roh$Mean_KB_per_Indiv[roh_class] = sum(x$x[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl & x$CLASS == roh_class])/as.numeric(as.character(sort(unique(x$INDIV[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl]))[length(unique(x$INDIV[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl]))-1]))
        
      }
      
      #rbind what we just calculated with dta_final
      dt_final = rbind(dt_final, dt_roh)
    }
  }
}


write.table(dt_final, "final_RAD_dis_2" , col.names = T , row.names = F , quote = F)

##########WGS

#Read the dataframe
dta <- read.table("my_final_WGS_dis_Rzoo_out", header = T)
head(dt)

#Add a column, filled with 0, to be the future ROH-CLASS column
dt = cbind(dta, ROH_CLASS=vector(mode = "numeric", length = nrow(dta)))

#Loop through the rows, to assign a class to each ROH depending on its size
for(row in 1:nrow(dt)) {
  
  if(dt$length[row] < 2000000) {
    
    dt$ROH_CLASS[row] = 1
    
  } else if(dt$length[row] >= 2000000 & dt$length[row] < 4000000) {
    
    dt$ROH_CLASS[row] = 2
    
  } else if(dt$length[row] >= 4000000 & dt$length[row] < 6000000) {
    
    dt$ROH_CLASS[row] = 3
    
  } else if(dt$length[row] >= 6000000 & dt$length[row] < 8000000) {
    
    dt$ROH_CLASS[row] = 4
    
  } else if(dt$length[row] >= 8000000 & dt$length[row] < 16000000) {
    
    dt$ROH_CLASS[row] = 5
    
  } else if(dt$length[row] >= 16000000) {
    
    dt$ROH_CLASS[row] = 6
  }
}

#Calculate the sum of ROHs for each roh class, for each Replicate, in each individual, for each Sequencing technique and Simulation
x <- aggregate(dt$length, by = list(SimID=dt$Sim_ID, INDIV=dt$ID, CLASS=dt$ROH_CLASS, REP=dt$Replicate, SEQ_TECH=dt$NB_RAD_FRAG), FUN = sum)
head(x)
View(x)
#Create an emtpy dataframe that we wil fill
dt_final = as.data.frame(matrix(nrow = 0, ncol = 5))
names(dt_final) = c("SimID","SEQ_TECH","REP","ROH_CLASS","Mean_KB_per_Indiv")

dt$Sim_ID <- as.factor(dt$Sim_ID)
dt$ID <- as.factor(dt$ID)
dt$Replicate <- as.factor(dt$Replicate)
dt$NB_RAD_FRAG <- as.factor(dt$NB_RAD_FRAG)


#Loop through Simulations FOR WGS
for(sim in levels(dt$Sim_ID)) {
  
  #Loop through Sequencing techniques
  for(seqtech in levels(dt$NB_RAD_FRAG)) {
    
    repl = 1
    #Create an emtpy dataframe that we wil fill within info from x BUT with mean per individual if exists or 0 if no ROHs have been called
    dt_roh = as.data.frame(matrix(data = 0, nrow = length(unique(dt$ROH_CLASS)), ncol = 5))
    names(dt_roh) = c("SimID","SEQ_TECH","REP","ROH_CLASS","Mean_KB_per_Indiv")
    
    #Fill the Sim, Se tech, Replicate & ROH class columns
    dt_roh$SimID = rep(sim, nrow(dt_roh))
    dt_roh$SEQ_TECH = rep(seqtech, nrow(dt_roh))
    dt_roh$REP = rep(repl, nrow(dt_roh))
    dt_roh$ROH_CLASS = 1:nrow(dt_roh)
    
    #Loop through ROH classes to fill the MeanKb per indiv column
    for(roh_class in 1:length(unique(dt$ROH_CLASS))) {
      
      #Here we divide the tot sum of KB for each class by the number of individual in which ROHs have been detected in this simulation (because varies among simulations & replicate)
      dt_roh$Mean_KB_per_Indiv[roh_class] = sum(x$x[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl & x$CLASS == roh_class])/as.numeric(as.character(sort(unique(x$INDIV[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl]))[length(unique(x$INDIV[x$SimID == sim & x$SEQ_TECH == seqtech & x$REP == repl]))-1]))
      
    }
    
    #rbind what we just calculated with dta_final
    dt_final = rbind(dt_final, dt_roh)
  }
}
write.table(dt_final, "final_WGS_dis_2" , col.names = T , row.names = F , quote = F)

####plotting

##open files with read.table:
files_1 <- read.table("final_RAD_dis_2" , header = T)
files_2 <- read.table("final_WGS_dis_2" , header = T)
##rbinf both data-frames
dt_f <- rbind(files_1 , files_2)

##create a file in my directory with contain the rbinf command results
write.table(dt_f ,"final_dis_Rzoo_out_1",col.names = T , row.names = F , quote = F)

##read the file from my directory

dt_final_1 <- read.table("final_dis_Rzoo_out_1" , header = T)


#Calculate mean KB per individual by CLASS & SEQ TECH
barplot_df = aggregate(dt_final_1$Mean_KB_per_Indiv, by = list(CLASS=dt_final_1$ROH_CLASS, SEQ_TECH=dt_final_1$SEQ_TECH), FUN = mean)
#Class & SeqTECH as factor
barplot_df$CLASS = as.factor(barplot_df$CLASS)
barplot_df$SEQ_TECH = factor(barplot_df$SEQ_TECH, levels = c("120000", "140000", "160000", "WGS"))

write.table(barplot_df, file = "./final_bar_plot_1", col.names = T, row.names = F, quote = F)

#########################

barplot_df = read.table("final_bar_plot_1", header = T)

#axis label !
classesROH = c("1Mb - 2Mb", "2Mb - 4Mb","4Mb - 6Mb","6Mb - 8Mb","8Mb - 16Mb", "> 16Mb")

barsub_Ordered = barplot_df[order(barplot_df$CLASS),]
#Plot mean KB ~ Seq tech & CLASS
barplot(barsub_Ordered$x/1000000, col = c("red", "orange", "blue", "green"),ylab = "Mean Mb (among individuals)", xlab = "ROHs Length Classes")
#Add the x axis labels
axis(1, at = c(3,8,13,18,23,28), labels = classesROH, cex = 1.2)
#Add the axes titles
title(cex.lab = 1.3, mgp = c(5,5,5))
