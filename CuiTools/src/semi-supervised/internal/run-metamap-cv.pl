#!/usr/bin/perl -w

my $dir = "/export/scratch/work/metamap-split";

my $temp = "temp";
open(TEMP, ">temp") || die "TEMP\n";

opendir(DIR, $dir) || die "Could not open $choices\n";
my @target_words = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and  $_ ne "raw_summary" and $_ ne "index.shtml"} readdir DIR;

my %accuracies = ();

foreach my $target_word (@target_words) {

    #if($target_word ne "adjustment") { next; }
    print "$target_word\n";

    my $senses = "";
    open(SENSES, "/export/scratch/work/target_word.choices/$target_word.choices") || die;
    while(<SENSES>) {
	chomp;
	my @array = split/\|/; my $s = shift @array;
	$senses .= "$s,";
    } $senses .= "None";

    open(HEAD, ">header") || die "HEADER";
    print HEAD "<corpus lang=\'en\'>\n";
    print HEAD "  <lexelt item=\"$target_word\" senses=\"$senses\">\n";
    close HEAD;

    my $accuracy = 0;
    for my $fold (1..10) {
	
	my $test = "$dir/$target_word/$target_word.human.$fold";
	
	my @training_files = ();
	for my $i (1..10) {
	    if($i == $fold) { next; }
	    push @training_files, "$dir/$target_word/$target_word.metamap.$fold";
	}
	my $cat_files = join " ", @training_files;
	
	system "cat header $cat_files footer > train";
	system "cat header $test footer > test";

	system "disambiguate.pl --cui --cutoff 1 --directory $target_word.fold.$fold --test test train";
	
	open(RESULTS, "$target_word.fold.$fold.results/OverallResults") || die "RESULTS\n";
	while(<RESULTS>) {
	    chomp;
	    if($_=~/Overall Accuracy/) {
		my @array = split/\s+/;
		$accuracy += pop @array;
	    }
	}

	system "rm -rf $target_word.fold.$fold.results";
	system "rm -rf $target_word.fold.$fold.weka";
	system "rm -rf $target_word.fold.$fold.arff";
	system "rm train";
	system "rm test";
    }   
    
    $accuracy = $accuracy / 10;
    print TEMP "$target_word : $accuracy\n";
    $accuracies{$target_word} = $accuracy;    
 }

my @array = qw(adjustment blood_pressure evaluation immunosuppression radiation sensitivity cold depression discharge extraction fat implantation japanese lead mole pathology reduction sex ultrasound degree growth man mosaic nutrition repair scale weight white association condition culture determination energy failure fit fluid frequency ganglion glucose inhibition pressure resistance secretion single strains support surgery transient transport variation);


foreach my $target (sort keys %accuracies) {
    print "$target : $accuracies{$target}\n";
}

foreach my $target_word (@array) {
     print "$target_word $accuracies{$target_word}\n";
}
