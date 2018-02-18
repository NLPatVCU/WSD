#!/usr/local/bin/perl -w

open(IN,$ARGV[0]);
$k=0;
while(<IN>)
{
	if(/<answer instance=\"(.*)\" senseid=\".*\"\/>/)
	{
		print "<answer instance=\"$1\" senseid=\"NOTAG\"\/>\n";
		next;
	}
	if(/<\/instance>/)
	{
		$k++;
	}
	print;
}
