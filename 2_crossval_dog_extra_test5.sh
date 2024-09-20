#!/bin/sh
#SBATCH --job-name=multithread	# create a short name for your job
#SBATCH --nodes=1	# Number of nodes for the cores
#SBATCH --ntasks=1	# total number of tasks across all nodes
#SBATCH --cpus-per-task=N	# cpu-cores per task
#SBATCH --mem-per-cpu=64G	# memory per cpu-core
#SBATCH -t 0-10:00	# Runtime in D-HH:MM format
#SBATCH -p sapphire	# Partition to submit to
#SBATCH --mem=20000	# Memory pool for all CPUs
#SBATCH -o /n/holyscratch01/davis_lab/Everyone/VarKode_expansion/datasets/dog_breeds/extra/output/2_dog_crossval.%A.out
#SBATCH -e /n/holyscratch01/davis_lab/Everyone/VarKode_expansion/datasets/dog_breeds/extra/output/2_dog_crossval.%A.err      # File to which standard err will be written

module load python
source activate varKoder
cd /n/holyscratch01/davis_lab/Everyone/VarKode_expansion/datasets/dog_breeds/extra/try5

echo ARCHITECTURE vit_large_patch32_224, equal weight

#list all samples
export samples=$(find ./images_dogs_extra -name '*.png' -exec basename {} \; | cut -d \+ -f 1 | cut -d @ -f 1 | sort | uniq )

for sample in $samples
    do
    echo START TRAINING  $sample
    varKoder train --overwrite --single-label -b 64 -r 0.05 -c vit_large_patch32_224 -z 0 -e 20 -V $sample images_dogs_extra vit_train_${sample}
    varKoder train --overwrite --pretrained-model vit_train_${sample}/trained_model.pkl -b 64 -r 0.005 -c vit_large_patch32_224 -z 10 -e 0 -V $sample images_dogs_extra vit_train_${sample}
    echo END TRAINING $sample
    mkdir -p vit_query_${sample}
    cd vit_query_${sample}
    ln -s ../images_dogs_extra/${sample}@* ./
    cd ..
    echo START QUERY $sample
    varKoder query --overwrite --include-probs -v --model vit_train_${sample}/trained_model.pkl -I vit_query_${sample} vit_results/${sample}/
    echo ELAPSED QUERY $sample
    mv vit_train_${sample}/input_data.csv vit_results/${sample}/
    rm -r vit_train_${sample}  vit_query_${sample}

done

cd ..

echo DONE

exit

