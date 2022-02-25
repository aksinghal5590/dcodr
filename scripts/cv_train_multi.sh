#!/bin/bash
homedir=$1
zscore_method=$5

gene2idfile="${homedir}/data/training_files_av/gene2ind_${2}_${3}.txt"
cell2idfile="${homedir}/data/training_files_av/cell2ind_${3}.txt"
ontfile="${homedir}/data/training_files_av/ontology_${2}_${3}.txt"
mutationfile="${homedir}/data/training_files_av/cell2mutation_${2}_${3}.txt"
cn_deletionfile="${homedir}/data/training_files_av/cell2cndeletion_${2}_${3}.txt"
cn_amplificationfile="${homedir}/data/training_files_av/cell2cnamplification_${2}_${3}.txt"
traindatafile="${homedir}/data/training_files_av/${6}_train_${3}_${4}.txt"

modeldir="${homedir}/models/model_${2}_${3}_${4}_${5}_${6}"
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

python -u $pyScript -onto $ontfile -gene2id $gene2idfile -cell2id $cell2idfile -train $traindatafile \
	-mutations $mutationfile -cn_deletions $cn_deletionfile -cn_amplifications $cn_amplificationfile \
	-std $stdfile -model $modeldir -genotype_hiddens 4 -lr 0.0001 -cuda $cudaid -epoch 300 \
	-batchsize 128 -optimize 2 -zscore_method $zscore_method > "${modeldir}/train.log"

qcscript="${homedir}/src/qc_plots.py"

source activate base

python -u $qcscript $modeldir

bash "${1}/scripts/cv_test.sh" $1 $2 $3 $4 $5 $6

if [ $4 = "Palbociclib" ]
then
	bash "${1}/scripts/cv_test_genie.sh" $1 $2 $3 $4 $5 $6
fi
