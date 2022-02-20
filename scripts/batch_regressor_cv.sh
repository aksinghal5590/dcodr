#!/bin/bash
#SBATCH --job-name=regressorcv
#SBATCH --mem-per-cpu=32G
#SBATCH --ntasks=1
#SBATCH --partition=nrnb-compute
#SBATCH --output=out.log

homedir=$1
method=$2
drug=$3

datadir="${homedir}/data/training_files_av"
resultdir="${homedir}/models/${method}"

pyscript="${homedir}/src/regressor_cv.py -method $method -drug $drug -datadir $datadir -resultdir $resultdir"

source activate base
python -u $pyscript
