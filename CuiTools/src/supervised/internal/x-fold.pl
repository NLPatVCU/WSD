#!/usr/bin/perl  -w

=head1 NAME

x-fold.pl 

=head1 SYNOPSIS

This program randomly splits a file in mm format into a training 
and test files. 

=head1 DESCRIPTION

This program randomly splits a file in our xml-like .mm format in 
to X number of files so that X-fold cross validation can be performed.

=head1 USAGE

x-fold.pl [OPTIONS] DESTINATION SOURCE

=head1 INPUT

=head2 Required Arguments:

=head3 DESTINATION (DIRECTORY)

The DIRECTORY for the test and training files. The training files will 
be labeled <fold>.train and the test files will be labeled <fold>.test

=head3 SOURCE (FILE)

The mm formated file to be split into training and test files 
to perform x-fold cross validation

=head2 Optional Arguments:

=head3 --fold NUMBER

This indicates the number of folds. Default = 10


=head3 --seed NUMBER

This is used with the --cv option in order to seed the 
random number generator for the cross validation

Default: --seed 1

=head3 --help

Displays the summary of command line options.

=head3 --version

Displays the version information.

=head1 OUTPUT

This program output two files for each fold: i) <fold>.test and 
ii) <fold>.train. Each file is in .mm format and can be used by 
the disambiguate.pl program.

=head1 PROGRAM REQUIREMENTS

=over

=item * Perl (version 5.8.5 or better) - http://www.perl.org

=back

=head1 AUTHOR

Bridget McInnes, University of Minnesota, Twin Cities

=head1 COPYRIGHT

Copyright (c) 2007-2008,

 Ted Pedersen, University of Minnesota, Duluth.
 tpederse at umn.edu

 Bridget McInnes, University of Minnesota, Twin Cities
 bthomson at cs.umn.edu

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
use Getopt::Long;

GetOptions( "version", "help", "fold=s", "seed=s");

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

my $fold = 10;
if( defined $opt_fold ) {
    $fold = $opt_fold;
}

if(defined $opt_seed) {
    srand($opt_seed);
} else { srand(1); }
    

my $destination = shift;
my $source = shift;

#  check that destination has been supplied
if( !($destination) ) {
    print STDERR "No output directory (DESTINATION) supplied.\n";
    &askHelp();
    exit;
}

if(-e "$destination") {

    if( !(-d "$destination")) {
	print STDERR "DESTINATION must be a directory\n";
	&askHelp();
	exit;
    }
    print STDERR "DESTINATION directory ($destination) alreadly exists!";
    print STDERR "Overwrite (Y/N)?";

    my $reply = <STDIN>;  chomp $reply; $reply = uc($reply);
    exit 0 if ($reply ne "Y"); 

} else { system "mkdir $destination"; } 

#  check that source has been supplied
if( !($source) ) {
    print STDERR "No output directory (SOURCE) supplied.\n";
    &askHelp();
    exit;
}

if( -d "$source") {
    print "SOURCE must be a file\n";
    &askHelp();
    exit;
}

open(SRC, $source)|| die "Could not open source file: $source\n";

my @InstanceArray    = ();
my $line            = "";
my $OpenCorpusLine  = "";
my $OpenLexeltLine  = "";
my $CloseCorpusLine = "";
my $CloseLexeltLine = "";

while(<SRC>) { 

    if($_=~/\<corpus/)   { $OpenCorpusLine  = $_; next; }
    if($_=~/\<lexelt/)   { $OpenLexeltLine  = $_; next; }
    if($_=~/\<\/lexelt/) { $CloseLexeltLine = $_; next; }
    if($_=~/\<\/corpus/) { $CloseCorpusLine = $_; next; }
    
    $line .= $_;
    
    if($line=~/\<\/instance\>/) { 
	push @InstanceArray, $line;
	$line = "";
    }
}

&fisher_yates_shuffle(\@InstanceArray);

#  set split
$split = int( ($#InstanceArray+1) / $fold );

if($split < 1) { 
    print "The fold must be equal to or greater than ";
    print "the number of instance in the SOURCE file\n\n";
    &askHelp();
    exit;
}

my $first = 0;
my $last  = $split;

for (1..$fold) {
    
    open(TEST, ">$destination/$_.mm.test");
    open(TRAIN, ">$destination/$_.mm.train");

    print TEST "$OpenCorpusLine";
    print TEST "$OpenLexeltLine";

    print TRAIN "$OpenCorpusLine";
    print TRAIN "$OpenLexeltLine";
        
    for my $i (0..$#InstanceArray) {
	
	if( ($i >= $first) and ($i < $last) ) {
	    print TEST "$InstanceArray[$i]";
	}
	else {
	    print TRAIN "$InstanceArray[$i]";
	}
    }

    print TEST "$CloseLexeltLine";    
    print TEST "$CloseCorpusLine";
    
    print TRAIN "$CloseLexeltLine";
    print TRAIN "$CloseCorpusLine";

    $first = $last;
    $last  = $last + $split;
}

###############################################################################
#
#   Function:   fisher_yates_shuffle
#   Purpose:    Randomize an array
#
#   Comments:   This routine was ripped from 'Perl Cookbook' Section 4.17
#
#               fisher_yates_shuffle( \@array ) : generate a random 
#               permuatation of @array in place
###############################################################################
sub fisher_yates_shuffle {
    my $array = shift;
    my $i;
    for ($i = @$array; --$i; ) {
        my $j = int rand ($i+1);
        next if $i == $j;
        @$array[$i,$j] = @$array[$j,$i];
    }
}

##############################################################################
#  SUB FUNCTIONS
##############################################################################

#  function to output minimal usage notes
sub minimalUsageNotes {
    
    print STDERR "Usage: x-fold.pl [OPTIONS] DESTINATION SOURCE\n";
    print STDERR "Type x-fold.pl --help for help.\n\n";
}

#  function to output help messages for this program
sub showHelp() {

    print "Usage: x-fold.pl [OPTIONS] DESTINATION SOURCE\n\n";
    
    print "Takes as input a text in .mm format and splits it into \n";
    print "test and training files for x-fold cross validation.\n\n";

    print "OPTIONS:\n\n";

    print "--fold NUMBER            The desired fold for cross validation\n";
    print "                         Default: 10\n\n";

    print "--seed NUMBER            This is used with the --cv option in order\n";
    print "                         to seed the random number generator for \n";
    print "                         for the cross validation. Default: --seed 1\n\n";

    print "--version                Prints the version number\n\n";

    print "--help                   Prints this help message.\n\n";
}

#  function to output the version number
sub showVersion {
        print '$Id: x-fold.pl,v 1.7 2008/07/11 23:35:39 btmcinnes Exp $';
        print "\nCopyright (c) 2007, Ted Pedersen & Bridget McInnes\n";
}

#  function to output "ask for help" message when user's goofed
sub askHelp {
    print STDERR "Type x-fold.pl --help for help.\n";
}
    
