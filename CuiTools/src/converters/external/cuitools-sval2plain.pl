#!/usr/local/bin/perl 

# 3 JUNE 2008: 
#
# THIS PROGRAM ORIGINALLY BELONGS TO THE SenseClusters PACKAGE 
# VERSION 0.95 (http://senseclusters.sourceforge.net) DEVELOPED 
# BY Ted Pedersen, Amruta Purandare,  Anagha Kulkarni, and Mahesh 
# Joshi. IT HAS BEEN INCLUDED IN CuiTools DISTRIBUTION FOR 
# CONVENIENCE REASONS.

# THIS PROGRAM HAS BEEN MODIFIED

=head1 NAME

cuitools-sval2plain.pl

=head1 SYNOPSIS

Converts a given file from Senseval-2 format into plain text format. 
Each line of the plain text files contains a single context.  

This program is from SenseClusters v0.95

=head1 USAGE

cuitools-sval2plain.pl [OPTIONS] SVAL2

=head1 INPUT

=head2 Required Arguments:

=head3 SVAL2

Input file in Senseval-2 format that is to be converted into plain text format.

=head2 Optional Arguments:

=head3 --senseinfo 

    Prints the sense information for the target word in tags 
    in the output. For example:
    <head item="target word" instance="instanceid" sense="sense">word</head> 

    NOTE: this was added by Bridget McInnes August 2007
=head3 --help

Displays the summary of command line options.

=head3 --version

Displays the version information.

=head1 OUTPUT

sval2plain displays the given SVAL2 file in plain text format with the 
contextual data of each instance on a separate line. Specifically, each
i'th line displayed on STDOUT shows the context of the i'th instance in
the given SVAL2 file.

BTM: Modification of this program to include the instance id and sense 
information for each instance. These are located with in the 
head tags. For example: 
We met in front of the <head item="art" instance="art.402" 
sense="art_gallery">art</head> gallery and Town Hall or in 
a park.

=head1 AUTHOR

Ted Pedersen, University of Minnesota, Duluth

Amruta Purandare, University of Minnesota, Duluth

Bridget McInnes, University of Minnesota

=head1 COPYRIGHT

Copyright (c) 2002-2007,

 Ted Pedersen, University of Minnesota, Duluth.
 tpederse at umn.edu

 Amruta Purandare, University of Pittsburgh.
 amruta at cs.pitt.edu

 Bridget McInnes, University of Minnesota
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

#$0 contains the program name along with
#the complete path. Extract just the program
#name and use in error messages
$0=~s/.*\/(.+)/$1/;

###############################################################################

#                           ================================
#                            COMMAND LINE OPTIONS AND USAGE
#                           ================================

# command line options
use Getopt::Long;
GetOptions ("help","version", "senseinfo");

# show help option
if(defined $opt_help)
{
        $opt_help=1;
        &showhelp();
        exit;
}

# show version information
if(defined $opt_version)
{
        $opt_version=1;
        &showversion();
        exit;
}

# show minimal usage message if no arguments
if($#ARGV<0)
{
        &showminimal();
        exit;
}

#############################################################################

#                       ================================
#                          INITIALIZATION AND INPUT
#                       ================================

#accept the input file name
$infile=$ARGV[0];
if(!-e $infile)
{
        print STDERR "ERROR($0):
        SVAL2 file <$infile> doesn't exist...\n";
        exit;
}
open(IN,$infile) || die "Error($0):
        Error(code=$!) in opening <$infile> file.\n";

##############################################################################

# BTM : two new variables for sense and instance information
$sense="";
$instance="";

$data_start=0;
$context="";
#  BTM: added this option
if(defined $opt_senseinfo) {
    while(<IN>)
    {
	chomp;
	# BTM : get the target word
	if(/<lexelt item=\"(.*?)\"\>/) {
	    $item = $1;
	}

	# BTM : get the instance id
	if(/<instance id=\"(.*?)\"/) {
	    $instance = $1;
	}
	# BTM: get sense information if it exists
	if(/<answer instance=\"(.*?)\" senseid=\"(.*?)\"/) {
	    $sense = $2;
	}
	if(/<\/context>/) {
	    # BTM :  adding the sense information to the context 
	    
	    # remove tags - from line, serve, interest and hard data 
	    $context=~s/\<\/?s\>//g;
	    $context=~s/\<\/?p\>//g;
	    $context=~s/\<\/?\@\>//g;
	    
	    #  remove tags from the sval format
	    $context=~s/<title>//g;
	    $context=~s/<\/title>//g;
	    $context=~s/<local//g;
	    $context=~s/<\/local//g;
	    
	    $context=~s/\s+/ /g;
	    
	    $context=~s/\<head/\<head item=\"$item\" instance=\"$instance\" sense=\"$sense\"/;
	    print $context . "\n";
	    $data_start=0;
	    $context="";
	}
	if($data_start==1) {
	    $context.="$_ ";
	}
	if(/<context>/) {
	    $data_start=1;
	}
    }
}
else {

    while(<IN>)
    {
        chomp;
        if(/<\/context>/)
        {
	    print $context . "\n";
	    $data_start=0;
	    $context="";
        }
        if($data_start==1)
        {
	    $context.="$_ ";
        }
        if(/<context>/)
        {
	    $data_start=1;
        }
    }
}

##############################################################################

#                      ==========================
#                          SUBROUTINE SECTION
#                      ==========================

#-----------------------------------------------------------------------------
#show minimal usage message
sub showminimal()
{
        print "Usage: cuitools-sval2plain.pl [OPTIONS] SVAL2";
        print "\nTYPE cuitools-sval2plain.pl --help for help\n";
}

#-----------------------------------------------------------------------------
#show help
sub showhelp()
{
	print "Usage:  cuitools-sval2plain.pl [OPTIONS] SVAL2

Converts a given file in Senseval-2 format to plain text format.

SVAL2
	Input file in Senseval-2 format.

OPTIONS:

--senseinfo 
        Prints the sense information for the target word in tags 
        in the output. For example:

        <head item=\"target word\" instance=\"instanceid\" sense=\"sense\">word</head> 


--help
        Displays this message.
--version
        Displays the version information.

Type 'perldoc cuitools-sval2plain.pl' to view detailed documentation of sval2plain.\n";
}

#------------------------------------------------------------------------------
#version information
sub showversion()
{
	print '$Id: cuitools-sval2plain.pl,v 1.1 2011/01/04 19:25:21 btmcinnes Exp $';
        print "Copyright (c) 2002-2007, Ted Pedersen, Amruta Purandare & Bridget McInnes\n";
#        print "cuitools-sval2plain.pl      -       Version 0.01\n";
#        print "Converts a given file in Senseval-2 format into plain text format.\n";
#        print "Date of Last Update:     06/02/2004\n";
}

#############################################################################

