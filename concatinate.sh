#!/bin/bash
for filename in *.fastq.gz; do
    for ((i=0; i<=3; i++)); do
        cat $filename >> buffer_$filename
    done
    mv buffer_$filename $filename
done
