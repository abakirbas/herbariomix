
#install varKoder
git clone https://github.com/brunoasm/varKoder
cd varKoder #change name in linux.yml or mac.yml
conda env create --file conda_environments/linux.yml
conda activate varKoder
git checkout cgr -f
pip install .
pip install accelerate
pip install --upgrade fastai accelerate


#use varKoder 

module load python/3.10.12-fasrc01
conda activate varKoder_cgr1
