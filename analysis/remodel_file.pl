#!/usr/bin/perl
##by Li Lei, 2020-04-17, Berkeley;
#this is to reorgnize the dataset:
#You need have combined plates data
#usage: 
use strict;
use warnings;
use Data::Dumper;

my $file1 = $ARGV[0];

my %hash; #define a hash to store the positions for each SNP;
open(OUT,  "$file1") or die "Could not open $file1";
my $header = <OUT>;
print "Row,Database Name (format: mutant line_chromosme_position_zygosity),Chromosome (Scaffold),Position,Plate,Mutant Line,Mutation,REFerence Allele,ALTernate Allele,Zygosity,Wt Reads,Mutant Reads,Ratio wt/mutant,Gene,Effect,Impact,Type of Impact,JV Quality Score\n";
#print "$header";
foreach my $row (<OUT>){
        chomp $row;
        my @rtemp = split(/\,/,$row);
        my $effect;
        if ($rtemp[14] =~ /^NON_SYNONYMOUS_CODING/){
             $effect = "MISSENSE";
        }
        elsif($rtemp[14] =~ /^SYNONYMOUS_CODING/){
             $effect = "SILENT";
        }
        elsif($rtemp[14] =~ /^STOP_GAINED*/){
             $effect = "NONSENSE";
        }
        else{
            $effect = "";
        }
        print "$rtemp[0],$rtemp[1],$rtemp[2],$rtemp[3],$rtemp[4],$rtemp[5],$rtemp[6],$rtemp[7],$rtemp[8],$rtemp[17],$rtemp[10],$rtemp[11],$rtemp[12],$rtemp[13],$rtemp[14],$rtemp[15],$effect,$rtemp[16]\n";
}
close (OUT);