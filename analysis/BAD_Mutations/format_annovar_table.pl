#!/usr/bin/perl
##by Li Lei, 2021-08-10, El Cerrito;
#this is to format the Annovar output table to do the prediction for nonsyn SNPs from the natural lines!!!
#You need extracted annotation from SNPeff files !
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
        my @rtemp = split(/\t/,$row);
        my $snpid = $rtemp[0];
        my ($chr,$pos) = split(/\./,$snpid);
        if (defined $rtemp[3]){
           $rtemp[3]=~s/BdiBd21\-3./BdiBd21\-3_/ig;
           $rtemp[3]=~s/\.\d+\.//ig;
            my @array = split /(\d+)/,$rtemp[-1];
            if(defined $rtemp[6] and $rtemp[6] eq "MISSENSE"){
                print "$snpid\t$chr\t$pos\tNo\t$rtemp[3]\t\-\t$rtemp[1]\t$rtemp[2]\t$array[0]\t$array[2]\t\-\t$array[1]\n";
            }
            #elsif(defined $rtemp[5] and $rtemp[5] eq "HIGH"){
            #    if (defined $array[0] and $array[2] and $array[1]){
            #        print "$snpid\t$chr\t$pos\tNo\t$rtemp[3]\t\-\t$rtemp[1]\t$rtemp[2]\t$array[0]\t$array[2]\t\-\t$array[1]\n";
            #    }
            #    else{
            #        print "$snpid\t$chr\t$pos\tNo\t$rtemp[3]\t\-\t$rtemp[1]\t$rtemp[2]\t-\t-\t\-\t-\n";
            #    }
            #}
            #else{
            #    print "$snpid\t$chr\t$pos\tYes\t$rtemp[3]\t\-\t$rtemp[1]\t$rtemp[2]\t-\t-\t\-\t-\n";
            #}
        }
 }
close (FILE);