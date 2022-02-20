#!/bin/bash
homedir=$1
zscore_method=$5

gene2idfile="${homedir}/data/gene2ind_${2}_${3}.txt"
cell2idfile="${homedir}/data/cell2ind_${3}.txt"
mutationfile="${homedir}/data/cell2mutation_${2}_${3}.txt"
testdatafile="${homedir}/data/training_files/test_${3}_${4}.txt"

modeldir="${homedir}/models/model_${3}_${4}_${5}"
modelfile="${modeldir}/model_final.pt"

stdfile="${modeldir}/std.txt"

resultfile="${modeldir}/predict"

hiddendir="${modeldir}/hidden"
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
	-batchsize 2000 -predict $testdatafile -zscore_method $zscore_method -load $modelfile -cuda $cudaid > "${modeldir}/test.log"
