#!/bin/bash

set -o errexit
set -o nounset

OUTPUT_FILES_PATTERN="$(basename "${OUTPUT_FILES}")"
OUTPUT_FILE_WO_EXT="${OUTPUT_FILES%.*}"
OUTPUT_DIR="$(dirname "${OUTPUT_FILES}")"
FQ1=${OUTPUT_FILE_WO_EXT}.unmapped.R1.fastq
FQ2=${OUTPUT_FILE_WO_EXT}.unmapped.R2.fastq
echo ${OUTPUT_FILE_WO_EXT}
echo ${OUTPUT_DIR}
echo $FQ1

samtools view -b -f 12  -F 256 ${BAM_FILE} > unmapped.bam
samtools sort -n unmapped.bam -o unmapped_sorted.bam
bedtools bamtofastq -i unmapped_sorted.bam \
           -fq ${FQ1} \
	   -fq2 ${FQ2}
gzip ${FQ1}
gzip ${FQ2}
