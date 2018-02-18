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

#  Test for create-vectors.pl
    
##############################################################################

echo "Test 1 : Checking --cuidef option"
    
echo "create-vectors.pl --stop CUITOOLSHOME/default_options/stoplist --cuidef --training data/adjustment.trainingdata --instances data/adjustment.mm --senses data/adjustment.choices --tw adjustment  create-vectors.log"

create-vectors.pl --stop CUITOOLSHOME/default_options/stoplist --cuidef --training data/adjustment.trainingdata --instances data/adjustment.mm --senses data/adjustment.choices --tw adjustment create-vectors.log 

diff create-vectors.log/adjustment.senses.sval output/adjustment.senses.sval.cuidef > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between create-vectors.log/adjustment.senses.sval and output/adjustment.senses.sval.cuidef"
    exit;
endif

rm -rf create-vectors.log difference


############################################################################## 
echo "Test 2 : Checking --context o2 option"
    
echo "create-vectors.pl --stop CUITOOLSHOME/default_options/stoplist --cuidef --training data/adjustment.trainingdata --instances data/adjustment.mm --senses data/adjustment.choices --tw adjustment --context o2  create-vectors.log"

create-vectors.pl --stop CUITOOLSHOME/default_options/stoplist --cuidef --training data/adjustment.trainingdata --instances data/adjustment.mm --senses data/adjustment.choices --tw adjustment  --context o2 create-vectors.log 

diff create-vectors.log/adjustment.senses.sval output/adjustment.senses.sval.cuidef > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between create-vectors.log/adjustment.senses.sval and output/adjustment.senses.sval.cuidef"
    exit;
endif

rm -rf create-vectors.log difference

##############################################################################   
echo "Test 3 : Checking --context o1 option"
    
echo "create-vectors.pl --stop CUITOOLSHOME/default_options/stoplist --cuidef --training data/adjustment.trainingdata --instances data/adjustment.mm --senses data/adjustment.choices --tw adjustment --context o1 create-vectors.log"

create-vectors.pl --stop CUITOOLSHOME/default_options/stoplist --cuidef --training data/adjustment.trainingdata --instances data/adjustment.mm --senses data/adjustment.choices --tw adjustment --context o1 create-vectors.log 

diff create-vectors.log/adjustment.senses.sval output/adjustment.senses.sval.cuidef > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between create-vectors.log/adjustment.senses.sval and output/adjustment.senses.sval.cuidef"
    exit;
endif

rm -rf create-vectors.log difference
