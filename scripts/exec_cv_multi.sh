#!/bin/bash

homedir="/cellar/users/asinghal/Workspace/dcodr"

drugfile="${homedir}/data/training_files_av/drugname_av.txt"

drugs=$(cat $drugfile)
echo "$drugs" | while read d1; read d2;
do
	sbatch -J "DCoDR_${d1}" -o "${homedir}/logs/out_${d1}.log" ${homedir}/scripts/cv_batch_multi.sh $homedir $d1 $d2
	sbatch -J "DCoDR_${d1}" -o "${homedir}/logs/rlipp_${d1}.log" ${homedir}/scripts/cv_rlipp_slurm_multi.sh $homedir $d1 $d2
done
