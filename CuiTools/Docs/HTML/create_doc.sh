#!/bin/csh

# This script file creates .html files for all .pl present in the SC's root directory
# eg: currently it creates discriminate.html for discriminate.pl and setup.html for setup.pl 
# This also calls traverse.sh script which does the same task as of this script with the difference
# that it creates .html files for .pl files of bin directory.

# This script has been  modified to create .html files for all the .pl in CuiTools

if($#argv != 1) then
	echo "Usage: create_doc.sh  PATH_2_CUITOOLS";
	exit 1;
endif

# path to SenseClusters
set CUITOOLS = $1
cd $CUITOOLS

set DOCS = "$CUITOOLS/Docs"
if(! -e $DOCS) then
	mkdir $DOCS 
endif

set perls=`ls *.pl`
foreach perl_file ($perls)
	set program = `echo $perl_file | sed 's/\.pl//'`
	pod2html --title $perl_file $perl_file > $DOCS/HTML/$program.html
	/bin/rm pod2ht*
end

if(! -e "$DOCS/HTML/src_Docs") then
	mkdir "$DOCS/HTML/src_Docs"
endif

cd src
	traverse.sh "$DOCS/HTML/src_Docs"
cd ..
