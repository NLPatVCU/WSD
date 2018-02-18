#!/usr/bin/perl -w


=head1 NAME

mmChecker.pl

=head1 SYNOPSIS

This program checks to see if a .mm file is correct. Note, I do 
not have all possible checks in this program. This is a work in 
progress. As I notice things that should be checked I add them.
If you have any suggestions of what else should be checked 
please let me know.

=head1 USGAE

mmChecker.pl [OPTIONS] SOURCE

=head1 INPUT

=head2 Required Arguments:

=head3 SOURCE (DIRECTORY or FILE)

The mm formated file or a directory containing mm formated files.

=head2 Optional Arguments:

=head3 --help

Displays the summary of command line options.

=head3 --version

Displays the version information.

=head1 OUTPUT

The output is through standard out. It will contain the file, instance 
and problem.

=head1 AUTHOR

Bridget McInnes, University of Minnesota, Twin Cities

Ted Pedersen, University of Minnesota, Duluth

=head1 COPYRIGHT

Copyright (c) 2002-2008,

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

eval(GetOptions( "version", "help"))or die ("Please check the above mentioned option(s).\n");

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

my $SOURCE      = shift;

#  check that source has been supplied
if( !($SOURCE) ) {
    print STDERR "No input file/directory (SOURCE) supplied.\n";
    &askHelp();
    exit;
}

my @files = ();
if(-d $SOURCE) {
    opendir(DIR, "$SOURCE") || 
	die "Could not open directory: $SOURCE\n";
    my @f = grep { $_ ne '.' and $_ ne '..' and $_ ne "CVS" } readdir DIR;
    foreach (@f) { push @files, "$SOURCE/$_"; }
}
else {
    push @files, $SOURCE;
}

my $instance = "";
my $answer   = "";
my $lexelt   = "";
my $corpus   = "";
my $context  = "";


my $target = 0;
my $id     = "";

foreach $file (@files) {
    
    open(FILE, $file) || die "Could not open file: $file\n";

    
    while(<FILE>) {
	
	if($_=~/<instance id=\"(.*?)\" alias/) {
	    $id     = $1;
	    $target = 0;
	}

	if($_=~/<target/) {
	    $target++;
	}

	if($target > 1) { 
	    print "Instance $id in file $file has more than one target word!\n\n";
	}

	if($_=~/<\/instance/) {
	    if($target < 1) { 
		print "Instance $id in file $file does not have a target word!\n\n";
	    }
	}
	
    } 
    
} 


##############################################################################
#  SUB FUNCTIONS
##############################################################################

#  function to output minimal usage notes
sub minimalUsageNotes {
    
    print STDERR "Usage: mmChecker.pl [OPTIONS] SOURCE\n";
    askHelp();
}

#  function to output help messages for this program
sub showHelp() {

    print "Usage: mmChecker.pl [OPTIONS] SOURCE\n\n";
    
    print "Takes as input a text in .mm format or directory containing\n";
    print "mm formated files and checks to see if there are any errors.\n\n";

    print "OPTIONS:\n\n";

    print "--version                Prints the version number\n\n";

    print "--help                   Prints this help message.\n\n";
}

#  function to output the version number
sub showVersion {
        print '$Id: mmChecker.pl,v 1.4 2008/06/11 00:03:17 btmcinnes Exp $';
        print "\nCopyright (c) 2007, Ted Pedersen & Bridget McInnes\n";
}

#  function to output "ask for help" message when user's goofed
sub askHelp {
    print STDERR "Type mmChecker.pl --help for help.\n";
}
    
