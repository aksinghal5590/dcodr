#!/bin/bash

homedir=$1
ontology="${homedir}/data/training_files_av/ontology_${2}_${3}.txt"
gene2idfile="${homedir}/data/training_files_av/gene2ind_${2}_${3}.txt"
cell2idfile="${homedir}/data/training_files_av/cell2ind_${3}.txt"
mutationfile="${homedir}/data/training_files_av/cell2mutation_${2}_${3}.txt"
cn_deletionfile="${homedir}/data/training_files_av/cell2cndeletion_${2}_${3}.txt"
cn_amplificationfile="${homedir}/data/training_files_av/cell2cnamplification_${2}_${3}.txt"
test="${homedir}/data/training_files_av/${6}_test_sr_${3}_${4}.txt"

modeldir="${homedir}/models/model_${2}_${3}_${4}_${5}_${6}"

predicted="${modeldir}/predict.txt"
output="${modeldir}/rlipp.out"

hidden="${modeldir}/hidden"

cpu_count=$7

genotype_hiddens=`grep "genotype_hiddens" "${modeldir}/train.log" | tail -1`
readarray -d : -t str <<< "$genotype_hiddens"
neurons=`echo "${str[1]}" | xargs`

python -u ${homedir}/src/rlipp_helper.py -hidden $hidden -ontology $ontology \
	-gene2idfile $gene2idfile -cell2idfile $cell2idfile -output $output \
	-mutations $mutationfile -cn_deletions $cn_deletionfile -cn_amplifications $cn_amplificationfile \
	-test $test -predicted $predicted -cpu_count $cpu_count -drug_count 0 -genotype_hiddens $neurons > "${modeldir}/rlipp.log"
