#!/bin/bash
WOEIPfile=$1
#datepat="^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$"
scraperPath="baaqmdScraper.py"
outfilePath="BAAQMDScrape.txt"

for line in $(tail -n +2 $WOEIPfile) ; do
	echo $line | printf '%s\n' $(cut -f 1 -d ",");
done | sort | uniq >> temp.txt

while read date; do
	python $scraperPath $date $outfilePath
done < temp.txt

rm temp.txt
