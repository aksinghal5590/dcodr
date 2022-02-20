#!/bin/bash

homedir=$1
ontology="${homedir}/data/training_files_av/ontology_${2}_${3}.txt"
gene_index="${homedir}/data/training_files_av/gene2ind_${2}_${3}.txt"
cell_index="${homedir}/data/GENIE/GENIE_all_cell2ind.txt"
cell_mutation="${homedir}/data/GENIE/GENIE_cell2mutation_${3}.txt"
test="${homedir}/data/GENIE/GENIE_test_av_${4}.txt"

modeldir="${homedir}/models_2/model_${2}_${3}_${4}_${5}_${6}"

predicted="${modeldir}/predict_genie.txt"
output="${modeldir}/rlipp_genie.out"

hidden="${modeldir}/hidden_genie"

cpu_count=$7

genotype_hiddens=`grep "genotype_hiddens" "${modeldir}/train.log" | tail -1`
readarray -d : -t str <<< "$genotype_hiddens"
neurons=`echo "${str[1]}" | xargs`

python -u ${homedir}/src/rlipp_helper.py -hidden $hidden -ontology $ontology \
	-gene_index $gene_index -cell_index $cell_index -cell_mutation $cell_mutation -output $output \
	-test $test -predicted $predicted -cpu_count $cpu_count -drug_count 0 -genotype_hiddens $neurons > "${modeldir}/rlipp.log"
