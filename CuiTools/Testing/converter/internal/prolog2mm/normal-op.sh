#!/bin/csh
# Shell Test script to run all tests which check normal behavior of 
# prolog2mm.pl
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

#  Test for prolog2mm.pl 
echo "Test 1: "
echo "prolog2mm.pl --log log mm prolog/"

prolog2mm.pl --log log mm prolog

diff mm/EMG.mm sub-1.output > difference
if (-z difference) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! Following differences exist between sub-1.output and mm/EMG.mm"
    exit
endif
rm -rf difference mm log
