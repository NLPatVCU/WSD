#!/bin/csh

# This script sets up data in an .mm format that is used by the 
# disambiguate.pl program. That means that there is a directory 
# created (called .mm) that contains subdirectories, one for each 
# word we wish to sense discriminate. 
    
if(-e make-MetaMapNLM-data.mm) then
    echo "make-MetaMapNLM-data.mm already exists."
    echo "Remove the directory before running make-MetaMapNLM-data.sh"
    exit 1
endif

# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format. Hence, the content surrrounding the 
#  target word will be at the abstract level

echo "Running nlm2mm.pl ..."

echo ""

echo "nlm2mm.pl --log make-MetaMapNLM-data.log make-MetaMapNLM-data.mm $NLMWSDHOME/Basic_Reviewed_Results"
echo ""

nlm2mm.pl --log make-MetaMapNLM-data.log make-MetaMapNLM-data.mm $NLMWSDHOME/Basic_Reviewed_Results

echo "Program complete - result in make-MetaMapNLM-data.mm"
