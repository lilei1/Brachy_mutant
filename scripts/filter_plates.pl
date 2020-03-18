#!/usr/bin/perl
##by Li Lei, 2020-03-18, Berkeley;
#this is to do filtering for the mutants data with the missingness of 50%
#You need have plates data
#usage: ./SNP_density.pl vcf windows 
use strict;
use warnings;

my ($file1, $threshold) = @ARGV;

my %hash; #define a hash to store the positions for each SNP;
open(OUT,  "$file1") or die "Could not open $file1";
my $header = <OUT>;
print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my ($first, @rtemp)= split(/\"\,\"/,$row);
        my @tt = split(/\,\"/,$first);
        push @rtemp, $tt[1];
        my $count = 0;
        my $ele;
        foreach $ele (@rtemp){
            if ($ele =~ /^\.\/\./){
                $count++;
            }
        }
        my $missing = $count / ($#rtemp+1);
        print "$count\t$#rtemp\n";
        if ($missing <= $threshold){
            #print "$row\n";
        }
        #print "$tt[0]\n";
}
close (OUT);
