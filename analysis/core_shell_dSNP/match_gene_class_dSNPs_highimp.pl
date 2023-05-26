#!/usr/bin/perl
##by Li Lei, 2021-09-30, Alameda;
#this is to add the gene classification information to the current file!!!!
#You need have gene classification file download from the phytozome and the gene 
#usage: 
use strict;
use warnings;
use Data::Dumper;

my ($file1,$file2 )= @ARGV;

my %hash; #define a hash to store the positions for each SNP;
#my $total =0;
open(OUT,  "$file1") or die "Could not open $file1";
#my $header = <OUT>;
#print "$header";
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
my $header1 = <FILE>;
print "Gene_Id\tconserved_site\ttotal_site\tclass\tnb_dSNPs\tdSNPs\tnb_HISNP\tHISNP\n";
my $gid;
foreach my $row (<FILE>){
        chomp $row;
        my @rtmp = split(/\t/,$row);
            $gid = $rtmp[0];
        if (exists $hash {$gid}){
                my $value = $hash {$gid};
                my @array = split(/\t/,$value);
                #if (defined $array[12] && $array[15]){
                    print "$row\t$array[1]\t$array[2]\t$array[3]\t$array[4]\n";
                #}
        }
        else{
                print "$row\t0\tNone\t0\tNone\n";
                #}
            }
        
 }
close (FILE);
#    print "$count\n";
