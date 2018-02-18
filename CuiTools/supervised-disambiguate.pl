#!/usr/bin/perl -w 

=head1 NAME

supervised-disambiguate

=head1 SYNOPSIS

This is a wrapper program for supervised, unsupervised and 
semi-supervised word sense disambiguation using CuiTools 
programs. 

=head1 DESCRIPTION

The program takes as input the data set (SOURCE) which 
can either be a directory containing files in the CuiTools 
xml-like format or a single file in the CuiTools xml-like 
format and returns the results stored in a directory 
(DESTINATION).

The program extracts specified features based on the user 
defined options options and outputs arff formatted text to 
be used by the WEKA data mining package for supervised word 
sense disambiguation. 

=head1 USAGE

perl supervised-disambiguate.pl [OPTIONS] SOURCE

=head1 INPUT

=head2 Required Arguments:

=head3 SOURCE

A directory containing the CuiTools xml-like .mm formatted 
training file(s) or a single file in the CuiTools xml-like
.mm format.

head2 Optional Arguments:

=head3 SUPERVISED DATA OPTIONS :

=head4 --wekacv NUMBER 

This will perform NUMBER-fold cross validation on the training 
data using the cross validation in the WEKA data mining package.

NOTE: This is also the default option. If neither --test or 
--split or --cv are specified, 10-fold cross validation will 
be performed.

=head4 --cv NUMBER

With weka (--wekacv option) the features are identified from 
all of the X folds, one of which is the test fold. In --cv, 
the features are identified from only the X-1 training folds, 
where the test fold is held out of feature identification.

=head4 --seed NUMBER

This is used with the --cv option in order to seed the 
random number generator for the cross validation

Default: --seed 1

=head4 --test FILE

The program will train on the complete training data and test on 
a given test data FILE. 

=head4 --nokey 

The test data does not contain the sense tags. The id and 
sense tag assigned by the classifier will be in the file, 
test.answers, in the log directory. This This option can 
only be used with the --test option.

=head4 --key FILE

The program will obtain the answers to the given test file from the 
key file. The key file is expected to be in the same format as the 
Senseval-2 key file.

    Example:

   art art.40003 pop_art%1:06:00::
    
    <target word> <instance id> <sense>


=head4 --split NUMBER

This option will split the training data into two sections. The 
NUMBER specifies the percentage of the training data that will 
be put aside for testing if the --test option is set. 
Example: --split 25 
    25% of the data will be used to test the algorithm and 
    75% of the data will be used to train.

=head3 FEATURE OPTIONS :

If no feature option is chosen, the default feature setting 
is used:

    --ngramcount "--ngram 1 --frequency 2"


If no feature option is chosen, the default is as follows:
    --ngramcount "--ngram 1 --frequency 2"

=head4 --pos

The part of speech of the target word

=head4 --head

Whether the target word is the head word of its phrase.

=head4 --mesh

Uses the MeSH terms assigned to the abstract containing the 
target word as features

=head4 --mmi SCORE

Uses the CUIs whose MMI score is greater than SCORE

=head4 --ngramcount "OPTIONS"

The words surrounding the target word as features 

The Ngram Statistic Package (NSP) count.pl program is used to obtain 
the counts. The options specify any additional options to be passed 
to count.pl program.

  Note: All the options must be within double quotes, as
      would be passed to the program at command line.

Note: If the --sentence option is defined, the surrounding 
words will come from the sentence that contains the target 
word. If the --phrase option is defined, the surrounding owrds 
will come only from the phrase that contains the target word. 
Otherwise they come from the abstract.

=head4 --ngrammeasure "OPTIONS"

Specifies a measure of association to be used with the statistic.pl 
program in the Ngram Statistics Package which is used in combination 
with the --ngramstat option to perform feature selection for the 
--ngramcount option

Note: All the options must be within double quotes, as
      would be passed to the program at command line.

=head4 --ngramstat "OPTIONS"

Specifies any additional options to be passed to statistic.pl program 
when using --ngramcount and --ngrammeasure options

Note: All the options must be within double quotes, as
      would be passed to the program at command line.

=head4 --cuicount "OPTIONS"

Unified Medical Language System (UMLS) Concept Unique Identifiers 
(CUIs) of the words surrounding the target word.

The Ngram Statistic Package (NSP) is used to obtain the counts.

The options specify any additional options to be passed to count.pl
program.

  Note: All the options must be within double quotes, as
      would be passed to the program at command line.

Note: If the --sentence option is defined, the surrounding 
words will come from the sentence that contains the target 
word. If the --phrase option is defined, the surrounding owrds 
will come only from the phrase that contains the target word. 
Otherwise they come from the abstract.

=head4 --cuimeasure "OPTIONS"

Specifies a measure of association to be used with the statistic.pl 
program in the Ngram Statistics Package which is used in combination 
with the --cuistat option to perform feature selection for the 
--cuicount option

Note: All the options must be within double quotes, as
      would be passed to the program at command line.

=head4 --cuistats "OPTIONS"

Specifies any additional options to be passed to statistic.pl program 
when using --ngramcount and --ngrammeasure options

Note: All the options must be within double quotes, as
      would be passed to the program at command line.

=head4 --firstranked

The first CUI in the set of one or more CUIs found in the mapping 
(that have the highest MTI score) is used as the feature rather 
than all of them (which is the default).

=head4 --conflatedcuis

Combine all the CUIS in the set of one or more CUIs found in the 
mapping into one sorted string and use the string as a feature

=head4 --stcount "OPTIONS"

The words surrounding the target word as features 

The Ngram Statistic Package (NSP) count.pl program is used to obtain 
the counts. The options specify any additional options to be passed 
to count.pl program.

  Note: All the options must be within double quotes, as
      would be passed to the program at command line.

Note: If the --sentence option is defined, the surrounding 
words will come from the sentence that contains the target 
word. If the --phrase option is defined, the surrounding owrds 
will come only from the phrase that contains the target word. 
Otherwise they come from the abstract.

=head4 --stmeasure "OPTIONS"

Specifies a measure of association to be used with the statistic.pl 
program in the Ngram Statistics Package which is used in combination 
with the --ststat option to perform feature selection for the 
--stcount option

Note: All the options must be within double quotes, as
      would be passed to the program at command line.

=head4 --ststats "OPTIONS"

Specifies any additional options to be passed to statistic.pl program 
when using --ngramcount and --ngrammeasure options

Note: All the options must be within double quotes, as
      would be passed to the program at command line.

=head4 --nspconfig FILE

This is can be used in replace of or in conjunction with the 
ngramcount, ngrammeasure, ngramstat, cuicount, cuimeasure, 
cuistat, stcount, stmeasure and ststat options. It allows 
for multiple instances of ngramcount, cuicount and stcount 
to be called in order to allow for multiple ngrams to be 
used as features. 

