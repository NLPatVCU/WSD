#!/bin/csh
# Shell Test script to run all tests which check normal behavior of 
# mm2arff.pl
# normal-op.sh version 0.01
# By Bridget T. McInnes 30/04/07

# Copyright (c) 2007
# Bridget T. McInnes, University of Minnesota
# bthomson@cs.umn.edu
# Ted Pedersen, University of Minnesota, Duluth
# tpederse@umn.edu

#############################################################################
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

##############################################################################

echo "Test 1 : Checking --POS option"
echo "         supervised-disambiguate.pl --pos --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --pos --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-1.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-1.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 2 : Checking --head option"
echo "         supervised-disambiguate.pl --head --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --head --wekacv 10 --directory output mm/

diff output.arff/adjustment.arff sub-2.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-2.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 3 : Checking --ngramcount "--ngram 1" option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --ngramcount "--ngram 1" --wekacv 10 --directory output mm/

diff output.arff/adjustment.arff sub-3.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-3.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference


#############################################################################
echo "Test 4 : Checking --ngramcount and --ngramstat and --ngrammeasure option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 2" --ngrammeasure "ll.pm" --ngramstat "--score 3.841" --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --ngramcount "--ngram 2" --ngrammeasure "ll.pm" --ngramstat "--score 3.841" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-4.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-4.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 5 : Checking --ngramcount and --ngrammeasure without the --ngramstat option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 2" --ngrammeasure "ll.pm" --wekacv 10 --directory output mm/adjustment.mm" 

supervised-disambiguate.pl --ngramcount "--ngram 2" --ngrammeasure "ll.pm" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-5.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-5.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 6 : Checking --cuicount option"
echo "         supervised-disambiguate.pl --cuicount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --cuicount "--ngram 1" --wekacv 10 --directory output mm/

diff output.arff/adjustment.arff sub-6.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-6.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 7 : Checking --st option"
echo "         supervised-disambiguate.pl --stcount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --stcount "--ngram 1" --wekacv 10 --directory output mm/

diff output.arff/adjustment.arff sub-7.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-7.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 8 : Checking --relations option"
echo "         supervised-disambiguate.pl --relation --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --relation --wekacv 10 --directory output mm/

diff output.arff/adjustment.arff sub-8.output > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-8.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 9 : Checking ngramcount option with a frequency cutoff of 2"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1 --frequency 2" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1 --frequency 2" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-9.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-9.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 10 : Checking --stop option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1 --stop $CUITOOLSHOME/default_options/stoplist" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1 --stop $CUITOOLSHOME/default_options/stoplist" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-10.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-10.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 11 : Checking --punc option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --punc --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --punc --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-11.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-11.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 12 : Checking --phrase option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --phrase --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --phrase --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-12.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-12.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 13 : Checking --sentence option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --sentence --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --sentence --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-13.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-13.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 14 : Checking --line option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --line --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --line --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-14.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-14.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 15 : Checking --weka option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --weka weka.classifiers.functions.SMO --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --weka weka.classifiers.functions.SMO --wekacv 10 --directory output mm/adjustment.mm

if (-e output.weka) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! output.weka/adjustment.weka is empty or does not exist"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 16 : Checking --wekacv option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm

if (-e output.weka/adjustment.weka) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! output.weka/adjustment.weka is empty or does not exist"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 17 : Checking --split option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --split 25 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --split 25 --directory output mm/adjustment.mm

