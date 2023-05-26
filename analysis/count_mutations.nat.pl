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
my $header =<OUT>;
my $total = 0;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        $total++;
        my @rtemp = split(/\t/,$row);
        if (($rtemp[2] eq "A" && $rtemp[3] eq "C") or ($rtemp[2] eq "T" && $rtemp[3] eq "G")){
            $AC++;
        }
        elsif(($rtemp[2] eq "A" && $rtemp[3] eq "T") or ($rtemp[2] eq "T" && $rtemp[3] eq "A")){
            $AT++;
        }
        elsif(($rtemp[2] eq "A" && $rtemp[3] eq "G") or ($rtemp[2] eq "T" && $rtemp[3] eq "C")){
            $AG++;
        }
        elsif(($rtemp[2] eq "C" && $rtemp[3] eq "A") or ($rtemp[2] eq "G" && $rtemp[3] eq "T")){
            $CA++;
        }
        elsif(($rtemp[2] eq "C" && $rtemp[3] eq "G") or ($rtemp[2] eq "G" && $rtemp[3] eq "G")){
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