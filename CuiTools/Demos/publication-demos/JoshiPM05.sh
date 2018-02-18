#!/bin/csh

# This script sets up data in an .mm format and runs the disambiguation 
# program simulating the experiments that were conducted by Joshi, Pedersen 
# and Maclin 2005%

if(-e JoshiPM05.dir.mm) then
    echo "JoshiPM05.dir.mm already exists."
    echo "Remove directory before running JoshiPM05.sh"
    exit 1
endif

if(-e JoshiPM05.dir.arff) then
    echo "JoshiPM05.dir.arff already exists."
    echo "Remove directory before running JoshiPM05.sh"
    exit 1
endif

if(-e JoshiPM05.dir.weka) then
    echo "JoshiPM05.dir.weka already exists."
    echo "Remove directory before running JoshiPM05.sh"
    exit 1
endif


# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format. 

echo "prolog2mm.pl --nlm --log JoshiPM05.dir.conversion.log JoshiPM05.dir.mm $NLMWSDHOME/Reviewed_Results"
prolog2mm.pl --nlm --log JoshiPM05.dir.conversion.log JoshiPM05.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE XML DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING WEKA

echo "Creating the ARFF files for WEKA and running WEKA to obtain "
echo "the results." 
echo "Features: ";
echo "    unigrams in the same abstract as the target word" 
echo "    using a cutoff of four."
echo "Algorithm: ";
echo "    WEKA's Support Vector Machine  (weka.classifiers.functions.SMO)"
echo ""

echo "supervised-disambiguate.pl  --weka weka.classifiers.functions.SMO --unigram --unicutoff 4 --wekacv 10 --directory JoshiPM05.dir JoshiPM05.dir.mm"
echo ""

supervised-disambiguate.pl  --wekaparams "-s 42" --weka weka.classifiers.functions.SMO --ngramcount "--ngram 1 --frequency 4" --wekacv 10 --lc --directory JoshiPM05.dir JoshiPM05.dir.mm

#  NOW GO BACK AND SHOW THE FILE CONTAINING THE OVERALL RESULTS
#  ON THE SCREEN

echo "Printing precision results located in the "
echo "JoshiPM05.dir.results/OverallResults file."

more JoshiPM05.dir.results/OverallResults

echo "Note: Due to the 10 fold cross validation these results are "
echo "not exactly duplication of the results from Joshi, et al. 2005" 
echo "but an approximation."
 

