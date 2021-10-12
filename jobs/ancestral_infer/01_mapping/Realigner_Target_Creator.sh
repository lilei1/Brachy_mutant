#!/bin/bash
#SBATCH --image=docker:broadinstitute/gatk3:3.8-1
#SBATCH --qos=genepool
#SBATCH --time=36:00:00
#SBATCH --nodes=1
#SBATCH --account=plant
#SBATCH --job-name=gatk_RTC
#SBATCH --output=gatk_RTC-%l.out
#SBATCH --error=gatk_RTC-%l.err

shifter -i broadinstitute/gatk3:3.8-1 java -jar /usr/GenomeAnalysisTK.jar \
-T RealignerTargetCreator \
-R /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/Reference/Brachypodium_distachyon_var_Bd21_3.and.organelles.fa  \
-nt 1  \
-I /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/merged_bam/stacei_0.035.bam \
-- fix_misencoded_quality_scores \
-o /global/cscratch1/sd/llei2019/Bdist_mutant/ancerstral_infer/out/merged_bam/stacei_0.035.intervals
