#!/usr/bin/perl
##by Li Lei, 2020-03-20, Berkeley;
#this is to look for genes to see if they have Sorghum orthologues with 1:1 or 1:many
#You need have whole set of the BD21-3 orthologues files with the bioMart Phytozome 13 and gene list;
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1, $file2) = @ARGV;

my %hash; #define a hash to store the positions for each SNP;
open(OUT,  "$file1") or die "Could not open $file1";
my $header = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
        #my @tt = split(/\.(\d+)/,$rtemp[0]);
        #print "$rtemp[1]\n";
         $hash{$rtemp[1]} = $row;
}
close (OUT);
#print Dumper(\%hash);

open(FILE,  "$file2") or die "Could not open $file2";
#my $header = <FILE>;
#print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @temp = split(/\t/,$row);
        if (exists $hash{$temp[0]}){
            my $line = $hash{$temp[0]};
            my @tt = split(/\t/,$line);
            print "$temp[0]\t$tt[3]\t$tt[5]\n"; 
        }
        else{
            print "$temp[0]\tNo\tNA\n";
        }
}
close (FILE);
