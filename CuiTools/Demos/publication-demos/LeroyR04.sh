#!/bin/csh

# This script sets up data in an .mm format and runs the disambiguation 
# program simulating the experiments that were conducted by Leroy and 
# Rindflesch 2004 - this is not an exact reduplication 

if(-e LeroyR04.dir.mm) then
    echo "LeroyR04.dir.mm already exists."
    echo "Remove directory before running LeroyR04.sh"
    exit 1
endif

if(-e LeroyR04.dir.arff) then
    echo "LeroyR04.dir.arff already exists."
    echo "Remove directory before running LeroyR04.sh"
    exit 1
endif

if(-e LeroyR04.dir.weka) then
    echo "LeroyR04.dir.weka already exists."
    echo "Remove directory before running LeroyR04.sh"
    exit 1
endif


# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format. 

echo "prolog2mm.pl --nlm --log LeroyR04.dir.conversion.log LeroyR04.dir.mm $NLMWSDHOME/Reviewed_Results"

prolog2mm.pl --nlm --log LeroyR04.dir.conversion.log LeroyR04.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE XML DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING WEKA

echo "Creating the ARFF files for WEKA and running WEKA to obtain "
echo "the results." 
echo "Features: "
echo "  semantic types in the same sentence as the target word"
echo "  the part-of-speech of the target word"
echo "  whether the target word is the head word"
echo "Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo ""

echo "supervised-disambiguate.pl --st --pos --head --sentence --wekacv 10 --directory LeroyR04.dir LeroyR04.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --stcount "--ngram 1" --pos --head --sentence --wekacv 10 --directory LeroyR04.dir LeroyR04.dir.mm

#  NOW GO BACK AND SHOW THE FILE CONTAINING THE OVERALL RESULTS
#  ON THE SCREEN

echo "Printing precision results located in the "
echo "LeroyR04.dir.results/OverallResults file."

more LeroyR04.dir.results/OverallResults

echo "Note: Due to the 10 fold cross validation these results are "
echo "not exactly duplication of the results from Leroy, et al. 2004" 
echo "but an approximation."

