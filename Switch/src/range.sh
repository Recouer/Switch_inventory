#!/bin/bash


if [[ ! -z $3 ]]
then
    > ./feedMeSwitchs.txt
fi


min=($(echo $1 | tr "." " "))
max=($(echo $2 | tr "." " "))



for ((k=${min[0]};i<=${max[0]};i++))
do
    for ((l=${min[1]};i<=${max[1]};i++))
    do
	for ((j=${min[2]};i<=${max[2]};i++))
	do
	    for ((i=${min[3]};i<=${max[3]};i++))
	    do
		echo "$k.$l.$j.$i" >> ./feedMeSwitchs.txt
	    done
	done
    done
done
