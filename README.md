# First-step-project
####Plink calling

1)coverts the vcfs format to a binary format by --make-bed function
2)rohs calling using homozig function

####Plink distributions

1)list the fils in one list
2)create a function
3)create an empty file that we will fill by the for loop function within our file list
4)loop through the list of file to fill the matrix
5)extract sim_id, Nb_rad_frag, replicate from the file name
6)read the file
7)create 3 vectors : Sim_id, Frag, Replicate
8)unite the 3 vectors with dateframe of each file
9)bind the final dataframe with the matrix
10)launch the function with both seq_teq and merge the result
11)save the dataframe with write.table function
12)read the file saved before
13)classify the ROHs depending on their length
14)Calculate the sum of ROHs for each roh class, for each Replicate, in each individual, for each Sequencing technique and Simulation
15)create a matrix with sim_id, nb_frag, replicate and fill it with a for loop for RAD_seq and WGS
16)save file
17)read file
18)Calculate mean KB per individual by CLASS & SEQ TECH
19)save the file
20)read the file
21)order the ROHs class
22)plot the distribution

#########RZooROH ROH calling

1)install RZooROH /foreach / doParallel packages
2)library RZooROH /foreach/ doParallel
3)list files in one list
4)create a matrix that we wil fill with a for loop within files
5)loop through the list of files
6)read the data by using zoodata function
7)choose the model by defining the number of classes
8)loop for HBD segments with zoorun function
9)estimate realized autozygosity with @realized function
10)use the @hbdseg function to get a dataframe with all HBD segemnts identified
11)within the file name extract the sim_id, nb_fragments, replicate number
12)create 3 vector and fill them with the command 11
13)bind the vectors using cbind(uniting by columns)
14)save the distribution file
15)create a dataframe wich contain fROH
16 save FROH file 

########unite files for FROH measurement: RAD_sub and WGS

1)list the files in one list
2)create a matrix and rename the columns
3)fill the matrix by looping through the list
4)extract sim_id, nb_frag and replicate value within files name
5)read the file
6)rename the dataframe
7)unite the dataframe with the matrix
8)save the file 

########unite files for rohs ditributions measurement RAD_sub and WGS

1)list the files in one list
2)create a matrix and reaname the columns
3)fill the matrix by looping through the list
4)extract sim_id, nb_frag and replicate value within files name
5)read the file
6)rename the dataframe
7)unite the dataframe with the matrix
8)save the file 

#######unite RAD_sub and WGS Froh files + plot

1)read files 
2)merge the files by Sim_ID and ID 
3)subset NB_RAD_FRAD and replicate for WGS because its WGS for all NB_RAD_FRAD rows and 1 for Replicate rows
4)save the file
5)read the file
6)design RAD_sub fragment level
7)loop through RAD_fragment levels and calculte the mean of ROHs length depending on SIM_ID  and ID for both seq_teq
8)plot the FROH of wgs vs rad_sub

########unite RAD_sub and WGS dist + plot

1)read RAD_sub file
2)add a ROH-class column to the dataframe
3)fill this columns by looping through the length columns to classify the ROHs segments sccording to their length
4)Calculate the sum of ROHs for each roh class, for each Replicate, in each individual, for each Sequencing technique and Simulation
5)create an empty matrix and fill is with a foorloop throug sim_id, nb_rad_fragment levels and replicate
6)save the file
7)do the same with WGS 
8)however for part 5) we will loop just through SIM_ID and nb_rad_frag
9)save the file
10)read WGS and rad_sub files by uniting them
11)Calculate mean KB per individual by CLASS & SEQ TECH
12)covert the class and seq_teq to factor
13)save the file
14)read the file
15)do the plotting after ordering the ROHs classes

####### WGS FROH of RZooROH and PLINK

1)set the directory of files
2)read the files and assign them to a variable
3)merge the files by sim_id and id
4)save the file
5)plot the plink wgs-Froh vs RZooROH wgs-Froh 


#######PLINK FROH

1)list files of RAD_sub and WGS in one list(each one in a list)
2)create a function
3)create a matrix that we will fill by a fro loop within these list
4)loop through the list of file to fill the matrix
5)extract sim_id, Nb_rad_frag, replicate from the file name
6)read the file
7)create 3 vectors : Sim_id, Frag, Replicate
8)unite the 3 vectors with dateframe of each file
9)bind the final dataframe with the matrix
10)launch the function with both seq_teq and bind the function with rbind function
11)save the dataframe with write.table function
12)read the file saved before
13)assign levels to RAD_fragments
14)in each levels of RAD_fragments, calculate the mean of kb for both seq_teq by takimg in consideration SIM_ID and ID
15)FROH plotting
