#!/usr/bin/perl -w

=head1 NAME

unsupervised-disambiguate.pl

=head1 SYNOPSIS

This is a wrapper program for unsupervised word sense 
disambiguation using CuiTools programs. 

=head1 DESCRIPTION

The program takes as input the data directory (SOURCE) and 
returns the results stored in the results directory.

For unsupervised WSD, the program will extract the specified 
features as well as the context of the potential coXncepts and 
create vectors (using SenseCluster functions). These vectors 
will be analyzed using the cosine measure and the instance 
vector that is closest to the possible concept vector will 
be assigned that concept.

=head1 USAGE

perl unsupervised-disambiguate.pl [OPTIONS] SOURCE

=head1 INPUT

=head2 Required Arguments:

=head3 SOURCE

Directory containing the CuiTools xml-like .mm formatted file.

=head2 Required Options:

=head4 --senses [DIR|FILE]

Directory containing the sense information that corresponds to
each of the datasets in the SOURCE directory. This is located 
in the default_options directory. This directory is called: 

    NLM-WSD.target_word.choices


And can also be downloaded downloaded from:

    http://wsd.nih.gov

If you are using another dataset, the expected format is:

<TAG>|<TERM>|<Semanticc Type>|<CUI>

For example, one of the possible concepts for the target word 
adjustment is:

Adjustment <1> (Individual Adjustment)|inbe, Individual Behavior|C0376209

The expected name of the file is <target word>.choices. For 
our adjustment example, the name of the sense file is 
"adjustment.choices"

=head2 First-order Options: 

=head3 --cuidef

Use the extended UMLS CUI definition of the possible concepts as context 
[Default]. 

This definition comes from the UMLS-Interface package using the command: 
    getExtendedDefinition($cui);

The definitions to include in this are defined in the configuration 
file. 

=head3 --config CONFIGURATION FILE

The configuration file for the --cuidef option. This is used by the UMLS-Interface 
package to create the extended definition. The default is to use all of the UMLS 
and all relations to create the extended definition. 

=head3 --summary FILE

File containing a text description of each possible concept for each 
possible target word in the source directory. The format is as follows:

    <tw>.<concept>.<summary>
    ...

=head2 Second-order Options

=head3 --training [DIR|FILE]

Directory containing the training data that corresponds to 
each of the data sets in the SOURCE directory 
or 
a file containing the training data

The following format for the file(s) (either in the directory 
or passed into the command line) is as follows:

The expected name for each of the corresponding training files 
is :

    <target word>.trainingdata

For example, the target word adjustment would have the 
file "adjustment.trainingdata" located in the training 
directory.

=head3 --stop STOPFILE

A file of Perl regexes that define the stop list of words to be excluded from 
the features.

STOPFILE could be specified with two modes -

AND mode - declared by including '@stop.mode=AND' on the first line of the
STOPFILE.
         - ignores word pairs in which both words are stop words.

OR mode - declared by including '@stop.mode=OR' on the first line of the
STOPFILE.
        - ignores word pairs in which either word is a stop word.

Both modes exclude stop words from unigram features.

Default is OR mode.

=head4 --ngramcount "OPTIONS"

The Ngram Statistic Package (NSP) count.pl program is used to obtain 
the counts for the first and second-order co-occurrence vectors. The 
options specify any additional options to be passed to count.pl program.

 Note: All the options must be within double quotes, as
      would be passed to the program at command line.

Current 1st order options are:
 --ngram 1 
 --newLine 
 --token $ENV{CUITOOLSHOME}/default_options/token.regex
 --remove 2 
 --uremove 150 
 --stop $ENV{CUITOOLSHOME}/default_options/stoplist $directory/$tw.unigrams $opt_training

Current 2nd order options are:
 --ngram 2 
 --extended 
 --newLine 
 --token $ENV{CUITOOLSHOME}/default_options/token.regex 
 --remove 2 
 --uremove 150 
 --stop $ENV{CUITOOLSHOME}/default_options/stoplist  


=head2 Program Options;

=head3 --vectors [o1|o2]

First order (o1) or second order (o2) vectors are used. 

