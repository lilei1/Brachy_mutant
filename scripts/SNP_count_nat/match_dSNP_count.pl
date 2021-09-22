#!/usr/bin/perl
#By Li Lei, 2021/09/14, El Cerrito
#This is to match the dSNPs id to the biSNP count!!! Then I can run a bash script to 
#
#Usage: file1:dSNP file2: the SNP count

my ($SNPtype, $SNPCount) = @ARGV;
my %hash;

open (INFILE, "< $SNPtype")or die "Can't open $SNPtype";
#my $header = <INFILE>;
while (<INFILE>) {
		$line = $_;
		chomp $line;
			my @array = split(/\t/, $line);
			my $snpid = $array[1]; #creat the same key with gene id and aa positions;
				$hash{$snpid} = 999;
			#print "$gene_cdsPos\n";
}
close OUTFILE;

open (EFFT, "< $SNPCount")or die "Can't open $SNPCount";
my $header = <EFFT>;
#print "GeneID\tSNP_ID\tChromosome\tPosition\tSilent\tCodon_Position\tRef_Base\tAlt_Base\tAA1\tAA2\tCDS_Pos\tAA_Pos\tTranscript_ID\tAA_pos\tAlignedPosition\tL0\tL1\tConstraint\tChisquared\tP-value\tSeqCount\tAlignment\tReferenceAA\tMaskedConstraint\tMaskedP-value\tLogisticP_Unmasked\tLogisticP_Masked\n";
while (<EFFT>) {
		$line = $_;
		chomp $line;
			my @temp = split(/\t/, $line);
			my $snp_id = $temp[0];
				#print "$key\n";
			if (exists $hash{$snp_id}){
                print "$line\n";
			}

}

close EFFT;
