#!/bin/bash
#arguments: file to parse, old compiled data
file=$1
old_file=$2
printf $file

#extract date from file_name
date="$(grep "Test Start Date" $file | cut -f 2 -d ",")"

#save start hour to "hour"
rawtime="$(grep "Test Start Time" $file | cut -f 2 -d ",")"
hour="$(echo $rawtime | cut -f 1 -d ":")"
hour=${hour#0}
#extract meridiem
meridiem="$(echo $rawtime | cut -f 2 -d " ")"
#check if PM, if so, add 12 to hour
if [ $meridiem = "PM" ]; then hour=$((hour + 12)); fi

#get num errors
errors="$(grep "Errors" WOEIP_22062011.csv | head -n 1 | cut -f 2 -d ",")"

#count numreadings
#get first header line
header="$(grep -n "Elapsed Time" $file | cut -f 1 -d ":")"
#get num readings
numreadings=$(($(wc -l < $file) - header))

#print date, hour, and numerrors to old file
printf '%s' $date ',' $hour ',' $errors ',' >> $old_file

#print summary stats to temp.csv
awk -F "," -v val=$header 'NR>val && NR<=3600{print $2}'  $file | sort -n | awk '
  BEGIN {
     c = 0;
     sum = 0aw;
     sumsq = 0;
   }
   $1 ~ /^[0-9]*(\.[0-9]*)?$/ {
     a[c++] = $1;
     sum += $1;
     sumsq+=$1*$1
   }
   END {
     ave = sum / c;
     if( (c % 2) == 1 ) {
       median = a[ int(c/2) ];
     } else {
       median = ( a[c/2] + a[c/2-1] ) / 2;
     }
     min = a[0];
     max = a[c-1];
     range = max - min;
     stdev = sqrt(sumsq/c - (ave**2));
     OFS="\t";
     print c, ",", ave, ",", median, ",", min, ",", max, ",", range, ",", stdev, ","; 
   }
 ' >> temp.csv

 #remove tabs
 tr -d '\t' <temp.csv >temp2.csv

 #concatenate files, save to new file
 cat $old_file temp2.csv > temp3.csv

 #rename and remove files
 mv temp3.csv $old_file
 rm temp.csv
 rm temp2.csv



