#!/usr/bin/perl -w

my $choices = "/export/scratch/work/target_word.choices/";
my $mms = "/export/scratch/Medline/2005/mm/";

opendir(CHOICES, $choices) || die "Could not open $choices\n";
my @choice_files = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and  $_ ne "raw_summary" and $_ ne "index.shtml"} readdir CHOICES;

my %hash_id      = ();
my %hash_aid     = ();
my %hash_cui     = ();
my %hash_target  = ();
my %target_words = ();

foreach $choice (@choice_files) {
        
    $choice=~/(.*?)\.choices/;
    $target = $1;
	

    $target_words{$target}++;
    
    open(CHOICE, "$choices/$choice") || die "DIED: $choice\n";
    
    my $senses = "";
    while(<CHOICE>) { 
	chomp;
	my ($tag, $term, $st, $cui) = split/\|/;
	$hash_cui{$cui} = $tag;
	$senses .= "$tag,";
    }
    $senses .= "None";
    
    open(DST, ">$target.metamap.training.mm") || die "$target.metamap.training.mm\n";
    print DST "<corpus lang=\'en\'>\n";
    print DST "  <lexelt item=\"$target\" senses=\"$senses\">\n";
    close DST;

    my $result_file = "/export/scratch/data/NLM-WSD/Reviewed_Results/$target/results";
    open(RESULT, $result_file) || die "RESULT: $result_file\n";
    
    while(<RESULT>) {
	chomp;
	my ($num, $id, $answer) = split/\|/;
	$id=~/(.*?)\.[a-z]+\.[0-9]+/;  
	$aid = $1;
	$hash_id{$target}{$aid}++;
	$hash_aid{$aid} = $id;
	$hash_target{$aid} = $target;
    }
}

opendir(MM, $mms) || die "Could not open $mms\n";
my @mm_files = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and  $_ ne "raw_summary" and $_ ne "index.shtml"} readdir MM;

foreach my $f (@mm_files) {
    
    my $file = "$mms/$f";

    print "$file\n";

    system "gunzip $file";

    $file=~s/\.gz$//g;

    open(FILE, $file) || die "Could not open file: $file\n";
   
    my $line   = "";
    my $flag   = "";
    my $cui    = "";
    my $aid    = "";
    my $target = "";
    
    my $instance_flag = "false";

    my %instance = ();
    my %context  = ();
    my %answer   = ();
    my %sense    = ();
    my %hash_tw  = ();
    my %original = ();

    while(<FILE>) {

        chomp;

        if($_=~/<corpus lang=\'en\'>/)           { next; }
        if($_=~/<lexelt item=\"\" senses=\"\">/) { next; }
        if($_=~/<answer instance/)               { next; }

        if($_=~/<instance id=\"(.*?)\" alias/) {
           $id = $1; 
           $id=~/(.*?)\.[a-z]+\.[0-9]+/;  
           $aid = $1;
	   
	   if(exists $hash_aid{$aid}) { $instance_flag = "true"; } 
	   else                       { $instance_flag = "false"; }
									  
	   next;
        }
	
	if($instance_flag eq "false") { next; }
	
	$hash_tw{$aid}++;

        $_=~s/<sentence tw=\"\"/<sentence tw=\"no\"/g;   
        $_=~s/<phrase tw=\"\"/<phrase tw=\"no\"/g;   

        if($_=~/<context line=\"(.*?)\"/) {
           $context{$aid} .= $1;
           next;
        }
	
	my $clean_word = $hash_target{$aid};
	$clean_word=~s/\_/ /g;	
	if($_=~/<token word=\"$clean_word/) {

	    $_=~s/<token word/<target word/;

	    $flag          = "target"; 
	    $target        = $word;
		
            my $map = <FILE>;
	
	    #if($_=~/<mapping rank=\"1/ and $flag eq "target") {
          
	    $answer{$aid} = $id;
                   
	    $map=~/umls_cui=\"(.*?)\" umls_concept=\"(.*)\" semantic/;
	    my $concept = $1;
	    
	    my $cui = "None";
	    if(exists $hash_cui{$concept}) { 
	    	$cui = $hash_cui{$concept}; 	
	    }

	    $sense{$aid} = $cui;
	    $original{$aid} = $concept;
	    
	}

	if($_=~/<\/token>/ and $flag eq "target") {

           $_=~s/\<\/token\>/\<\/target\>/g;
           $flag = "";
        }

        if($_=~/<\/instance>/) {
	    
	    push @{$instance{$aid}}, $line;
	    
	    $line = "";
	    $cui  = "";
	    $flag = "";

	    $instance_flag = "false";

	    next;
        }
  
        $line .= "$_\n";

    }

    system "gzip $file";


    foreach my $target (sort keys %hash_id) {

	open (DST, ">>$target.metamap.training.mm") || die "DEAD: $target\n";
	
	foreach my $aid (sort keys %{$hash_id{$target}}) {
	    
	    my $id = $hash_aid{$aid};
	   
	    if(exists $hash_tw{$aid}) {
		
	    	print "   => $target : $aid : $id : $original{$aid} : $sense{$aid}\n";

		print DST "    <instance id=\"$aid\" alias=\"$target\">\n";
		print DST "      <answer instance=\"$id\" senseid=\"$sense{$aid}\"\/>\n"; 
		print DST "      <context line=\"$context{$aid}\"\/>\n";
				
		foreach my $line (@{$instance{$aid}}) {
            
		    $line=~s/<sentence tw=\"no\" id=\"$id\"/<sentence tw=\"yes\" id=\"$id\"/; 
		    
		    print DST "$line";
		    
		}
		print DST "   </instance>\n";
	    }
	}
	close DST;
    }
}


foreach $choice (@choice_files) {

        $choice=~/(.*?)\.choices/;
        $target = $1;
        open(DST, ">>$target.metamap.training.mm") || die;

	print DST "  </lexelt>\n";
	print DST "</corpus>\n"
}
