#!/usr/bin/perl
##by Li Lei, 2021-11-03, Alameda;
#this is to add the gene classification information to the current file!!!!
#You need have the genes and conserved sites and total sites!!!
#File1: gene_class file
#File2: gene_conserved 
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
        $hash{$rtemp[0]} = $rtemp[1];
 }
close (OUT);

open(FILE,  "$file2") or die "Could not open $file2";
#my $header1 = <FILE>;
print "Gene_Id\tconserved_site\ttotal_site\tclass\n";
my $gid;
foreach my $row (<FILE>){
        chomp $row;
        my @rtmp = split(/\t/,$row);
        #my @gene = split(/\./,$rtmp[0]);
        #print "$rtmp[4]\n";
        #if (defined $gene[0] && $gene[1] && $gene[2]){
            $gid = $rtmp[0];
        #}
        if (exists $hash {$gid}){
                my $value = $hash {$gid};
                    print "$row\t$value\n";
        }
        else{
                print "$row\tNone\n";
                #}
            }
        
 }
close (FILE);