=head3 --directory

The prefix that the directories for the log and results files.

Default: dir

The results file location: <directory>.results
The vector files location: <directory>.logs

The log files directory also contains any log file 
associated with the unsupervised-disambiguate program.

=head3 --help

Displays the quick summary of program options.

=head3 --version

Displays the version information.

=head1 OUTPUT

mm2arff.pl creates one file in arff format. This file can be used as input 
training data to the WEKA data mining package.

=head1 THE .mm FORMAT

See README.mm.format

=head1 PROGRAM REQUIREMENTS

=over

=item * Perl (version 5.8.5 or better) - http://www.perl.org

=item * Text::NSP - http://search.cpan.org/dist/Text-NSP

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
use Math::SparseVector;

# catch, abort and print the message for unknown options specified
eval(GetOptions( "version", "help", "cuidef", "summary=s", "gloss", "stop=s", "lc", "training=s", "bigramfile=s", "unigramfile=s", "statfile=s", "senses=s", "directory=s", "vectors=s", "context=s", "other=s", "similarity=s", "measure=s", "verbose", "config=s", "username=s", "password=s", "hostname=s", "database=s", "socket=s", "cosine", "euclidean", "dice", "debug", "ngramcount=s", "format=s", "svd", "svdfile=s", "wrdvecfile=s", "featfile=s", "testregexfile=s")) or die ("Please check the above mentioned option(s).\n");

#  set the debug
my $debug = 0;
if(defined $opt_debug) { $debug = $opt_debug; }

# option variables
my $stop        = "";
my $options     = "";
my $directory   = "";
my $lc          = ""; 
my $format      = ""; 

#  directory variables
my $resultsDir    = "";
my $logDir    = "";

#  accuracy variables
my $correct = 0;
my $wrong   = 0;

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

#  check that arguments exist
if($#ARGV < 0) {
    $opt_help = 1;
    &minimalUsageNotes();
    exit;
}

