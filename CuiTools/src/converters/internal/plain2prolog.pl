#!/usr/bin/perl -w

=head1 NAME

plain2prolog.pl

=head1 SYNOPSIS

Converts plain formated data to the prolog format used in 
the NLM-WSD dataset.

=head1 DESCRIPTION

This program takes as input plain formated data and converts it 
to the prolog format similar to that of the NLM-WSD Reviewed 
Results directory.

=head1 USAGE

perl nlm2mm.pl DESTINATION Basic_Reviewed_Results DIRECTORY 

=head1 The MetaMap COMMAND

    The MetaMap command used in the program is:

    $ENV{METAMAP_PATH}/metamap08 -q InputFile OutputFile
   
         where --q option outputs the data in machine code

Note: the METAMAP_PATH environment variable must be set to the 
bin directory containing the metamap program

    For example:

      in bash: export METAMAP_PATH=/home/bthomson/metamap/public_mm/bin

      in cshrc: set env METAMAP_PATH /home/bthomson/metamap/public_mm/bin

=head1 INPUT

=head2 Required Arguments:

=head3 DESTINATION

The directory that will contain the prolog files. The 
structure of this directory is similar to that of the 
NLM-WSD Reviewed_Results directory.

=head3 SOURCE

SOURCE can be a directory or a file. 

=head2 Optional Arguments:

=head3 --metamap TWO DIGIT YEAR

Specifies which version of metap to use. The default is 10 which will 
run metamap10.                       

=head3 --log DIRECTORY

Directory to contain temporary and log files. DEFAULT: plain2prolog.log

=head3 --help

Displays the quick summary of program options.

=head3 --version

Displays the version information.

=head1 OUTPUT

plain2prolog.pl converts the data set to the CuiTools xml-like .mm format.

=head1 THE plain FORMAT

In plain format each line of the text files contains a single context 
where the ambiguous word is identified by:

<head item="target word" instance="instance" sense="sense">word</head>.

For example: 

Paul was named <head item="art" instance="art.30002" sense="art">Art</head> magazine's top collector.


=head1 PROGRAM REQUIREMENTS

=over

=item * Perl (version 5.8.5 or better) - http://www.perl.org

=item * MetaMap - http://metamap.nlm.nih.gov

=item * National Library of Medicine Word Sense Disambiguation 
        (NLM-WSD) dataset - http://wsd.nlm.nih.gov

=back

=head1 AUTHOR

 Bridget T. McInnes, University of Minnesota, Twin Cities    
=head1 COPYRIGHT

Copyright (c) 2007-2008,

 Bridget T. McInnes, University of Minnesota, Twin Cities
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


use lib "$ENV{CUITOOLSHOME}/lib";

use Getopt::Long; 
use UMLS::CuiTools::MM;

eval(GetOptions("metamap=s", "version", "help", "log=s", "headless")) or die ("Please check the above mentioned option(s).\n");

my $handler = new UMLS::CuiTools::MM;

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

#  if no arguments are on the command line
if($#ARGV < 0) {
    $opt_help = 1;
    &minimalUsageNotes();
    exit;
}

#  check if log directory name is defined
my $timestamp = &timeStamp();
my $log = "$timestamp.plain2prolog.log";
if(defined $opt_log) {
    $log = $opt_log;
}

my $metamap = "metamap";
if(defined $opt_metamap) { 
    $metamap = "metamap" . $opt_metamap;
}

#  create the log directory
if(! (-e $log) ) {
    system "mkdir $log";
}

my $destination = shift;
#  check that destination directory has been supplied
if( !($destination) ) {
    print STDERR "No output directory (DESTINATION) supplied.\n";
    &askHelp();
    exit;
}

#  check if the destination directory already exists otherwise make it
if( -e $destination ) {
    print "DESTINATION ($destination) already exists! Overwrite (Y/N)?";
    my $reply = <STDIN>;  chomp $reply; $reply = uc($reply);
    exit 0 if ($reply ne "Y"); 
} 
else { system("mkdir $destination"); } 


