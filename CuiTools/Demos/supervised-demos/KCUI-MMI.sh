#!/bin/csh

# This script sets up data in CuiTolls xml-like .mm format and runs the 
# disambiguation program simulating the cui experiments in my thesis

if(-e KCUI-MMI.dir..mm) then
    echo "KCUI-MMI.dir.mm already exists."
    echo "Remove directory before running KCUI-MMI.sh"
    exit 1
endif


# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format.

echo "prolog2mm.pl --nlm --log KCUI-MMI.dir.log KCUI-MMI.dir.mm $NLMWSDHOME/Reviewed_Results"
prolog2mm.pl --nlm --log KCUI-MMI.dir.log KCUI-MMI.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE .MM DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING WEKA
echo "MMI Cutoff dissertation experiments:"

echo ""
echo "  Features: "
echo "    CUIs in the same abstract as the target word"
echo "    with an MMI cutoff of 10"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --mmi 10 --directory KCUI-MMI.10.nb.dir KCUI-MMI.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --mmi 10 --directory KCUI-MMI.10.nb.dir KCUI-MMI.dir.mm

echo ""
echo "  Features: "
echo "    CUIs in the same abstract as the target word"
echo "    with an MMI cutoff of 20"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --mmi 20 --directory KCUI-MMI.20.nb.dir KCUI-MMI.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --mmi 20 --directory KCUI-MMI.20.nb.dir KCUI-MMI.dir.mm

echo ""
echo "  Features: "
echo "    CUIs in the same abstract as the target word"
echo "    with an MMI cutoff of 10"
echo "  Algorithm: ";
echo "    WEKA's Support Vector Machine  (weka.classifiers.functions.SMO)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --mmi 10  --weka weka.classifiers.functions.SMO --directory KCUI-MMI.10.smo.dir KCUI-MMI.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --mmi 10  --weka weka.classifiers.functions.SMO --directory KCUI-MMI.10.smo.dir KCUI-MMI.dir.mm

echo ""
echo "  Features: "
echo "    CUIs in the same abstract as the target word"
echo "    with an MMI cutoff of 20"
echo "  Algorithm: ";
echo "    WEKA's Support Vector Machine  (weka.classifiers.functions.SMO)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --mmi 20 --weka weka.classifiers.functions.SMO --directory KCUI-MMI.20.smo.dir KCUI-MMI.dir.mm"
echo ""

supervised-disambiguate.pl --wekaparams "-s 42" --cv 10 --mmi 20 --weka weka.classifiers.functions.SMO --directory KCUI-MMI.20.smo.dir KCUI-MMI.dir.mm

