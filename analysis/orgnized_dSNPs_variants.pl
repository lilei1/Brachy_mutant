#!/usr/bin/perl
##by Li Lei, 2021-07-18, El Cerrito;
#this is to orgnized the full datasets for both dSNPs and high impact variants
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
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
       $hash{$rtemp[0]} = $row;
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";
my $header1 = <FILE>;
#print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @tt = split(/\t/,$row);
        if (exists $hash {$tt[0]}){
            my $value = $hash {$tt[0]};
            my @arr = split(/\t/,$value);
            shift @arr; 
            print "$row\t";
            foreach my $ele (@arr) {
                print "$ele\t";
            }
            print "\n";
        }
        else{
            print "$row\t0\tNone\n";
        }
        
 }
close (FILE);
#    print "$count\n";