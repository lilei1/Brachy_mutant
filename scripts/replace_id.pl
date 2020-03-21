#!/usr/bin/perl
##by Li Lei, 2020-03-20, Berkeley;
#this is to replace the Bd-21 gene id with Bd-21-3
#You need have T DNA insertion data  and look up table
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
        my @rtemp = split(/\t/,$row);
         $hash{$rtemp[1]} = $rtemp[0];
}
close (OUT);
#print Dumper(\%hash);

open(FILE,  "$file2") or die "Could not open $file2";
my $header = <FILE>;
print "$header";
foreach my $row (<FILE>){
        chomp $row;
        my @temp = split(/\t/,$row);
        #print "$temp[4]\n";
        if ($temp[4] ne ""){
            my @tt = split(/\./,$temp[4]);
            if (exists $hash{$tt[0]}){
                print "$hash{$tt[0]}\t$row\n"; 
            }
            else{
                print "Empty\t$row\n"; 
            }
        }
        else{
               print "Empty\t$row\n"; 
        }
}
close (FILE);