An example of the format required for the configuration 
file is as follows:

ngramcount::
count:: --ngram 3 --remove 3
statistic:: ll.pm --score 3.841

ngramcount::
count:: --ngram 2 --remove 1

cuicount::
count:: --ngram 2 --remove 3
statistic:: ll.pm --score 3.841

stcount::
count:: --ngram 1 --remove 3

=head4 --relation 

The semantic relation of the semantic type of the target word and 
the semantic types s of the words surrounding the target word. 
The relations are read in from a file which is located in the 
'default_options' directory. The name of the file is called 
'relation'. The relations comes from the UMLS 2007AC documentation.


If you would like to provide your own, the format of the file 
is as follows:

    semantic_type relation semantic_type

where each semantic type pair and relation are on their own line. 

For example:

    acab affects virs
    acab affects vtbt
    acap affects rept
    ...

=head4 --punc

Removes punctuation in the --unigram, --term, --bigram or 
--trigram options

=head4 --phrase

The context considered is only the features that are in the 
same phrase as the target word. The phrases are identified 
by MetaMap.

Note: If the phrase option is set then the --sentence and 
--line options need to be off.

=head4 --sentence

The context considered is only the features that are in the 
same sentence as the target word.

Note: If the sentence option is set then the --phrase and 
--line options need to be off.

=head4 --line

The context considered is the features that are in the 
the complete line as defined by the .mm file as the 
target word.

Note: If the line option is set then the --sentence and 
--phrase options need to be off.

Note: This is the default option.

=head4 --stop FILE

Stoplist for the count.pl program. This can also be added in 
the --ngramcount option but I wanted to add it here as well 
in case people were not as familiar with NSP.

==head4 --idfstop DIR

This is the directory that contains the idf stoplists for 
each of the target words. The directory should contain 
a file called:

     <target word>.idf.stop

foreach target word file.

=head3 WEKA OPTIONS: 

=head4 --weka

The weka machine learning algorithm that you would like to 
run the feature set on. The program is expecting the java 
command that would be used to run weka.

Default:

weka.classifiers.bayes.NaiveBayes

=head4 --wekaparams PARAMETERS

Option so that the user can directly pass weka parameters through the 
command line

The main reason we added this was to allow for the -s NUM option to 
be  used. This option sets the random number seed for cross-validation. 
Its default is 1.

=head4 --javaparams PARAMETERS

Option so that the user can directly pass java parameters through the 
command line

=head3 PROGRAM OPTIONS: 

=head4 --debug

Sets the debug option

=head4 --directory

The prefix that the directories for the weka, arff, results and log files.

Default: <timestamp>.dir

Therefore the weka files would be located in <timestamp>.dir.weka.,
the arff files would be located in <timestamp>.dir.arff, results 
in the <timestamp>.dir.results and log files in the <timestamp>.dir.log. 

=head4 --confidence

Print out the confidence values with the accuracy

=head4 --binary

Uses a binary indicator to represent whether a feature exists. DEFAULT

=head4 --freq

Uses the frequency count of a feature to represent its existance.


=head3 HELP OPTIONS:

=head4 --help

Displays the quick summary of program options.

=head4 --version

Displays the version information.

=head1 OUTPUT

supervised-disambiguate.pl creates two directories. One containing the 
arff files and the other containing the weka files. In the weka directory, 
the overall averages are stored in the OverallAverage file.

=head1 PROGRAM REQUIREMENTS

=over

=item * Perl (version 5.8.5 or better) - http://www.perl.org

=item * Text::NSP - http://search.cpan.org/dist/Text-NSP

=item * WEKA data mining package - http://sourceforge.net/projects/weka/

=back

=head1 AUTHOR

 Bridget T. McInnes, University of Minnesota

=head1 COPYRIGHT

Copyright (c) 2007,

 Bridget T. McInnes, University of Minnesota
 bthomson at cs.umn.edu
    
    Ted Pedersen, University of Minnesota Duluth
    tpederse at d.umn.edu

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to 

 The Free Software Foundation, Inc.,
 59 Temple Place - Suite 330,
 Boston, MA  02111-1307, USA.

=cut

###############################################################################

#                               THE CODE STARTS HERE
###############################################################################

#                           ================================
#                            COMMAND LINE OPTIONS AND USAGE
#                           ================================

use Getopt::Long;

eval(GetOptions( "version", "help", "debug", "pos", "head", "relation", "weka=s", "directory=s", "phrase", "sentence", "line", "test=s", "split=i","wekacv=i", "key=s", "punc", "wekaparams=s", "cv=s", "nokey", "ngramcount=s", "collocations", "ngrammeasure=s", "ngramstat=s", "cuicount=s", "cuimeasure=s", "cuistat=s", "stcount=s", "stmeasure=s", "ststat=s", "mesh", "mmi=s", "nspconfig=s", "lc", "confidence", "firstranked", "conflatedcuis", "javaparams=s", "seed=s", "freq", "binary", "similarity", "stop=s", "idfstop=s", "simconfig=s")) or die ("Please check the above mentioned option(s).\n");

#  option variables
my $wekacv        = 10;
my $split         = 10;
my $totalAccuracy = 0;

my $javaparams    = "";
my $wekaparams    = "";

my $default = "";
my $set     = "";
    
my $timestamp     = &timeStamp();

#  set the directory variables
my $wekaDir       = "";
my $arffDir       = "";
my $resultsDir    = "";
my $logDir        = "";

#  set the accuracy variables
my $tw            = "";
my $accuracy      = 0;
my @resultFiles   = ();

#  set the key variables
my %keyHash       = ();

format OVERALL =
@>>>>>>>>>>>>>>>>>>>>>>> @##.##
$tw, $accuracy
.
    
#  if help is defined, print out help
if( defined $opt_help ) {
    $opt_help = 1;
    &showHelp();
    exit;
}

#  if version is requested, show version
if( defined $opt_version ) {
    $opt_version = 1;
    &showVersion();
    exit;
}

#  check if command line contains arguements
if($#ARGV < 0) {
    $opt_help = 1;
    &minimalUsageNotes();
    exit;
}

