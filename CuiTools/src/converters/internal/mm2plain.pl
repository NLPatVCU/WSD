#!/usr/bin/perl -w

=head1 NAME

mm2plain.pl

=head1 SYNOPSIS

Converts a given file from .mm format into plain text format. 

=head1 DESCRIPTION

This program takes as input a plain text. Each line of the plain 
text files contains a single context. We defined plain text to be 
an instance whose context is on a single line and the target word 
is tagged with its instance id and sense, for example:

<head item="art" instance="art.402" sense="art_gallery">art</head> gallery and Town Hall or in a park.

This is converted into .mm format. For more information please see 
README.format.mm.

=head1 USAGE

mm2plain.pl [OPTIONS] MM 

=head1 INPUT

=head2 Required Arguments:

=head3 MM

Input file in .mm format that is to be converted into plain text format.

=head2 Optional Arguments:

=head3 --key KEYFILE

    Creates an optional key file.

    Each line in KEYFILE should show the instance id and optional 
    sense tags of the instance displayed on the corresponding line 
    in the TEXT file, in the format -

	<instance id=\"IID\"\/> [<sense id=\"SID\"\/>]*

    where an <instance> tag is followed by zero or more <sense> tags.

=head3 --senseinfo

    Prints the sense information for the target word in tags 
    in the output. For example:
    <head item="target word" instance="instanceid" sense="sense">word</head> 

=head4 --lc

    lower cases the text

=head3 --cui

    Prints out the Concept Unique Identifiers of the words in 
    the instance as the plain text rather than the words 
    themselves.

=head3 --concept

    Prints out the English form of the Concept Unique Identifiers 
    of the words in the instance as the plain text rather than 
    the words themselves.

=head3 --st

    Prints out the semantic types of the Concept Unique Identifiers 
    of the words in the instance as the plain text rather than 
    the words themselves.    

=head3 --help

Displays the summary of command line options.

=head3 --version

Displays the version information.

=head1 OUTPUT

mm2plain displays the given .mm file in plain text format with the 
contextual data of each instance on a separate line. Specifically, each
i'th line displayed on STDOUT shows the context of the i'th instance in
the given .mm file.

=head1 THE plain FORMAT

In plain format each line of the text files contains a single context. 
where the ambiguous word is identified by:

<head item="target word" instance="instance" sense="sense">word</head>.

For example: 

Paul was named <head item="art" instance="art.30002" sense="art">Art</head> magazine's top collector.

=head1 THE .mm FORMAT

See L<README.mm.format>

=head1 PROGRAM REQUIREMENTS

=over

=item * Perl (version 5.8.5 or better) - http://www.perl.org

=back

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

use Getopt::Long;

eval(GetOptions( "version", "help", "cui", "context=s", "concept", "senseinfo", "lc", "key=s" ))or die ("Please check the above mentioned option(s).\n");

#  call help
if(defined $opt_help) {
    &askHelp();
    exit;
}

# show version information
if(defined $opt_version) {
    $opt_version = 1;
    &showversion();
    exit;
}

#  if no arguments are on the command line
if($#ARGV < 0) {
    $opt_help = 1;
    &minimalUsageNotes();
    exit;
}

#  check if senseinfo is defined
if(defined $opt_senseinfo) {
    $opt_senseinfo = 1;
}

my $context = "unigrams";
#  check on the context
if(defined $opt_context) { 
    $context = $opt_context;
}

my $lc;
#  check if text should be lower cased
if(defined $opt_lc) { $lc = $opt_lc; }

#  get the source file
my $source = shift;

#  check that source has been supplied
if( !($source) ) {
    print STDERR "No source file (SOURCE) supplied.\n";
    &askHelp();
    exit;
}

open(SOURCE, $source) || die "Could not open SOURCE ($source) file\n";

my $instance = ""; 
my $sentence = "";
my $output     = ""; 

my @key_array = (); 

my $targetFlag      = 0; 
my $instanceCounter = 1;

my $position = 1; 

