#!/bin/bash

homedir="/cellar/users/asinghal/Workspace/nest_drugcell"
dataFile="${homedir}/result/drugcell_k10.predict"
outFile="drugcell.predict"

lc=`cat $dataFile | wc -l`

for i in {1..5}
do
	min=$(( ($lc * ($i - 1)) / 5 + 1 ))
	max=$(( ($lc * $i) / 5 ))

	sed -n "${min},${max}p" $dataFile > "${homedir}/result/${i}_${outFile}"
done
