Testing for plain2mm.pl
-------------------------
Bridget T. McInnes
bthomson@cs.umn.edu

2007-04-30

1. Introduction: 
----------------

We have tested plain2mm.pl, a component of NAME version 0.1. 
Following is a description of the aspects of plain2mm.pl that 
we have tested. 

Also provided below is an inventory of the
various files in this directory (SenseTools-0.1/Testing/nsp2regex),
and the role of each file. We provide the scripts and files used for
testing so that later versions of preprocess.pl can be tested for
backward compatibility. 

2. Phase1 Testing of Commandline Options:
-------------------------------------------------------

Following are the various subtests involved in this test:

Subtest  1: Testing plain2mm.pl

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

The major features of plain2mm.pl have been tested. 


