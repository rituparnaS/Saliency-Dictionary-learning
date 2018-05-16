#!/bin/bash

#SBATCH -p serial
#SBATCH -A viva-hpc
#SBATCH -t 60:00:00
#SBATCH -o gaborfea.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
 


module load matlab

matlab -nodisplay -nosplash -r "Gaborsfea;exit"

