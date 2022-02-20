# DrugCell: a visible neural network model for drug response prediction
DrugCell is an interpretable neural network-based model that predicts
cell response to a wide range of drugs. Unlike fully-connected neural networks,
connectivity of neurons in the DrugCell mirrors a
biological hierarchy (e.g. Gene Ontology), so that the information travels
only between subsystems (or pathways) with known hierarchical relationship
during the model training.
This feature of the framework allows for identification of
subsystems in the hierarchy that are important to the model's prediction,
warranting further investigation on underlying biological mechanisms of
cell response to treatments.

The current version (v2.0) of the DrugCell model
is trained using 692,859 (cell line, drug) pairs across
1,258 tumor cell lines and 888 drugs. The training data is retrieved from Genomics of
Drug Sensitivity in Cancer database (GDSC) and the Cancer Therapeutics Response
Portal (CTRP) v1 and v2.

DrugCell characterizes each cell line using its genotype;
the feature vector for each cell is a binary vector representing
mutational status of the of the genes used in clinical panels (n=718)
Drugs are encoded using Morgan Fingerprint (radius = 2), and the resulting
feature vectors are binary vectors of length 512.

# Environment set up for training and testing of DrugCell
DrugCell training/testing scripts require the following environmental setup:

* Hardware required for training a new model
    * GPU server with CUDA>=11 installed

* Software
    * Python 2.7 or >=3.6
    * Anaconda
        * Relevant information for installing Anaconda can be found in: https://docs.conda.io/projects/conda/en/latest/user-guide/install/.
    * PyTorch
        * The current release of DrugCell model was trained/tested using PyTorch 1.8.0
        * Depending on the specification of your machine, run appropriate command to install PyTorch.
        The installation command line can be found in https://pytorch.org/.
        * For a **LINUX-based GPU server** with **CUDA version 11.1**, run the following command line:
        ```angular2
        conda install pytorch torchvision cudatoolkit=11.1 -c pytorch
        ```

* Set up a virtual environment
    * If you are training a new model or test the pre-trained model using a GPU server, run the following command line
    to set up a virtual environment (cuda11_env).
        ```angular2
         conda env create -f cuda11_env.yml
        ```
    * After setting up the conda virtual environment, make sure to activate environment before executing DrugCell scripts.
    When testing in _sample_ directory, no need to run this as the example bash scripts already have the command line.
        ```
        source activate cuda11_env
        ```


# DrugCell release v2.0
DrugCell v2.0 was trained using (cell line, drug) pairs, but
it can be generalized to estimate response of any cells to any drugs if:
1. The feature vector of cell is built as a binary vector representing
mutational status of 718 genes (the list of index and name of the genes
is provided in _gene2ind.txt_).
2. The feature vector of drug is encoded into a binary vector of length 512
using Morgan Fingerprint (radius = 2). We also provide the pre-computed
feature vectors for all 888 drugs in our training data (_drug2fingerprint.txt_).

Required input files:
1. Cell feature files: _gene2ind.txt_, _cell2ind.txt_, _cell2mutation.txt_
    * _gene2ind.txt_: make sure you are using _gene2ind.txt_ file provided in this repository.
    * _cell2ind.txt_: a tab-delimited file where the 1st column is index of cells and the 2nd column is the name of cells (genotypes).
    * _cell2mutation.txt_: a comma-delimited file where each row has 718 binary values indicating each gene is mutated (1) or not (0).
    The column index of each gene should match with those in _gene2ind.txt_ file. The line number should
    match with the indices of cells in _cell2ind.txt_ file.
2. Drug feature files: drug2ind, drug2fingerprints
    * _drug2ind.txt_: a tab-delimited file where the 1st column is index of drug and the 2nd column is
    identification of each drug (e.g., SMILES representation or name). The identification of drugs
    should match to those in _drug2fingerprint.txt_ file.
    * _drug2fingerprint.txt_: a comma-delimited file where each row has 512 binary values which would form
    , when combined, a Morgan Fingerprint representation of each drug.
    The line number of should match with the indices of drugs in _drug2ind.txt_ file.
3. Test data file: _drugcell_test.txt_
    * A tab-delimited file containing all data points that you want to estimate drug response for.
    The 1st column is identification of cells (genotypes) and the 2nd column is identification of
    drugs.

To load a pre-trained model used for analyses in our manuscript and make prediction for (cell, drug) pairs of
your interest, execute the following:

1. Make sure you have _gene2ind.txt_, _cell2ind.txt_, _cell2mutation.txt_, _drug2ind.txt_,
_drug2fingerprint.txt_, and your file containing test data in proper format (examples are provided in
_data_ and _sample_ folder)

