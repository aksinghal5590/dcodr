#!/bin/bash
homedir=$1
zscore_method=$5

gene2idfile="${homedir}/data/training_files_av/gene2ind_${2}_${3}.txt"
cell2idfile="${homedir}/data/training_files_av/cell2ind_${3}.txt"
ontfile="${homedir}/data/training_files_av/ontology_${2}_${3}.txt"
mutationfile="${homedir}/data/training_files_av/cell2mutation_${2}_${3}.txt"
traindatafile="${homedir}/data/training_files_av/train_${3}_${4}.txt"

modeldir="${homedir}/models_2/model_${2}_${3}_${4}_${5}"
if [ -d $modeldir ]
then
	rm -rf $modeldir
fi
mkdir -p $modeldir

stdfile="${modeldir}/std.txt"
resultfile="${modeldir}/predict"

cudaid=0

pyScript="${homedir}/src/train_drugcell.py"

source activate cuda11_env

python -u $pyScript -onto $ontfile -gene2id $gene2idfile -cell2id $cell2idfile \
	-train $traindatafile -genotype $mutationfile -std $stdfile -model $modeldir \
	-genotype_hiddens 6 -lr 0.0001 -wd 0.0001 -alpha 0.3 -cuda $cudaid -epoch 300 \
	-batchsize 64 -optimize 1 -zscore_method $zscore_method > "${modeldir}/train.log"
