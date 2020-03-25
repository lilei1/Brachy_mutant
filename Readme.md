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

### 3. extract the high effect mutations and nonsyn

```
grep "HIGH" combined_all.csv >high_effect_all.csv
grep "NON_SYNONYMOUS" combined_all.csv >nonsyn.csv
```



