#!/bin/csh
# Shell Test script to run all tests which check normal behavior of 
# unsupervised-disambiguate.pl
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

echo "Test 1 : Checking default option"
echo "         unsupervised-disambiguate.pl --training training/adjustment.trainingdata --senses senses/adjustment.choices --directory dir mm/adjustment.mm/"

unsupervised-disambiguate.pl --training training/adjustment.trainingdata --senses senses/adjustment.choices --directory dir mm/adjustment.mm
 
diff "dir.log/adjustment.unigrams" test-1.output > difference
     
if (-z difference) then
else
    echo "Status: ERROR\!\! Following differences exist between dir.log/adjustment.unigrams and test-1.output"
    exit;
endif
if(-e dir.results/OverallResults) then 
    echo "Status: OK\!\! Output matches target output"
else 
    echo "Status: ERROR\!\! output is empty or does not exist"
    exit;
endif
rm -rf  difference

##############################################################################

echo "Test 2 : Checking --stop option"
echo "         unsupervised-disambiguate.pl --training training/adjustment.trainingdata --senses senses/adjustment.choices --directory dir --etop $CUITOOLSHOME/default_options/stoplist mm/adjustment.mm"

unsupervised-disambiguate.pl --training training/adjustment.trainingdata --senses senses/adjustment.choices --directory dir --stop $CUITOOLSHOME/default_options/stoplist mm/adjustment.mm

diff dir.log/adjustment.unigrams test-2.output > difference

if (-z difference) then
else
    echo "Status: ERROR\!\! Following differences exist between dir.log/adjustment.unigrams and test-2.output"
    exit;
endif
if(-e dir.results/OverallResults) then 
    echo "Status: OK\!\! Output matches target output"
else 
    echo "Status: ERROR\!\! output is empty or does not exist"
    exit;
endif

rm -rf dir.log dir.results  difference

##############################################################################

echo "Test 3 : Checking --cuidef option"
echo "         unsupervised-disambiguate.pl --training training/adjustment.trainingdata --senses senses/adjustment.choices --cuidef --directory dir mm/adjustment.mm"

unsupervised-disambiguate.pl --training training/adjustment.trainingdata --senses senses/adjustment.choices --cuidef --directory dir mm/adjustment.mm

diff dir.log/adjustment.senses.plain test-3.output > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between dir.log/adjustment.senses.plain and test-3.output"
    exit;
endif

rm -rf dir.log dir.results  output difference

##############################################################################
