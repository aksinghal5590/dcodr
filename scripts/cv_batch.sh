#!/bin/bash
#SBATCH --job-name=DCoDR
#SBATCH --output=out.log
#SBATCH --partition=nrnb-gpu
#SBATCH --account=nrnb-gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --dependency=singleton

bash "${1}/scripts/cv_train.sh" $1 $2 $3 $4 $5 $6
bash "${1}/scripts/cv_test.sh" $1 $2 $3 $4 $5 $6

#bash "${1}/scripts/cv_test_genie.sh" $1 $2 $3 $4 $5 $6
