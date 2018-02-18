#!/bin/csh
# Shell Test script to run all tests which check normal behavior of 
# x-fold.pl
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

#  Test for x-fold.pl
    
echo "Test 1 : Checking --fold option"
    
echo "x-fold.pl --fold 5 results data/data.mm"

x-fold.pl --fold 5 results data/data.mm

cd results

set dirlist = `ls *.test`
foreach i ($dirlist)
    echo $i
    grep "instance id" $i | wc > $i.check
    diff $i.check ../sub-1.output/$i > difference
    if (-z difference) then
	echo "Status: OK\!\! Output matches target output"
    else
	echo "Status: ERROR\!\! Following differences exist between results-1.test sub-1.output/output-1.test"
	cd ../
	exit
    endif
end

set dirlist = `ls *.train`
foreach i ($dirlist)
    echo $i
    grep "instance id" $i | wc > $i.check
    diff $i.check ../sub-1.output/$i > difference
    if (-z difference) then
	echo "Status: OK\!\! Output matches target output"
    else
	echo "Status: ERROR\!\! Following differences exist between $i.check sub-1.output/$i"
	cd ../
	exit
    endif
end

cd ../
rm -rf results

 #  Test for x-fold.pl
    
echo "Test 2 : Checking --fold option when it results in a split that "
echo "         that has less one instance in the fold files"

echo "x-fold.pl --fold 5 results data/data.mm"

x-fold.pl --fold 100 results data/data.mm > results.out

diff results.out sub-2.output > difference

if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-1.output and output.arff/adjustment.arff"
    exit;
endif
rm -rf  difference results.out results


 #  Test for x-fold.pl
    
echo "Test 3 : Checking --fold option when it results in a split that "
echo "         that has less one instance in the fold files"

echo "x-fold.pl --seed 42 --fold 10 results data/data.mm"

x-fold.pl --seed 42 --fold 10 results data/data.mm 

cd results

set dirlist = `ls *.test`
foreach i ($dirlist)
    echo $i
    diff $i ../sub-3.output/$i > difference
    if (-z difference) then
	echo "Status: OK\!\! Output matches target output"
    else
	echo "Status: ERROR\!\! Following differences exist between results/$i sub-3.output/$i"
	cd ../
	exit;
    endif
end

set dirlist = `ls *.train`
foreach i ($dirlist)
    echo $i
    diff $i ../sub-3.output/$i > difference
    if (-z difference) then
	echo "Status: OK\!\! Output matches target output"
    else
	echo "Status: ERROR\!\! Following differences exist between results/$i sub-3.output/$i"
	cd ../
	exit
    endif
end

cd ../
rm -rf results

 #  Test for x-fold.pl
    
echo "Test 4 : Checking --fold option when it results in a split that "
echo "         that has less one instance in the fold files"

echo "x-fold.pl --seed 42 --fold 10 results data/data.mm"

x-fold.pl --seed 2 --fold 10 results data/data.mm 

cd results

set dirlist = `ls *.test`
foreach i ($dirlist)
    echo $i
    diff $i ../sub-4.output/$i > difference
    if (-z difference) then
	echo "Status: OK\!\! Output matches target output"
    else
	echo "Status: ERROR\!\! Following differences exist between results/$i sub-4.output/$i"
	cd ../
	exit;
    endif
end

set dirlist = `ls *.train`
foreach i ($dirlist)
    echo $i
    diff $i ../sub-4.output/$i > difference
    if (-z difference) then
	echo "Status: OK\!\! Output matches target output"
    else
	echo "Status: ERROR\!\! Following differences exist between results/$i sub-4.output/$i"
	cd ../
	exit
    endif
end

cd ../
rm -rf results difference


