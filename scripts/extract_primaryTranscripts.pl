#!/usr/bin/perl
##by Li Lei, 2020-12-23, El Cerrito;
#this is to extract the primary transcript from the gtf file
#You need have T DNA insertion data  and look up table
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1, $file2,$out1, $out2) = @ARGV;

my %hash; #define a hash to store the positions for each SNP;
open(OUT,  "$file1") or die "Could not open $file1";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
         $hash{$rtemp[0]} = 999;
}
close (OUT);
#print Dumper(\%hash);

open(FILE,  "$file2") or die "Could not open $file2";
open(OUT1,  ">$out1") or die "Could not open $out1";
open(OUT2,  ">$out2") or die "Could not open $out2";
#my $header = <FILE>;
#print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @temp = split(/\t/,$row);
        my @tmp = split(/\"/,$temp[8]);
        $tmp[1] =~ s/\.v1\.1//ig;
        #print "$tmp[1]\n";
        if (exists $hash{$tmp[1]}){
                print OUT1 "$row\n"; 
        }
        else{
                print OUT2 "$row\n"; 
        }

}
close (FILE);
