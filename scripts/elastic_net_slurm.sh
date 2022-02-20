#!/bin/bash
#SBATCH --job-name=NeST_DrugCell_EN
#SBATCH --output=cpu_out.log
#SBATCH --partition=nrnb-compute
#SBATCH --nodelist=nrnb-cn-08
#SBATCH --mem=64G

bash "${1}/scripts/elastic_net.sh" $1 $2

