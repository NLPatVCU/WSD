#!/usr/bin/perl  -w

=head1 NAME

split.pl 

=head1 SYNOPSIS

This program randomly splits a file in mm format into a training 
and test files. 

=head1 USGAE

split.pl [OPTIONS] DESTINATION SOURCE

=head1 INPUT

=head2 Required Arguments:

=head3 DESTINATION

The PREFIX for the test and training files. The training file will 
be labeled DESTINATION.train and the test file will be labeled 
DESTINATION.test

=head3 SOURCE

The mm formated file to be split into training and test.

=head2 Optional Arguments:

=head3 --split NUMBER

This indicates what percentage of the file in test. Default: 10.

For example: --split 10

    This will put 10% of the file into the DESTINATION.test file 
    and the remaining 90% into the DESTINATION.train file

=head3 --help

Displays the summary of command line options.

=head3 --version

Displays the version information.

=head1 OUTPUT

This program output two files: i) DESTINATION.test and ii) DESTINATION.train. 
Each file is in .mm format and can be used by the disambiguate.pl program.

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

GetOptions( "version", "help", "split=s");

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

my $split = 10;
if( defined $opt_split ) {
    $split = $opt_split;
}

my $destination = shift;
my $source      = shift;
#  check that destination has been supplied
if( !($destination) ) {
    print STDERR "No output directory (DESTINATION) supplied.\n";
    &askHelp();
    exit;
}

if( (-e "$destination.train") || (-e "$destination.test") ) {
    print "Output files $destination.train and/or $destination.test "; 
    print "already exists! Overwrite (Y/N)?";
    my $reply = <STDIN>;  chomp $reply; $reply = uc($reply);
    exit 0 if ($reply ne "Y"); 
} 

#  check that source has been supplied
if( !($source) ) {
    print STDERR "No output directory (SOURCE) supplied.\n";
    &minimalUsageNotes();
    exit;
}

open(SRC, $source)                 || die "Could not open source file: $source\n";
open(TEST, ">$destination.test")   || die "Could not open $destination.test\n";
open(TRAIN, ">$destination.train") || die "Could not open $destination.train\n";

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

@InstanceArray = shuffle(\@InstanceArray);

print TEST "$OpenCorpusLine";
print TEST "$OpenLexeltLine";

print TRAIN "$OpenCorpusLine";
print TRAIN "$OpenLexeltLine";


#  set split
$split = int(($opt_split * .01) * ($#InstanceArray + 1)); 


my $count = 0;
foreach my $line (@InstanceArray) {

    $count++;
    if($count <= $split) {
	print TEST "$line"; 
    } 
    else {
	print TRAIN "$line";
    }
}

print TEST "$CloseLexeltLine";    
print TEST "$CloseCorpusLine";

print TRAIN "$CloseLexeltLine";
print TRAIN "$CloseCorpusLine";


###############################################################################
#
#   Function:   shuffle
#   Purpose:    Randomize an array
#
#   Comments:   This routine was ripped from 'Perl Cookbook' pg 121-122
#               
###############################################################################

sub shuffle {
    my $array = shift;
    my $i = scalar(@$array);
    my $j;
    
    # BTM : removed $item from foreach $item (@$array )
    foreach (@$array)
    {
        --$i;
        $j = int rand ($i+1);
        next if $i == $j;
        @$array [$i,$j] = @$array[$j,$i];
    }
    return @$array;
}


##############################################################################
#  SUB FUNCTIONS
##############################################################################

#  function to output minimal usage notes
sub minimalUsageNotes {
    
    print STDERR "Usage: split.pl [OPTIONS] DESTINATION SOURCE\n";
    print STDERR "Type split.pl --help for help.\n\n";
}

#  function to output help messages for this program
sub showHelp() {

    print "Usage: split.pl [OPTIONS] DESTINATION SOURCE\n\n";
    
    print "Takes as input a text in .mm format and splits it into \n";
    print "test and training files.\n\n";

    print "OPTIONS:\n\n";

    print "--split NUMBER           The percentage of instances\n";
    print "                         that should go in the test file.\n";
    print "                         Default: 10\n\n";

    print "--version                Prints the version number\n\n";

    print "--help                   Prints this help message.\n\n";
}

#  function to output the version number
sub showVersion {
        print '$Id: split.pl,v 1.8 2008/07/02 22:05:17 btmcinnes Exp $';
        print "\nCopyright (c) 2007, Ted Pedersen & Bridget McInnes\n";
}

#  function to output "ask for help" message when user's goofed
sub askHelp {
    print STDERR "Type split.pl --help for help.\n";
}
    
