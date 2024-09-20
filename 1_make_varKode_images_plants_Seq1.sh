#!/bin/sh
#SBATCH --job-name=multithread	# create a short name for your job
#SBATCH --nodes=1	# Number of nodes for the cores
#SBATCH --ntasks=1	# total number of tasks across all nodes
#SBATCH --cpus-per-task=N	# cpu-cores per task
#SBATCH --mem-per-cpu=64G	# memory per cpu-core
#SBATCH -t 0-10:00	# Runtime in D-HH:MM format
#SBATCH -p sapphire	# Partition to submit to
#SBATCH --mem=20000	# Memory pool for all CPUs
#SBATCH -o /n/holyscratch01/davis_lab/Lab/Seq1/1_plant_generate_varkodes.%A.out
#SBATCH -e /n/holyscratch01/davis_lab/Lab/Seq1/1_plant_generate_varkodes.%A.err      # File to which standard err will be written

module load python
source activate varKoder
. /n/holylabs/LABS/davis_lab/Lab/software/spack/share/spack/setup-env.sh
spack load fastp
cd /n/holyscratch01/davis_lab/Lab/Seq1/fastq

varKoder image -k 7 -n 20 -c 1 -m 500K -M MAX_BP -o ./images_Seq1 plant_images_Seq1.csv -v


exit

