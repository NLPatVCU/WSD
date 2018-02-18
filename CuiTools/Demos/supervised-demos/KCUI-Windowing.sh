#!/bin/csh

# This script sets up data in CuiTolls xml-like .mm format and runs the 
# disambiguation program simulating the cui experiments in my thesis

if(-e KCUI-Windowing.dir..mm) then
    echo "KCUI-Windowing.dir.mm already exists."
    echo "Remove directory before running KCUI-Windowing.sh"
    exit 1
endif


# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format.

echo "prolog2mm.pl --nlm --log KCUI-Windowing.dir.log KCUI-Windowing.dir.mm $NLMWSDHOME/Reviewed_Results"
prolog2mm.pl --nlm --log KCUI-Windowing.dir.log KCUI-Windowing.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE .MM DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING WEKA
echo "Windowing dissertation experiments:"

echo ""
echo "  Features: "
echo "    CUIs in the same abstract as the target word"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --cuicount "--ngram 1" --directory KCUI-Windowing.dir.nb.abstract KCUI-Windowing.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --cuicount "--ngram 1" --directory KCUI-Windowing.dir.nb.abstract KCUI-Windowing.dir.mm

echo ""
echo "  Features: "
echo "    CUIs in the same sentence as the target word"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --sentence --cv 10 --cuicount "--ngram 1" --directory KCUI-Windowing.dir.nb.sentence KCUI-Windowing.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --sentence --cv 10 --cuicount "--ngram 1" --directory KCUI-Windowing.dir.nb.sentence KCUI-Windowing.dir.mm

echo ""
echo "  Features: "
echo "    CUIs in the same phrase as the target word"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --phrase --cv 10 --cuicount "--ngram 1" --directory KCUI-Windowing.dir.nb.phrase KCUI-Windowing.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --phrase --cv 10 --cuicount "--ngram 1" --directory KCUI-Windowing.dir.nb.phrase KCUI-Windowing.dir.mm

echo "  Features: "
echo "    CUIs in the same abstract as the target word"
echo "  Algorithm: ";
echo "    WEKA's Support Vector Machine  (weka.classifiers.functions.SMO)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --cuicount "--ngram 1"  --weka weka.classifiers.functions.SMO --directory KCUI-Windowing.dir.smo.abstract KCUI-Windowing.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --cuicount "--ngram 1"  --weka weka.classifiers.functions.SMO --directory KCUI-Windowing.dir.smo.abstract KCUI-Windowing.dir.mm

echo "  Features: "
echo "    CUIs in the same sentence as the target word"
echo "  Algorithm: ";
echo "    WEKA's Support Vector Machine  (weka.classifiers.functions.SMO)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --sentence --cv 10 --cuicount "--ngram 1"  --weka weka.classifiers.functions.SMO --directory KCUI-Windowing.dir.smo.sentence KCUI-Windowing.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --sentence --cv 10 --cuicount "--ngram 1"  --weka weka.classifiers.functions.SMO --directory KCUI-Windowing.dir.smo.sentence KCUI-Windowing.dir.mm

echo "  Features: "
echo "    CUIs in the same phrase as the target word"
echo "  Algorithm: ";
echo "    WEKA's Support Vector Machine  (weka.classifiers.functions.SMO)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --phrase --cv 10 --cuicount "--ngram 1"  --weka weka.classifiers.functions.SMO --directory KCUI-Windowing.dir.smo.phrase KCUI-Windowing.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --phrase --cv 10 --cuicount "--ngram 1"  --weka weka.classifiers.functions.SMO --directory KCUI-Windowing.dir.smo.phrase KCUI-Windowing.dir.mm

