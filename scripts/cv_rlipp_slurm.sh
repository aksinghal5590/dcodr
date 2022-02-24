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

folds=5

for ((i=1;i<=folds;i++));
do
    bash "${1}/scripts/cv_rlipp.sh" $1 $2 $3 $4 $5 $i $cpu_count
    #bash "${1}/scripts/cv_rlipp_genie.sh" $1 $2 $3 $4 $5 $i $cpu_count
done