#  check that source file exist
if(! (-e $ARGV[$#ARGV]) ) {
    print STDERR "Source file or directory (SOURCE) does not exist\n";
    &minimalUsageNotes();
    exit;
}    

&checkOptions();

my $source  = shift;

#  check that source has been supplied
if( !($source) ) {
    print STDERR "No output directory (SOURCE) supplied.\n";
    &minimalUsageNotes();
    exit;
}

#  make the sub directories
system "rm -rf $logDir $resultsDir\n";
system("mkdir $logDir");
system("mkdir $resultsDir");


#  get the test files
my @test_files = ();
if(-d $source) {
    opendir(DIR, $source) || die "Could not open source directory: $source\n";
    my @dirs = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and $_ ne "raw_summary" and $_ ne "index.shtml"} readdir DIR;
    foreach my $file (@dirs) { push @test_files, "$source/$file"; }
}
else { push @test_files, $source; }

#  directory or file containing training data
my %training_files = ();

&setTraining();

my %sense_files = ();
&setSenses();

# open the destination file
open(DST, ">$resultsDir/OverallResults") || 
    die "Could not open destination file: $resultsDir/OverallResults\n";

my $overall_accuracy = 0;
my $overall_counter  = 0;

foreach my $file (sort @test_files) {
    
    my $target_word = "";
    
    if($file=~/\//) { $file=~/(.*)(\/)(.*?)\.(mm|plain)$/; $target_word = $3; }
    else            { $file=~/(.*?)\.(mm|plain)/;	   $target_word = $1; }

    if($target_word=~/^\s*$/) { next; }

    if($debug) { 
	print STDERR "FILE: $file\n";    
	print STDERR "TARGET WORD: *$target_word*\n";
    }
    
    if(! (exists $sense_files{$target_word})) {
	print STDERR "Sense file for $target_word does not exist.\n";
	exit;
    }
    
    if( !(exists $training_files{$target_word})) {
	print STDERR "Training file for $target_word does not exist.\n";
	exit;
    }
    
    if(defined $opt_verbose) {
	print "create-vectors.pl $options --training $training_files{$target_word} --instances $file --senses $sense_files{$target_word} --tw $target_word $logDir\n";
	#print "create-vectors.pl $options --training $training_files{\"train\"} --instances $file --senses $sense_files{$target_word} --tw $target_word $logDir\n";
    }
    system "create-vectors.pl $options --training $training_files{$target_word} --instances $file --senses $sense_files{$target_word} --tw $target_word $logDir";
    #system "create-vectors.pl $options --training $training_files{\"train\"} --instances $file --senses $sense_files{$target_word} --tw $target_word $logDir";
   
    
    open(SENSES, "$logDir/$target_word.senses.vectors")       || 
	die "Could not open $logDir/$target_word.senses.vectors\n";
    open(INSTANCES, "$logDir/$target_word.instances.vectors") || 
	die "Could not open $logDir/$target_word.instances.vectors\n";
    open(INSTANCES_KEY, "$logDir/$target_word.instances.key")           || 
	die "Could not open $logDir/$target_word.instances.key\n";
    open(SENSES_KEY, "$logDir/$target_word.senses.key")           || 
	die "Could not open $logDir/$target_word.senses.key\n";
    
    my @instances         = ();
    my @senses            = ();
    my @instances_key     = ();
    my @senses_key        = ();
    my @senses_mags       = ();
    my @instances_mags    = ();
    my $n                 = 0;

    while(<INSTANCES_KEY>) {
	chomp;
	$_=~/<instance id=\"(.*?)\"\/> <sense id=\"(.*?)\"\/>/;
	push @instances_key, $2;
    } close INSTANCES_KEY;

    while(<SENSES_KEY>) {
	chomp;
	$_=~/<instance id=\"(.*?)\"\/> <sense id=\"(.*?)\"\/>/;
	push @senses_key, $2;
    } close SENSES_KEY;

    my $ikey    = <INSTANCES>;
    my $iheader = <INSTANCES>;
    while(<INSTANCES>) {
	chomp;
	push @instances, $_;
    } close INSTANCES;


    my $skey    = <SENSES>;
    my $sheader = <SENSES>;
    while(<SENSES>) {
	chomp;
	
	$_=~s/^\s*//g; 
	$_=~s/\s$//g; 
	
	my @vec = split/\s+/;
	
	my $sensevec = Math::SparseVector->new;
	my $i = 0;
	my $smag = 0;
	my $x = 1; 
	while ($i < $#vec) {

	    if(defined $opt_svd) {
		if($vec[$i] > 0) { 
		    $sensevec->set($x, $vec[$i]);
		}
	    }
	    else { 
		$sensevec->set($vec[$i++], $vec[$i]);
	    }
	    $smag += ($vec[$i]**2); 
	    $i++; $x++; 
	}
	$smag = sqrt($smag);
	push @senses_mags, $smag;
	push @senses, $sensevec;
    } close SENSES;

    $correct = 0; $wrong = 0;

    for my $i (0..$#instances) {
	my $instance    = $instances[$i];
	my $sense       =  $instances_key[$i];

	my $answer = ""; 

	
	$instance=~s/^\s*//g; 
	$instance=~s/\s$//g; 
	
	my @vec         = split/\s+/, $instance;

	my $instancevec = Math::SparseVector->new;
	my $i           = 0;
	my $imag        = 0;
	my $x           = 1; 

	while ($i <= $#vec) {
	    if(defined $opt_svd) { # svd is dense
		if($vec[$i] > 0) { 
		    $instancevec->set($x, $vec[$i]);  
		}
	    }
	    else { 
		$instancevec->set($vec[$i++], $vec[$i]);
	    }
	    $imag += ($vec[$i]**2);
	    $i++; $x++; 
	}
	$imag = sqrt($imag);
	
	
	my $max = -1; my $min = -1;    

	for my $j (0..$#senses) {	
	    
	    my $sensevec = $senses[$j];
	    my $tag      = $senses_key[$j];
	    my $smag     = $senses_mags[$j];
	 

	    my @s_indices = $sensevec->keys;
	    my @i_indices = $instancevec->keys;
	    
	    my %indicesHash = ();
	 
	    foreach my $index (@s_indices) { $indicesHash{$index}++; }
	    foreach my $index (@i_indices) { $indicesHash{$index}++; }
 
	    #  calculates the euclidean distance
	    if(defined $opt_euclidean) {	    
		my $euclideanvec = Math::SparseVector->new;
		foreach my $index (sort (keys %indicesHash)) {
		    my $i_value = $instancevec->get($index);
		    my $s_value = $sensevec->get($index);
		    my $diff    = $i_value - $s_value;
		    if($diff != 0) {
			$euclideanvec->set($index, $diff);
		    }
		}
		my $ed = $euclideanvec->norm;
		if($min == -1) { $min = $ed; }
		if($ed <= $min) {
		    $answer = $tag;
		    $min    = $ed;
		}
		
	    }
	    #  calculates the dice coefficient
	    elsif(defined $opt_dice) {
		my $union = 0;
		foreach my $index (sort (keys %indicesHash)) {
		    my $i_value = $instancevec->get($index);
		    my $s_value = $sensevec->get($index);
		    if( ($i_value != 0) && ($s_value != 0) ) {
			$union++;
		    }
		}
		$dice = (2*$union) / ($#i_indices + $#s_indices);
		if($dice >= $max) {
		    $answer = $tag;
		    $max = $dice;
		}
	    }		    
	    #  calculates the cosine meaure
	    else {
		my $cosine = $instancevec->dot($sensevec);
		#my $dotprod = $instancevec->dot($sensevec);
		#my $cosine = 0;
		#if( ($smag*$imag) == 0 ) { $cosine = 0 } 
		#else { $cosine  = $dotprod / ($smag*$imag); }
		if($cosine >= $max) {
		    $answer = $tag; 
		    $max = $cosine;
		}
		if($opt_verbose) { print STDERR "$tag ($cosine) "; }
	    }
	}
	if($opt_verbose) { print STDERR ": $answer $sense\n"; }
	if($answer eq $sense) { $correct++; }
	else                  { $wrong++;   }  
    }

    my $denom = $correct + $wrong;
    if($denom == 0) { next; }
    
    my $accuracy = $correct / ($correct + $wrong);
    print DST "ACCURACY for $target_word : $accuracy\n";

    $overall_counter++;
    $overall_accuracy += $accuracy;
    
}

$overall_accuracy = $overall_accuracy / $overall_counter;
print DST "OVERALL ACCURACY : $overall_accuracy\n";

print "Results are located: $resultsDir/OverallResults\n";

sub setTraining {
    
    if($debug) { print STDERR "In setTraining\n"; }
    
    if(defined $opt_training) {
	if(-d $opt_training) {
	    opendir(DIR, $opt_training) || die "Could not open $opt_training directory\n";
	    my @dirs = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and 
				  $_ ne "raw_summary" and $_ ne "index.shtml"} readdir DIR;
	    foreach my $file (@dirs) { 
		$file=~/(.*?)\.trainingdata/;
		my $tw = uc($1); 
		$training_files{$tw} = "$opt_training/$file";
	    }
	}
	else { 
	    my $tw = "";
	    if($opt_training=~/\//) { $opt_training=~/(.*)(\/)(.*?)\.trainingdata/; $tw = $3; }
	    else                    { $opt_training=~/(.*?)\.trainingdata/;	    $tw = $1; }
	    $training_files{$tw} = $opt_training;
	    #$training_files{"train"} = $opt_training;
	}
    }
    else {
        foreach my $file (sort @test_files) {
	    
	    my $tw = "";

	    if($file=~/\//) { $file=~/\/([A-Za-z0-9\_\-]+)\.(mm|plain)$/; $tw = $1; }
	    else            { $file=~/(.*?)\.(mm|plain)/;                 $tw = $1; }
	    
	    my $train = "$logDir/$tw.trainingdata";
	    $train=~s/\/\//\//g;
	    print STDERR "TRAINING FILE: $train\n";
	    
	    if($format=~/mm/) { 

		my $mm2plain_options = ""; 	    
		if(defined $opt_lc)      { $mm2plain_options = "--lc "; }
		if(defined $opt_context) { $mm2plain_options = "--context $opt_context "; }

		if(defined $opt_verbose) { 
		    print STDERR "mm2plain.pl $mm2plain_options $file > $train\n";
		}
		
		#system "compoundify.pl compoundword.txt $file > $file.compounds"; 
		
		system "mm2plain.pl $mm2plain_options $file > $train";
	    }
	    else { 

		open(PLAIN, "$file") || die "Could not open plain file ($file)\n";
		open(TRAIN, ">$train") || die "Could not open train file ($train)\n";
		while(<PLAIN>) { 
		    chomp;
		    $_=~s/<head item=\"(.*?)\" instance=\"(.*?)\" sense=\"(.*?)\">(.*?)<\/head>/<head>$tw<\/head>/g; 
		    print TRAIN "$_\n";
		} 
		close PLAIN; close TRAIN; 
	    }

	    $training_files{$tw} = $train;
	}
    }
}

sub setSenses {

    if($debug) { print STDERR "In setSenses\n"; }

    if(defined $opt_senses) {
	if(-d $opt_senses) {
	    opendir(DIR, $opt_senses) || die "Could not open $opt_senses directory\n";
	    my @dirs = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and 
				  $_ ne "raw_summary" and $_ ne "index.shtml"} readdir DIR;
	    foreach my $file (sort @dirs) { 
		$file=~/(.*?)\.choices/;	    
		my $tw = $1; 
		if($debug) { print STDERR "$tw : $file\n"; }
		$sense_files{$tw} = "$opt_senses/$file";
	    }
	}
	else { 
	    my @array = split/\//, $opt_senses;
	    my $file  = $array[$#array];
	    $array[$#array]=~/(.*?)\.choices/;	
	    my $tw = $1; 
	    $sense_files{$tw} = $opt_senses;
	}
    }
    else {
	opendir(DIR, "$ENV{CUITOOLSHOME}/default_options/NLM-WSD.target_word.choices") || 
	    die "Could not open NLM-WSD.target_word.choices directory in CUITOOLSHOME\n";
	my @dirs = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and 
			      $_ ne "raw_summary" and $_ ne "index.shtml"} readdir DIR;
	foreach my $file (@dirs) { 
	    $file=~/(.*?)\.choices/;	    
	    my $tw = $1;
	    $sense_files{$tw} = "$ENV{CUITOOLSHOME}/default_options/NLM-WSD.target_word.choices/$file";
	}
    }
}

sub checkOptions
{
    if($debug) { print STDERR "In checkOptions\n"; }
    
    my $default = "";
    my $set     = "";

    #  check svd
    if(defined $opt_svd) { 
	$set .= "  --svd\n";
	$options .= "--svd "; 
    }
    
    #  check files
    if(defined $opt_svdfile) { 
	$set .= "  --svdfile $opt_svdfile\n";
	$options .= "--svdfile $opt_svdfile "; 
    }
    if(defined $opt_unigramfile) { 
	$set .= "  --unigramfile $opt_unigramfile\n";
	$options .= "--unigramfile $opt_unigramfile "; 
    }
    if(defined $opt_bigramfile) { 
	$set .= "  --bigramfile $opt_bigramfile\n";
	$options .= "--bigramfile $opt_bigramfile "; 
    }
    if(defined $opt_statfile) { 
	$set .= "  --statfile $opt_statfile\n";
	$options .= "--statfile $opt_statfile "; 
    }
    if(defined $opt_wrdvecfile) { 
	$set .= "  --wrdvecfile $opt_wrdvecfile\n";
	$options .= "--wrdvecfile $opt_wrdvecfile "; 
    }
    if(defined $opt_featfile) { 
	$set .= "  --featfile $opt_featfile\n";
	$options .= "--featfile $opt_featfile "; 
    }
    if(defined $opt_testregexfile) { 
	$set .= "  --testregexfile $opt_testregexfile\n";
	$options .= "--testregexfile $opt_testregexfile "; 
    }

    #  check input format
    if(defined $opt_format) { 
	$set .= "  --format $opt_format\n";
	$format = $opt_format; 
	$options .= "--format $opt_format "; 
    }
    else { 
	$default = "  --format mm\n"; 
	$format = "mm"; 
    }

    #  set the training directory
    if(defined $opt_training) {
	$set .= "  --training $opt_training\n";
    } 

    #  set the senses directory
    if(defined $opt_senses) {
	$set .= "  --senses $opt_senses\n";
    }
    else {
	$default .= "  --senses $ENV{CUITOOLSHOME}/default_options/NLM-WSD.target_word.choices\n";
    }
    
    #  set the stoplist
    $stop = "$ENV{CUITOOLSHOME}/default_options/stoplist";
    if(defined $opt_stop) {
	$stop = $opt_stop;
      	$set .= "  --stop $stop\n";
    } $options .= "--stop $stop "; 
    
    if(defined $opt_lc) { 
	$lc = $opt_lc;
	$options .= "--lc "; 
	$set     .= "  --lc \n";
    } 

    if(defined $opt_ngramcount) { 
	$options .= "--ngramcount \"$opt_ngramcount\" ";
	$set     .= "  --ngramcount \"$opt_ngramcount\"\n";
    }

    #  set the context
    if(defined $opt_context) { 
	$options .= "--context $opt_context "; 
	$set     .= "  --context $opt_context\n";
    }
    else { 
	$options .= "--context terms "; 
	$set     .= "  --context terms\n";
    }
    #  set the vectors
    if(defined $opt_vectors) {
	$options .= "--vectors $opt_vectors ";
	$set     .= "  --vectors $opt_vectors\n";
    }
    else {
	$options .= "--vectors o1 ";
	$default .= "  --vectors o1\n";
    }

    #  set the similarity information
    if(defined $opt_similarity) {
	$options .= "--similarity $opt_similarity ";
	$set     .= "  --similarity $opt_similarity\n";
    }

    if(defined $opt_measure) { 
	$options .= "--measure $opt_measure "; 
	$set     .= "  --measure $opt_measure\n";
    }

    #  set umls database information
    if(defined $opt_config) {
	$options .= "--config $opt_config ";
	$set     .= "  --config $opt_config\n";
    }    
    if(defined $opt_username) {
	$options .= "--username $opt_username ";
	$set     .= "  --username $opt_username\n";
    }
    if(defined $opt_password) {
	$options .= "--password $opt_password ";
	$set     .= "  --password $opt_password\n";
    }
    if(defined $opt_hostname) {
	$options .= "--hostname $opt_hostname ";
	$set     .= "  --hostname $opt_hostname\n";
    }
    if(defined $opt_database) {
	$options .= "--database $opt_database ";
	$set     .= "  --database $opt_database\n";
    }
    if(defined $opt_socket) {
	$options .= "--socket $opt_socket ";
	$set     .= "  --socket $opt_socket\n";
    }

    #  set verbose mode
    if(defined $opt_verbose) {
	$options .= "--verbose ";
	$set     .= "  --verbose\n";
    }
	    
    #  set the representation of meaning
    if(defined $opt_cuidef) {
	$options .= "--cuidef ";
	$set     .= "  --cuidef\n";
    }

    #  set the representation of meaning
    if(defined $opt_gloss) { 
	$options .= "--gloss ";
	$set     .= "  --gloss\n";
    }

    #  set the representation of meaning
    if(defined $opt_summary) {
	$options .= "--summary $opt_summary";
	$set     .= "  --summary $opt_summary\n";
    }

    if(defined $opt_other) {
	$options .= "--other $opt_other ";
	$set     .= "  --other $opt_other\n";
    }

    if( !(defined $opt_cuidef)   and 
	!(defined $opt_summary)  and
	!(defined $opt_gloss)    and 
	!(defined $opt_other)) {
	$options .= "--cuidef ";
	$default .= "  --cuidef\n";
    }

    #  set the vector measure
    if(defined $opt_euclidean) {
	$set .= "  --euclidean\n";
	$opt_euclidean = 1;
    }
    elsif(defined $opt_dice) {
	$set .= "  --dice\n";
	$opt_dice = 1;;
    }
    elsif(defined $opt_cosine) {
	$set .= "  --cosine\n";
	$opt_cosine = 1;
    }
    else {
	$default .= "  --cosine\n";
    }

    #  set the output directories if defined
    if(defined $opt_directory) {
	$logDir = "$opt_directory.log";
	$resultsDir = "$opt_directory.results";
    }
    else {
	my $timestamp = &time_stamp();
	$resultsDir = "$timestamp.dir.results";
	$logDir     = "$timestamp.dir.log";
    }
    
    if($default ne "") {
	print "Defaults options set:\n";
	print "$default\n\n";
    }


    if($set ne "") {
	print "User defined options set:\n";
	print "$set\n\n";
    }

    print "Output Directories: \n";
    print "  LOG directory    : $logDir\n";
    print "  RESULTS directory: $resultsDir\n\n";

}

##############################################################################
#  function to create a timestamp
##############################################################################
sub time_stamp {
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
    
    print STDERR "Usage: unsupervised-disambiguate.pl [OPTIONS] SOURCE\n";
    &askHelp();
}

##############################################################################
#  function to output help messages for this program
##############################################################################
sub showHelp() {

    print "Usage: unsupervised-disambiguate.pl [OPTIONS] SOURCE\n\n";
    

    print "This is a wrapper program for unsupervised word sense\n";
    print "disambiguation using CuiTools programs. The program \n";
    print "takes as input the data directory (SOURCE)and returns \n";
    print "the results stored in <directory>.results/OverallResults.\n\n";
    
    print "For unsupervised WSD, the program will extract the specified  \n";
    print "features as well as the vectors of the potential concepts and \n";
    print "create vectors (using SenseCluster functions). These contexts \n";
    print "will be analyzed using the cosine measure and the instance \n";
    print "vector that is closest to the possible concept vector will \n\n";
    print "be assigned that concept.\n";


    print "Required Options:\n\n";

    print "--sense [DIR|FILE]       Directory containing the sense \n";
    print "                         information that corresponds to\n";
    print "                         each of the datasets in the SOURCE \n";
    print "                         directory. \n\n";

    print "First Order Options:\n\n";

    print "--cuidef                 Use the extended CUI definition of a possible\n";
    print "                         concepts (obtained from UMLS-Interface) as the\n";
    print "                         first order context (DEFAULT).\n\n";

    print "--config CONFIGURATION   UMLS-Interface configuration file\n\n";

    print "--summary FILE           FILE containing summaries of the possible\n";
    print "                         concepts.\n\n";

    print "2nd order Options:\n\n";

    print "--training [DIR|FILE]    Directory containing the training data \n";
    print "                         that corresponds to each of the data \n";
    print "                         sets in the SOURCE directory - the unigram\n";
    print "                         or bigram files are created from this.\n\n";

    print "--stop STOPFILE          A file of Perl regexes that define \n";
    print "                         the stop list of words to be excluded\n";
    print "                         from the features. DEFAULT stoplit is\n";
    print "                         located in the default_options directory\n\n";

    print "--ngramcount OPTIONS     Additional options for count.pl when creating\n";
    print "                         The first or second order vectors\n";

    print "Program Options:\n\n";
    
    print "--vectors [o1|o2]        Use first order (o1) or second order (o2)\n";
    print "                         vectors. Default: o1\n\n";
	

    print "--directory PREFIX       The prefix that the log directories and\n";
    print "                         the results\n\n";

    print "--version                Prints the version number\n\n";
 
    print "--help                   Prints this help message.\n\n";
}

##############################################################################
#  function to output the version number
##############################################################################
sub showVersion {
    print '$Id: unsupervised-disambiguate.pl,v 1.47 2016/01/20 18:16:42 btmcinnes Exp $';
    print "\nCopyright (c) 2008, Ted Pedersen & Bridget McInnes\n";
}

##############################################################################
#  function to output "ask for help" message when user's goofed
##############################################################################
sub askHelp {
    print STDERR "Type unsupervised-disambiguate.pl --help for help.\n";
}
