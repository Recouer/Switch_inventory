#!/bin/bash

TMP=./SwitchData/tmp/temp.txt

# used to merge all files from a given server
i=0
files=($(find ./Rendu -type f))
while (( $i < ${#files[@]} ))
do
    cat ${files[$i]} > $TMP
    cat $TMP > ${files[$i]:0:15}.csv
    j=$(expr $i + 1)
    while [[ "${files[$i]:0:15}" == "${files[$j]:0:15}" ]]
    do
	cat ${files[$j]} >> ${files[$i]:0:15}.csv
	rm ${files[$j]}
	j=$(expr $j + 1)
    done
    if [[ ${files[$i]} != ${files[$i]:0:15}.csv ]]
    then
	rm ${files[$i]}
    fi
    i=$(expr $i + 1)
    files=($(find ./Rendu -type f))
done
