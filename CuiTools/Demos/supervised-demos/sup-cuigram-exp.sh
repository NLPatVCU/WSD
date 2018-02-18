#!/bin/csh

# This script sets up data in CuiTolls xml-like .mm format and runs the 
# disambiguation program simulating the cui experiments in my thesis

if(-e sup-cui-exp.dir.mm) then
    echo "sup-cui-exp.dir.mm already exists."
    echo "Remove directory before running sup-cui-exp.sh"
    exit 1
endif

#  cui-unigram experiment with cutoff = 2 but no stoplist
if(-e sup-cui-unigram.arff) then
    echo "sup-cui-unigram.arff already exists."
    echo "Remove directory before running sup-cui-exp.sh"
    exit 1
endif
if(-e sup-cui-unigram.weka) then
    echo "sup-cui-unigram.weka already exists."
    echo "Remove directory before running sup-cui-exp.sh"
    exit 1
endif

#  cui-bigram experiment with cutoff = 2 but no stoplist
if(-e sup-cui-bigram.arff) then
    echo "sup-cui-bigram.arff already exists."
    echo "Remove directory before running sup-cui-exp.sh"
    exit 1
endif
if(-e sup-cui-bigram.weka) then
    echo "sup-cui-bigram.weka already exists."
    echo "Remove directory before running sup-cui-exp.sh"
    exit 1
endif

#  cui-trigram experiment with cutoff = 2 but no stoplist
if(-e sup-cui-trigram.arff) then
    echo "sup-cui-trigram.arff already exists."
    echo "Remove directory before running sup-cui-exp.sh"
    exit 1
endif
if(-e sup-cui-trigram.weka) then
    echo "sup-cui-trigram.weka already exists."
    echo "Remove directory before running sup-cui-exp.sh"
    exit 1
endif

# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format.

echo "prolog2mm.pl --nlm --log sup-cui-exp.dir.conversion.log sup-cui-exp.dir.mm $NLMWSDHOME/Reviewed_Results"
prolog2mm.pl --nlm --log sup-cui-exp.dir.conversion.log sup-cui-exp.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE .MM DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING WEKA

echo "Re-creating the cui results from the thesis"

echo "cui-unigram experiments:"

echo "  Features: "
echo "    cui-unigrams in the same abstract as the target word"
echo "    with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 2" --cv 10 --directory sup-cui-unigram sup-cui-exp.dir.mm"
echo""

supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 2" --cv 10 --directory sup-cui-unigram sup-cui-exp.dir.mm

echo "cui-bigram experiments:"

echo "  Features: "
echo "    cui-bigrams in the same abstract as the target word"
echo "    with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --cuicount "--ngram 2 --frequency 2" --cv 10 --directory sup-cui-bigram sup-cui-exp.dir.mm"
echo""

supervised-disambiguate.pl --cuicount "--ngram 2 --frequency 2" --cv 10 --directory sup-cui-bigram sup-cui-exp.dir.mm

echo "cui-trigram experiments:"

echo "  Features: "
echo "    cui-trigrams in the same abstract as the target word"
echo "    with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --cuicount "--ngram 3 --frequency 2" --cv 10 --directory sup-cui-trigram sup-cui-exp.dir.mm"
echo""

supervised-disambiguate.pl --cuicount "--ngram 3 --frequency 2" --cv 10 --directory sup-cui-trigram sup-cui-exp.dir.mm

