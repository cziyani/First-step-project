################### terminal

##script of calling in the terminal :
#!/bin/bash

##list all the files in one list
VCFs=/mnt/c/Users/chaym/Desktop/masters1/firststep/*.vcf

##loop through the files
for vcf in ${VCFs}
do
	
	#remove the extension using basename function and "_" using cut function
	nb_frag=$(basename -s ".vcf" ${vcf}| cut -d'_' -f2)
	Sim_ID=$(basename -s ".vcf" ${vcf} | cut -d'_' -f1)
	replicate=$(basename -s ".vcf" ${vcf} | cut -d'_' -f3)

	#covert vcf file to Ped file with --make-bed function
	plink.exe --vcf C:/Users/chaym/Desktop/masters1/firststep/${Sim_ID}_${nb_frag}_${replicate}.vcf --make-bed --chr-set 30 --out C:/Users/chaym/Desktop/masters1/firststep/bedfiles/output_${Sim_ID}_${nb_frag}_${replicate}

	#call ROHs within files using --homozyg function
	plink.exe --bfile C:/Users/chaym/Desktop/masters1/firststep/bedfiles/output_${Sim_ID}_${nb_frag}_${replicate} --homozyg --chr-set 30 --homozyg-kb 1000 --out C:/Users/chaym/Desktop/masters1/firststep/plinkoutput/output_${Sim_ID}_${nb_frag}_${replicate}
done 
