#!/usr/bin/perl
##by Li Lei, 2021-07-18, El Cerrito;
#this is to check if the mutations in the natural variation from the natural lines!!!!
#You need have both files from the dSNPs and high impact variants
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1,$file2 )= @ARGV;

my %hash; #define a hash to store the positions for each SNP;
my $total =0;
open(OUT,  "$file1") or die "Could not open $file1";
my $header = <OUT>;
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
        my $snpid = $rtemp[0].".".$rtemp[1].".".$rtemp[3].".".$rtemp[4];
        #print "$snpid\n";
       $hash{$snpid} = 999;
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";
my $header1 = <FILE>;
chomp $header1;
print "$header1\,exists_natural_line\n";
foreach my $row (<FILE>){
        chomp $row;
        my @tt = split(/\,/,$row);
        my $snpid = $tt[2].".".$tt[3].".".$tt[7].".".$tt[8];
        #print "$snpid\n";
        if (exists $hash {$snpid}){
            print "$row\,Yes\n";
        }
        else{
            print "$row\,No\n";
        }
        
 }
close (FILE);
#    print "$count\n";