Testing for mm2arff.pl
-------------------------
Bridget T. McInnes
bthomson@cs.umn.edu

2007-04-30

1. Introduction: 
----------------

We have tested mm2arff.pl, a component of NAME version 0.1. 
Following is a description of the aspects of mm2arff.pl that 
we have tested. 

Also provided below is an inventory of the
various files in this directory (SenseTools-0.1/Testing/nsp2regex),
and the role of each file. We provide the scripts and files used for
testing so that later versions of preprocess.pl can be tested for
backward compatibility. 

2. Phase1 Testing of Commandline Options:
-------------------------------------------------------

Following are the various subtests involved in this test:

Subtest  1: Testing mm2arff.pl  --pos
Subtest  2: Testing mm2arff.pl  --st --context
Subtest  3: Testing mm2arff.pl  --st --sentence
Subtest  4: Testing mm2arff.pl  --st --phrase
Subtest  5: Testing mm2arff.pl  --cui
Subtest  6: Testing mm2arff.pl  --cui --cutoff 5
Subtest  7: Testing mm2arff.pl  --cui --sentence
Subtest  8: Testing mm2arff.pl  --cui --phrase
Subtest  9: Testing mm2arff.pl  --head
Subtest  10: Testing mm2arff.pl --relation
Subtest  11: Testing mm2arff.pl --unigram
Subtest  12: Testing mm2arff.pl --unigram --sentence
Subtest  13: Testing mm2arff.pl --unigram --phrase
Subtest  14: Testing mm2arff.pl --unigram --cutoff 3
Subtest  15: Testing mm2arff.pl --unigram --stop 

------------------------------------------

The source file for Subtest 2i: sub-i.source
The required output file for Subtest 2i: sub-i.output



2.2 Details of Phase 2: Evaluation of Execution Time on Big Files:
------------------------------------------------------------------

Run on following architecture: Linux running Ubuntu 6.10

time nsp2regex.pl big.bigram > big.regex
13.620u 0.440s 0:15.93 88.2%	0+0k 0+0io 316pf+0w

wc output on big.bigram:

137376  412122 3154593

3. Conclusion:
--------------

The major features of mm2arff.pl have been tested. 


