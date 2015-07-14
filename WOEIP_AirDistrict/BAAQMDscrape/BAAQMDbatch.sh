#!/bin/bash
file=$1
#datepat="^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$"
datepat="^[0-9]"
scraperPath="baaqmdScraper.py"
outfilePath="BAAQMDScrape.txt"

while IFS="," read f1 f2
do
	if [[ $f1 =~ $datepat ]]; then
		python $scraperPath $f1 outfilePath
	fi
done < $file