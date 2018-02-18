#!/bin/csh

# This script sets up data in CuiTolls xml-like .mm format and runs the 
# disambiguation program simulating the similarity experiments in my thesis

if(-e sup-similarity-exp.dir.mm) then
    echo "sup-similarity-exp.dir.mm already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif

#  unigram-similarity experiment with cutoff = 2 but no stoplist
if(-e sup-unigram-similarity.arff) then
    echo "sup-unigram-similarity.arff already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif
if(-e sup-unigram-similarity.weka) then
    echo "sup-unigram-similarity.weka already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif

#  bigram-similarity experiment with cutoff = 2 but no stoplist
if(-e sup-bigram-similarity.arff) then
    echo "sup-bigram-similarity.arff already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif
if(-e sup-bigram-similarity.weka) then
    echo "sup-bigram-similarity.weka already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif
#  trigram-similarity experiment with cutoff = 2 but no stoplist
if(-e sup-trigram-similarity.arff) then
    echo "sup-trigram-similarity.arff already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif
if(-e sup-trigram-similarity.weka) then
    echo "sup-trigram-similarity.weka already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif

#  cui-unigram-similarity experiment with cutoff = 2 but no stoplist
if(-e sup-cui-unigram-similarity.arff) then
    echo "sup-cui-unigram-similarity.arff already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif
if(-e sup-cui-unigram-similarity.weka) then
    echo "sup-cui-unigram-similarity.weka already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif

#  cui-bigram-similarity experiment with cutoff = 2 but no stoplist
if(-e sup-cui-bigram-similarity.arff) then
    echo "sup-cui-bigram-similarity.arff already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif
if(-e sup-cui-bigram-similarity.weka) then
    echo "sup-cui-bigram-similarity.weka already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif
#  cui-trigram-similarity experiment with cutoff = 2 but no stoplist
if(-e sup-cui-trigram-similarity.arff) then
    echo "sup-cui-trigram-similarity.arff already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif
if(-e sup-cui-trigram-similarity.weka) then
    echo "sup-cui-trigram-similarity.weka already exists."
    echo "Remove directory before running sup-similarity-exp.sh"
    exit 1
endif

# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format.

echo "prolog2mm.pl --nlm --log sup-similarity-exp.dir.conversion.log sup-similarity-exp.dir.mm $NLMWSDHOME/Reviewed_Results"
prolog2mm.pl --nlm --log sup-similarity-exp.dir.conversion.log sup-similarity-exp.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE .MM DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING WEKA

echo "Re-creating the similarity results from the thesis"

echo "unigram-similarity experiments:"

echo "  Features: "
echo "    unigram-similaritys in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist with similarity"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 1 --frequency 2" --cv 10 --similarity --directory sup-unigram-similarity sup-similarity-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 1 --frequency 2" --cv 10 --similarity --directory sup-unigram-similarity sup-similarity-exp.dir.mm

echo "bigram-similarity experiments:"

echo "  Features: "
echo "    bigram-similaritys in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist with similarity"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 2 --frequency 2" --cv 10 --similarity --directory sup-bigram-similarity sup-similarity-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 2 --frequency 2" --cv 10 --similarity --directory sup-bigram-similarity sup-similarity-exp.dir.mm

echo "trigram-similarity experiments:"

echo "  Features: "
echo "    trigram-similaritys in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist with similarity"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 3 --frequency 2" --cv 10 --similarity --directory sup-trigram-similarity sup-similarity-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 3 --frequency 2" --cv 10 --similarity --directory sup-trigram-similarity sup-similarity-exp.dir.mm


echo "cui-unigram-similarity experiments:"

echo "  Features: "
echo "    cui-unigram-similaritys in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist with similarity"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 1 --frequency 2" --cv 10 --similarity --directory sup-cui-unigram-similarity sup-similarity-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 1 --frequency 2" --cv 10 --similarity --directory sup-cui-unigram-similarity sup-similarity-exp.dir.mm

echo "cui-bigram-similarity experiments:"

echo "  Features: "
echo "    cui-bigram-similaritys in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist with similarity"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 2 --frequency 2" --cv 10 --similarity --directory sup-cui-bigram-similarity sup-similarity-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 2 --frequency 2" --cv 10 --similarity --directory sup-cui-bigram-similarity sup-similarity-exp.dir.mm

echo "cui-trigram-similarity experiments:"

echo "  Features: "
echo "    cui-trigram-similaritys in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist with similarity"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 3 --frequency 2" --cv 10 --similarity --directory sup-cui-trigram-similarity sup-similarity-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 3 --frequency 2" --cv 10 --directory sup-cui-trigram-similarity sup-similarity-exp.dir.mm

