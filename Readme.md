# Aim: This analysis is to have some stats on the mutants for John V.'s grant proposal

I've got a bunch of the csv files from Amy. Those files are Sodium Azide Mutant Lines. All of the unfiltred files sent from Amy is [here](https://drive.google.com/drive/u/1/folders/1HUXy6GOxppKtJzExaMLmEx7mjcEo7L1l).

 John wanted me to fill the blanks for the excel he sent to me, which is shared in the [Raw_data](https://github.com/lilei1/Brachy_mutant/tree/master/Raw_data): `ASAP genes Chris Maker All3yearTFset.xlsx` and `transporter genes.xlsx`

## The processes I did:

### 1. filter the plates with ≥50% missingness of the accessions with [filter_plates.pl](https://github.com/lilei1/Brachy_mutant/blob/master/scripts/filter_plates.pl):

```
./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate21_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate21_filtered_LL.csv  

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate24_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate24_filtered_LL.csv

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate23_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate23_filtered_LL.csv 

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate22_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate22_filtered_LL.csv 

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/tubes_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/tubes_filtered_LL.csv 

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate17_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate17_filtered_LL.csv  

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate7_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate7_filtered_LL.csv

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate8_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate8_filtered_LL.csv 

 ./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate6_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate6_filtered_LL.csv  
   
./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate7_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate7_filtered_LL.csv  

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate4_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate4_filtered_LL.csv  

./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate4_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate4_filtered_LL.csv
 
./filter_plates.pl /Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate3_filtered.csv 0.5 >/Users/LiLei/Projects/Brachy_mutant/filtered_calls/plate3_filtered_LL.csv 

```

Some of the files get filtered but others not and maybe because Amy has do certain degree of filtering mannually. Here are the numbers with and without filtering:

```
(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate21_filtered_LL.csv
   89404 plate21_filtered_LL.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate21_filtered.csv
   89450 plate21_filtered.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate22_filtered.csv
  105719 plate22_filtered.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate22_filtered_LL.csv
  105695 plate22_filtered_LL.csv

wc -l plate23_filtered_LL.csv
  100521 plate23_filtered_LL.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate23_filtered.csv
  100521 plate23_filtered.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate24_filtered.csv
   88254 plate24_filtered.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate24_filtered_LL.csv
   88219 plate24_filtered_LL.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate17_filtered_LL.csv
   56072 plate17_filtered_LL.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate17_filtered.csv
   56113 plate17_filtered.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate6_filtered.csv
   98534 plate6_filtered.csv
(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate6_filtered_LL.csv
   98487 plate6_filtered_LL.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate7_filtered_LL.csv
   79604 plate7_filtered_LL.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate7_filtered.csv
   79650 plate7_filtered.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate8_filtered.csv
   93658 plate8_filtered.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l plate8_filtered_LL.csv
   93620 plate8_filtered_LL.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l tubes_filtered_LL.csv 
  869629 tubes_filtered_LL.csv

(base) LiLei@LiLei-M57:~/Projects/Brachy_mutant/filtered_calls$ wc -l tubes_filtered.csv 
  869699 tubes_filtered.csv
```

### 2. combined all of the plates

Since the plates 1-5-9-16 has some issues (they lack of the sample ID in the first column), I have to manually add a fake column ("plate_pilot_1-5_9_16") there to match other plates.

```
awk 'NR==1 {print} NR>1 {printf("%s\,%s\n",  "plate_pilot_1-5_9_16", $0) }' Plates_pilot.1-5.9-16.csv > newPlates_pilot.1-5.9-16.csv
```
Move all of the filtered files into a new directory, and combined all of them.

```
cat *.csv >combined_all.csv
```
delete the header lines with vim 

```
vi combined_all.csv
:g/Database/d
:g/row/d
```

### 3. Extract the high effect mutations and nonsyn

```
grep "HIGH" combined_all.csv >high_effect_all.csv
grep "NON_SYNONYMOUS" combined_all.csv >nonsyn.csv
```

### 4. Find the corresponding counts for each gene:

```
for i in $(cut -f 1  transporter.txt) ; do printf '%s\t%s\t%s\n'  $i $(grep "$i" nonsyn.csv|wc -l) $(grep "$i" high_effect_all.csv|wc -l); done >transporter_high_nonsyn.txt
```

### 5. Dowbload the map file between the Bd-21 and Bd-21-3 for each gene via this [link](https://genome.jgi.doe.gov/portal/Phytozome/download/_JAMO/5da7a3b8aa74fab996deb6b0/BdistachyonBd21_3_460_v1.1.synonym.txt?requestTime=1584748531).

### 6. Deal with the T-DNA files with [T_DNA_finding.pl](https://github.com/lilei1/Brachy_mutant/blob/master/scripts/T_DNA_finding.pl).

```
./T_DNA_finding.pl ~/Projects/Brachy_mutant/genic_T_DNA_full_Bd21-3.txt ~/Projects/Brachy_mutant/transporter_genelist.txt >~/Projects/Brachy_mutant/transporter_genelist_T_DNA.txt
```

### 7. Find the orthologs for the Sorguhm and Brachypodium distachyon according to David Goodstein's instruction:

```
Choose the Phytozome V13 Genomes and Families -> Phytozome v13 Genomes data set
Click Filters, and select Brachypodium distachyon v3.2 (or v3.1 if you’re interested in the previous one.
-Click Attributes and select “Orthology”
-Select B sylvaticum in the organism filter.
-Click Counts
-click Results
-export via Compressed web file (notify by email)
```
The files are in the [Raw_data](https://github.com/lilei1/Brachy_mutant/tree/master/Raw_data).

