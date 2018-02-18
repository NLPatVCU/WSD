#!/bin/csh

# This script shows how to run the 10-fold cross validation using 
# CuiTools. The data used for this demo is the NLM-WSD data set. 
# There is no specific reason for using this data set except for  
# consistency since all of the other demos to date use this data 
# set.

if(-e 10-fold-demo.dir.mm) then
    echo "10-fold-demo.dir.mm already exists."
    echo "Remove directory before running 10-fold-demo.sh"
    exit 1
endif

if(-e 10-fold-demo.dir.arff) then
    echo "10-fold-demo.dir.arff already exists."
    echo "Remove directory before running 10-fold-demo.sh"
    exit 1
endif

if(-e 10-fold-demo.dir.weka) then
    echo "10-fold-demo.dir.weka already exists."
    echo "Remove directory before running 10-fold-demo.sh"
    exit 1
endif

# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format.

prolog2mm.pl --log log --nlm 10-fold-demo.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE .MM DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING OUR 10
#  FOLD CROSS VALIDATION SOFTWARE

echo "Running 10-fold cross validation on the NLM-WSD data set"

supervised-disambiguate.pl --wekaparams "-s 42" --cuicount "--ngram 1 --frequency 1" --cv 10 --directory 10-fold-demo.dir 10-fold-demo.dir.mm


#  NOW GO BACK AND SHOW THE FILE CONTAINING THE OVERALL RESULTS 
#  ON THE SCREEN 
more 10-fold-demo.dir.results/OverallResults