while(<SOURCE>) {
    chomp;

    #  get the item
    if($_=~/<lexelt item=\"(.*?)\" senses/) {
	$item = $1;
    }

    #  get the instanceid and sense information 
    if($_=~/<answer instance=\"(.*?)\" senseid=\"(.*?)\"\/>/) {
	$id = $1; $sense = $2;
	
	#  set the sense information for the key file
	my $key_line = "<instance id=\"$id.$instanceCounter\"\/> <sense id=\"$sense\"\/>";
	push @key_array, $key_line;
	$instanceCounter++;
    }

    #  if the output is to be a list of concepts    
    if( ($context eq "concept") and ($targetFlag == 0) ) {
	if($_=~/umls_concept=\"(.*?)\" /) {
	    $output = $1; 
	    $output=~s/\,//g;   
	    $output=~s/\'//g;   
	    $output=~s/^\s+//g; 
	    $output=~s/\s+$//g;
	    $output=~s/\s+/_/g;
	    
	}
    }
    
    #  if the output is to be a list of CUIs (this is the number: C000000)
    elsif( ($context eq "cui") and ($targetFlag == 0) ) {
	if($_=~/umls\_cui=\"(.*?)\" umls/) {
	    $output = $1;
	}
    }

    #  if the output is to be a list of semantic types
    elsif( ($context eq "st") and ($targetFlag == 0) ) {
	if($_=~/semantic_types=\"(.*?)\"/) {
	    $output = $1; 
	    $output=~s/\,/ /g;
	}
    }

    #  otherwise we use the words 
    else {    
	if($_=~/<sentence tw=\"(.*?)\" id=\"(.*?)\" line=\"(.*?)\">/) {
	    $sentence = $3;
	}
	if($_=~/<\/sentence>/) {
	    if(defined $opt_lc) { 
		$output = lc($sentence); 
	    }
	    else {
		$output = $sentence;
	    }
	}
    }
    
    #  if the word is a token set the targetFlag to 0
    if($_=~/<token word/) { $targetFlag = 0; }
       
    #  if the word is a target word replace the cui or concept 
    #  or st or the word itself with the head tags
    if($_=~/<target word=\"(.*?)\" /) {
	
	#  get the target word
	my $target = $1;
	
	#  set the target flag to one inorder to not get
	#  the cuis, st and concepts of the target word
	$targetFlag = 1;
	
	#  set the head tag information
	my $info = "";
	if(defined $opt_senseinfo) {
	    $info = "<head item=\"$item\" instance=\"$id\" sense=\"$sense\">$target<\/head> "; 
	}
	else {  $info = "<head>$target<\/head> ";  }
	
	#  if using words replace the target word in 
	#  the sentence with the head tag information
	if( $context eq "unigram") { 
	    $sentence=~s/$target/$info/i;
	}
	#  otherwise replace the cui, concept  
	#  or st with the head tag information
	else { $output = $info; }
    }
    
       #  add the item to the instance
    $instance .= "$output ";

    #  reinitialize the item variable
    $output = "";

    #  if we are at the end of the instance print the plain
    #  text and reinitialize the instance variable
    
    if($_=~/<\/instance>/) {
	
	#if($instance=~/^\s*$/) { next; }
	
	if(!($instance=~/<head/)) { 
	    $instance .= "<head item=\"$item\" instance=\"$id\" sense=\"$sense\">$item<\/head> "; 
	}
	$instance=~s/\s+/ /g;
	
	print "$instance\n"; 
	
	$instance = "";
    }
}

if(defined $opt_key) {
    
    open(KEY, ">$opt_key") || die "Could not open KEYFILE ($opt_key).\n";    
    foreach (@key_array) { print KEY "$_\n"; }
}


##############################################################################
#  function to output minimal usage notes
##############################################################################
sub minimalUsageNotes {
    
    print STDERR "Usage: mm2plain.pl [OPTIONS] MM\n";
    print STDERR "Type mm2plain.pl --help for help.\n\n";
}

sub askHelp()
{
    print "Usage:  mm2plain.pl [OPTIONS] MM\n\n";
    

    print "Converts a given file in MM format to plain text format.\n\n";
    print "MM: 	Input file in MM format.\n\n";


    print "OPTIONS:\n\n";
    print "--senseinfo            Prints the sense information for the \n";
    print "                       target word in tags in the output.\n\n";
    
    print "--lc                   lower cases the text when converting to\n";
    print "                       plain text\n\n";

    print "--cui                  Prints out the Concept Unique Identifiers\n";
    print "                       of the words in the instance as the plain\n";
    print "                       text rather than the words themselves.\n\n";

    print "--concept              Prints the English form of the Concept\n";
    print "                       Unique Identifiers (CUI) of the words \n";
    print "                       in the instance as the plain text rather\n";
    print "                       than the words themselves.\n\n";
    
    print "--st                   Prints the semantic types of the Concept\n";
    print "                       Unique Identifiers of the words in the \n";
    print "                       instance as the plain text rather than\n"; 
    print "                       the words themselves.\n\n";
    
    print "--help                 Displays this message.\n\n";
    
    print "--version              Displays the version information.\n\n";

    print "Type 'perldoc mm2plain.pl' to view detailed \n";
    print "documentation of mm2plain.\n\n";

} 

#------------------------------------------------------------------------------
#version information
sub showversion()
{
	print '$Id: mm2plain.pl,v 1.12 2016/01/20 18:16:42 btmcinnes Exp $';
        print "Copyright (c) 2007, Ted Pedersen & Bridget McInnes\n";
}

#############################################################################

