salloc -p gpu_test -t 0-01:00 --mem 80000 --gres=gpu:3

module load python/3.10.12-fasrc01
source activate varKoder_cgr

cd /n/holyscratch01/davis_lab/pflynn/soil


varKoder train --overwrite -b 300 -r 0.1 --single-label -e 30 -z 0  cgr_Ecosystem varkoder_trained_model_SL1_cgr_Ecosystem

val_samples=$(grep -E 'True$' varkoder_trained_model_SL1_cgr_Ecosystem/input_data.csv | cut -d , -f 1 | paste -sd, -)
echo $val_samples > validation_samples_SL1_cgr_Ecosystem.txt

varKoder train -V validation_samples_SL1_cgr_Ecosystem.txt -b 64 -r 0.01 -e 3 -z 5 --pretrained-model varkoder_trained_model_SL1_cgr_Ecosystem/trained_model.pkl cgr_Ecosystem varkoder_trained_model_ML1_cgr_Ecosystem


#query
mkdir -p varkoder_query_cgr_Ecosystem

cat validation_samples_SL1_cgr_Ecosystem.txt | tr ',' '\n' | xargs -L 500 -I {} bash -c 'for sample in "$@"; do for file in $(find  images/ -name "${sample}@*"); do ln -sf ../"$file" varkoder_query_cgr_Ecosystem/; done; done' bash {}

#now do query

varKoder query --include-probs --overwrite --threshold 0.7 -I -b 64 --model varkoder_trained_model_ML1_cgr_Ecosystem/trained_model.pkl varkoder_query_cgr_Ecosystem varkoder_query_results_cgr_Ecosystem

