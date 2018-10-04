#!/bin/bash
readonly PROJECT_ID=${1}
readonly logging=${2}
readonly script=${3}
readonly ram=${4}
readonly batch=${5}
readonly DOCKER="quay.io/humancellatlas/secondary-analysis-hisat2:v0.2.2-2-2.1.0"
grep -v "^--" ${batch} | while read line
do
  batch_name=$(echo $line|awk '{print $1}')
  samplename=$(echo $line|awk '{print $2}')
  fastqdir=$(echo $line|awk '{print $4}')"unmapped/${batch_name}/${samplename}"
  output_dir=$(echo $line|awk '{print $4}')"hisat2/${batch_name}/${samplename}"
 if [[ ! `gsutil ls "${output_dir}"` ]];then
  cmd="dsub \
    --project ${PROJECT_ID} \
    --zones "us-central1-*" \
    --logging ${logging} \
    --disk-size 150 \
    --boot-disk-size 50 \
    --min-ram ${ram} \
    --image ${DOCKER} \
    --script ${script} \
    --env SAMPLENAME=${samplename} \
    --input FQ1=${fastqdir}/${samplename}.unmapped.R1.fastq.gz \
    --input FQ2=${fastqdir}/${samplename}.unmapped.R2.fastq.gz \
    --input REFERENCE="gs://bacteria/GbBac/GbBac.*" \
    --output OUTPUT_FILES="${output_dir}/${samplename}.*" \
    --preemptible "
echo $cmd
#$cmd
fi
done
