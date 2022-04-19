#!/bin/bash

homedir="/cellar/users/asinghal/Workspace/dcodr"

dataset="av"
zscore_method="auc"
folds=5
nested_folds=5

drugs=`awk '{ print $1 }' "${homedir}/data/training_files_av/drugname_${dataset}.txt"`

for ont in "ctg"
do
    for drug in "Palbociclib"
	do
		for ((i=1;i<=folds;i++));
		do
			for ((j=0;j<nested_folds;j++));
			do
				nf=$(( 5*j + i ))
				sbatch -J "DCoDR_${ont}_${drug}_${nf}" -o "${homedir}/logs/out_${ont}_${drug}_${nf}.log" ${homedir}/scripts/cv_batch.sh $homedir $ont $dataset $drug ${zscore_method} $i $nf
				sbatch -J "DCoDR_${ont}_${drug}_${nf}" -o "${homedir}/logs/rlipp_${ont}_${drug}_${nf}.log" ${homedir}/scripts/cv_rlipp_slurm.sh $homedir $ont $dataset $drug ${zscore_method} $i $nf
			done
		done
	done
done