#!/bin/bash
#
#SBATCH --job-name=multithread	# create a short name for your job
#SBATCH --nodes=1	# Number of nodes for the cores
#SBATCH --ntasks=1	# total number of tasks across all nodes
#SBATCH --cpus-per-task=N	# cpu-cores per task
#SBATCH --mem-per-cpu=64G	# memory per cpu-core
#SBATCH -t 0-10:00	# Runtime in D-HH:MM format
#SBATCH -p sapphire	# Partition to submit to
#SBATCH --mem=20000	# Memory pool for all CPUs
#SBATCH -o /n/holyscratch01/davis_lab/pflynn/bbduk/getorg_test1.out      # File to which standard out will be written
#SBATCH -e /n/holyscratch01/davis_lab/pflynn/bbduk/getorg_test1.err     # File to which standard err will be written

#Activate conda environment, assuming the name of the conda environment is 'getorg'

. /n/holylabs/LABS/davis_lab/Lab/software/spack/share/spack/setup-env.sh

module load python
spack load getorganelle
spack load py-pandas
spack load py-biopython

export DATA_DIR=/n/holyscratch01/davis_lab/pflynn/bbduk/clean

#To assemble plant plastome
get_organelle_from_reads.py -1 $DATA_DIR/$1 -2 $DATA_DIR/$2 -o /n/holyscratch01/davis_lab/pflynn/bbduk/chl/$3 -R 15 -k 21,45,65,85,95,105 -F embplant_pt

#To assemble plant nuclear ribosomal RNA
get_organelle_from_reads.py -1 $DATA_DIR/$1 -2 $DATA_DIR/$2 -o /n/holyscratch01/davis_lab/pflynn/bbduk/ITS/$3 -R 10 -k 35,85,105,115 -F embplant_nr

#To assemble plant mitochondria:
get_organelle_from_reads.py -1 $DATA_DIR/$1 -2 $DATA_DIR/$2 -o /n/holyscratch01/davis_lab/pflynn/bbduk/mito/$3 -R 50 -k 21,45,65,85,105 -P 1000000 -F embplant_mt


