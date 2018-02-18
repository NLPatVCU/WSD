#!/usr/bin/perl

#  NLM-WSD Reviewed_Results directory
my $source = "$ENV{NLMWSDHOME}/Reviewed_Results";

#  DESTINATION directory
my $dest = "$ENV{HOME}/work/new";

#  The MRCON FILE
my $mrconFile = "/nfsvol/nlsaux5/nls/umls_on_aux5/UMLS1999/META/MRCON";

#  The MRSTY FILE
my $mrstyFile = "/nfsvol/nlsaux5/nls/umls_on_aux5/UMLS1999/META/MRSTY";

#  hash variables
my %mrcon  = ();
my %mrsty  = ();
my %num_st = ();

#  get the MRCON information
open(MRCON, $mrconFile) || die "Could not open MRCON file\n";
while(<MRCON>) {
    chomp;
    my @array = split/\|/;
    $mrcon{lc($array[6])}{$array[0]}++;
} close MRCON;

#  get the MRSTY information
open(MRSTY, $mrstyFile) || die "Could not open MRSTY file\n";
while(<MRSTY>) {
    chomp;
    my @array = split/\|/;
    $mrsty{$array[0]}{$array[2]}++;
    $num_st{$array[0]}++;
}

#  get the target words from the NLM-WSD dataset
opendir(DIR, $source) || die "Could not open source directory: $source\n";
my @files = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and $_ ne "raw_summary" and $_ ne "index.shtml"} readdir DIR;


foreach my $tw (@files) {

    my $file        = "$source/$tw/choices";    
    my $destination = "$dest/$tw.choices";
    
    open(DST, ">$destination") || die "FILE $destination\n";

    open(FILE, $file) || die "Could not open $file\n";

    while(<FILE>) {
	chomp;
	my($tag, $term, $st) = split/\|/;

	my $cui = "";
	
	#  set the possible term
	my $pterm = $term;
	$pterm=~s/\(.*?\)//g;
	$pterm=~s/[\(\)]//g;
	$pterm=~s/^\s+//g;
	$pterm=~s/\s+$//g;

	#  problem with spacing and number in the term
	$pterm=~s/([A-Za-z])(\<[0-9]\>)/$1 $2/;
	$pterm=~s/(NOS) \<[0-9]\>/NOS/;

	#  get the associated semantic types
	my %sthash = ();
	while($st=~/([a-z][a-z][a-z][a-z])\, ([A-Za-z\s\,]+)\;?/g) { 
	    my $possible_st = $2;
	    if($tw eq "lead" and $possible_st eq "elii, Element, Ion, or Isotope") {
		$possible_st=~s/elii\, //g;
	    }
	    $sthash{$possible_st}++; 
	}

	#  get the semantic types associated with the concept
	my $stkeys = keys %sthash;

	#  check the semantic types for each of the possible cuis 
	#  associated with this term when there is a match print
	foreach my $possible_cui (sort keys %{$mrcon{lc($pterm)}}) {
	    
	    if($stkeys != $num_st{$possible_cui}) { next; }

	    my $flag = 1; 
	    foreach my $possible_st (sort keys %sthash) {
		if($flag == 0) { next; }
		if(!(exists ($mrsty{$possible_cui}{$possible_st}))) { $flag = 0; }
	    }
	    if($flag == 1) {
		print DST "$tag|$term|$st|$possible_cui\n";
	    }
	}
    }   
}
	 
