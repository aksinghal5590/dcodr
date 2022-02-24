#!/bin/bash

homedir="/cellar/users/asinghal/Workspace/dcodr"

dataset="av"
zscore_method="auc"

drugs=`awk '{ print $1 }' "${homedir}/data/training_files_av/drugname_${dataset}.txt"`

for ont in ctg
do
    for drug in $drugs
	do
		sbatch -J "DCoDR_${drug}" -o "${homedir}/logs/out_${ont}_${drug}.log" ${homedir}/scripts/cv_batch.sh $homedir $ont $dataset $drug ${zscore_method}
		sbatch -J "DCoDR_${drug}" -o "${homedir}/logs/rlipp_${drug}.log" ${homedir}/scripts/cv_rlipp_slurm.sh $homedir $ont $dataset $drug ${zscore_method}
	done
done
