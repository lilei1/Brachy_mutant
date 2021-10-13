#!/bin/bash
#SBATCH --image=docker:broadinstitute/gatk3:3.8-1
#SBATCH --qos=jgi_exvivo
#SBATCH --time=36:00:00
#SBATCH --nodes=1
#SBATCH --account=plant
#SBATCH --job-name=indel_reaglign
#SBATCH --output=indel_reaglign-%l.out
#SBATCH --error=indel_reaglign-%l.err

shifter -i broadinstitute/gatk3:3.8-1 java -jar /usr/GenomeAnalysisTK.jar -T IndelRealigner \
            -R /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/Reference/Brachypodium_distachyon_var_Bd21_3.and.organelles.fa \
            --entropyThreshold 0.10 \
            --LODThresholdForCleaning 1.0 \
            --targetIntervals /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/merged_bam/stacei_0.035.intervals \
            --maxReadsInMemory 50000 \
            -I  /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/merged_bam/stacei_0.035.bam \
            -o  /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/merged_bam/stacei_0.035_realigned.bam
