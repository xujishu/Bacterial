#!/bin/bash
set -o errexit
set -o nounset

OUTPUT_FILES_PATTERN="$(basename "${OUTPUT_FILES}")"
OUTPUT_FILE_WO_EXT="${OUTPUT_FILES%.*}"
OUTPUT_DIR="$(dirname "${OUTPUT_FILES}")"


reference="${REFERENCE%.*}"
samplename=${SAMPLENAME}
FQ1=${FQ1}
FQ2=${FQ2}

hisat2 -t \
      -x ${reference}\
      -1 ${FQ1} \
      -2 ${FQ2} \
      --new-summary --summary-file ${OUTPUT_FILE_WO_EXT}.log \
      --met-file ${OUTPUT_FILE_WO_EXT}.hisat2.met.txt --met 5 \
      --seed 12345 \
      -k 10 \
      --rg-id=${samplename} --rg SM:${samplename} --rg LB:${samplename} \
      --secondary \
      -p 32 -S ${OUTPUT_FILE_WO_EXT}.sam
samtools sort -@ 32 -O bam -o "${OUTPUT_FILE_WO_EXT}.bam" "${OUTPUT_FILE_WO_EXT}.sam"
samtools index "${OUTPUT_FILE_WO_EXT}.bam" "${OUTPUT_FILE_WO_EXT}.bam.bai"
samtools idxstats "${OUTPUT_FILE_WO_EXT}.bam" >${OUTPUT_FILE_WO_EXT}.stat
rm ${OUTPUT_FILE_WO_EXT}.sam


