#!/bin/sh

export CUDA_VISIBLE_DEVICES=7
# export CUDA_VISIBLE_DEVICES=4
source ../triplet-reid-rl-attention/venv/bin/activate

epoch=240000
dataset_size=''
# expr_dir='ckpt_inception_v4'
expr_dir='ckpt_inception_MBA_5b_addition_1.0'
BRANCH="2"

python embed_branch_addition.py \
        --experiment_root ./experiments/pku-vd/${expr_dir} \
        --dataset data/pku-vd/VD1_${dataset_size}query.csv \
        --filename pku-vd_VD1_${dataset_size}query_${epoch}_b_embeddings.h5 \
        --checkpoint checkpoint-${epoch} \
        --branch_name ${BRANCH} \
        --batch_size 128

dataset_size='small_'

python embed_branch_addition.py \
        --experiment_root ./experiments/pku-vd/${expr_dir} \
        --dataset data/pku-vd/VD1_${dataset_size}query.csv \
        --filename pku-vd_VD1_${dataset_size}query_${epoch}_b_embeddings.h5 \
        --checkpoint checkpoint-${epoch} \
        --branch_name ${BRANCH} \
        --batch_size 128

python ./evaluate.py \
    --excluder diagonal \
    --query_dataset ./data/pku-vd/VD1_query.csv \
    --query_embeddings ./experiments/pku-vd/${expr_dir}/pku-vd_VD1_query_${epoch}_b_embeddings.h5 \
    --gallery_dataset ./data/pku-vd/VD1_${dataset_size}query.csv \
    --gallery_embeddings ./experiments/pku-vd/${expr_dir}/pku-vd_VD1_${dataset_size}query_${epoch}_b_embeddings.h5 \
    --metric euclidean \
    --filename ./experiments/pku-vd/${expr_dir}/pku-vd_VD1_${dataset_size}query_${epoch}_b_evaluation.json \
    --batch_size 64 \
    
