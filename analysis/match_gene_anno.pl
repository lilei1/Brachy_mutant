#!/usr/bin/perl
##by Li Lei, 2021-07-20, El Cerrito;
#this is to add the gene annotation information to the current file!!!!
#You need have gene anotation file download from the phytozome and the gene 
#usage: 
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
        $hash{$rtemp[2]} = $row;
        #print "$rtemp[2]\n";
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";
my $header1 = <FILE>;
#print "$header";
my $gid;
foreach my $row (<FILE>){
        chomp $row;
        my @rtmp = split(/\t/,$row);
        my @gene = split(/\./,$rtmp[0]);
        #print "$rtmp[4]\n";
        if (defined $gene[0] && $gene[1] && $gene[2]){
            $gid = $gene[0].".".$gene[1].".".$gene[2];
        }
        if (exists $hash {$gid}){
                my $value = $hash {$gid};
                my @array = split(/\t/,$value);
                if (defined $array[12] && $array[15]){
                    print "$gid\t$rtmp[1]\t$rtmp[2]\t$rtmp[3]\t$rtmp[4]\t$array[12]\t$array[15]\n";
                }
        }
        else{
                print "$gid\t$rtmp[1]\t$rtmp[2]\t$rtmp[3]\t$rtmp[4]\tNone\tNone\n";
            }
        
 }
close (FILE);
#    print "$count\n";