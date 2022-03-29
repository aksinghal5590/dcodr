#!/bin/bash

homedir="/cellar/users/asinghal/Workspace/dcodr"

dataset="av"
zscore_method="auc"
folds=5

drugs=`awk '{ print $1 }' "${homedir}/data/training_files_av/drugname_${dataset}.txt"`

for ont in "ctg"
do
    for drug in $drugs
	do
		for ((i=1;i<=folds;i++));
		do
			sbatch -J "DCoDR_${ont}_${drug}_${i}" -o "${homedir}/logs/out_${ont}_${drug}_${i}.log" ${homedir}/scripts/cv_batch.sh $homedir $ont $dataset $drug ${zscore_method} $i
			sbatch -J "DCoDR_${ont}_${drug}_${i}" -o "${homedir}/logs/rlipp_${ont}_${drug}_${i}.log" ${homedir}/scripts/cv_rlipp_slurm.sh $homedir $ont $dataset $drug ${zscore_method} $i
		done
	done
done