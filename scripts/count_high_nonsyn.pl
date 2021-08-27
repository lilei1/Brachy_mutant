#!/usr/bin/perl
##by Li Lei, 2020-03-20, Berkeley;
#this is to count the different type of mutations for each genes
#You need have plates data and gene list
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1, $file2) = @ARGV;

my %hash; #define a hash to store the positions for each SNP;
open(OUT,  "$file1") or die "Could not open $file1";
#my $header = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\,/,$row);
        my @tt = split(/\.(\d+)\./,$rtemp[13]);
        #print "$rtemp[13]\t$tt[0]\n";
         $hash{$tt[0]} = $rtemp[1];
}
close (OUT);
#print Dumper(\%hash);

open(FILE,  "$file2") or die "Could not open $file2";
my $header = <FILE>;
#print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @temp = split(/\t/,$row);
        my $count = 0;
        print "$temp[0]\t";
        foreach my $key (keys(%hash)) {
            if ($key eq $temp[0]){
                print "$key\t";
            #    $count++;
            }
        }
        print "\n";
        #print "$row\t$count\n";
        $count = 0;
}
close (FILE);
