#!/bin/bash
#SBATCH --job-name=NeST_DrugCell_RLIPP
#SBATCH --output=cpu_out.log
#SBATCH --partition=nrnb-compute
#SBATCH --account=nrnb
#SBATCH --mem=64G
#SBATCH --cpus-per-task=30
#SBATCH --ntasks=1
#SBATCH --dependency=singleton

cpu_count=30

bash "${1}/scripts/rlipp_genie.sh" $1 $2 $3 $4 $5 $cpu_count
