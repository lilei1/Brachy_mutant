#!/usr/bin/perl
##by Li Lei, 2021-06-22, El Cerrito;
#this is to add the missing annotation to the current file!!!!
#You need have combined plates data and the annotation output from previous scripts
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
       $hash{$rtemp[0]} = $row;
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";
#my $header = <FILE>;
#print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @rtemp = split(/\,/,$row);
        my $snpid = $rtemp[2].".".$rtemp[3];
        if ($rtemp[14] ne ""){
                print "$row\n";
            }
        else{
            if (exists $hash {$snpid}){
                my $value = $hash {$snpid};
                my @array = split(/\t/,$value);
                print "$rtemp[0]\,$rtemp[1]\,$rtemp[2]\,$rtemp[3]\,$rtemp[4]\,$rtemp[5]\,$rtemp[6]\,$rtemp[7]\,$rtemp[8]\,$rtemp[9]\,$rtemp[10]\,$rtemp[11]\,$rtemp[12]\,$array[1]\,$array[2]\,$array[3]\,$array[4]\,$rtemp[17]\,$rtemp[18]\n";
                }
            else{
                    print "$row\n";
                }
            }
        
 }
close (FILE);
#    print "$count\n";