#  check that source has been supplied
if( !($ARGV[$#ARGV]) ) {
    print STDERR "No source file/directory (SOURCE) supplied.\n";
    &minimalUsageNotes();
    exit;
}

#  check that source file exist
if(! (-e $ARGV[$#ARGV]) ) {
    print STDERR "Source file or directory (SOURCE) does not exist\n";
    &minimalUsageNotes();
    exit;
}    

#  set debug
my $debug = 0;
if(defined $opt_debug) { $debug = $opt_debug; }

#  check Environment variables
&checkEnvironmentVariables();

#  set up the weka command
my $weka = &setWeka(); 

#  check the options
&checkOptions(); 

#  retrieve the source (training file or directory containing training files)
my $source = shift;

#  check if the source file is a directory
my @sourceFiles = ();
if( -d $source ) {
    opendir(SRC, "$source") || die "Could not open directory $source\n";
    my @files = grep { $_ ne '.' and $_ ne '..' and $_ ne 'CVS'} readdir SRC; close SRC;
    foreach (@files) { push @sourceFiles, "$source/$_"; }
} else { push @sourceFiles, $source; }



#  make the sub directories
system "rm -rf $wekaDir $arffDir $resultsDir $logDir\n";
system "rm -rf $wekaDir  $resultsDir $logDir\n";
system("mkdir $wekaDir");
system("mkdir $arffDir");
system("mkdir $resultsDir");
system("mkdir $logDir");

# set options for features to extract from the mm file for mm2arff.pl 
my $options = &setOptions();

# run the trials on each file from the source directory
&runTrials();
&setOverall($resultsDir);


##############################################################################
#  SUB FUNCTIONS
##############################################################################

##############################################################################
#  run the trials for each source file
##############################################################################
sub runTrials {
    
    foreach my $source (@sourceFiles) {
	
	#  set the prefix
	my $prefix = setPrefix($source); 
	
	#  get the results file
	push @resultFiles, "$resultsDir/$prefix";

	#  initialize the total accuracy
	my $totalAccuracy = 0; 


        #  perform test where the test file is provided
	if( (defined $opt_test) and (defined $opt_nokey)  ) {
	    performNoKeyTest($opt_test, $source, $prefix, $arffDir, $wekaDir, $resultsDir);
	}
	elsif( (defined $opt_test) and !(defined $opt_nokey) ) {
	    performTest($opt_test, $source, $prefix, $arffDir, $wekaDir); 
	    setAccuracy($prefix);
	}	    
	#  perform train-test split 
	elsif( defined $opt_split ) { 
	    performSplit($split, $prefix, $arffDir, $wekaDir, $source); 
	    setAccuracy($prefix);
	}
	#  perform cross validation using WEKA
	elsif( (defined $opt_wekacv) ) { 
	    performWekaCV($prefix, $arffDir, $wekaDir, $source); 
	    setWekaCvAccuracy($prefix);
	}
	#  perform cross validation
	else {
	    performCV($prefix, $arffDir, $wekaDir, $source); 
	    setAccuracy($prefix);
	}
    }
}


##############################################################################
#  perform cross validation on the data set using WEKA
##############################################################################
sub performWekaCV {

    my $prefix  = shift;
    my $arffDir = shift;
    my $wekaDir = shift;
    my $source  = shift;
    
    if($debug) { print STDERR "In performWekaCV\n"; }
    
    # extract the features creating an arff file for weka
    system ("mm2arff.pl $options $arffDir/$prefix $source");
    
    #  check if the arff files for WEKA exist
    if(! (-e "$arffDir/$prefix.arff") ) {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff) does not exist\n";
	exit;
    }    
    if(-z "$arffDir/$prefix.arff")  {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff) is empty\n";
	exit;
    }

    # run the file through WEKA
    system("java $javaparams $weka -x $wekacv $wekaparams -o -t $arffDir/$prefix.arff > $wekaDir/$prefix.weka");
    print STDERR ("java $javaparams $weka -x $wekacv $wekaparams -o -t $arffDir/$prefix.arff > $wekaDir/$prefix.weka\n");

}

##############################################################################
#  perform cross validation on the data set
##############################################################################
sub performCV {

    if($debug) { print "In performCV\n"; }

    my $prefix  = shift;
    my $arffDir = shift;
    my $wekaDir = shift;
    my $source  = shift;
    
    # split the source file into training and testing files  
    system("x-fold.pl --seed $seed --fold $opt_cv $arffDir/$prefix $source");
    
    for my $fold (1..$opt_cv) {

	if($debug) { print STDERR "mm2arff.pl $options --test $arffDir/$prefix/$fold.mm.test $arffDir/$prefix/$fold $arffDir/$prefix/$fold.mm.train\n"; }

	system("mm2arff.pl $options --test $arffDir/$prefix/$fold.mm.test $arffDir/$prefix/$fold $arffDir/$prefix/$fold.mm.train");
			
        #  check if the arff files for WEKA exist
	if(! (-e "$arffDir/$prefix/$fold.train.arff") ) {
	    print STDERR "ERROR1: The ARFF file ($arffDir/$prefix/$fold.train.arff) does not exist\n";
	    exit;
	}    
	if(-z "$arffDir/$prefix/$fold.train.arff") {
	    print STDERR "ERROR: The ARFF file ($arffDir/$prefix/$fold.train.arff) is empty\n";
	    exit;
	}
	if(! (-e "$arffDir/$prefix/$fold.test.arff") ) {
	    print STDERR "ERROR: The ARFF file ($arffDir/$prefix/$fold.test.arff) does not exist\n";
	    exit;
	}    
	if(-z "$arffDir/$prefix/$fold.test.arff") {
	    print STDERR "ERROR: The ARFF file ($arffDir/$prefix/$fold.test.arff) is empty\n";
	    exit;
	}
	#  run the files through WEKA
	#if($debug) { 
	    print STDERR ("java  $javaparams $weka $wekaparams -o -t $arffDir/$prefix/$fold.train.arff -T $arffDir/$prefix/$fold.test.arff -p 0 > $wekaDir/$prefix.$fold.weka\n");
	#}
	system("java  $javaparams $weka $wekaparams -o -t $arffDir/$prefix/$fold.train.arff -T $arffDir/$prefix/$fold.test.arff -p 0 > $wekaDir/$prefix.$fold.weka");

	
    }
} 

##############################################################################
#  perform a train-test split on the data set
##############################################################################
sub  performSplit{
    
    my $split   = shift;
    my $prefix  = shift;
    my $arffDir = shift;
    my $wekaDir = shift;
    my $source  = shift;
 
    if($debug) { print STDERR "In performSplit\n"; }

    #  split the source file into training and testing files
    system("split.pl --split $split $arffDir/$prefix.mm $source");

    #  extract the feature creating a test and train arff file for weka
    system("mm2arff.pl $options --test $arffDir/$prefix.mm.test $arffDir/$prefix.arff $arffDir/$prefix.mm.train");

    #  check if the arff files for ARFF exist
    if(! (-e "$arffDir/$prefix.arff.train.arff") ) {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff.train.arff) does not exist\n";
	exit;
    }    
    if(-z "$arffDir/$prefix.arff.train.arff") {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff.train.arff) is empty\n";
	exit;
    }
    if(! (-e "$arffDir/$prefix.arff.test.arff") ) {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff.test.arff) does not exist\n";
	exit;
    }    
    if(-z "$arffDir/$prefix.arff.test.arff") {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff.test.arff) is empty\n";
	exit;
    }

    #  run the files through WEKA
    system("java $javaparams $weka $wekaparams -o -t $arffDir/$prefix.arff.train.arff -T $arffDir/$prefix.arff.test.arff -p 0 > $wekaDir/$prefix.weka");

    print STDERR ("java $javaparams $weka $wekaparams -o -t $arffDir/$prefix.arff.train.arff -T $arffDir/$prefix.arff.test.arff -p 0 > $wekaDir/$prefix.weka\n");
    
}

