#!/usr/bin/perl


my $type = shift;
my $datadir = shift;

my $source = "$datadir/psb2011.mm";

opendir(SRC, $source) || die "Could not open dir: $source\n"; 
my @dirs = grep { $_ ne '.' and $_ ne '..'} readdir SRC;     

my $directory = "PSB2011.results/$type";
my $stoplist  = "$datadir/psb2011.stoplist";

#  run the experiments
foreach my $dir (sort @dirs) { 
    
    my $tw = $dir;
    
    if($tw=~/CVS/) { next; }

    my $test  = "$source/$dir/$dir.mm";
    my $train = "$source/$dir/$dir.train.mm";
    
    my $log = "$directory/$tw";

    print STDERR "$tw\n";

    #  run the unigram experiment
    if($type eq "unigram") { 
	print "supervised-disambiguate.pl $train  --directory $log --test $test --weka \"weka.classifiers.meta.AttributeSelectedClassifier -E \\\"weka.attributeSelection.InfoGainAttributeEval -M\\\" -S \\\"weka.attributeSelection.Ranker -T 0.0 -N -1\\\" -W weka.classifiers.functions.SMO\" --ngramcount \"--ngram 1 --frequency 2\" --stop $stoplist --lc\n";
	system "supervised-disambiguate.pl $train  --directory $log --test $test --weka \"weka.classifiers.meta.AttributeSelectedClassifier -E \\\"weka.attributeSelection.InfoGainAttributeEval -M\\\" -S \\\"weka.attributeSelection.Ranker -T 0.0 -N -1\\\" -W weka.classifiers.functions.SMO\" --ngramcount \"--ngram 1 --frequency 2\" --stop $stoplist --lc";
    }

    exit;
    #  run the bigram experiment
    if($type eq "bigram") { 
	system "supervised-disambiguate.pl $train  --directory $log --test $test --weka \"weka.classifiers.meta.AttributeSelectedClassifier -E \\\"weka.attributeSelection.InfoGainAttributeEval -M\\\" -S \\\"weka.attributeSelection.Ranker -T 0.0 -N -1\\\" -W weka.classifiers.functions.SMO\" --ngramcount \"--ngram 2 --frequency 2\" --stop $stoplist --lc";
	    
    }
    
    #  run the st experiment
    if($type eq "st") { 
	system "supervised-disambiguate.pl $train  --directory $log --test $test --weka \"weka.classifiers.meta.AttributeSelectedClassifier -E \\\"weka.attributeSelection.InfoGainAttributeEval -M\\\" -S \\\"weka.attributeSelection.Ranker -T 0.0 -N -1\\\" -W weka.classifiers.functions.SMO\" --stcount \"--ngram 1 --frequency 5";
	
    }
} 
