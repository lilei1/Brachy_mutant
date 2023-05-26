#!/usr/bin/perl
##by Li Lei, 2021-06-09, El Cerrito;
#this is to count the length of the deletions from different mutant lines
#You need have deletion data
#usage: 
use strict;
use warnings;
use Data::Dumper;

my $file1 = $ARGV[0];

my %hash; #define a hash to store the positions for each SNP;
open(OUT,  "$file1") or die "Could not open $file1";
#my $header = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\,/,$row);
        $rtemp[7] =~ s/^\s+|\s+$//g;
        $rtemp[8] =~ s/^\s+|\s+$//g;
        my $ref = $rtemp[7];
        my $alt = $rtemp[8]; 
        my $len = length($ref)-length($alt);
        print "$rtemp[1]\t$ref\t$alt\t$len\n";
 }
close (OUT);
