#!/usr/bin/perl
##by Li Lei, 2021-09-28, Alameda;
#this is to count the variants, SNPs, small indels in files
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
        my @rtemp = split(/\t/,$row);
        push @{$hash{$rtemp[0]}}, $rtemp[1];
 }
close (OUT);
#print Dumper(\%hash);
my $count = 0;
print "GeneID\tdvariants_NB\n";
foreach my $key (keys %hash){
        my @array = @{$hash{$key}};
            $count = $#array + 1;
    print "$key\t$count\t";
    foreach my $ele (@array) {
        print "$ele,";
    }
    print "\n";
}
