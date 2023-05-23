#!/bin/bash


WORK_DIR=/mnt/proj3/open-24-5/pengjy_new/HuBERT/fairseq/examples/hubert/simple_kmeans/
source /mnt/proj3/open-24-5/pengjy_new/Support/miniconda/bin/activate /mnt/proj3/open-24-5/pengjy_new/Support/miniconda/envs/py39

# which python

cd $WORK_DIR

lab_dir=/scratch/project/open-24-5/pengjy/Vox3 
train_file_dir=/mnt/proj3/open-24-5/pengjy_new/HuBERT/fairseq/examples/hubert/simple_kmeans/
valid_file_dir=/mnt/proj3/open-24-5/pengjy_new/HuBERT/fairseq/examples/hubert/simple_kmeans/

n_clusters=500
nshard=5

stage=1
stop_stage=5

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
echo "Stage1: Preparing MFCC Data for 1st round training ..."
for rank in $(seq 0 $((nshard - 1))); do
python dump_mfcc_feature.py $train_file_dir train $nshard $rank $lab_dir
done
fi

if [ ${stage} -le 2 ] && [ ${stop_stage} -ge 2 ]; then
echo "Stage2: Kmeans Clustering ..."
python learn_kmeans.py $lab_dir train $nshard $lab_dir/Kmeans $n_clusters --percent 0.3
fi

if [ ${stage} -le 3 ] && [ ${stop_stage} -ge 3 ]; then
echo "Stage3: Assigning labels to frames..."
for rank in $(seq 0 $((nshard - 1))); do
python dump_km_label.py $train_file_dir train $lab_dir/Kmeans $nshard $rank $lab_dir
done
fi

if [ ${stage} -le 4 ] && [ ${stop_stage} -ge 4 ]; then
echo "Stage4: valid Data preparing ..."
python dump_mfcc_feature.py $valid_file_dir valid 1 0 $lab_dir
python dump_km_label.py $valid_file_dir valid $lab_dir/Kmeans 1 0 $lab_dir
fi

if [ ${stage} -le 5 ] && [ ${stop_stage} -ge 5 ]; then
echo "Stage5: Concating all data ..."
for x in $(seq 0 $((n_clusters - 1))); do
  echo "$x 1"
done >> $lab_dir/dict.km.txt

split=train
for rank in $(seq 0 $((nshard - 1))); do
  cat $lab_dir/${split}_${rank}_${nshard}.km
done > $lab_dir/${split}.km

split=valid
nshard=1
for rank in $(seq 0 $((nshard - 1))); do
  cat $lab_dir/${split}_${rank}_${nshard}.km
done > $lab_dir/${split}.km
fi


# for rank in $(seq 0 $((nshard - 1))); do
#   cat $lab_dir/${split}_${rank}_${nshard}.km
# done > $lab_dir/${split}.km

# for x in $(seq 0 $((n_clusters - 1))); do
#   echo "$x 1"
# done >> $lab_dir/dict.km.txt
