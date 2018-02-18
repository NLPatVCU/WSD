#!/bin/csh

# This script sets up data in CuiTolls xml-like .mm format and runs the 
# disambiguation program simulating the experiments that were conducted 
# for the AMIA 2007

if(-e McInnesPC07.dir.mm) then
    echo "McInnesPC07.dir.mm already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif

if(-e a-1-cui.arff) then
    echo "a-1-cui.arff already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif
if(-e a-1-cui.weka) then
    echo "a-1-cui.weka already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif

if(-e a-2-cui.arff) then
    echo "a-2-cui.arff already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif
if(-e a-2-cui.weka) then
    echo "a-2-cui.weka already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif

if(-e s-1-cui.arff) then
    echo "s-1-cui.arff already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif
if(-e s-1-cui.weka) then
    echo "s-1-cui.weka already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif

if(-e s-2-cui.arff) then
    echo "s-2-cui.arff already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif
if(-e s-2-cui.weka) then
    echo "s-2-cui.weka already exists."
    echo "Remove directory before running McInnesPC07.sh"
    exit 1
endif

# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format.

echo "prolog2mm.pl --nlm --log McInnesPC07.dir.conversion.log McInnesPC07.dir.mm $NLMWSDHOME/Reviewed_Results"
prolog2mm.pl --nlm --log McInnesPC07.dir.conversion.log McInnesPC07.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE .MM DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING WEKA

echo "Re-creating the results from the AMIA07 paper"

echo "a-1-cui:"
echo "  Features: "
echo "    CUIs in the same abstract as the target word"
echo "    with a cutoff of one"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo ""

echo "supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 1" --wekacv 10 --directory a-1-cui McInnesPC07.dir.mm"
echo""

supervised-disambiguate.pl --wekaparams "-s 42" --cuicount "--ngram 1 --frequency 1" --wekacv 10 --directory a-1-cui McInnesPC07.dir.mm

echo "a-2-cui:"
echo "  Features: "
echo "    CUIs in the same abstract as the target word"
echo "    with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo ""

echo "supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 2" --wekacv 10 --directory a-2-cui McInnesPC07.dir.mm"
echo""

supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 2" --wekacv 10 --directory a-2-cui McInnesPC07.dir.mm

echo "s-1-cui:"
echo "  Features: "
echo "    CUIs in the same sentence as the target word"
echo "    with a cutoff of one"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo ""

echo "supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 1" --sentence --wekacv 10 --directory s-1-cui McInnesPC07.dir.mm"
echo""

supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 1" --sentence --wekacv 10 --directory s-1-cui McInnesPC07.dir.mm

echo "s-2-cui:"
echo "  Features: "
echo "    CUIs in the same sentence as the target word"
echo "    with a cutoff of one" 
echo "  Algorithm: "; 
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo ""

echo "supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 2" --sentence --wekacv 10 --directory s-2-cui McInnesPC07.dir.mm"
echo""

supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 2" --sentence --wekacv 10 --directory s-2-cui McInnesPC07.dir.mm


#  NOW GO BACK AND SHOW THE FILE CONTAINING THE OVERALL RESULTS
#  ON THE SCREEN

echo "Printing precision results for each of the runs"
echo ""
echo "Note: Due to the 10 fold cross validation these results are "
echo "not exactly duplication of the results from McInnes, et al. 2007" 
echo "but an approximation."
echo ""

displayMcInnesPC07.pl a-1-cui.results/OverallResults a-2-cui.results/OverallResults s-1-cui.results/OverallResults s-2-cui.results/OverallResults

