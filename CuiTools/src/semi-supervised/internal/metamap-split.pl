#!/usr/bin/perl -w

#my $metamap_nlm_dir = "/export/scratch/Medline/2005/metamap.training.mm";
#my $metamap_nlm_dir = "/export/scratch/Medline/2005/mm.training.mm";

my $metamap_nlm_dir = "/export/scratch/work/metamap-instances/";
my $human_nlm_dir   = "/export/scratch/work/nlm-wsd.mm";

my $split_dir       = "/export/scratch/work/metamap-split";


opendir(NLM, $human_nlm_dir) || die "Could not open $nlm_human_dir\n";
my @files = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and  $_ ne "raw_summary" and $_ ne "index.shtml"} readdir NLM;

foreach my $file (@files) {
	    
    $file=~/(.*?)\.mm/; 
    my $target = $1;
	
    print "$target\n";

    my $human_file   = "$human_nlm_dir/$file";
    my $metamap_file = "$metamap_nlm_dir/$target.metamap.training.mm";
    #my $metamap_file = "$metamap_nlm_dir/$target.mm.training.mm";
    
    my %human_hash   = ();
    my %metamap_hash = ();
    
    my @id_array     = ();

    open(HUMAN, $human_file) || die "DIE: $human_file\n";
    open(METAMAP, $metamap_file) || die "DIE: $metamap_file\n";

    my $id   = "";
    my $line = "";

    while(<HUMAN>) {
	
	if($_=~/<corpus lang=\'en\'>/)           { next; }
	if($_=~/<lexelt item=\"\" senses=\"\">/) { next; }
	if($_=~/<\/lexelt>/)                     { next; }
	if($_=~/<\/corpus>/)                     { next; }

	$line .= $_;
	
	if($_=~/<instance id=\"(.*?)\" alias/) {
	    $id = $1; 
	    push @id_array, $id;
	}

	if($_=~/<\/instance>/) {
        
	    $human_hash{$id} = $line;
	    $id   = "";
	    $line = "";
	}    
    } close HUMAN;

    $metamap_count = 0;
 
    while(<METAMAP>) {
	
	if($_=~/<corpus lang=\'en\'>/)           { next; }
	if($_=~/<lexelt item=\"\" senses=\"\">/) { next; }
	if($_=~/<\/lexelt>/)                     { next; }
	if($_=~/<\/corpus>/)                     { next; }

	$line .= $_;
	
	if($_=~/<instance id=\"(.*?)\" alias/) {
	    $id = $1; $metamap_count++;
	}

	if($_=~/<\/instance>/) {
        
	    $metamap_hash{$id} = $line;
	    $id   = "";
	    $line = "";
	}    
    } close METAMAP;
    
    my $overflow   = 1;
    my $file_count = 1;
    my $counter    = 0;
    my $total      = 0;

    my $split = int($metamap_count / 10);

    print "$metamap_count : $split\n";

    my $target_split_dir = "$split_dir/$target";

    system "mkdir $target_split_dir";

    open(HDST, ">$target_split_dir/$target.human.$file_count") || 
	die "DST: $target.human.$file_count";
    open(MDST, ">$target_split_dir/$target.metamap.$file_count") || 
	die "DST: $target.metamap.$file_count";
	
    for my $i (1..100) {
       
	my $random_number = int(rand(100));	     
	
	if($total >= $metamap_count) { next; }

	while( ($id_array[$random_number] == 1) or 
               (! (exists $metamap_hash{$id_array[$random_number]})) ) {
	    $random_number = int(rand(100));
	}
		
	$total++;

	print HDST "$human_hash{$id_array[$random_number]}";
	print MDST "$metamap_hash{$id_array[$random_number]}";
	$id_array[$random_number] = 1;

	$counter++;
	if( ($counter  >= $split) or ($overflow > 1) ){
	    $counter = 0;
	    $file_count++;
	    close HDST;
	    close MDST;
	    	    
	    if(($file_count > 10) and ($overflow >= 1)) { 
		open(HDST, ">>$target_split_dir/$target.human.$overflow") || 
		die "DST: $target.human.$overflow";
	        open(MDST, ">>$target_split_dir/$target.metamap.$overflow") || 
		die "DST: $target.metamap.$overflow";
	        $overflow++;
	    }
	    else {
	        open(HDST, ">$target_split_dir/$target.human.$file_count") || 
		die "DST: $target.human.$file_count";
	        open(MDST, ">$target_split_dir/$target.metamap.$file_count") || 
		die "DST: $target.metamap.$file_count";
            }
	}
    }
	
    close HDST;
    close MDST;
}
