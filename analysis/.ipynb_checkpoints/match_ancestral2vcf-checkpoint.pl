#!/usr/bin/perl
##by Li Lei, 2021-10-13, Alameda;
#this is to match teh ancestral_derived status for the rare and common SNPs!!!!
#You need infferend ancestral status and the rare and commond SNP vcf file!!!
use strict;
use warnings;
use Data::Dumper;

my ($file1,$file2 )= @ARGV;

my %hash; #define a hash to store the positions for each SNP;
#my $total =0;
open(OUT,  "$file1") or die "Could not open $file1";
my $header = <OUT>;
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\t/,$row);
        my $snpid = $rtemp[0].".".$rtemp[1];
        $hash{$snpid} = $row;
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";
#my $header1 = <FILE>;
print "chr\tpos\tanc\tderived\n";
my $gid;
foreach my $row (<FILE>){
        chomp $row;
        if ($row =~ "^\#.+"){
            next;
        }
        else{
            my @rtmp = split(/\t/,$row);
            my $SNP = $rtmp[0].".".$rtmp[1];
            if (exists $hash {$SNP}){
                my $value = $hash {$SNP};
                my @array = split(/\t/,$value);
                if ($rtmp[3] eq $array[4]){
                    print "$rtmp[0]\t$rtmp[1]\t$array[4]\t$rtmp[4]\n";
                }
                elsif($rtmp[4] eq $array[4]){
                    print "$rtmp[0]\t$rtmp[1]\t$array[4]\t$rtmp[3]\n"
                }
            }

        }
        
 }
close (FILE);
#    print "$count\n";
