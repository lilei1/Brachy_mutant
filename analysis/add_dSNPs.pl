#!/usr/bin/perl
##by Li Lei, 2021-06-23, El Cerrito;
#this is to add the dSNPs predicted by BAD_mutations to the current file!!!!
#You need have combined plates data and dSNPs file with masked or unmasked approaches!!!
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1,$file2 )= @ARGV;

my %hash; #define a hash to store the positions for each SNP;
my $total =0;
open(OUT,  "$file1") or die "Could not open $file1";
#my $header = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
       $hash{$rtemp[1]} = $rtemp[27];
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";
#my $header = <FILE>;
#print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @rtemp = split(/\,/,$row);
        my $snpid = $rtemp[2].".".$rtemp[3];
        if (exists $hash {$snpid}){
                if ($rtemp[14] =~ /NON_SYNONYMOUS/){
                        print "$row\,$hash{$snpid}\n";
                }
                else{
                        print "$row\,None\n";
                }
        }
        else{
                print "$row\,None\n";
        }
            
        
 }
close (FILE);