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

#  Test for mm2arff.pl with part of speech option (pos)

echo "Test 1 : Checking POS option"
echo "         mm2arff.pl --pos output mm/art.mm"
 
mm2arff.pl --pos output mm/art.mm

diff output.arff sub-1.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output.arff"
else
    echo "Status: ERROR\!\! Following differences exist between sub-1.output and output"
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 2 : Checking semantic type option"
echo "          mm2arff.pl --stcount "--ngram 1" output mm/art.mm"

mm2arff.pl --stcount "--ngram 1" output mm/art.mm

diff output.arff sub-2.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-2.output and output"
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff


#############################################################################

echo "Test 3 : Checking the sentence semantic type option"
echo "         mm2arff.pl --sentence --stcount "--ngram 1" output mm/art.mm"

mm2arff.pl --sentence --stcount "--ngram 1" output mm/art.mm

diff output.arff sub-3.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-3.output and output"    
    exit
endif

rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 4 : Checking the phrase semantic type option"
echo "         mm2arff.pl --phrase --stcount "--ngram 1" output mm/art.mm"

mm2arff.pl --phrase --stcount "--ngram 1" output mm/art.mm

diff output.arff sub-4.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-4.output and output"
    
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 5 : Checking the cui option"
echo "         mm2arff.pl --cuicount "--ngram 1" output mm/art.mm"

mm2arff.pl --cuicount "--ngram 1" output mm/art.mm

diff output.arff sub-5.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-5.output and output.arff"
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 6 : Checking the cui option with frequency cutoff of 4"
echo "         mm2arff.pl --cuicount "--ngram 1 --frequency 4" output mm/art.mm"

mm2arff.pl --cuicount "--ngram 1 --frequency 4" output mm/art.mm

diff output.arff sub-6.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-6.output and output.arff"
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 7 : Checking the sentence cui option"
echo "         mm2arff.pl --cuicount "--ngram 1" --sentence output mm/art.mm"

mm2arff.pl --cuicount "--ngram 1" --sentence output mm/art.mm

diff output.arff sub-7.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-7.output and output.arff"
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 8 : Checking the phrase cui option"
echo "         mm2arff.pl --cuicount "--ngram 1" --phrase output mm/art.mm"

mm2arff.pl --cuicount "--ngram 1" --phrase output mm/art.mm

diff output.arff sub-8.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-8.output and output.arff"
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 9 : Checking the head word option"
echo "         mm2arff.pl --head output mm/art.mm"

mm2arff.pl --head output mm/art.mm

diff output.arff sub-9.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-9.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 10 : Checking the relation option"
echo "          mm2arff.pl --relation output mm/art.mm"

mm2arff.pl --relation output mm/art.mm

diff output.arff sub-10.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-10.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 11 : Checking the unigram option"
echo "          mm2arff.pl --ngramcount "--ngram 1" output mm/art.mm"

mm2arff.pl --ngramcount "--ngram 1" output mm/art.mm

diff output.arff sub-11.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-11.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 12 : Checking the sentence unigram option"
echo "          mm2arff.pl --ngramcount --sentence output mm/art.mm"

mm2arff.pl --ngramcount "--ngram 1" --sentence output mm/art.mm

diff output.arff sub-12.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-12.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 13 : Checking the phrase unigram option"
echo "          mm2arff.pl --ngramcount --phrase output mm/art.mm"

mm2arff.pl --ngramcount "--ngram 1" --phrase output mm/art.mm

diff output.arff sub-13.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-13.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 14 : Checking the unigram option with a frequency cutoff of 2"
echo "          mm2arff.pl --ngramcount "--ngram 1 --frequency 2" output mm/art.mm"

mm2arff.pl --ngramcount "--ngram 1 --frequency 2" output mm/art.mm

diff output.arff sub-14.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-14.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff


#############################################################################

echo "Test 15 : Checking the --ngramcount option for unigrams with a stop"
echo "          mm2arff.pl --ngramcount "--ngram 1 --stop default_options/stoplist" output mm/art.mm"
mm2arff.pl --ngramcount "--ngram 1 --stop $CUITOOLSHOME/default_options/stoplist" output mm/art.mm

diff output.arff sub-15.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-15.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff


#############################################################################

echo "Test 16 : Checking the --ngramcount option for bigrams cutoff of 1"
echo "          mm2arff.pl --ngramcount "--ngram 2 --frequency 1" output mm/art.mm"

mm2arff.pl --ngramcount "--ngram 2 --frequency 1" output mm/art.mm

diff output.arff sub-16.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-16.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################
 
echo "Test 17 : Checking the --ngramcount for trigrams with cutoff of 1"
echo "          mm2arff.pl --ngramcount "--ngram 3 --frequency 1" output mm/art.mm"

mm2arff.pl --ngramcount "--ngram 3 --frequency 1" output mm/art.mm

diff output.arff sub-17.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-17.output and output.arff"
    exit;
endif

rm -rf mm2arff.log output.input output.input.cnt difference output.arff

############################################################################# 

 
echo "Test 18 : Checking the --nspconfig option"
echo "          mm2arff.pl --nspconfig my.config output mm/art.mm"

mm2arff.pl --nspconfig my.config output mm/art.mm

diff output.arff sub-18.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-18.output and output.arff"
    exit;
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 19 : Checking the cui option"
echo "         mm2arff.pl --firstranked --cuicount "--ngram 1" output mm/art.mm"

mm2arff.pl --firstranked --cuicount "--ngram 1" output mm/art.mm

diff output.arff sub-19.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-19.output and output.arff"
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff

#############################################################################

echo "Test 20 : Checking the cui option"
echo "         mm2arff.pl --conflatedcuis --cuicount "--ngram 1" output mm/art.mm"

mm2arff.pl --conflatedcuis --cuicount "--ngram 1" output mm/art.mm

diff output.arff sub-20.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-20.output and output.arff"
    exit
endif
rm -rf mm2arff.log output.input output.input.cnt difference output.arff