my $source = shift;

#  check  that the source exists
if(! (-e $source)) {
    print STDERR "Source ($source) does not exist\n";
    &askHelp();
    exit;
}

#  get the source files
my @files = ();
if(-d $source) {
    opendir(DIR, $source) || die "Could not open directory $source\n";
    my @dirs = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and $_ ne "raw_summary" and $_ ne "index.shtml" and $_ ne "index.html" } readdir DIR;
    foreach (@dirs) { push @files, "$source/$_"; }
}
else {
    push @files, $source;
}


foreach my $file (@files) {
    
    my $targetWord = "";

    open(FILE, $file) || die "Could not open file: $file\n";

    my %choices   = ();

    my @senses    = ();
    my @results   = ();    
    my @instances = ();
    
    my $idcounter = 1;

    while(<FILE>) {
       	
	chomp;
	
	if($_=~/^\s*$/) { next; }
	
	#  get the sense information from the instances head tag
	my $item; my $id; my $sense; my $word; my $before; my $after;
	if($_=~/<head item=\"(.*?)\" instance=\"(.*?)\" sense=\"(.*?)\">(.*?)<\/head>/) {

	    $item   = $1;
	    $id     = $2;
	    $sense  = $3;
	    $word   = $4;	    
	    $before = $`;
	    $after  = $'; #'
	}
	elsif($_=~/<head>(.*?)<\/head>/) {

	    $item   = $1;
	    $before = $`;
	    $after  = $'; #'
	    $id     = $idcounter.$idcounter;
	    $sense  = "UK";
	    $word   = $item;	    

	    $idcounter++;
	}
	else {
	    $item   = "Unknown";
	    $before = $_;
	    $after  = "";
	    $id     = "$idcounter.$idcounter";
	    $sense  = "UK";
	    $word   = "Unknown";
	    
	    $idcounter++;
	}
	
	#  set the line
	my $line = $before . " " . $word . " " . $after;

	#  get rid of the spaces
	$line=~s/\s+/ /g;
	$line=~s/^\s+//g;
	$line=~s/\s+$//g;

	#  count the number of target words before the 
	#  the actual target word
	my $count = 0;
	while($before=~/$word/g) { $count++; } $count++;

	$before=~s/^\s*//g; $before=~s/\s*$//g;
	my @before_words = split/\s+/, $before;
	my $location = $#before_words + 1;
	
	my $abstractId = $id;
	
	#  get the prolog output for the line
	my $mmtxline = &callMetaMap($line); 
	
	#  replace the utterance numbers with the abstract id 
	#  and the postfile .tx.<number> 	
	$mmtxline=~s/utterance\(\'(.*?)\.(tx.[0-9]+)\'/utterance\(\'$abstractId\.$2\'/g;

	#  replace target word utterance with the target word id
	my $tcount = 0; 
	while($mmtxline=~/utterance\(\'(.*?)\',\"(.*?)\"\)\./g) {
		
	    my $num      = $1;
	    my $sentence = $2;
	    
	    while($sentence=~/$word/g) { 
		$tcount++;
      
		if($tcount == $count) {
		    $mmtxline=~s/utterance\(\'$num\',/utterance\(\'$id\',/;
		    $tcount++;
		    last;
		}
	    }
	}
	
	
	$choices{$sense}++; 

	$targetWord = $item;

	push @results, $id;
	push @senses, $sense;
	push @instances, $mmtxline;
    }
    #  get the needed files
    my $resultFile = "$destination/$targetWord/results";
    my $directory  = "$destination/$targetWord/machine_output";
    my $choiceFile = "$destination/$targetWord/choices";
    
    #  create the target word directory
    if(! (-e "$destination/$targetWord") ){ 
	system "mkdir $destination/$targetWord";
    }
    
    #  create the  machine_output directory
    if(! (-e "$directory") ) {
	system "mkdir $directory";
    }
    
    #  populate the result information
    my $counter = 1;
    open(RESULT, ">$resultFile") || die "Could not open result file: $resultFile\n";
    for my $i (0..$#results) {
	print RESULT "$counter|$results[$i]|$senses[$i]\n";
	$counter++;
    }

    #  populate the choice information
    open(CHOICE, ">$choiceFile") || die "Could not open choice file: $choiceFile\n";
    foreach my $choice (sort keys %choices) { 
	if($choice eq "None") { next; }
	print CHOICE "$choice| | \n";
    }
    
    #  populate the machine_code directory
    $counter = 1;
    foreach my $prolog (@instances) {
	open(FILE, ">$directory/cit.$counter") || die "Could not open file: $directory/cit.$counter\n";
	print FILE "$prolog";
	close FILE;
	$counter++;
    }
}

sub callMMTx 
{
    my $line = shift;
    
    my $output = "";
    
    my $timestamp = &timeStamp();
    my $mmtxInput  = "$log/tmp.mmtx.input.$timestamp";
    my $mmtxOutput = "$log/tmp.mmtx.output.$timestamp";
    
    open(MMTX_INPUT, ">$mmtxInput") || die "Could not open file: $mmtxInput\n";
    
    print MMTX_INPUT "$line\n"; close MMTX_INPUT;
    
    system("$ENV{MMTX_PATH}/nls/mmtx/bin/MMTx -q --fileName=$mmtxInput --outputFileName=$mmtxOutput");
    
    open(MMTX_OUTPUT, $mmtxOutput) || die "Could not open file: $mmtxOutput\n";

    while(<MMTX_OUTPUT>) { $output .= $_; }
    
    return $output;
}

sub callMetaMap
{    
    my $line = shift;
    
    my $output = "";
    
    my $timestamp = &timeStamp();
    my $mmtxInput  = "$log/tmp.mmtx.input.$timestamp";
    my $mmtxOutput = "$log/tmp.mmtx.output.$timestamp";

    open(MMTX_INPUT, ">$mmtxInput") || die "Could not open file: $mmtxInput\n";
    
    print MMTX_INPUT "$line\n"; close MMTX_INPUT;
    
    system("$ENV{METAMAP_PATH}/$metamap -q -c $mmtxInput $mmtxOutput");

    open(MMTX_OUTPUT, $mmtxOutput) || die "Could not open file: $mmtxOutput\n";    
    while(<MMTX_OUTPUT>) { $output .= $_; }
    
    return $output;
}


##############################################################################
#  SUB FUNCTIONS
##############################################################################
#  set the time stamp
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

#  function to output minimal usage notes
sub minimalUsageNotes {
    
    print STDERR "Usage: plain2prolog.pl [OPTIONS] DESTINATION SOURCE\n";
    print STDERR "Type plain2prolog.pl --help for help.\n\n";
}

#  function to output help messages for this program
sub showHelp() {

    print "Usage: plain2prolog.pl DESTINATION SOURCE\n\n";
    
    print "This program takes as input plain formated data\n";
    print "and converts it to the prolog format similar to that \n";
    print "of the NLM-WSD Reviewed Results directory.\n\n";

    print "OPTIONS:\n\n";

    print "--metamap TWO DIGIT YEAR Specifies which version of metamap\n";
    print "                         to use. The default is 10 which will\n";
    print "                         run the program ./metamap10.\n\n";

    print "--log DIRECTORY          Directory to contain log files.\n\n";

    print "--version                Prints the version number\n\n";

    print "--help                   Prints this help message.\n\n";
}

#  function to output the version number
sub showVersion {
        print '$Id: plain2prolog.pl,v 1.20 2016/01/20 18:16:43 btmcinnes Exp $';
        print "\nCopyright (c) 2007-2010, Ted Pedersen & Bridget McInnes\n";
}

#  function to output "ask for help" message when user's goofed
sub askHelp {
    print STDERR "Type plain2prolog.pl --help for help.\n";
}
    
