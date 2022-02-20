import argparse
from rlipp_calculator import *


def main():

	parser = argparse.ArgumentParser(description = 'RLIPP score calculation')
	parser.add_argument('-hidden', help = 'Hidden folders path', type = str)
	parser.add_argument('-ontology', help = 'Ontology file', type = str)
	parser.add_argument('-test', help = 'Test file', type = str)
	parser.add_argument('-predicted', help = 'Predicted result file', type = str)
	parser.add_argument('-gene_index', help = 'Gene-index file', type = str)
	parser.add_argument('-cell_index', help = 'Cell-index file', type = str)
	parser.add_argument('-cell_mutation', help = 'Cell line mutation file', type = str)
	parser.add_argument('-output', help = 'Output file', type = str)
	parser.add_argument('-cpu_count', help = 'No of available cores', type = int, default = 1)
	parser.add_argument('-drug_count', help = 'No of top performing drugs', type = int, default = 0)
	parser.add_argument('-genotype_hiddens', help = 'Mapping for the number of neurons in each term in genotype parts', type = int, default = 6)

	cmd_args = parser.parse_args()

	rlipp_calculator = RLIPPCalculator(cmd_args)
	rlipp_calculator.calc_scores()


if __name__ == "__main__":
	main()
