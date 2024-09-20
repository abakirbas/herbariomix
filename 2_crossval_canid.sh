
salloc -p gpu_test -t 0-06:00 --mem 80000 --gres=gpu:3

module load python/3.10.12-fasrc01
source activate varKoder_cgr1

cd /n/holyscratch01/davis_lab/pflynn/canid

echo ARCHITECTURE vit_large_patch32_224, equal weight

#list all samples
export samples=$(find ./canid_4more_cgr -name '*.png' -exec basename {} \; | cut -d \+ -f 1 | cut -d @ -f 1 | sort | uniq )

for sample in $samples
    do
    echo START TRAINING  $sample
    varKoder train --overwrite --single-label -b 64 -r 0.05 -c vit_large_patch32_224 -z 0 -e 20 -V $sample canid_4more_cgr vit_train_${sample}
    varKoder train --overwrite --pretrained-model vit_train_${sample}/trained_model.pkl -b 64 -r 0.005 -c vit_large_patch32_224 -z 10 -e 0 -V $sample canid_4more_cgr vit_train_${sample}
    echo END TRAINING $sample
    mkdir -p vit_query_${sample}
    cd vit_query_${sample}
    ln -s ../canid_4more_cgr/${sample}@* ./
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

