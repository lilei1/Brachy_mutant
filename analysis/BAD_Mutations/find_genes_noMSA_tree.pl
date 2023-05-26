#!/usr/bin/perl
##by Li Lei, 2021-08-10, El Cerrito;
#this is to find the genes without the MSA and tree files!!!
#You need MSA, tree list, and gene list !
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1, $file2)= @ARGV;

my %hash; #define a hash to store the positions for each SNP;

open(FILE,  "$file1") or die "Could not open $file1";
#my $header = <FILE>;
#print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @rtemp = split(/\//,$row);
           $rtemp[9]=~s/\_MSA\.fasta//ig;
           $hash{$rtemp[9]} = 999;
 }
close (FILE);

open(OUT,  "$file2") or die "Could not open $file2";
#my $header = <FILE>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
        my $snpid = $rtemp[0];
        unless (exists $hash{$snpid}){
               print "$row\n";
        }
 }
close (OUT);