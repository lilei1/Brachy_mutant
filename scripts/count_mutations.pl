#!/usr/bin/perl
##by Li Lei, 2021-06-03, Berkeley;
#this is to count the different types of SNPs in files
#You need have combined plates data
#usage: 
use strict;
use warnings;
use Data::Dumper;

my $file = $ARGV[0];

my $AC=0; #define a hash to store the positions for each SNP;
my $AT=0; #define a hash to store the positions for each SNP;
my $AG=0; #define a hash to store the positions for each SNP;
my $CA=0; #define a hash to store the positions for each SNP;
my $CG=0; #define a hash to store the positions for each SNP;
my $CT=0; #define a hash to store the positions for each SNP;

open(OUT,  "$file") or die "Could not open $file";
my $total = 0;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        $total++;
        my @rtemp = split(/\,/,$row);
        if (($rtemp[7] eq "A" && $rtemp[8] eq "C") or ($rtemp[7] eq "T" && $rtemp[8] eq "G")){
            $AC++;
        }
        elsif(($rtemp[7] eq "A" && $rtemp[8] eq "T") or ($rtemp[7] eq "T" && $rtemp[8] eq "A")){
            $AT++;
        }
        elsif(($rtemp[7] eq "A" && $rtemp[8] eq "G") or ($rtemp[7] eq "T" && $rtemp[8] eq "C")){
            $AG++;
        }
        elsif(($rtemp[7] eq "C" && $rtemp[8] eq "A") or ($rtemp[7] eq "G" && $rtemp[8] eq "T")){
            $CA++;
        }
        elsif(($rtemp[7] eq "C" && $rtemp[8] eq "G") or ($rtemp[7] eq "G" && $rtemp[8] eq "G")){
            $CG++;
        }
        else{
            $CT++;
        }
 }
close (OUT);
my $ACfac = $AC/$total;
my $ATfac = $AT/$total;
my $AGfac = $AG/$total;
my $CAfac = $CA/$total;
my $CGfac = $CG/$total;
my $CTfac = $CT/$total;

print "Catigories\tcounts\ttotal\tFractions\n";
print "A2C*\t$AC\t$total\t$ACfac\n";
print "A2T*\t$AT\t$total\t$ATfac\n";
print "A2G*\t$AG\t$total\t$AGfac\n";
print "C2A*\t$CA\t$total\t$CAfac\n";
print "C2G*\t$CG\t$total\t$CGfac\n";
print "C2T*\t$CT\t$total\t$CTfac\n";

#    print "$count\n";