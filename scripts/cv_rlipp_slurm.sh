#!/bin/bash
#SBATCH --partition=nrnb-compute
#SBATCH --account=nrnb
#SBATCH --mem=64G
#SBATCH --cpus-per-task=30
#SBATCH --ntasks=1
#SBATCH --dependency=singleton

cpu_count=30

bash "${1}/scripts/cv_rlipp.sh" $1 $2 $3 $4 $5 $6 $cpu_count
if [ $4 = "Palbociclib" ]
then
    bash "${1}/scripts/cv_rlipp_genie.sh" $1 $2 $3 $4 $5 $6 $cpu_count
fi
