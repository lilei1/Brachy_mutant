#!/usr/bin/env python
""" convert the MSA file into position specific frequency matrix and count the conserved the sites """
# by Li Lei, 11/02/2021
from Bio import AlignIO
from Bio.Align import AlignInfo
import os
import sys
from pathlib import Path
import argparse

#try:
#    fasta_fh = sys.argv[0]
#except IndexError:
#    sys.stderr.write(__doc__ + '\n')
#    exit(1)
#def get_file (path,gene_id,ext):
#	fasta_fh = os.path.join(path, gene_id,ext)
#	return fasta_fh

def get_cons(path,gene_id,num_species):
	#fasta_fh.seek(0)
	#filename = os.path.basename(fasta_fh)
	#head, tail = os.path.split(fasta_fh)
	fasta_fh = os.path.join(path, gene_id+'_MSA.fasta')
	align = AlignIO.read(fasta_fh,'fasta')
	summary_align = AlignInfo.SummaryInfo(align)
	consensus = summary_align.dumb_consensus()
	my_pssm = summary_align.pos_specific_score_matrix(consensus,chars_to_ignore = ['N'])
	#print(my_pssm)
	cons_site = 0
	total_site = 0
	for i, line in enumerate(my_pssm):
		total_site = total_site + 1
		all_values = my_pssm[i].values()
		max_line = max(all_values)
		if max_line >= num_species:
			cons_site = cons_site + 1

	return print ('\t'.join([gene_id,str(cons_site),str(total_site)]))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="find the conserved sites and total sites of the gene")
    parser.add_argument("--data_dir",type=lambda p: Path(p).absolute(),default=Path(__file__).absolute().parent / "data",help="the path of the MSA file")
    parser.add_argument("gene_id", type=str, help="the gene id of the MSA")
    parser.add_argument("num_species", type=float, help="the number of species aligned(in range 20 to 91)",)
    args = parser.parse_args()
    get_cons(args.data_dir, args.gene_id, args.num_species)
