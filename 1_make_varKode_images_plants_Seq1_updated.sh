#!/bin/sh
#SBATCH -p sapphire
#SBATCH -t 0-48:00
#SBATCH --mem 60G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH -o /n/holyscratch01/davis_lab/Lab/Seq1/1_plant_generate_varkodes.%A.out
#SBATCH -e /n/holyscratch01/davis_lab/Lab/Seq1/1_plant_generate_varkodes.%A.err      # File to which standard err will be written

module load python/3.10.12-fasrc01
source activate varKoder
. /n/holylabs/LABS/davis_lab/Lab/software/spack/share/spack/setup-env.sh
spack load fastp

cd /n/holyscratch01/davis_lab/Lab/Seq1/fastq

varKoder  image --kmer-mapping cgr -k 7 -n 20 -c 1 -m 500K -M MAX_BP -o ./images_Seq1 plant_images_Seq1.csv -v

exit

