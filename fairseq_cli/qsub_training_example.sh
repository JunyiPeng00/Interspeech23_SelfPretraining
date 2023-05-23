#!/bin/bash
#PBS -N TestOnly
#PBS -A OPEN-27-71
#PBS -q qnvidia
#PBS -l select=1:ncpus=128,walltime=47:30:00

WORK_DIR=/mnt/proj3/open-24-5/pengjy_new/HuBERT/fairseq/fairseq_cli/
source /mnt/proj3/open-24-5/pengjy_new/Support/miniconda/bin/activate /mnt/proj3/open-24-5/pengjy_new/Support/miniconda/envs/py39



cd $WORK_DIR

ml CUDA
ml cuDNN
ml mkl
ml GCC

python hydra_train.py \
  --config-dir /mnt/proj3/open-24-5/pengjy_new/HuBERT/fairseq/examples/hubert/config/pretrain \
  --config-name hubert_base_librispeech_vox2_Conformer_1200K_AUG_MUSAN \
  task.data=/mnt/proj3/open-24-5/pengjy_new/Data/Data2/Vox2/Conformer task.label_dir=/mnt/proj3/open-24-5/pengjy_new/Data/Data2/Vox2/Conformer task.labels='["km"]' model.label_rate=50
