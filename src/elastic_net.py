import argparse
import numpy as np
import pandas as pd
from sklearn.linear_model import ElasticNetCV

def exec_elastic_net(args):
    
    train_df = pd.read_csv(args.train, sep='\t', header=None, names=(['cell', 'drug', 'auc']))
    test_df = pd.read_csv(args.test, sep='\t', header=None, names=(['cell', 'drug', 'auc']))

    gene_index = pd.read_csv(args.gene_index, sep='\t', header=None, names=(['I', 'G']))
    gene_list = gene_index['G']
    
    cell_index = pd.read_csv(args.cell_index, sep='\t', header=None, names=(['I', 'C']))
    cell_map = dict(zip(cell_index['C'], cell_index['I']))
    
    cell_features = pd.read_csv(args.cell_mutation, header=None, names=gene_list)
    
    drug_index = pd.read_csv(args.drug_index, sep='\t', header=None, names=(['I', 'D']))
    drug_map = dict(zip(drug_index['D'], drug_index['I']))
    
    drug_features = pd.read_csv(args.drug_fingerprint, header=None)
    
    train_Y = np.array(train_df['auc'])
    train_X = np.empty(shape = (len(train_df), len(gene_list) + len(drug_features.columns)))
    test_X = np.empty(shape = (len(test_df), len(gene_list) + len(drug_features.columns)))
    
    for i, row in train_df.iterrows():
        temp = []
        temp = np.append(temp, np.array(cell_features.iloc[int(cell_map[row['cell']])]))
        temp = np.append(temp, np.array(drug_features.iloc[int(drug_map[row['drug']])]))
        train_X[i] = temp

    for i, row in test_df.iterrows():
        temp = []
        temp = np.append(temp, np.array(cell_features.iloc[int(cell_map[row['cell']])]))
        temp = np.append(temp, np.array(drug_features.iloc[int(drug_map[row['drug']])]))
        test_X[i] = temp
    
    regr = ElasticNetCV(fit_intercept=True, cv=5, max_iter=3000, tol=1e-3, n_jobs=-2)
    regr.fit(train_X, train_Y)
    predicted_Y = regr.predict(test_X)
    
    np.savetxt(args.output, predicted_Y, fmt = '%.4e')


def main():
    
    parser = argparse.ArgumentParser(description = 'Execute Elastic net')
    parser.add_argument('-train', help = 'Train file', type = str)
    parser.add_argument('-test', help = 'Test file', type = str)
    parser.add_argument('-drug_index', help = 'Drug-index file', type = str)
    parser.add_argument('-gene_index', help = 'Gene-index file', type = str)
    parser.add_argument('-cell_index', help = 'Cell-index file', type = str)
    parser.add_argument('-cell_mutation', help = 'Cell line mutation file', type = str)
    parser.add_argument('-drug_fingerprint', help = 'Drug fingerprint file', type = str)
    parser.add_argument('-output', help = 'Output file', type = str)
    
    cmd_args = parser.parse_args()
    
    exec_elastic_net(cmd_args)


if __name__ == "__main__":
    main()