##############################################################################
#  perform a test with a given file and key
##############################################################################
sub  performTest {

    my $test    = shift;
    my $train   = shift;
    my $prefix  = shift;
    my $arffDir = shift;
    my $wekaDir = shift;

    if($debug) { print STDERR "In performTest\n"; }

    #get the test file
    if( -d $test ) { $test = "$test/$prefix.mm"; }

    #  extract the feature creating a test and train arff file for weka
    system("mm2arff.pl $options --test $test $arffDir/$prefix $train");
    
    #  check if the arff files for WEKA exist
    if(! (-e "$arffDir/$prefix.train.arff") ) {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.train.arff) does not exist\n";
	exit;
    }    
    if(-z "$arffDir/$prefix.train.arff")  {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.train.arff) is empty\n";
	exit;
    }
    if(! (-e "$arffDir/$prefix.test.arff") ) {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.test.arff) does not exist\n";
	exit;
    }    
    if(-z "$arffDir/$prefix.test.arff")  {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.test.arff) is empty\n";
	exit;
    }

    #  run the files through WEKA
    #if($debug) { 
	print STDERR "java $javaparams $weka $wekaparams -t $arffDir/$prefix.train.arff -T $arffDir/$prefix.test.arff -o  -p 0 > $wekaDir/$prefix.weka\n";
    #}
    system("java $javaparams $weka $wekaparams -t $arffDir/$prefix.train.arff -T $arffDir/$prefix.test.arff -o  -p 0 > $wekaDir/$prefix.weka");
    
}

##############################################################################
#  perform a test with a given file and no key - answers are printed out to
#  the opt_answer file
##############################################################################
sub  performNoKeyTest {

    if($debug) { print STDERR "In performNoKeyTest\n"; }

    my $test       = shift;
    my $train      = shift;
    my $prefix     = shift;
    my $arffDir    = shift;
    my $wekaDir    = shift;
    my $resultsDir = shift;

    my $orderfile  = "$arffDir/$prefix.arff.test.order";
    my $answerfile = "$wekaDir/$prefix.weka.test.answers";
    my $resultfile = "$resultsDir/$prefix.test.answers";
    
    #get the test file
    if( -d $test ) { $test = "$test/$prefix.mm"; }

    #  extract the feature creating a test and train arff file for weka
    system("mm2arff.pl $options --nokey --test $test $arffDir/$prefix.arff $train");

     #  check if the arff files for WEKA exist
    if(! (-e "$arffDir/$prefix.arff.train.arff") ) {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff.train.arff) does not exist\n";
	exit;
    }    
    if(-z "$arffDir/$prefix.arff.train.arff")  {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff.train.arff) is empty\n";
	exit;
    }
    if(! (-e "$arffDir/$prefix.arff.test.arff") ) {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff.test.arff) does not exist\n";
	exit;
    }    
    if(-z "$arffDir/$prefix.arff.test.arff")  {
	print STDERR "ERROR: The ARFF file ($arffDir/$prefix.arff.test.arff) is empty\n";
	exit;
    }
    #  run the files through WEKA
    print STDERR ("java $javaparams $weka $wekaparams -o -t $arffDir/$prefix.arff.train.arff -T $arffDir/$prefix.arff.test.arff -p 0 > $answerfile\n");

    system("java $javaparams $weka $wekaparams -o -t $arffDir/$prefix.arff.train.arff -T $arffDir/$prefix.arff.test.arff -p 0 > $answerfile");

    open(ORDER, $orderfile)   || die "Could not open ORDER file: $orderfile\n";
    open(ANSWER, $answerfile) || die "Could not open ANSWER file: $answerfile\n";
    
    open(RESULT, ">$resultfile") || die "Could not open RESULT file: $resultfile\n";

    my @answers = ();
    while(<ANSWER>) {
	chomp;
	if($_=~/^\s*$/)  { next; }
	if($_=~/inst\#/) { 
	    if($debug) { print STDERR "$_\n"; }
	    next; 
	}
	if($_=~/=== Predictions on test data ===/) { 
		if($debug) { print STDERR "$_\n"; }
		next;
	}
	$_=~s/^\s+//g;
	$_=~s/\s+^//g;
	$_=~s/[+-]//g;
	
	my ($num, $actual, $predicted, $confid) = split/\s+/;
	if($debug) { print STDERR "$num, $actual, $predicted, $confid\n"; }
	push @answers, $predicted;
    } close ANSWER;
    
    my $counter = 0;
    while(<ORDER>) {
	chomp;
	my $answer = $answers[$counter]; $counter++;
	print RESULT "$prefix $_ $answer\n";
    } close ORDER;
}
    
##############################################################################
#  check Environment Variables
##############################################################################
sub checkEnvironmentVariables{

    if($ENV{CUITOOLSHOME} eq "") {
	print STDERR "The environment variable CUITOOLSHOME needs to be set.

  For example:

    # in cshell
    setenv CUITOOLSHOME /home/btmcinnes/CuiTools

    # in bash
    export CUITOOLSHOME=/home/btmcinnes/CuiTools

  This can be added to your .cshrc or .bashrc file.
  See INSTALL guide for more information.\n\n";

	exit;
    }
        
    if($ENV{WEKAHOME} eq "") {
	print STDERR "The environment variable WEKAHOME needs to be set.

  For example:

    # in cshell
    setenv WEKAHOME /home/btmcinnes/weka/weka-3-5-3

    # in bash
    export WEKAHOME=/home/btmcinnes/weka/weka-3-5-3

  This can be added to your .cshrc or .bashrc file.
  See INSTALL guide for more information.\n\n";

	exit;
    }
}

