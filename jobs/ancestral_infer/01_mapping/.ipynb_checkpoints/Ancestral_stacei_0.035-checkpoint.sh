#!/bin/bash
#SBATCH --image=docker:ohdzagenetics/angsd
#SBATCH --qos=genepool
#SBATCH --time=36:00:00
#SBATCH --nodes=1
#SBATCH --account=plant
#SBATCH --job-name=indel_reaglign
#SBATCH --output=indel_reaglign-%l.out
#SBATCH --error=indel_reaglign-%l.err

shifter -i ohdzagenetics/angsd /src/angsd \
-doCounts 1 \
-doFasta 3 \
-i /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/merged_bam/stacei_0.035_realigned.bam \
-out /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/stacei_0.03.fasta 
