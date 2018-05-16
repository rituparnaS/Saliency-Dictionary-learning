#!/bin/bash

#SBATCH -p serial
#SBATCH -A viva-hpc
#SBATCH -t 60:00:00
#SBATCH -o SuppixSim.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
 


module load matlab

matlab -nodisplay -nosplash -r "parpool('local',10);compute_similarityBisque;exit"