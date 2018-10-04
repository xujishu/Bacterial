#!/bin/bash
readonly PROJECT_ID=${1}
readonly logging=${2}
readonly script=${3}
readonly ram=${4}
readonly batch=${5}
readonly DOCKER="quay.io/xujishu/ngs-toolbox:0.0.1"

grep -v "^--" ${batch} | while read line
do
  batch_name=$(echo $line|awk '{print $1}')
  samplename=$(echo $line|awk '{print $2}')
  bamfile=$(echo $line|awk '{print $3}')
  fastqdir=$(echo $line|awk '{print $4}')"unmapped/${batch_name}/${samplename}"
 if [[ ! `gsutil ls "${fastqdir}"` ]];then
  cmd="dsub \
    --project ${PROJECT_ID} \
    --zones "us-central1-*" \
    --logging ${logging} \
    --disk-size 100 \
    --min-ram ${ram} \
    --image ${DOCKER} \
    --script ${script} \
    --input BAM_FILE=${bamfile} \
    --output OUTPUT_FILES="${fastqdir}/${samplename}.*" \
    --preemptible "
echo $cmd
$cmd
fi
done
