#!/bin/csh

# This script sets up data in CuiTolls xml-like .mm format and runs the 
# disambiguation program simulating the ngram experiments in my thesis

if(-e sup-ngram-exp.dir.mm) then
    echo "sup-ngram-exp.dir.mm already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif

#  unigram experiment with cutoff = 2 but no stoplist
if(-e sup-unigram.arff) then
    echo "sup-unigram.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-unigram.weka) then
    echo "sup-unigram.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
#  unigram experiment with cutoff = 2 with stoplist
if(-e sup-unigram-stop.arff) then
    echo "sup-unigram-stop.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-unigram-stop.weka) then
    echo "sup-unigram-stop.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif

#  unigram experiment with cutoff = 2 with idf stoplist
if(-e sup-unigram-idfstop.arff) then
    echo "sup-unigram-idfstop.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-unigram-idfstop.weka) then
    echo "sup-unigram-idfstop.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif

#  bigram experiment with cutoff = 2 but no stoplist
if(-e sup-bigram.arff) then
    echo "sup-bigram.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-bigram.weka) then
    echo "sup-bigram.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
#  bigram experiment with cutoff = 2 with stoplist
if(-e sup-bigram-stop.arff) then
    echo "sup-bigram-stop.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-bigram-stop.weka) then
    echo "sup-bigram-stop.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
#  bigram experiment with cutoff = 2 with idf stoplist
if(-e sup-bigram-idfstop.arff) then
    echo "sup-bigram-idfstop.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-bigram-idfstop.weka) then
    echo "sup-bigram-idfstop.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif

#  trigram experiment with cutoff = 2 but no stoplist
if(-e sup-trigram.arff) then
    echo "sup-trigram.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-trigram.weka) then
    echo "sup-trigram.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
#  trigram experiment with cutoff = 2 with stoplist
if(-e sup-trigram-stop.arff) then
    echo "sup-trigram-stop.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-trigram-stop.weka) then
    echo "sup-trigram-stop.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif

#  trigram experiment with cutoff = 2 with idf stoplist
if(-e sup-trigram-idfstop.arff) then
    echo "sup-trigram-idfstop.arff already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif
if(-e sup-trigram-idfstop.weka) then
    echo "sup-trigram-idfstop.weka already exists."
    echo "Remove directory before running sup-ngram-exp.sh"
    exit 1
endif


# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly


# CONVERT NLM-WSD FORMATED DATA TO .mm

echo "Converting the NLM-WSD formated data to .mm format."

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format.

echo "prolog2mm.pl --nlm --log sup-ngram-exp.dir.conversion.log sup-ngram-exp.dir.mm $NLMWSDHOME/Reviewed_Results"
prolog2mm.pl --nlm --log sup-ngram-exp.dir.conversion.log sup-ngram-exp.dir.mm $NLMWSDHOME/Reviewed_Results

echo ""

#  CREATE THE ARFF FILES FOR THE .MM DATA SET AND
#  DISAMBIGUATE THE TARGET WORDS USING WEKA

echo "Re-creating the ngram results from the thesis"

echo "unigram experiments:"

echo "  Features: "
echo "    unigrams in the same abstract as the target word"
echo "    with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --ngramcount "--ngram 1 --frequency 2" --cv 10 --directory sup-unigram sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --ngramcount "--ngram 1 --frequency 2" --cv 10 --directory sup-unigram sup-ngram-exp.dir.mm

echo "  Features: "
echo "    unigrams in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 1 --frequency 2" --cv 10 --directory sup-unigram-stop sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 1 --frequency 2" --cv 10 --directory sup-unigram-stop sup-ngram-exp.dir.mm

echo "  Features: "
echo "    unigrams in the same abstract as the target word"
echo "    with a cutoff of two and using the idf stoplist"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --idfstop /home/bridget/work/2005_baseline_stoplist/stop.1/ --ngramcount "--ngram 1 --frequency 2" --cv 10 --directory sup-unigram-idfstop sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --idfstop /home/bridget/work/2005_baseline_stoplist/stop.1/ --ngramcount "--ngram 1 --frequency 2" --cv 10 --directory sup-unigram-idstop sup-ngram-exp.dir.mm

echo "bigram experiments:"

echo "  Features: "
echo "    bigrams in the same abstract as the target word"
echo "    with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --ngramcount "--ngram 2 --frequency 2" --cv 10 --directory sup-bigram sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --ngramcount "--ngram 2 --frequency 2" --cv 10 --directory sup-bigram sup-ngram-exp.dir.mm

echo "  Features: "
echo "    bigrams in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 2 --frequency 2" --cv 10 --directory sup-bigram-stop sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 2 --frequency 2" --cv 10 --directory sup-bigram-stop sup-ngram-exp.dir.mm

echo "  Features: "
echo "    bigrams in the same abstract as the target word"
echo "    with a cutoff of two and using the idf stoplist"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --idfstop /home/bridget/work/2005_baseline_stoplist/stop.1/ --ngramcount "--ngram 2 --frequency 2" --cv 10 --directory sup-bigram-idfstop sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --idfstop /home/bridget/work/2005_baseline_stoplist/stop.1/ --ngramcount "--ngram 2 --frequency 2" --cv 10 --directory sup-bigram-idfstop sup-ngram-exp.dir.mm

echo "trigram experiments:"

echo "  Features: "
echo "    trigrams in the same abstract as the target word"
echo "    with a cutoff of two"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --ngramcount "--ngram 3 --frequency 2" --cv 10 --directory sup-trigram sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --ngramcount "--ngram 3 --frequency 2" --cv 10 --directory sup-trigram sup-ngram-exp.dir.mm

echo "  Features: "
echo "    trigrams in the same abstract as the target word"
echo "    with a cutoff of two and a stoplist"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 3 --frequency 2" --cv 10 --directory sup-trigram-stop sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --stop $CUITOOLSHOME/default_options/stoplist --ngramcount "--ngram 3 --frequency 2" --cv 10 --directory sup-trigram-stop sup-ngram-exp.dir.mm

echo "  Features: "
echo "    trigrams in the same abstract as the target word"
echo "    with a cutoff of two and using the idf stoplist"
echo "  Algorithm: ";
echo "    WEKA's Naive Bayes Algorithm  (weka.classifiers.bayes.NaiveBayes)"
echo "    using our 10 fold cross validation (--cv 10)"
echo ""

echo "supervised-disambiguate.pl --idfstop /home/bridget/work/2005_baseline_stoplist/stop.1/ --ngramcount "--ngram 3 --frequency 2" --cv 10 --directory sup-trigram-idfstop sup-ngram-exp.dir.mm"
echo""

supervised-disambiguate.pl --idfstop /home/bridget/work/2005_baseline_stoplist/stop.1/ --ngramcount "--ngram 3 --frequency 2" --cv 10 --directory sup-trigram-idfstop sup-ngram-exp.dir.mm


