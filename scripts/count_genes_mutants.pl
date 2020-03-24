#!/usr/bin/perl
##by Li Lei, 2020-03-23, Berkeley;
#this is to count the gene number for mutations 
#You need have combined plates data
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
        my @tt = split(/\.(\d+)\./,$rtemp[13]);
        #print "$rtemp[13]\t$tt[0]\n";
         $hash{$tt[0]} = 999;
}
close (OUT);
#print Dumper(\%hash);
my $count = 0;
foreach my $key (keys %hash){
    $count++;
    print "$key\n";
}

    print "$count\n";