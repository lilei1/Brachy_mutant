#!/usr/bin/perl
##by Li Lei, 2021-06-16, El Cerrito;
#this is to count the fraction of different type of variants, SNPs, small indels in files
#You need have combined plates data
#usage: 
use strict;
use warnings;
use Data::Dumper;

my $file1 = $ARGV[0];

my %hash; #define a hash to store the positions for each SNP;
my $total =0;
open(OUT,  "$file1") or die "Could not open $file1";
#my $header = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
        if (defined $rtemp[2]){
            push @{$hash{$rtemp[2]}}, $rtemp[0];
            $total++;
        }
 }
close (OUT);

#print Dumper(\%hash);
my $count = 0;
print "variant_type\tvariants_NB\tvariants_frac\n";
foreach my $key (keys %hash){
        my @array = @{$hash{$key}};
            $count = $#array + 1;
        my  $frac = $count/$total;
    print "$key\t$count\t$frac\n";
}

#    print "$count\n";