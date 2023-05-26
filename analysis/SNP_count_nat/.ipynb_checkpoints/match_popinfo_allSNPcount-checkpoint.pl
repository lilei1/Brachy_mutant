#!/usr/bin/perl
#By Li Lei, 2021/09/22, El Cerrito
#This is to match all othe dSNP, 
#
#Usage: file1:dSNP file2: the SNP count

my ($SNPtype, $SNPfile) = @ARGV;
my %hash;

open (INFILE, "< $SNPtype")or die "Can't open $SNPtype";
my $header = <INFILE>;
while (<INFILE>) {
		$line = $_;
		chomp $line;
			my @array = split(/\t/, $line);
			my $sampleid = $array[0]; #creat the same key with gene id and aa positions;
				$hash{$sampleid} = $array[1];
			#print "$gene_cdsPos\n";
}
close OUTFILE;

open (EFFT, "< $SNPfile")or die "Can't open $SNPfile";
my $header = <EFFT>;
print "Sample_ID\tAll_SNPs\tsynSNPs\tnonsynSNPs\tdSNPs\tdSNPs.To.nonsyn\tdSNPs.To.syn\tpops\n";
while (<EFFT>) {
		$line = $_;
		chomp $line;
			my @temp = split(/\t/, $line);
			my $smplid = $temp[0];
				#print "$key\n";
			if (exists $hash{$smplid}){
                print "$line\t$hash{$smplid}\n";
			}
            else{
                print "$line\tNA\n";
            }

}

close EFFT;
