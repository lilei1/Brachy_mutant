#!/usr/bin/perl
##by Li Lei, 2021-06-23, El Cerrito;
#this is to format the Annovar output table to do the prediction for the rest of the SNPs
#You need have combined plates data and dSNPs file with masked or unmasked approaches!!!
#usage: 
use strict;
use warnings;
use Data::Dumper;

my $file= $ARGV[0];

my %hash; #define a hash to store the positions for each SNP;
my $total =0;

open(FILE,  "$file") or die "Could not open $file";
#my $header = <FILE>;
#print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @rtemp = split(/\,/,$row);
        my $snpid = $rtemp[2].".".$rtemp[3];
           $rtemp[13]=~s/BdiBd21\-3./BdiBd21\-3_/ig;
           $rtemp[13]=~s/\.\dq\.//ig;
        #if ($rtemp[-1] ne "-"){
            my @array = split /(\d+)/,$rtemp[-2];
            #print "$array[0]\n";
            #print "$rtemp[-2]\n";
        #}
        print "$snpid\t$rtemp[2]\t$rtemp[3]\tNo\t$rtemp[13]\t\-\t$rtemp[7]\t$rtemp[8]\t$array[0]\t$array[2]\t\-\t$array[1]\n";                
 }
close (FILE);