#!/bin/csh

# This script runs the experiments conducted for the PSB2011 workshop

if(! (-e PSB2011.data)) then
    echo "PSB2011.data needs to be downloaded, unzipped, untared and"
    echo "put in the Demo directory inorder to run this script."
    echo "You can download this data from:"
    echo ""
    echo "    https://sourceforge.net/projects/cuitools/files/"
    echo ""
    echo ""
    exit 1
endif
    

if(-e PSB2011.results) then
    echo "PSB2011.results directory already exists."
    echo "Remove directory before running PSB2011.sh"
    exit 1
endif

mkdir PSB2011.results

echo "Re-creating the unigram results from the PSB2011 paper"
echo "  Features: "
echo "    Unigrams in the same abstract with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Support Vector Machine"
echo "  Filter: ";
echo "    WEKA's InfoGain"
echo ""

mkdir PSB2011.results/unigram
perl run-psb2011-exp.pl unigram PSB2011.data

exit;
echo "Re-creating the bigram results from the PSB2011 paper"
echo "  Features: "
echo "    Bigrams in the same abstract with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Support Vector Machine"
echo "  Filter: ";
echo "    WEKA's InfoGain"
echo ""

mkdir PSB2011.results/bigram
perl run-psb2011-exp.pl bigram PSB2011.data

echo "Re-creating the semantic type from the PSB2011 paper"
echo "  Features: "
echo "    Semantic types  in the same abstract with a cutoff of five"
echo "  Algorithm: ";
echo "    WEKA's Support Vector Machine"
echo "  Filter: ";
echo "    WEKA's InfoGain"
echo ""

mkdir PSB2011.results/bigram
perl run-psb2011-exp.pl st PSB2011.data


echo "Generating the unigram statistics"
calculate-statistics.pl PSB2011.results/unigram

echo "Generating the bigram statistics"
calculate-statistics.pl PSB2011.results/bigram

echo "Generating the semantic type statistics"
calculate-statistics.pl PSB2011.results/st

