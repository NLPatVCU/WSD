#!/usr/bin/perl -w
=head1 NAME

prolog2mm.pl

=head1 SYNOPSIS

Converts the NLM-WSD data set to the xml-like .mm `Xformat used by 
the CuiTools package using current UMLS information.

=head1 DESCRIPTION

This program takes as input the format of the National 
Library of Medicine's Word Sense Disambiguation and 
converts it to our xml-like mm format for processing 
with the CuiTools word sense disambiguation programs.

=head1 USAGE

perl prolog2mm.pl DESTINATION SOURCE

=head1 INPUT

=head2 Required Arguments:

=head3 DESTINATION

The directory that the .mm output files should go. The 
output file names will be named <targetword>.mm

=head3 SOURCE

If you are using the NLM-WSD dataset then the required 
SOURCE is

    NLMWSDHOME/Reviewed_Results

Otherwise it is the directory that is formated similar to 
that of the Reviewed_Results directory. The output directory 
to the plain2prolog.pl program is an example of this format. 

=head2 Optional Arguments:

=head3 --metamap TWO DIGIT YEAR

Specifies which version of metap to use. The default is 10 which will 
run metamap10.

=head3 --log DIRECTORY

Directory to contain temporary and log files. DEFAULT: prolog2mm.log

=head3 --nlm

The dataset being used the NLM-WSD dataset

=head3 --none 

Removes instances tagged with None from the dataset

=head3 --help

Displays the quick summary of program options.

=head3 --version

Displays the version information.

=head1 OUTPUT

prolog2mm.pl converts the data set to the CuiTools xml-like .mm format.

=head1 THE .mm FORMAT

See L<README.mm.format>

=head1 PROGRAM REQUIREMENTS

=over

=item * Perl (version 5.8.5 or better) - http://www.perl.org

=item * MetaMap - http://metamap.nlm.nih.gov/

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
    
###############################################################################

#                               THE CODE STARTS HERE
###############################################################################

#                           ================================
#                            COMMAND LINE OPTIONS AND USAGE
#                           ================================

use lib "$ENV{CUITOOLSHOME}/lib";

use Getopt::Long; 
use UMLS::CuiTools::MM;

eval(GetOptions( "version", "help", "none", "nlm", "log=s"))or die ("Please check the above mentioned option(s).\n");

my $handler = new UMLS::CuiTools::MM;

if(defined $opt_none) {
    $opt_none = 1;
}

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

if(defined $opt_none) {
  #
}

#  check if the log is defined
my $timestamp = &timeStamp();
my $log = "$timestamp.prolog2mm.log";
if(defined $opt_log) {
  $log = $opt_log;
}

#  create the log directory
if(! (-e $log)) {
  system "mkdir $log";
}

my $outputDir = shift;
my $inputDir  = shift;

my $ReviewedResults  = "$inputDir";


opendir(DIR, "$ReviewedResults") || 
    die "Could not open directory: $ReviewedResults\n";


#  check that destination has been supplied
if( !($outputDir) ) {
    print STDERR "No output directory (DESTINATION) supplied.\n";
    &askHelp();
    exit;
}
 
if( -e $outputDir ) {
    print "Output directory ($outputDir) for prolog2mm already exists! Overwrite (Y/N)?";
    my $reply = <STDIN>;  chomp $reply; $reply = uc($reply);
    exit 0 if ($reply ne "Y"); 
} 
else { system("mkdir $outputDir"); }

my @dirs = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" and $_ ne "raw_summary" and $_ ne "index.shtml" and $_ ne "index.html" } readdir DIR;

foreach my $targetWord (sort @dirs) {

    #  get the needed files
    my $resultFile = "$ReviewedResults/$targetWord/results";
    my $directory  = "$ReviewedResults/$targetWord/machine_output";
    my $choiceFile = "$ReviewedResults/$targetWord/choices";
    
    #  open the destination file
    open(DST, ">$outputDir/$targetWord.mm") || 
	die "Could not open file: $outputDir/$targetWord.mm\n";
    
    #  get the machine code files from the target word directory
    opendir(DIR, $directory) || die "Could not open directory $directory\n";

    my @files = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS"} readdir DIR;
    for (0..$#files) { $files[$_] = "$directory/$files[$_]"; }
    
    #  get the results for each instance
    my %resultHash  = ();
    my @resultArray = ();
    my %idHash      = ();

    open(RESULTS, $resultFile) || die "Could not open file: $resultFile\n";
    while(<RESULTS>) {
	chomp;
	if($_=~/^\s*$/) { next; }
	my ($num, $id, $answer) = split/\|/;
	
	$id = $num; 
	$resultHash{$id} = $answer; 
	push @resultArray, $id;
	$idHash{$id} = $id;
    }

    #  get the possible senses for the instances
    my $choices = "";
    open(CHOICES, $choiceFile) || die "Could not open file: $choiceFile\n";
    while(<CHOICES>) {
	chomp;
	if($_=~/^\s*$/) { next; }
	my @array = split/\|/;
	my $c1 = shift @array;
	$choices .="$c1,";
    } 
    $choices .= "None";

    #  set the target word and initialize the output
    my $tword = $targetWord; 
    $tword=~s/_/ /g; 

    #  not all the target words in the nlmwsd dataset 
    #  are of the exact name as the target word
    my $nlmword = $tword;
    if(defined $opt_nlm) {
	if($tword eq "adjustment")           { $nlmword = "adjustment|adjustments"; }
	elsif($tword eq "association")       { $nlmword = "association|associative"; }
	elsif($tword eq "blood pressure")     { $nlmword = "blood pressure|blood_pressure|blood-pressure"; }
	elsif($tword eq "culture")           { $nlmword = "culture|cultural|culturing"; }
	elsif($tword eq "depression")        { $nlmword = "depression|depressive"; }
	elsif($tword eq "determination")     { $nlmword = "determination|determining|determined"; }
	elsif($tword eq "discharge")         { $nlmword = "discharge|discharging"; }
	elsif($tword eq "energy")            { $nlmword = "energy|energies"; }
	elsif($tword eq "extraction")        { $nlmword = "extraction|extract"; }
	elsif($tword eq "immunosuppression") { $nlmword = "immunosuppression|immunodepression"; }    
	elsif($tword eq "mole")              { $nlmword = "mole|mol"; }
	elsif($tword eq "nutrition")         { $nlmword = "nutrition|trophic|nutritive"; }
        elsif($tword eq "pathology")         { $nlmword = "pathology|pathobiology|pathobiological"; }
	elsif($tword eq "scale")             { $nlmword = "scale|scalar"; }
	elsif($tword eq "secretion")         { $nlmword = "secretion|secretory"; }
	elsif($tword eq "sensitivity")       { $nlmword = "sensitivity|sensitiv"; }
	elsif($tword eq "surgery")           { $nlmword = "surgery|surgeries"; }
        elsif($tword eq "transient")         { $nlmword = "transient|transience"; }
        elsif($tword eq "weight")            { $nlmword = "weight|wt"; }
    }

    my $output = "";

    my $btmcounter = 0;
    my $resultnum = 1; 

    foreach $file (@files) { 

	open(FILE, $file) || die "Could not open file $file\n";
	
        my $id         = "";
	my $prolog     = "";
	my $line       = "";
	my $abstractId = "";
	my $aoutput    = "";

	my $location           = "";
	my $character_location = "";
	my $counter            = 0;
	my $lcounter           = 0;
	my $nlmtw              = "no";

	while(<FILE>) {
	    chomp;
	    
	    #  set the utterance information
	    if($_=~/^utterance\(\'(.*?)\'\,\"(.*)\"/) {
		$id = $1; my $input = $2;
		

		#  add the utterance to the line
		$line .= "$input ";
			
		#  find out where you are in the line
		my @inputarray = split/\s+/, $input;
		my @linearray  = split/\s+/, $line;
		 
		#  get the abstract id
		$id=~/([0-9]+)\./;
		$abstractId = $1; 

		#  check if utterance contains the target word
		my $tw = "no";  $nlmtw = "no";
		
		if(defined $opt_nlm) { 
		    if($idHash{$abstractId} eq "$id") { 
			$tw = "yes"; $nlmtw = "yes";
		    }
		}
		else {
		    #  get the location of the target word
		    $idHash{$abstractId}=~/[0-9]+\.([0-9]+)\./;
		    $location = $1;

		    print STDERR "$id : $lcounter : $#linearray : $location : $character_location\n";

		    if( ($location >=  $lcounter) && 
			($location <= $#linearray) ) { 
			$tw = "yes"; 
			$line=~s/\;/ \;/g; 
			my @larray = split/\s+/, $line;
			my @barray = ();
			for my $i (0..($location)) { push @barray, $larray[$i]; }
			my $bstring = join " ", @barray;
			my @carray = split//, $bstring;
			$character_location = $#carray + 1;
			$btmcounter++;
			print STDERR "$abstractId : $line : $location : $character_location\n";
		    }
		    #  increment where we are in the utterences
		    $lcounter += ($#inputarray + 1);
		}
		
		#  print the sentence header
		$aoutput .= $handler->setSentenceHeader($_, $tw);

	    }
	    elsif($_=~/phrase\(/ || $_=~/\'EOU\'\./) {
		
		#  if prolog is empty continue\n";
		if($prolog eq "") { $prolog = "$_\n"; next; }
		

		#  what is the phrase - this is more for error checking
		$prolog=~/phrase\(\'?(.*?)\'?\,\[/;
		my $phrase = $1;

		#  find out if the target word is in the pharse		
		my $tw = "no"; 	my $index = -1; 

		if(defined $opt_nlm) { 
		    if($nlmtw eq "yes") {
			my $lcphrase = lc($phrase);
			if($lcphrase=~/($nlmword)/) { 
			    $lcphrase=~s/\'+s//g;
			    $lcphrase=~s/[\-\,\"\'\;\>\(\)\/\+\=]/ /g; 
			    $lcphrase=~s/^\s+//g;
			    if($tword eq "blood pressure") { 
				$lcphrase=~s/blood pressure/blood_pressure/g;
			    }
			    my @array = split/\s+/, $lcphrase;
			    my $temp = join "\|", $lcphrase;
			    my $i = 0;
			    foreach my $word (@array) {
				$word = lc($word);
				if($word=~/($nlmword)/) { 
				    $index = $i; $tw = "yes"; $nlmtw = "no";
				}
				$i++;
			    }
			}
		    }
		}
		else {
		    $prolog=~/\,([0-9]+)\/([0-9]+)\,\[/;
		    my $num1 = $1; my $range = $2;
		    my $num2 = $num1 + $range;
		    print STDERR "NO NLM: $prolog";
		    print STDERR "$num1 : $num2 : $phrase\n\n";
		    if($character_location ne "") {  
			if( ($character_location >= $num1) && 
			($character_location <= $num2) ) { 
			    $tw = "yes";
			    my $i     = -1;
			    my $count = $num1; 
			    #$phrase=~s/-/ /g;
			    $phrase=~s/^\s*//g;
			    $phrase=~s/\s*$//g;
			    $phrase=~s/\s+/ /g;
			    my @warray = split/\s+/, $phrase; 
			    my $flag = 0;
			    print STDERR "WORDS: @warray\n";
			    foreach my $word (@warray) {
				#  check that it is not a paranthesis which 
				#  does horrible things to the code and 
				#  for some reason isn't treated like a token
				if($word eq "(" or $word eq ")") { $flag++; }
				#  add a space at the end of the word
				$word = $word . " "; 
				#  increment where we are in the array
				$i++;
				#  check if this is the target word
				my @chars = split//, $word; 
				foreach my $char (@chars) { 
				    if($character_location == $count) { 
					$index = $i;
					print STDERR "INDEX: $warray[$index] : $index: $character_location : $count : $char : $flag\n";
					for (1..$flag) { $index--; }
				    }
				    $count++;
				}
			    }
			    print STDERR "$phrase : $num1 : $num2 : $abstractId : $tword : $index\n";
			}
		    }
		}

		
		#  print the parse the phrase
		$aoutput .= $handler->parsePhrase($prolog, $tw, $index, $tword, $id);
				
		#  add the phrase information for the next phrase
		$prolog = "$_\n";

		#  if EOU then print the sentence footer 
		if($_=~/\'EOU\'\./) {
		    $aoutput .= $handler->setSentenceFooter();
		    $prolog = "";
		}
		
	    }
	    elsif($_=~/mappings/) {
		#  add the mapping and/or candidate information
		$prolog .= "$_\n";
	    }
	}
	
	if((defined $opt_none) and ($resultHash{$idHash{$abstractId}}=~/None/)) { next; }
	
	
	if($abstractId=~/^\s*$/) { next; }
	
	$abstractId = $resultnum; $resultnum++; 
	$output .= $handler->setInstanceHeader($abstractId,
					       $targetWord, 
					       $idHash{$abstractId}, 
					       $resultHash{$idHash{$abstractId}}, 
					       $line);
	
	$output .= $aoutput;
	
	$output .= $handler->setInstanceFooter();
    }
   
    print DST $handler->getHeader($targetWord, $choices);
    print DST "$output";
    print DST $handler->getFooter();
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
    
    print STDERR "Usage: prolog2mm.pl [OPTIONS] DESTINATION SOURCE\n";
    print STDERR "Type prolog2mm.pl --help for help.\n\n";
}

#  function to output help messages for this program
sub showHelp() {

    print "Usage: prolog2mm.pl DESTINATION SOURCE\n\n";
    
    print "Takes as input the NLM-WSD data set (or some other SOURCE\n";
    print "directory with the same prolog format) and converts it to\n";
    print "our xml-like .mm format. The SOURCE is the directory\n";
    print "containing the Reviewed_Results directory form the NLM-WSD\n";
    print "data set. DESTINATION is the directory containing the\n";
    print "output files.\n\n";

    print "OPTIONS:\n\n";

    print "--log DIRECTORY          Directory to contain log files.\n";
    print "                         DEFAULT: <timestamp.prolog2mm.log\n\n";

    print "--none                   Removes instances tagged with\n";
    print "                         None from the dataset\n\n";

    print "--nlm                    The NLM-WSD dataset is being converted.\n\n";
    
    print "--version                Prints the version number\n\n";

    print "--help                   Prints this help message.\n\n";
}

#  function to output the version number
sub showVersion {
        print '$Id: prolog2mm.pl,v 1.34 2016/01/20 18:16:43 btmcinnes Exp $';
        print "\nCopyright (c) 2007-2008, Ted Pedersen & Bridget McInnes\n";
}

#  function to output "ask for help" message when user's goofed
sub askHelp {
    print STDERR "Type prolog2mm.pl --help for help.\n";
}

