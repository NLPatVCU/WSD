#!/usr/bin/perl -w

=head1 NAME

nlm2mm.pl

=head1 SYNOPSIS

Converts the NLM-WSD data set to the xml-like .mm format used by 
the CuiTools package using current UMLS information.

=head1 DESCRIPTION

This program takes as input the National Library of Medicine's 
Word Sense Disambiguation (NLM-WSD) data set and converts it 
to our xml-like mm format for processing with the CuiTools 
word sense disambiguation programs.

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

The directory that the .mm output files should go. The 
output file names will be named <targetword>.mm

=head3 BASIC_REVIEWED_RESULTS_DIRECTORY

This is the Basic_Reviewed_Results directory from the 
PMID version of the NLM-WSD data set. Note, that 
this program only works for the PMID version of the 
NLM-WSD data set.

=head2 Optional Arguments:

head3 --log DIRECTORY

Directory to contain temporary and log files. DEFAULT: nlm2mm.log

=head3 --help

Displays the quick summary of program options.

=head3 --version

Displays the version information.

=head1 OUTPUT

nlm2mm.pl converts the data set to the CuiTools xml-like .mm format.

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


use Getopt::Long; 

eval(GetOptions( "version", "help", "log=s") )or die("Please check the above mentioned option(s).\n");

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

my $mmResults    = shift;

#  check that destination has been supplied
if( !($mmResults) ) {
    print STDERR "No output directory (DESTINATION) supplied.\n";
    &minimalUsageNotes();
    exit;
}
 
if( -e $mmResults ) {
    print STDERR "Output directory ($mmResults) for nlm2mm already exists! Overwrite (Y/N)?";
    my $reply = <STDIN>;  chomp $reply; $reply = uc($reply);
    exit 0 if ($reply ne "Y"); 
} 

my $BasicReviewedResults = shift;

if(! (-d $BasicReviewedResults)) {
    print STDERR "ERROR: The \"Basic Reviewed Results\" is not a directory\n";
    &minimalUsageNotes();
    exit;
}

my $timestamp = &timeStamp();
my $log = "$timestamp.nlm2mm.log";
if(defined $opt_log) {
    $log = $opt_log;
}
if(! (-e $log) ) {
    system "mkdir $log";
}

my $svalResults  = "nlm2sval2_results";
my $plainResults = "$log/sval2plain_results";
my $prologResults = "$log/plain2prolog_results";


# convert NLM-WSD Basic Reviewed Results to sval2 format
print STDERR "convert NLM-WSD Basic Reviewed Results to sval2 format\n\n";

system "nlm2sval2driver.pl $BasicReviewedResults";

opendir(DIR, "$svalResults") || 
    die "Could not open directory: $svalResults\n";

my @dirs = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" } readdir DIR;

# convert each of the NLM WSD sval2 files into plain text
print STDERR "convert each of the NLM WSD sval2 files into plain text\n\n";

system "mkdir $plainResults";

foreach $dir (@dirs) {
    my $file = "$svalResults/$dir/$dir.abstract.sval2";

    print "$file\n";

    system "sval2plain.pl --senseinfo $file > $plainResults/$dir.plain";
}

# convert each of the NLM WSD plain files into mm format
print STDERR "convert each of the NLM WSD plain files into prolog format\n\n";

system "plain2prolog.pl  --log $log $prologResults $plainResults";

#foreach $dir (@dirs) {
system "prolog2mm.pl --nlm --log $log $mmResults $prologResults";
#}

# remove the plain and sval2 result directory
#system "rm -rf $svalResults";


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
#  SUB FUNCTIONS
##############################################################################

#  function to output minimal usage notes
sub minimalUsageNotes {
    
    print STDERR "Usage: nlm2mm.pl [OPTIONS] DESTINATION Basic_Reviewed_Results DIRECTORY\n";
    print STDERR "Type nlm2mm.pl --help for help.\n\n";

}

#  function to output help messages for this program
sub showHelp() {

    print "Usage: nlm2mm.pl [OPTIONS] DESTINATION Basic_Reviewed_Results DIRECTORY\n\n";
    
    print "Takes as input nlm text and converts it to the CuiTools\n";
    print "the xml-like .mm format.\n\n";

    print "OPTIONS:\n\n";

    print "--log DIRECTORY          Directory to contain log files.\n";
    print "                         DEFAULT: nlm2mm.log\n\n";

    print "--version                Prints the version number\n\n";

    print "--help                   Prints this help message.\n\n";
}

#  function to output the version number
sub showVersion {
        print '$Id: nlm2mm.pl,v 1.17 2009/01/20 21:39:51 btmcinnes Exp $';
        print "\nCopyright (c) 2007-2008, Ted Pedersen & Bridget McInnes\n";
}

#  function to output "ask for help" message when user's goofed
sub askHelp {
    print STDERR "Type nlm2mm.pl --help for help.\n";
}
    
