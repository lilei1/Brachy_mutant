#!/usr/bin/perl
#by Li Lei 2021-06-02, El Cerrito, CA
#For looking for the files not predicted!!!
use strict;
use warnings;
use diagnostics;
use Data::Dumper;
#my ($file1, $file2) = @ARGV;
my $file1 = $ARGV[0];
my %gidhash;
#my $g_id = "";
#my @rt = "";

open(IN,  "$file1") or die "Could not open $file1";

foreach my $row (<IN>){
        chomp $row;
        if ($row =~ /^\#/){
            next;
        }
        else{
            my @rt = split(/\t/,$row);
            my $snpid = $rt[0].".".$rt[1];
            my @array = split(/\;/,$rt[7]);
            my @arr = split(/\(/,$array[-1]);
            my @tt = split(/\=/,$arr[0]);
            #my @other = split(/\|/,$arr[1]);
            my @other = "";
            if ($tt[0] eq "EFF"){
                @arr = split(/\(/,$array[-1]);
                @tt = split(/\=/,$arr[0]);
                @other = split(/\|/,$arr[1]);
            }
            elsif($tt[0] eq "NMD"){
                @arr = split(/\(/,$array[-3]);
                @tt = split(/\=/,$arr[0]);
                @other = split(/\|/,$arr[1]); 
            
            }
            elsif($tt[0] eq "LOF"){
                @arr = split(/\(/,$array[-2]);
                @tt = split(/\=/,$arr[0]);
                @other = split(/\|/,$arr[1]); 
            }
            
            #my $size = $other[0];
            my $gene = "";
            my $anno = "";
            my $aachanges = "";
            my $size = "";
            if ($tt[1] eq "INTERGENIC" or $tt[1] eq "FilteredInAll" or $tt[1] eq "variant2"){
                 #$size = $other[0];
                 $anno = ".";
                 $gene = ".";
                 $aachanges = ".";
             #print "$eff\t$size\n";
            }
            elsif($tt[1] eq "INTRON"){
                #$size = $other[0];
                $anno = ".";
                $aachanges = ".";
                $gene = $other[8];
            }
            elsif($tt[1] eq "NON_SYNONYMOUS_CODING" or $tt[1] eq "SYNONYMOUS_CODING" or $tt[1] eq "STOP_LOST" or $tt[1] eq "START_LOST" or $tt[1] eq "STOP_LOST+SPLICE_SITE_REGION+CODON_DELETION" or $tt[1] eq "STOP_LOST+SPLICE_SITE_REGION" or $tt[1] eq "NON_SYNONYMOUS_CODING+SPLICE_SITE_REGION" or $tt[1] eq "SPLICE_SITE_REGION+SYNONYMOUS_CODING" or $tt[1] eq "START_LOST+SPLICE_SITE_REGION" or $tt[1] eq "SYNONYMOUS_STOP" or $tt[1] eq "STOP_GAINED+SPLICE_SITE_REGION" or $tt[1] eq "STOP_GAINED" or $tt[1] eq "NON_SYNONYMOUS_START" or $tt[1] eq "SPLICE_SITE_REGION+SYNONYMOUS_STOP"){
                #$size = $other[0];
                $aachanges = $other[3];
                $anno = $other[1];
                $gene = $other[8];
            }
            elsif($tt[1] eq "UTR_5_PRIME" or $tt[1] eq "UTR_3_PRIME" or $tt[1] eq "START_GAINED" or $tt[1] eq "SPLICE_SITE_REGION+INTRON" or $tt[1] eq "NON_SYNONYMOUS_CODING+SPLICE_SITE_REGION" or $tt[1] eq "SPLICE_SITE_DONOR+INTRON"or $tt[1] eq "SPLICE_SITE_REGION" or $tt[1] eq "SPLICE_SITE_ACCEPTOR+INTRON" or $tt[1] eq "SPLICE_SITE_REGION+INTRON" or $tt[1] eq "CODON_CHANGE_PLUS_CODON_DELETION" or $tt[1] eq "FRAME_SHIFT" or $tt[1] eq "CODON_DELETION" or $tt[1] eq "CODON_CHANGE_PLUS_CODON_INSERTION" or $tt[1] eq "CODON_INSERTION" or $tt[1] eq "FRAME_SHIFT+SPLICE_SITE_DONOR+SPLICE_SITE_REGION+INTRON" or $tt[1] eq "FRAME_SHIFT+SPLICE_SITE_REGION" or $tt[1] eq "FRAME_SHIFT+STOP_GAINED" or $tt[1] eq "FRAME_SHIFT+STOP_GAINED+SPLICE_SITE_REGION" or $tt[1] eq "FRAME_SHIFT+STOP_LOST" or $tt[1] eq "GENE_FUSION_REVERESE" or $tt[1] eq "SPLICE_SITE_ACCEPTOR+SPLICE_SITE_REGION+CODON_CHANGE_PLUS_CODON_DELETION+INTRON" or $tt[1] eq "SPLICE_SITE_ACCEPTOR+SPLICE_SITE_REGION+CODON_DELETION+INTRO" or $tt[1] eq "SPLICE_SITE_ACCEPTOR+SPLICE_SITE_REGION+INTRON" or $tt[1] eq "SPLICE_SITE_ACCEPTOR+SPLICE_SITE_REGION+UTR_5_PRIME+INTRON" or $tt[1] eq "SPLICE_SITE_DONOR+SPLICE_SITE_REGION+CODON_DELETION+INTRON" or $tt[1] eq "SPLICE_SITE_REGION+CODON_CHANGE_PLUS_CODON_DELETION" or $tt[1] eq "SPLICE_SITE_REGION+CODON_INSERTION" or $tt[1] eq "START_LOST+CODON_CHANGE_PLUS_CODON_DELETION" or $tt[1] eq "STOP_GAINED+CODON_CHANGE_PLUS_CODON_INSERTION " or $tt[1] eq "STOP_GAINED+CODON_INSERTION"){
                #$size = $other[0];
                $aachanges = ".";
                $anno = ".";
                $gene = $other[8];
            }
            elsif($tt[1] eq "STOP_LOST+CODON_CHANGE_PLUS_CODON_INSERTION" or $tt[1] eq "FRAME_SHIFT+START_LOST" or $tt[1] eq "SPLICE_SITE_DONOR+SPLICE_SITE_REGION+INTRON" or $tt[1] eq "FRAME_SHIFT+SPLICE_SITE_ACCEPTOR+SPLICE_SITE_REGION+INTRON"){
                $aachanges = $other[3];
                $anno = ".";
                $gene = $other[8];

            }
            
            $gene =~ s/v1\.1//g;
            my $eff = $tt[1];
            #if($other[0] eq 0){
            #print "$snpid\t";
            #print "$other[0]\n";
            $size = $other[0];
            #   }
            #else{
            #    $size = ".";
            #}
            #print "$snpid\t$gene\t$eff\t$anno\t$aachanges\n";
            #print "$snpid\t";
            #print "$other[0]\n";
#print join(", ", @other); 
#print "\n";
print "$snpid\t$rt[3]\t$rt[4]\t$gene\t$eff\t$size\t$anno\t$aachanges\n";
           
            #print "$eff\n";
            #my $other = 
            #if(defined($rt[8])){
            #  #print "$rt[8]\n";
            #   my @tt = split(/\_MSA/,$rt[8]);
            #   my $g_id = $tt[0];
            #   #print "$g_id\n";
            #   $gidhash{$g_id} = $row;   
            #}
        }
}
close (IN);

#open(SUBS,  "$file2") or die "Could not open $file2";
#foreach my $row (<SUBS>){
#        chomp $row;
#        my @rtemp = split(/\t/,$row);
#        if (exists $gidhash{$rtemp[0]}){
#            print "$gidhash{$rtemp[0]}\n";
#        }
#        else{
#            print "$rtemp[0]\n";
#        }
   
#}
#close (SUBS);
#print Dumper(\%gidhash);