if(-e output.weka/adjustment.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.weka is empty or does not exist"
    exit;
endif
if(-e output.arff/adjustment.arff.test.arff) then 
else 
    echo "Status: ERROR\!\! output.arff/adjustment.arff.test.arff is empty or does not exist"
    exit;
endif
if(-e output.arff/adjustment.arff.train.arff) then 
    echo "Status: OK\!\! Output matches target output"
else 
    echo "Status: ERROR\!\! output.arff/adjustment.arff.train.arff is empty or does not exist"
    exit;
endif
rm -rf output.* difference


#############################################################################

echo "Test 18 : Checking --cv option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --cv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --cv 10 --directory output mm/adjustment.mm

if(-e output.weka/adjustment.1.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.1.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.2.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.2.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.3.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.3.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.4.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.4.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.5.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.5.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.6.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.6.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.7.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.7.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.8.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.8.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.9.weka) then 
else 
    echo "Status: ERROR\!\! output.weka/adjustment.9.weka is empty or does not exist"
    exit;
endif
if(-e output.weka/adjustment.10.weka) then 
    echo "Status: OK\!\! Output matches target output"
else 
    echo "Status: ERROR\!\! output.weka/adjustment.10.weka is empty or does not exist"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 19 : Checking --ngramcount for bigrams\n";
echo "         supervised-disambiguate.pl --ngramcount "--ngram 2 --frequency 2" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 2 --frequency 2" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-19.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-19.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 20 : Checking --cuicount option with a frequency cutoff of 2"
echo "         supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 2" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --cuicount "--ngram 1 --frequency 2" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-20.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-20.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 21 : Checking --stcount option with a frequency cutoff of 2"
echo "         supervised-disambiguate.pl --stcount "--ngram 1 --frequency 2" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --stcount "--ngram 1 --frequency 2" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-21.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-21.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 22 : Checking --test and --nokey options"
echo "         supervised-disambiguate.pl --stcount "--ngram 1 --frequency 1" --test test.mm --nokey  --directory output mm/adjustment.mm"

supervised-disambiguate.pl --stcount "--ngram 1 --frequency 1" --test test.mm --nokey  --directory output mm/adjustment.mm 

if(-e output.weka/adjustment.weka.test.answers) then
    echo "Status: OK\!\! Output matches target output"
else 
    echo "Status: ERROR\!\! output.weka/adjustment.weka.test.answers is empty or does not exist"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 23 : Checking --ngramcount --ngram 1 option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-23.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-23.output and output.arff/adjustment.arff"
    exit
endif
rm -rf output.* difference

#############################################################################

echo "Test 24 : Checking --ngramcount --ngram 2 option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 2" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 2" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-24.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-24.output and output.arff/adjustment.arff"
    exit
endif
rm -rf output.* difference

#############################################################################

echo "Test 25 : Checking --ngramcount --ngram 3 option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 3" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 3" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-25.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-25.output and output.arff/adjustment.arff"
    exit
endif
rm -rf output.* difference

#############################################################################

echo "Test 26 : Checking --ngramcount --ngram 4 option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 4" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 4" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-26.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-26.output and output.arff/adjustment.arff"
    exit
endif
rm -rf output.* difference

#############################################################################

echo "Test 27 : Checking --ngramcount --ngram 5 option"
echo "         supervised-disambiguate.pl --ngramcount "--ngram 5" --wekacv 10 --directory output mm/adjustment.mm"

supervised-disambiguate.pl --ngramcount "--ngram 5" --wekacv 10 --directory output mm/adjustment.mm

diff output.arff/adjustment.arff sub-27.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-27.output and output.arff/adjustment.arff"
    exit
endif
rm -rf output.* difference

#############################################################################

echo "Test 28 : Checking defaults with --wekacv option"
echo "         supervised-disambiguate.pl --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --wekaparam "-s 42" --wekacv 10 --directory output mm/

diff output.results/OverallResults sub-28.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-28.output and output.results/OverallResults"
    exit;
endif

rm -rf output.* difference


#############################################################################

echo "Test 29 : Checking --conflatedcuis with --wekacv option"
echo "         supervised-disambiguate.pl --conflatedcuis --cuicount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --conflatedcuis --cuicount "--ngram 1" --wekaparam "-s 42" --wekacv 10 --directory output mm/

diff output.arff/adjustment.arff sub-29.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-29.output and output.arff/adjustment.arff"
    exit;
endif

rm -rf output.* difference



#############################################################################

echo "Test 30 : Checking --cuicount option with --firstranked"
echo "         supervised-disambiguate.pl --firstranked --cuicount "--ngram 1" --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --firstranked --cuicount "--ngram 1" --wekacv 10 --directory output mm/

diff output.arff/adjustment.arff sub-30.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-30.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

#############################################################################

echo "Test 31 : Checking --cuicount option"
echo "         supervised-disambiguate.pl --conflatedcuis --cuicount "--ngram 2" --wekacv 10 --directory output mm/adjustment.mm"
 
supervised-disambiguate.pl --conflatedcuis --cuicount "--ngram 2" --wekacv 10 --directory output mm/

diff output.arff/adjustment.arff sub-31.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-31.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf output.* difference

