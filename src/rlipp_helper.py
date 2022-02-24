import argparse
from rlipp_calculator import *


def main():

	parser = argparse.ArgumentParser(description = 'RLIPP score calculation')
	parser.add_argument('-hidden', help = 'Hidden folders path', type = str)
	parser.add_argument('-ontology', help = 'Ontology file', type = str)
	parser.add_argument('-test', help = 'Test file', type = str)
	parser.add_argument('-predicted', help = 'Predicted result file', type = str)
	parser.add_argument('-gene2idfile', help = 'Gene-index file', type = str)
	parser.add_argument('-cell2idfile', help = 'Cell-index file', type = str)
	parser.add_argument('-mutations', help = 'Mutation information for cell lines', type = str)
	parser.add_argument('-cn_deletions', help = 'Copy number deletions for cell lines', type = str)
	parser.add_argument('-cn_amplifications', help = 'Copy number amplifications for cell lines', type = str)
	parser.add_argument('-output', help = 'Output file', type = str)
	parser.add_argument('-cpu_count', help = 'No of available cores', type = int, default = 1)
	parser.add_argument('-drug_count', help = 'No of top performing drugs', type = int, default = 0)
	parser.add_argument('-feature_count', help = 'Number of features', type = int, default = 3)
	parser.add_argument('-genotype_hiddens', help = 'Mapping for the number of neurons in each term in genotype parts', type = int, default = 6)

	cmd_args = parser.parse_args()

	rlipp_calculator = RLIPPCalculator(cmd_args)
	rlipp_calculator.calc_scores()


if __name__ == "__main__":
	main()
