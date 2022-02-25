#!/bin/bash
#SBATCH --job-name=DCoDR_RLIPP
#SBATCH --output=cpu_out.log
#SBATCH --partition=nrnb-compute
#SBATCH --account=nrnb
#SBATCH --mem=64G
#SBATCH --cpus-per-task=30
#SBATCH --ntasks=1
#SBATCH --dependency=singleton

cpu_count=30
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
        bash "${homedir}/scripts/cv_rlipp.sh" $homedir $ont $dataset $drug $zscore $i $cpu_count
        if [ $drug = "Palbociclib" ]
        then
            bash "${1}/scripts/cv_rlipp_genie.sh" $homedir $ont $dataset $drug $zscore $i $cpu_count
        fi
    done
done