##############################################################################
#  process the configuration statement in the config file
##############################################################################
sub checkConfiguration
{
    my $line = shift;
    
    my $type  = "";
    my $count = "";

    my $counter = 0;
    while($line=~/count::/g) { $counter++; }
    if($counter > 2) {
	print STDERR "ERROR: count:: can only be specified once for:\n";
	print STDERR "$line\n";
	&minimalUsageNotes();
	exit;
    }
    
    $counter = 0;
    while($line=~/statistic::/g) { $counter++; }
    if($counter > 1) {
	print STDERR "ERROR: statistic:: can only be specified once for:\n";
	print STDERR "$line\n";
	&minimalUsageNotes();
	exit;
    }
	

    while($line=~/(.*?)\:\:/g) {
	$header = $1;
	if($header=~/(ngramcount|cuicount|stcount|count|statistic)/) {
	    #  all is good
	}
	else {
	    print STDERR "ERROR: unknown type in nspconfig for:\n";
	    print STDERR "$line\n";
	    &minimalUsageNotes();
	    exit;
	}
    }
	
    if($line=~/\bcount::(.*?)\s*\n/)  { $count = $1; }
    else {
	print STDERR "ERROR: count:: not specified in nspconfig for:\n";
	print STDERR "$line\n";
	&minimalUsageNotes();
	exit;
    }
    

    if($line=~/statistic::/) {
	if($line=~/\bstatistic::(.*?\.pm)/) { 
	    #  all is good
	}
	else {
	    print STDERR "ERROR: measure in statistic:: not specifiied in nspconfig for:\n";
	    print STDERR "$line\n";
	    &minimalUsageNotes();
	    exit;
	}
    }
}

    
##############################################################################
#  check options
##############################################################################
sub checkOptions {

    if(defined $opt_simconfig)    { $set .= "  --simconfig $opt_simconfig ";            }
    if(defined $opt_stop)         { $set .= "  --stop $opt_stop\n";                     }
    if(defined $opt_idfstop)      { $set .= "  --idfstop $opt_idfstop\n";               }
    if(defined $opt_similarity)   { $set .= "  --similarity\n";                         }
    if(defined $opt_freq)         { $set .= "  --freq\n";                               }
    if(defined $opt_phrase)       { $set .= "  --phrase\n";                             }
    if(defined $opt_confidence)   { $set .= "  --confidence\n";                         }
    if(defined $opt_sentence)     { $set .= "  --sentence\n";                           }
    if(defined $opt_line)         { $set .= "  --line\n";                               }
    if(defined $opt_pos)          { $set .= "  --pos\n";                                }
    if(defined $opt_head)         { $set .= "  --head\n";                               }
    if(defined $opt_relation)     { $set .= "  --relation $ENV{CUITOOLSHOME}/default_options/relation\n"; }
    if(defined $opt_punc)         { $set .= "  --punc\n";                               }
    if(defined $opt_lc)           { $set .= "  --lc\n";                                 }
    if(defined $opt_key)          { $set .= "  --key $opt_key\n";                       } 
    if(defined $opt_weka)         { $set .= "  --weka $weka\n";                         }
    if(defined $opt_wekaparams)   { $set .= "  --wekaparams $opt_wekaparams\n";         }
    if(defined $opt_javaparams)   { $set .= "  --javaparams $opt_javaparams\n";         }
    if(defined $opt_test)         { $set .= "  --test $opt_test\n";                     }
    if(defined $opt_split)        { $set .= "  --split $opt_split\n";                   }
    if(defined $opt_cv)           { $set .= "  --cv $opt_cv\n";                         }
    if(defined $opt_seed)         { $set .= "  --seed $opt_seed\n";                     }
    if(defined $opt_wekacv)       { $set .= "  --wekacv $opt_wekacv\n";                 }
    if(defined $opt_mesh)         { $set .= "  --mesh\n";                               }
    if(defined $opt_mmi)          { $set .= "  --mmi $opt_mmi\n";                       }
    if(defined $opt_collocations) { $set .= "  --collocations\n";                       }
    if(defined $opt_ngramcount)   { $set .= "  --ngramcount \"$opt_ngramcount\"\n";     } 
    if(defined $opt_ngrammeasure) { $set .= "  --ngrammeasure \"$opt_ngrammeasure\"\n"; } 
    if(defined $opt_ngramstat)    { $set .= "  --ngramstat \"$opt_ngramstat\"\n";       }
    if(defined $opt_cuicount)     { $set .= "  --cuicount \"$opt_cuicount\"\n";         } 
    if(defined $opt_cuimeasure)   { $set .= "  --cuimeasure \"$opt_cuimeasure\"\n";     } 
    if(defined $opt_cuistat)      { $set .= "  --cuistat \"$opt_cuistat\"\n";           }
    if(defined $opt_firstranked)  { $set .= "  --firstranked \n";                       }
    if(defined $opt_conflatedcuis){ $set .= "  --conflatedcuis \n";                     }
    if(defined $opt_stcount)      { $set .= "  --stcount \"$opt_stcount\"\n";           } 
    if(defined $opt_stmeasure)    { $set .= "  --stmeasure \"$opt_stmeasure\"\n";       } 
    if(defined $opt_ststat)       { $set .= "  --ststat \"$opt_ststat\"\n";             } 

    if(!defined $opt_freq and !defined $opt_similarity) {
	if(defined $opt_binary)  {
	    $set .= "  --binary\n";
	}
	else {
	    $default .= "  --binary\n";
	}
    }
    
    if(defined $opt_freq and defined $opt_binary) {
	print STDERR "The options --freq and  --binary can not both be defined.\n";
	&askHelp();
	exit;
    }

    if(defined $opt_seed) { 
	$seed = $opt_seed;
    }
    else {
	$seed = 1;
	$default .= "  --seed 1\n";
    }

    if(defined $opt_wekaparams) {
	$wekaparams = $opt_wekaparams;
    }
    else {
	$wekaparams = "";
    }

    if(defined $opt_javaparams) {
	$javaparams = $opt_javaparams;
    }
    else {
	$javaparams = "-Xmx2G";
	$default .= "  --javaparams \"-Xmx2G\"\n";
    }
    
    if(defined $opt_nspconfig) {
	$set .= "  --nspconfig $opt_nspconfig\n"; 
	open(CONFIG, $opt_nspconfig) || die "Could not open the nsp configuration file: $opt_nspconfig\n";
	
	my $configuration = "";
	while(<CONFIG>) {

	    if($_=~/^\#/)   { next; }
	    if($_=~/^\s*$/) { next; }
	    
	    if($_=~/(ngramcount\:\:|cuicount\:\:|stcount\:\:)/) {
		if($configuration ne "") {
		    &checkConfiguration($configuration);
		    $configuration=~s/\n/ /g;
		    $set .= "      $configuration\n";
		}
		$configuration = "";
	    }
	    $configuration .= $_;
	} 
	&checkConfiguration($configuration);
	$configuration=~s/\n/ /g;
	$set .= "      $configuration\n";
    }    
    
    
    if( (defined $opt_line && defined $opt_sentence) ||
	(defined $opt_line && defined $opt_phrase)   ||
	(defined $opt_phrase  && defined $opt_sentence)) {
	print STDERR "ERROR: Can only define the line, phrase OR sentence options\n";
	&askHelp();
	exit;
    }

    #  if defined split and crossvalidate throw an error
    if( (defined $opt_test  and defined $opt_wekacv) ||
	(defined $opt_test  and defined $opt_cv)     ||
	(defined $opt_split and defined $opt_wekacv) ||
	(defined $opt_split and defined $opt_cv)     ||
	(defined $opt_split and defined $opt_test)   ||
	(defined $opt_cv    and defined $opt_wekacv)) {
	print STDERR "ERROR : Can not perform both a cross validation, a test-train split, or test on the data set.\n";
	&askHelp();
	exit;
    }
        
    if( (defined $opt_nokey) and !(defined $opt_test) ) {
	print STDERR " ERROR: The --nokey option can only be used with the --test option.\n";
	&minimalUsageNotes();
	exit;
    }

    #  test-train split of D with a default of D=10
    if(defined $opt_split) { $split = $opt_split; }


    if( !(defined $opt_ngramcount) and 
	!(defined $opt_cuicount)   and 
	!(defined $opt_stcount)    and 
	!(defined $opt_pos)        and 
	!(defined $opt_relation)   and 
	!(defined $opt_mesh)       and
	!(defined $opt_mmi)        and
	!(defined $opt_nspconfig)  and 
	!(defined $opt_head) ){
	$opt_ngramcount = "--ngram 1 --frequency 2";
	$default .= "  --ngramcount \"--ngram 1 --frequency 2\"\n";
    }

    if(!(defined $opt_wekacv) and !(defined $opt_split) and 
       !(defined $opt_test)   and !(defined $opt_cv) ) {
	$default .= "  --cv 10\n";
	$opt_cv = 10;
    }

    if(defined $opt_nokey) {
	$default .= "  --nokey\n";
    }

    if(!(defined $opt_weka) ) {
	$default .= "  --weka weka.classifiers.bayes.NaiveBayes\n";
    }
    
    if(!(defined $opt_phrase) and !(defined $opt_sentence) and !(defined $opt_line) ) {
	$default .= "  --line \n";
	$opt_line = 1;
    }
    
    #  set the output directories if defined
    if(defined $opt_directory) {
	$wekaDir    = "$opt_directory.weka";
	$arffDir    = "$opt_directory.arff";
	$resultsDir = "$opt_directory.results";
	$logDir     = "$opt_directory.log";
    }
    else {
	$wekaDir    = "$timestamp.dir.weka";
	$arffDir    = "$timestamp.dir.arff";
	$resultsDir = "$timestamp.dir.results";
	$logDir     = "$timestamp.dir.log";
    }
    
    if($default ne "") {
	print STDERR "Defaults options set:\n";
	print STDERR "$default\n\n";
    }

    if($set ne "") {
	print STDERR "User defined options set:\n";
	print STDERR "$set\n\n";
    }

    print  STDERR "Output Directories: \n";
    print STDERR "  WEKA directory   : $wekaDir\n";
    print STDERR "  ARFF directory   : $arffDir\n";
    print STDERR "  RESULTS directory: $resultsDir\n";
    print STDERR "  LOG directory    : $logDir\n\n";

}

##############################################################################
#  get the overall accuracy for the target word(s)
##############################################################################
sub setOverall {
    
    my $dir = shift;

    if( (defined $opt_test) and (defined $opt_nokey) ) { return; }

    open(OVERALL, ">$dir/OverallResults") || die "Could not open OverallResults\n";
     
    print OVERALL "Defaults options set:\n";
    print OVERALL "$default\n\n";
    print OVERALL "User defined options set:\n";
    print OVERALL "$set\n\n";
    
    my $overall    = 0; 
    my $confidence = 0;
    my $conf_flag  = 0;

    foreach my $file (sort @resultFiles) {
	
	open(FILE, $file) || die "Could not open result file: $file\n";

	my $counter = 0;
	my $conf    = 0;

	$accuracy = 0;
	while(<FILE>) { 
	    chomp;
	    
	    if($_=~/Accuracy for (.*?)   : ([0-9\.]+)/) {
		$tw = $1;  $acc = $2;
		$accuracy += $acc; $counter++;
	    }
	    
	    if($_=~/Confidence for (.*?) : ([0-9\.]+)/) {
		$conf += $2; $conf_flag = 1;
	    }
	    
	} close FILE;
	
	$accuracy = $accuracy / $counter;
	$overall += $accuracy;
	write OVERALL;
	
	if(($conf_flag == 1) and (defined $opt_confidence)) {
	    $conf = $conf/ $counter;
	    $confidence += $conf;
	    $accuracy = $conf;
	    $tw = "confidence";
	    write OVERALL;
	    print OVERALL "\n";		
	}
	
	
    }

    print OVERALL "\n";

    $tw = "Overall Accuracy";
    $accuracy = $overall/($#resultFiles+1);
    
    write OVERALL;

    print OVERALL "\n";
    
    if( ($conf_flag == 1) and (defined $opt_confidence) ) {
	$tw = "Overall Confidence";
	$accuracy = $confidence / ($#resultFiles+1);
	write OVERALL;
    }

    close OVERALL;
    
    print "Results are located: $resultsDir/OverallResults\n";
}

##############################################################################
#  print the accuracy of a single target word in the results file
##############################################################################
sub setAccuracy() {
    
    my $prefix = shift;
    
    if($debug) { print STDERR "In setAccuracy\n"; }
    
    opendir(WEKADIR, "$wekaDir") || die "Could not open directory $wekaDir\n";
    my @files = grep { $_=~/$prefix/ } readdir WEKADIR; close WEKADIR;

    #  open the results file for this source
    open(RESULTS, ">$resultsDir/$prefix") || die "Could not open file: $resultsDir/$prefix";
    
    my $counter= 0;
    foreach $file (@files) {

	$counter++;

	if(! (-e "$wekaDir/$file") ) {
	    print STDERR "ERROR: The WEKA file ($wekaDir/$file) does not exist\n";
	    exit;
	}    
	
	if(-z "$wekaDir/$file") {
	    print STDERR "ERROR: The WEKA file ($wekaDir/$file) is empty\n";
	    exit;
	}
	
	# open weka file and get the accuracy
	open(WEKA, "$wekaDir/$file") || die "Could not open WEKA file: $wekaDir/$file\n";	
	my $right = 0; my $wrong = 0; my $confidence = 0; 
	while(<WEKA>) {
	    chomp;
	    if($_=~/^\s*$/) { next; }
	    if($_=~/inst\#/) { next; }
	    if($_=~/=== Predictions on test data ===/) { 
		if($debug) { print STDERR "$_\n"; }
		next;
	    }
	    $_=~s/^\s+//g;
	    $_=~s/\s+^//g;
	    
	    $_=~s/[+-]//g;
	    
	    my ($num, $gold, $answer, $confid) = split/\s+/;
	    if($debug) { print STDERR "$num, $gold, $answer, $confid\n"; }
     	    if($answer=~/$gold/) { $right++; } else { $wrong++; }
	    $confidence += $confid;

	} close WEKA;
	
	if($debug) { print STDERR "RIGHT: $right\n"; }
	if($debug) { print STDERR "WRONG: $wrong\n"; }
	

	my $accuracy = $right / ($right + $wrong);
	$confidence = $confidence / ($right+$wrong);

	if(defined $opt_cv) {
	    print RESULTS "Fold: $counter : $accuracy\n";
	    print RESULTS "Fold Accuracy: $accuracy\n"; 
	}

	print RESULTS "Accuracy for $prefix   : $accuracy\n";
	print RESULTS "Confidence for $prefix : $confidence\n\n";
    }
    
    close RESULTS;
}	


##############################################################################
#  get the accuracy of a single target word when performing cross validation
##############################################################################
sub setWekaCvAccuracy() {
    
    my $prefix = shift;

    my $accuracy = 0; 
    
    # open weka file and get the accuracy
    open(WEKA, "$wekaDir/$prefix.weka") || die "Could not open WEKA file: $wekaDir/$prefix.weka\n";

    while(<WEKA>) {
	chomp;
	if($_=~/Correctly Classified Instances/) {
	    my @array = split/\s+/; pop @array; $accuracy = pop @array; 
	}
    } close WEKA;
    
    #  open the results file for this source
    open(RESULTS, ">$resultsDir/$prefix") || die "Could not open file: $resultsDir/$prefix";

    print RESULTS "Accuracy for $prefix   : $accuracy\n";
    
    close RESULTS;
}	

##############################################################################
#  set the options for the mm2arff program
##############################################################################
sub setOptions {

    my $o = "";
    if(defined $opt_debug)        { $o .= "--debug ";                              }
    if(defined $opt_similarity)   { $o .= "--similarity ";                         }
    if(defined $opt_freq)         { $o .= "--freq   ";                             }
    if(defined $opt_phrase)       { $o .= "--phrase ";                             }
    if(defined $opt_sentence)     { $o .= "--sentence ";                           }
    if(defined $opt_line)         { $o .= "--line ";                               }
    if(defined $opt_pos)          { $o .= "--pos ";                                }
    if(defined $opt_head)         { $o .= "--head ";                               }
    if(defined $opt_relation)     { $o .= "--relation ";                           }
    if(defined $opt_punc)         { $o .= "--punc ";                               }
    if(defined $opt_lc)           { $o .= "--lc ";                                 }
    if(defined $opt_key)          { $o .= "--key $opt_key ";                       } 
    if(defined $opt_mesh)         { $o .= "--mesh ";                               }
    if(defined $opt_mmi)          { $o .= "--mmi $opt_mmi ";                       }
    if(defined $opt_collocations)   { $o .= "--collocations ";                     }
    if(defined $opt_ngramcount)   { $o .= "--ngramcount \"$opt_ngramcount\" ";     }
    if(defined $opt_ngrammeasure) { $o .= "--ngrammeasure \"$opt_ngrammeasure\" "; }
    if(defined $opt_ngramstat)    { $o .= "--ngramstat \"$opt_ngramstat\" ";       }
    if(defined $opt_cuicount)     { $o .= "--cuicount \"$opt_cuicount\" ";         }
    if(defined $opt_cuimeasure)   { $o .= "--cuimeasure \"$opt_cuimeasure\" ";     }
    if(defined $opt_cuistat)      { $o .= "--cuistat \"$opt_cuistat\" ";           }
    if(defined $opt_firstranked)  { $o .= "--firstranked ";                        }
    if(defined $opt_conflatedcuis){ $o .= "--conflatedcuis ";                      }
    if(defined $opt_stcount)      { $o .= "--stcount \"$opt_stcount\" ";           }
    if(defined $opt_stmeasure)    { $o .= "--stmeasure \"$opt_stmeasure\" ";       }
    if(defined $opt_ststat)       { $o .= "--ststat \"$opt_ststat\" ";             }
    if(defined $opt_nspconfig)    { $o .= "--nspconfig $opt_nspconfig ";           }
    if(defined $opt_stop)         { $o .= "--stop $opt_stop ";                     }
    if(defined $opt_idfstop)      { $o .= "--idfstop $opt_idfstop ";               }
    if(defined $opt_simconfig)    { $o .= "--simconfig $opt_simconfig ";           }
    $o .= "--log $logDir ";

    return $o;
}

##############################################################################
#  get the prefix
##############################################################################
sub setPrefix {
    my $s = shift;

    my @temp = split/\//, $s;

    my $p = pop @temp;
    $p=~s/[A-Za-z]+\///g;
    $p=~s/\.mm//g;
    #$p=~s/\.[A-Za-z0-9]+$//g;
    #$p=~s/[A-Za-z0-9]+\.//g;
    
    return $p;
}

##############################################################################
#  set the weka command
##############################################################################
sub setWeka {
    my $w = "";
    if(defined $opt_weka) { $w .= "$opt_weka"; }
    #else { $w .= "weka.classifiers.functions.SMO"; }
    else { $w .= "weka.classifiers.bayes.NaiveBayes"; }
    return $w;
}

##############################################################################
#  set the time stamp
##############################################################################
sub timeStamp {
    my ($stamp);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    
    $year += 1900;
    $mon++;
    $d = sprintf("%4d%2.2d%2.2d",$year,$mon,$mday);
    $t = sprintf("%2.2d%2.2d%2.2d",$hour,$min,$sec);
    
    $stamp = $d . $t;
    return($stamp);
}

##############################################################################
#  function to output minimal usage notes
##############################################################################
sub minimalUsageNotes {
    
    print STDERR "Usage: supervised-disambiguate.pl [OPTIONS] SOURCE\n";
    askHelp();
    exit;
}

##############################################################################
#  function to output help messages for this program
##############################################################################
sub showHelp() {

    print "Usage: supervised-disambiguate.pl [OPTIONS] SOURCE\n\n";
    
    print "This is a wrapper program for supervised WSD using CuiTools\n";
    print "programs. It takes as input (SOURCE) a directory containing \n"; 
    print "files in the CuiTools xml-like .mm format or a single file\n";
    print "in the xml-like .mm format. The program extracts specified \n";
    print "features and trains/tests a classifier using the WEKA data \n";
    print "mining package. The overall results are stored in a file \n";
    print "called overallResults located in the results directory. If \n";
    print "no feature option is chosen, the default feature setting is \n";
    print "used: --ngramcount \"--ngram 1 --frequency 2\"\n\n";

    print "FEATURES:\n\n";


    print "--pos                      Part of speech of the target word\n\n";
    
    print "--head                     Whether the target word is the head\n";
    print "                           word of its phrase\n\n";

    print "--relation                 The semantic relations between the semantic \n";
    print "                           types of the target word and the semantic types \n"; 
    print "                           of the words in the same context as the target \n";
    print "                           word\n\n";

    print "--mesh                     Uses the MeSH terms assigned to the abstract\n";
    print "                           containing the target word\n\n";

    print "--mmi                      Uses the MMI terms assigned to the abstract\n";
    print "                           containing the target word\n\n";

    print "--ngramcount \"OPTIONS\"   Words in the same context as the target\n";
    print "                           word and any additional options to be passed\n";
    print "                           to count.pl program.\n";
    print "                           Default: --ngramcount \"--ngram 1 --frequency 2\"\n";

    print "--ngrammeasure \"OPTIONS\" Measure of assocation used by the statistic.pl\n";
    print "                           program for feature selection. Used with the\n";
    print "                           --ngramcount option\n\n";

    print "--ngramstat \"OPTIONS\"    Options to be passed to the statistic.pl \n";
    print "                           program for feature selection\n\n";

    print "--cuicount \"OPTIONS\"     Words in the same context as the target\n";
    print "                           word and any additional options to be passed\n";
    print "                           to count.pl program.\n\n";

    print "--cuimeasure \"OPTIONS\"   Measure of assocation used by the statistic.pl\n";
    print "                           program for feature selection. Used with the\n";
    print "                           --cuicount option\n\n";

    print "--cuistat \"OPTIONS\"      Options to be passed to the statistic.pl \n";
    print "                           program for feature selection\n\n";

    print "--firstranked              The first CUI in the set of one or more CUIs\n";
    print "                           found in the mapping (that have the highest\n";
    print "                           MTI score) Note: The default is to use all of\n";
    print "                           them\n\n"; 

    print "--conflatedcuis            Combine all the CUIS in the set of one or more \n";
    print "                           CUIs found in the mapping into one sorted string \n";
    print "                           and use the string as a feature\n\n";

    print "--stcount \"OPTIONS\"      Words in the same context as the target\n";
    print "                           word and any additional options to be passed\n";
    print "                           to count.pl program.\n\n";

    print "--stmeasure \"OPTIONS\"    Measure of assocation used by the statistic.pl\n";
    print "                           program for feature selection. Used with the\n";
    print "                           --stcount option\n\n";

    print "--ststat \"OPTIONS\"       Options to be passed to the statistic.pl \n";
    print "                           program for feature selection\n\n";

    print "--nspconfig FILE           the --ngramcount, --ngrammeasure and --ngramstat\n";
    print "                           options (as well as the corresponding cui and st)\n";
    print "                           can be passed through a config file. See perldoc\n";
    print "                           for more information\n";

    print "--punc                     Removes punctuation in for the ngramcount option\n\n";
    
    print "--lc                       Lowercases all the words for the ngramcount option\n\n";

    print "--phrase                   Context is the phrase that contains the target word.\n";
    print "                           The phrases are identified by MetaMap.\n\n";

    
    print "--sentence                 Context is the sentence that contains the target word\n\n";
    
    print "--line                     Context is the entire line that was given (DEFAULT)\n\n";

    print "EXPERIMENTATION OPTIONS:\n\n";

    print "--weka CLASSIFIER          The weka machine learning algorithm to run the \n";
    print "                           feature set on. The program is expecting the \n";
    print "                           java command that would be used to run weka.\n";
    print "                           Default: weka.classifiers.bayes.NaiveBayes\n\n";

    print " --wekacv NUMBER           This will perform NUMBER-fold cross validation on\n"; 
    print "                           the training data using the WEKA datamining package.\n\n";

    print "--wekaparams OPTIONS       Option so that the user can directly pass weka \n";
    print "                           parameters through the command line\n\n";

    print "--javaparams OPTIONS       Option so that the user can directly pass java \n";
    print "                           parameters through the command line\n\n";

    print "--cv NUMBER                This will perform our implementation of X-fold\n";
    print "                           cross validation. This is different than --wekacv\n";
    print "                           because the features in the option are only extracted \n";
    print "                           from the training portion of the data.\n";
    print "                           (Default: --cv 10)\n\n";
  
    print "--seed NUMBER              This is used with the --cv option in order\n";
    print "                           to seed the random number generator for \n";
    print "                           for the cross validation. Default: --seed 1\n\n";

    print " --split                   The program will split the training data into a TEST \n";
    print "                           and TRAIN file where NUMBER is the percentage of the \n";
    print "                           dataset aside for testing. \n\n";
    
    print " --test FILE               The program will train on the SOURCE file and \n";
    print "                           test on the given test FILE.\n\n";

    print "--nokey                    The test data does not contain the sense tags. The\n";
    print "                           id and sense tag assigned by the classifier will be\n";
    print "                           in the file, test.answers, in the log directory. This\n";
    print "                           option can only be used with the --test option\n\n";
    
    print " --key FILE                If the test file does not contain the answers \n";
    print "                           a key file can be used. The format expected is\n";
    print "                           the same as the Senseval-2 formatted key file.\n\n";

    print "--binary                   Uses a binary indicator to represent whether a \n";
    print "                           feature exists. DEFAULT\n\n";

    print "--freq                     Uses the frequency count of a feature to represent\n";
    print "                           its existance in the learning algorithm.\n\n";

    print "PROGRAM OPTIONS: \n\n"; 

    print "--debug                    Sets the debug option on\n\n";

    print "--directory PREFIX         The prefix that the directories for the weka and\n";
    print "                           arff files. Default: dir (the directories would be\n";
    print "                           dir.(weka|arff|results).<timestamp>\n\n";

    print "--stop FILE                Stoplist for the count.pl program. This can also\n";
    print "                           be added in the --ngramcount option but I wanted \n";
    print "                           to add it here as well in case people were not as \n";
    print "                           familiar with NSP.\n\n";

    print "--idfstop DIR              Directory containing the idf stoplists for each of \n";
    print "                           the target words.\n\n"; 

    print "--version                  Prints the version number\n\n";
 
    print "--help                     Prints this help message.\n\n";
}

##############################################################################
#  function to output the version number
##############################################################################
sub showVersion {
    print '$Id: supervised-disambiguate.pl,v 1.50 2016/01/20 18:16:42 btmcinnes Exp $';
    print "\nCopyright (c) 2007-2008, Ted Pedersen & Bridget McInnes\n";
}

##############################################################################
#  function to output "ask for help" message when user's goofed
##############################################################################
sub askHelp {
    print STDERR "Type supervised-disambiguate.pl --help for help.\n";
}
    
