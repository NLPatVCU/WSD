#!/bin/csh

# This script sets up data in an .mm format that is used by the 
# disambiguate.pl program. That means that there is a directory 
# created (called .mm) that contains subdirectories, one for each 
# word we wish to sense discriminate. 
    
if(-e make-originalNLM-withoutNone-data.mm) then
    echo "make-originalNLM-withoutNone-data.mm already exists."
    echo "Remove the directory before running make-originalNLM-withoutNone-data.sh"
    exit;
endif

# The NLM-WSD must be downloaded and opened via their instructions 
# and the environment variables NLMWSDHOME must be set. If it is 
# not set the programs will not run properly

#  This command will convert the entire abstract in the NLM-WSD 
#  data into .mm format. Hence, the content surrrounding the 
#  target word will be at the abstract level

echo "Running prolog2mm.pl ..."

echo ""
echo "prolog2mm.pl --nlm --log make-originalNLM-withoutNone-data.log --none make-originalNLM-withoutNone-data.mm $NLMWSDHOME/Reviewed_Results"
echo ""

prolog2mm.pl --nlm --log make-originalNLM-withoutNone-data.log --none make-originalNLM-withoutNone-data.mm $NLMWSDHOME/Reviewed_Results

echo "Program complete - results in make-originalNLM-withoutNone-data.mm"
