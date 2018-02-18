#!/bin/csh

echo "Test A4 for sval2plain.pl"
echo "Running sval2plain.pl test-A4.sval2"

sval2plain.pl --senseinfo test-A4.sval2 > test-A4.output

diff -w test-A4.output test-A4.reqd > var

if(-z var) then
	echo "Test Ok";
else
	echo "Test Error";
	echo "When tested against test-A4.reqd";
	cat var;
endif

/bin/rm -f var t0 t1 test-A4.output
 
