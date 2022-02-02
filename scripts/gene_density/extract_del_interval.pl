#!/usr/bin/perl
#By Li Lei, 2022/02/01
#This is to extract the interval of the deletions from the file
#
#Usage: file1:dSNP file2: the SNP count

my ($SNPfile, $bedfile) = @ARGV;
open (INFILE, "< $SNPfile")or die "Can't open $SNPfile";
#open (OUT, "> $bedfile")or die "Can't open $bedfile";

#my $header = <INFILE>;
while (<INFILE>) {
		$line = $_;
		chomp $line;
			my @array = split(/\,/, $line);
			my $chr = $array[2]; 
            my $start = $array[3];
            my $reflen = length($array[7]);
            my $altlen = length($array[8]);
            my @len = ($reflen,$altlen);
            my $max = (sort {$b <=> $a} @len)[0];
            my $end = $start + $max +1;
			print  "$chr\t$start\t$end\n";
}
close INFILE;

