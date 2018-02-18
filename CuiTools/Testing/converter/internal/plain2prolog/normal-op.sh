#!/bin/csh
# Shell Test script to run all tests which check normal behavior of 
# plain2mm.pl
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

#  Test for plain2mm.pl 
echo "Test 1 :"
echo "plain2prolog.pl test-1.prolog test-1.plain "

plain2prolog.pl --log log test-1.prolog test-1.plain 

if (-e test-1.prolog/art/machine_output/cit.1) then
    echo "Status: OK\!\! Output matches target output"
else
    echo "Status: ERROR\!\! The file test-1.prolog/art/machine_output/cit.1 doesn't exist"
    exit;
endif
rm -rf difference test-1.prolog log
