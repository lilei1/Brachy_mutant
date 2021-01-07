# Aim: This analysis is to predict 

I've got a bunch of the csv files from Amy. Those files are Sodium Azide Mutant Lines. All of the unfiltred files sent from Amy is [here](https://drive.google.com/drive/u/1/folders/1HUXy6GOxppKtJzExaMLmEx7mjcEo7L1l).

 John wanted me to fill the blanks for the excel he sent to me, which is shared in the [Raw_data](https://github.com/lilei1/Brachy_mutant/tree/master/Raw_data): `ASAP genes Chris Maker All3yearTFset.xlsx` and `transporter genes.xlsx`

## The processes I did:

### 1. filter the plates with ≥50% missingness of the accessions with [filter_plates.pl](https://github.com/lilei1/Brachy_mutant/blob/master/scripts/filter_plates.pl):

```