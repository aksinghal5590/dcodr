#!/bin/bash
homedir=$1
zscore_method=$5

gene2idfile="${homedir}/data/training_files_av/gene2ind_${2}_${3}.txt"
cell2idfile="${homedir}/data/GENIE/cell2ind.txt"
mutationfile="${homedir}/data/GENIE/cell2mutation.txt"
cn_deletionfile="${homedir}/data/GENIE/cell2cndeletion.txt"
cn_amplificationfile="${homedir}/data/GENIE/cell2cnamplification.txt"
testdatafile="${homedir}/data/GENIE/test_${4}.txt"

modeldir="${homedir}/models/model_${2}_${3}_${4}_${5}_${6}"
modelfile="${modeldir}/model_final.pt"

stdfile="${modeldir}/std.txt"

resultfile="${modeldir}/predict_genie"

hiddendir="${modeldir}/hidden_genie"
if [ -d $hiddendir ]
then
	rm -rf $hiddendir
fi
mkdir -p $hiddendir

cudaid=0

pyScript="${homedir}/src/predict_drugcell.py"

source activate cuda11_env

python -u $pyScript -gene2id $gene2idfile -cell2id $cell2idfile -std $stdfile -hidden $hiddendir -result $resultfile \
	-mutations $mutationfile -cn_deletions $cn_deletionfile -cn_amplifications $cn_amplificationfile \
	-batchsize 2000 -predict $testdatafile -zscore_method $zscore_method -load $modelfile -cuda $cudaid > "${modeldir}/test.log"
