#!/usr/bin/perl
##by Li Lei, 2021-10-26, Alameda;
#this is toadd the dereived the alleles for each categories of genes!!!!
#You need have gene classification file download from the phytozome and the gene 
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1,$file2 )= @ARGV;

my %hash; #define a hash to store the positions for each SNP;
#my $total =0;
open(OUT,  "$file1") or die "Could not open $file1";
#my $header = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
        $hash{$rtemp[0]} = $rtemp[5];
        #print "$rtemp[2]\n";
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";
#my $header1 = <FILE>;
print "Gene_Id\tnb_synSNPs\tnonsyn_alleles\tsynSNPs\tsyn_alleles\tnb_dSNPs\td_alleles\tnb_HISNPs\tHI_alleles\n";
my $gid;
foreach my $row (<FILE>){
        chomp $row;
        my @rtmp = split(/\t+/,$row);
        my $gid = $rtmp[0];
        my @nonsyn = split(/\,/,$rtmp[2]);
        my $nonsyn_alleles = 0; 
        foreach my $ele (@nonsyn){
            if (exists $hash{$ele}){
                $nonsyn_alleles = $nonsyn_alleles + $hash{$ele};
            }
        }
        
        my @syn = split(/\,/,$rtmp[4]);
        my $syn_alleles = 0; 
        foreach my $ele (@syn){
            if (exists $hash{$ele}){
                $syn_alleles = $syn_alleles + $hash{$ele};
            }
        }
        
        my @dSNP = split(/\,/,$rtmp[6]);
        my $d_alleles = 0; 
        foreach my $ele (@dSNP){
            if (exists $hash{$ele}){
                $d_alleles = $d_alleles + $hash{$ele};
            }
        }        
        my @HISNP = split(/\,/,$rtmp[8]);
        my $HI_alleles = 0; 
        foreach my $ele (@HISNP){
            if (exists $hash{$ele}){
                $HI_alleles = $HI_alleles + $hash{$ele};
            }
        }
        #print"$rtmp[5]\n";
    print "$gid\t$rtmp[1]\t$nonsyn_alleles\t$rtmp[3]\t$syn_alleles\t$rtmp[5]\t$d_alleles\t$rtmp[7]\t$HI_alleles\n";
    $nonsyn_alleles = 0;
    $syn_alleles = 0;
    $d_alleles = 0;
    $HI_alleles = 0;
 }
close (FILE);
#    print "$count\n";
