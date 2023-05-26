#!/usr/bin/perl
##by Li Lei, 20210927,Alameda;
#this is to classify the genes into diffferent categories based on Grdon't at al 2017 criteria;

############################
#Core genes: all 55 lines!!#
#softcare genes: 52-54     #
#shell:3-51                #
#cloud genes: 1-2 lines!!!!#
############################
#You need have combined plates data and dSNPs file with masked or unmasked approaches!!!
#usage: 
use strict;
use warnings;
use Data::Dumper;

my $file1= $ARGV[0];

open(OUT,  "$file1") or die "Could not open $file1";
my $header1 = <OUT>;
my $header2 = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my ($gid,@rtemp) = split(/\,/,$row);
        my @tt = split(/\_/,$gid);
        my $ngid = $tt[1] =~ s/\.\d\.fna//r;
        my $count =0;
        foreach (@rtemp) {
                if ($_ != 0 ){
                        $count++;
                }
        }
        if ($count == 55){
                print "$ngid\tcore\n";
        }
        elsif($count >= 52 and $count <= 54){
                print "$ngid\tsoftcore\n";
        }
        elsif($count >= 3 and $count <= 51){
                print "$ngid\tshell\n";
        }
        elsif($count >= 1 and $count <= 2){
                print "$ngid\tcloud\n";
        }
}
close (OUT);
