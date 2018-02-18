#!/bin/csh

set dirlist = `ls`
foreach dir ($dirlist)
    echo "DIR : $dir"
    if($dir =~ "CVS") then
	echo "In $dir directory ... moving on ..."
    else if(-d $dir) then
	cd $dir
	echo ""
	echo "In Directory $dir";
	if(-d external) then
	    cd external
	    echo "  In $dir/external"
	    set newlist = `ls`
	    foreach test ($newlist)
		if($test =~ "CVS") then 
		else
		    cd $test
		    echo "    Starting Test $test"
		    ./normal-op.sh
		    cd ..
		endif
	    end
	endif
	if(-d internal) then 
	    cd internal
	    echo "  In $dir/internal"
	    set newlist = `ls`
	    foreach test ($newlist)
		if($test =~ "CVS") then 
		else
		    cd $test
		    echo "    Starting Test $test"
		    ./normal-op.sh
		    cd ..
		endif
	    end
	endif
	cd ..
	cd ..
    endif
end
