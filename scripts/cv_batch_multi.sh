#!/bin/bash

#SBATCH --partition=nrnb-gpu
#SBATCH --account=nrnb-gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=64G
#SBATCH --dependency=singleton

dataset="av"
zscore="auc"
ont="ctg"
folds=5

homedir=$1
d1=$2
d2=$3

for drug in $d1 $d2
do
	for ((i=1;i<=folds;i++));
	do
        bash "${homedir}/scripts/cv_train_multi.sh" $homedir $ont $dataset $drug $zscore $i &
    done
done

wait
