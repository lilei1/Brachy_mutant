#!/usr/bin/perl
##by Li Lei, 2022-02-09, Alameda;
#this is to match the line information to the !!!!
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1,$file2 )= @ARGV;

my %hash; #define a hash to store the positions for each SNP;
#my $total =0;
open(OUT,  "$file1") or die "Could not open $file1";
my $header = <OUT>;
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
        if (defined $rtemp[0]){
            $hash{$rtemp[0]} = $row;
            #print "$rtemp[2]\n";
        }
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";

print "Line_ID\tGeneration\tType\n";
my $line;
foreach my $row (<FILE>){
        chomp $row;
        my @rtmp = split(/\t/,$row);
            $line = $rtmp[0];
        if (exists $hash {$line}){
                my $value = $hash {$line};
                print "$value\n";

        }
        else{
                print "$row\tNA\tNA\n";
            }
        
 }
close (FILE);
#    print "$count\n";
