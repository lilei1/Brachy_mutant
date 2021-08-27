#!/usr/bin/perl
my $file = shift;
###20160425 by Li Lei
###aim: spliting the sequences from a fasta file with multiple sequences into individual files with single sequence;
#This script is download from https://github.com/MorrellLAB/Barley_Inversions/blob/master/analyses/BAD_Mutations/script/fasta_splitter.pl
open (INFILE, "< $file")or die "Can't open $file";
while (<INFILE>) {
		$line = $_;
		chomp $line;
		if ($line =~ /\>/) { #if has fasta >
			close OUTFILE;
			my $seq_name = substr($line,1);
			my @array = split(/\|/, $seq_name);
			my @tem = split (/\s+/,$array[0]);
			my @rtem = split (/\./,$tem[0]);
			my $new_file = $rtem[0]."_".$rtem[1];
			   $new_file =~ s/^\s+|\s+$//g; #remove all the whitespace;
			#print "$new_file\n";
			$new_file .= ".fasta";
			#print "$new_file\n";
			open (OUTFILE, ">$new_file")or die "Can't open: $new_file $!";
		}
		print OUTFILE "$line\n";
}
close OUTFILE;