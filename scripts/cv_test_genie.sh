#!/bin/bash
homedir=$1
zscore_method=$5

gene2idfile="${homedir}/data/training_files_av/gene2ind_${2}_${3}.txt"
cell2idfile="${homedir}/data/GENIE/GENIE_all_cell2ind.txt"
mutationfile="${homedir}/data/GENIE/GENIE_cell2mutation_${3}.txt"
testdatafile="${homedir}/data/GENIE/GENIE_test_av_${4}.txt"

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

python -u $pyScript -gene2id $gene2idfile -cell2id $cell2idfile \
	-genotype $mutationfile -std $stdfile -hidden $hiddendir -result $resultfile \
	-batchsize 5000 -predict $testdatafile -zscore_method $zscore_method -load $modelfile -cuda $cudaid > "${modeldir}/test.log"
