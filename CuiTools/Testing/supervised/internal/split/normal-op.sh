#!/bin/csh
# Shell Test script to run all tests which check normal behavior of 
# split.pl
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

#  Test for split.pl
    
echo "Test 1 : Checking --split option"
    
echo "split.pl --split 50 results data/data.mm"

split.pl --split 50 results data/data.mm

grep "instance id" results.test | wc > results-1.test
grep "instance id" results.train | wc > results-1.train

diff results-1.test output/output-1.test > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between results-1.test output/output-1.test"
    exit
endif
diff results-1.train output/output-1.train > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between results-1.train output/output-1.train"
    exit
endif

rm -rf results* difference

#  Test for split.pl
    
echo "Test 2 : Checking the default option"
    
echo "split.pl results data/data.mm"

split.pl --split 5 results data/data.mm

grep "instance id" results.test | wc > results-2.test
grep "instance id" results.train | wc > results-2.train

diff results-2.test output/output-2.test > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between results-2.test output/output-2.test"
    exit
endif
diff results-2.train output/output-2.train > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between results-2.train output/output-2.train"
    exit
endif

rm -rf results* difference




