#!/usr/bin/perl
##by Li Lei, 2021-08-04, El Cerrito;
#this is to split the variants into common and rare categories!!There are 114 samples from the file and 
#You need have both files from maf and the filtered vcf file
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1,$file2,$file3,$file4)= @ARGV;

my %hash; #define a hash to store the positions for each SNP;
my $total =0;
open(OUT,  "$file1") or die "Could not open $file1";
my $header = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
        my $snpid = $rtemp[0].".".$rtemp[1];
       $hash{$snpid} = $rtemp[5];
 }
close (OUT);
open(OUT1,  ">$file3") or die "Could not open $file3";
open(OUT2,  ">$file4") or die "Could not open $file4";

open(FILE,  "$file2") or die "Could not open $file2";
foreach my $row (<FILE>){
        chomp $row;
        if ($row =~ /^#/){
            print OUT1 "$row\n";
            print OUT2 "$row\n";
        }
        else{
            my ($chr, $pos, $id, $ref, $alt, $qual, $filter, $info, $format, @rtemp) = split(/\t/,$row);
            my $snpid = $chr.".".$pos;
            if (exists $hash {$snpid}){
                my $value = $hash {$snpid};
                if ($value <= 0.0175){
                    print OUT1 "$row\n";
                }
                else{
                    print OUT2 "$row\n";
                }
                
            }
            
    }        
}            
                       
               
close (FILE);
close (OUT1);
close (OUT2);