2. To run the model in a GPU server,  execute the following:
    ```
    python predict_drugcell_cpu.py -gene2id gene2ind.txt
                                   -cell2id cell2ind.txt
                                   -drug2id drug2ind.txt
                                   -genotype cell2mutation.txt
                                   -fingerprint drug2fingerprint.txt
                                   -predict testdata.txt
                                   -hidden <path_to_directory_to_store_hidden_values>
                                   -result <path_to_directory_to_store_prediction_results>
                                   -load <path_to_model_file>
                                   -cuda <GPU_unit_to_use> (optional)
    ```
    * An example bash script (_test.sh_) is provided in _sample_ folder.


# Train a new DrugCell model
To train a new DrugCell model using a custom data set, first make sure that you have
a proper virtual environment set up. Also make sure that you have all the required files
to run the training scripts:

1. Cell feature files: _gene2ind.txt_, _cell2ind.txt_, _cell2mutation.txt_
    * A detailed description about the contents of the files is given in _DrugCell release v1.0_ section.

2. Drug feature files: _drug2ind.txt_, _drug2fingerprints.txt_
    * A detailed description about the contents of the files is given in _DrugCell release v1.0_ section.

3. Training data file: _train.txt_
    * A tab-delimited file containing all data points that you want to use to train the model.
    The 1st column is identification of cells (genotypes), the 2nd column is identification of
    drugs and the 3rd column is an observed drug response in a floating number. The current
    version of the DrugCell code utilizes a loss function better suited for a regression problem (Minimum Squared Error; MSE),
    and we recommend using the code to train a regressor rather a classifier.

4. Validation data file: _drugcell_val.txt_
    * A tab-delimited file that in the same format as the training data. DrugCell training
    script would evaluate the model trained in each iteration using the data contained
    in this file. The performance of the model on the validation data may be used
    as an early termination condition.

5. Ontology (hierarchy) file: _ontology.txt_
    * A tab-delimited file that contains the ontology (hierarchy) that defines the structure of a branch
    of a DrugCell model that encodes the genotypes. The first column is always a term (subsystem or pathway),
    and the second column is a term or a gene.
    The third column should be set to "default" when the line represents a link between terms,
    "gene" when the line represents an annotation link between a term and a gene.
    The following is an example describing a sample hierarchy.

        ![](https://github.com/idekerlab/DrugCell/blob/master/misc/drugcell_ont_image_sample.png)

    ```
     GO:0045834	GO:0045923	default
     GO:0045834	GO:0043552	default
     GO:0045923	AKT2	gene
     GO:0045923	IL1B	gene
     GO:0043552	PIK3R4	gene
     GO:0043552	SRC	gene
     GO:0043552	FLT1	gene       
    ```

     * Example of the file (_ontology.txt_) is provided in _data_ folder.    


There are a few optional parameters that you can provide in addition to the input files:

1. _-model_: a name of directory where you want to store the trained models. The default
is set to "MODEL" in the current working directory.

2. _-genotype_hiddens_: a number of neurons to assign each subsystem in the hierarchy.
The default is set to 6.

3. _-drug_hiddens_: a string listing the number of neurons for the drug-encoding branch
of DrugCell. The number should be delimited by comma. The default value is "100,50,6",
and with the default option,
the drug branch of the resulting DrugCell model will be a fully-connected neural network with 3 layers
consisting of 100, 50, and 6 neurons.

4. _-final_hiddens_: the number of neurons in the top layer of DrugCell that combines
the genotype-encoding and the drug-encoding branches. The default is 6.

5. _-epoch_: the number of epoch to run during the training phase. The default is set to 300.

6. _-batchsize_: the size of each batch to process at a time. The deafult is set to 5000.
You may increase this number to speed up the training process within the memory capacity
of your GPU server.

7. _-cuda_: the ID of GPU unit that you want to use for the model training. The default setting
is to use GPU 0.

Finally, to train a DrugCell model, execute a command line similar to the example provided in
_sample/commandline_cuda.sh_:

```
python -u train_drugcell.py -onto drugcell_ont.txt
                            -gene2id gene2ind.txt
                            -cell2id cell2ind.txt
                            -drug2id drug2ind.txt
                            -genotype cell2mutation.txt
                            -fingerprint drug2fingerprints.txt
                            -train drugcell_train.txt
                            -test drugcell_val.txt
                            -model ./MODEL
                            -genotype_hiddens 6
                            -drug_hiddens "100,50,6"
                            -final_hiddens 6
                            -epoch 100
                            -batchsize 5000
                            -cuda 1
```


# Example data files in _sample_ directory
There are three subsets of our training data provided as toy example: drugcell_train.txt, drugcell_test.txt and drugcell_val.txt have 10,000, 1,000, and 1,000 (cell line, drug) pairs along with the corresponding drug response (area under the dose-response curve).
