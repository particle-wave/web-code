#!/bin/bash
#takes top folder of data as argument 1, old file as arg2
datadir=$1
oldfile=$2

for d in $(find $datadir -type d);
do
    for f in $(find $d -name '*.csv'); 
    do 
    sh WOEIP_hourly.sh $f $oldfile
	done
done
