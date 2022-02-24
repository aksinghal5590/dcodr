#!/bin/bash
#SBATCH --partition=nrnb-gpu
#SBATCH --account=nrnb-gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --ntasks-per-node=5
#SBATCH --dependency=singleton

folds=5

for ((i=1;i<=folds;i++));
do
    bash "${1}/scripts/cv_train.sh" $1 $2 $3 $4 $5 $i &
done

wait

for ((i=1;i<=folds;i++));
do
    bash "${1}/scripts/cv_test.sh" $1 $2 $3 $4 $5 $i &
    #bash "${1}/scripts/cv_test_genie.sh" $1 $2 $3 $4 $5 $i &
done

wait

