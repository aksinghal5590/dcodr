#!/bin/bash

homedir=$1
ontology="${homedir}/data/training_files_av/ontology_${2}_${3}.txt"
gene_index="${homedir}/data/training_files_av/gene2ind_${2}_${3}.txt"
cell_index="${homedir}/data/training_files_av/cell2ind_${3}.txt"
cell_mutation="${homedir}/data/training_files_av/cell2mutation_${2}_${3}.txt"
test="${homedir}/data/training_files_av/${6}_test_sr_${3}_${4}.txt"

modeldir="${homedir}/models_2/model_${2}_${3}_${4}_${5}_${6}"

predicted="${modeldir}/predict.txt"
output="${modeldir}/rlipp.out"

hidden="${modeldir}/hidden"

cpu_count=$7

genotype_hiddens=`grep "genotype_hiddens" "${modeldir}/train.log" | tail -1`
readarray -d : -t str <<< "$genotype_hiddens"
neurons=`echo "${str[1]}" | xargs`

python -u ${homedir}/src/rlipp_helper.py -hidden $hidden -ontology $ontology \
	-gene_index $gene_index -cell_index $cell_index -cell_mutation $cell_mutation -output $output \
	-test $test -predicted $predicted -cpu_count $cpu_count -drug_count 0 -genotype_hiddens $neurons > "${modeldir}/rlipp.log"
