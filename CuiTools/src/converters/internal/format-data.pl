#!/usr/bin/perl -w

=head1 CuiTools

format-data

=head1 SYNOPSIS

    Converts data in plain, senseval-2, NLM-WSD prolog formated 
    data into the xml-like .mm format required by CuiTools

=head1 USAGE

perl format-data.pl [OPTIONS] DESTINATION SOURCE

=head1 INPUT

=head2 Required Arguments:

=head3 SOURCE

The file or directory containing files that need to be convereted

=head3 DESTINATION

The location the .mm formated files will be stored

=head2 Optional Arguments:
=head2 Options:

=head3 --plain

The data needs to be converted from plain formated text 

=head3 --sval2

The data needs to be converted from senseval-2 formated text

=head3 --nlm

The data is the NLM-WSD data set and needs to be converted as is

=head4 --prolog

The data is in the NLM-WSD prolog format and needs to converted 
using information from the current MetaMap Transfer Program (MMTx).

=head4 --none

Removes those instances tagged with None in the NLM-WSD dataset. 
This option only works with --prolog.

=head3 --help

Displays the quick summary of program options.

=head3 --version

Displays the version information.

=head1 PROGRAM REQUIREMENTS

=over

=item * Perl (version 5.8.5 or better) - http://www.perl.org

=item * MetaMap Transfer Program (MMTx)

=item * sval2plain Package

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
this program; if not, write to: 

 The Free Software Foundation, Inc.,
 59 Temple Place - Suite 330,
 Boston, MA  02111-1307, USA.

=cut

###############################################################################
#
#                               THE CODE STARTS HERE
###############################################################################
#
#                           ================================
#                            COMMAND LINE OPTIONS AND USAGE
#                           ================================

use Getopt::Long;

eval(GetOptions( "version", "help", "sval2", "prolog", "nlm", "plain", "none"))or die ("Please check the above mentioned option(s).\n");

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

my $options = "";
#  check if none is defined
if( defined $opt_none ) {
    $options = "--none ";
}

my $destination = shift;

if( -e "$destination") { 
    print "DESTINATION ($destination) already exists! Overwrite (Y/N)?";
    my $reply = <STDIN>; chomp $reply; $reply = uc($reply);
    exit 0 if ($reply ne "Y");
}

#  retrieve the source (training file or directory containing training files)
my $source = shift;

#  check that source has been supplied
if( !($source) ) {
    print STDERR "No source file (SOURCE) supplied.\n";
    &askHelp();
    exit;
}


if(defined $opt_prolog) {
    
    if(! (-e "$source/Reviewed_Results") ) {
	print STDERR "Reviewed_Results directory is not in $source.\n";
	&askHelp();
	exit;
    }

    system "prolog2mm.pl $options $destination $source\n";

}


if(defined $opt_nlm) {
     
   if(! (-e "$source/Basic_Reviewed_Results") ) {
	print STDERR "Basic_Reviewed_Results directory is not in $source.\n";
	&askHelp();
	exit;
    }

    system "nlm2mm.pl $destination $source/Basic_Reviewed_Results";

}


if(defined $opt_plain) {
    
    
    system "plain2prolog.pl $destination.prolog $source";
    system "prolog2mm.pl $destination $destination.prolog";

}


if(defined $opt_sval2) {

    system "sval2plain.pl --senseinfo $source > $destination.plain";
    system "plain2prolog.pl $destination.prolog $destination.plain";
    system "prolog2mm.pl $destination $destination.prolog";
}

##############################################################################
#  function to output minimal usage notes
##############################################################################
sub minimalUsageNotes {
    
    print STDERR "Usage: format-data.pl [OPTIONS] DESTINAION SOURCE\n";
    askHelp();
}

##############################################################################
#  function to output help messages for this program
##############################################################################
sub showHelp() {

    print "Usage: disambiguate.pl [OPTIONS] DESTINATION SOURCE\n\n";
    
    print "This is a wrapper program to convert data from plain, \n";
    print "Senseval-2, or NLM-WSD prolog format to the xml-line  \n";
    print ".mm format required by CuiTools\n\n";

    print "--plain                  Data is in plain text format\n\n";

    print "--sval2                  Data is in Senseval-2 format\n\n";
    
    print "--nlm                    Data is the NLM-WSD data set\n\n";

    print "--prolog                 Data in the NLM-WSD prolog format\n";
    print "                         and needs to be converted using \n";
    print "                         information from the current MetaMap\n";
    print "                         Transfer Program (MMTx).  \n\n";

    print "--none                   Removes the instances tagged with the\n";
    print "                         sense None from the NLM-WSD dataset.\n";
    print "                         This option only works with --prolog\n\n";

    print "--version                Prints the version number\n\n";
 
    print "--help                   Prints this help message.\n\n";
}

##############################################################################
#  function to output the version number
##############################################################################
sub showVersion {
    print '$Id: format-data.pl,v 1.5 2009/05/15 12:56:01 btmcinnes Exp $';
    print "\nCopyright (c) 2007, Ted Pedersen & Bridget McInnes\n";
}

##############################################################################
#  function to output "ask for help" message when user's goofed
##############################################################################
sub askHelp {
    print STDERR "Type format-data.pl --help for help.\n";
}
    
