#!/usr/bin/perl -w

=head1 CuiTools
    
machinecode2mm.pl

=head1 SYNOPSIS

This program converts the machine code MetaMap formatted text  
to our xml-like .mm format used by the CuiTools package.

=head1 USAGE

perl machinecode2mm.pl DESTINATION SOURCE

    
=head1 INPUT

=head2 Required Arguments:
 
=head3 DESTINATION

The file that the mm output files should go. 

=head3 SOURCE

The SOURCE is the file that contains the machine 
code

=head2 Optional Arguments:

=head3 --help

Displays the quick summary of program options.

=head3 --version

Displays the version information.

=head1 OUTPUT

machinecode2mm.pl converts the MetaMap machine output 
to our xml-like .mm format.

=head2 THE .mm FORMAT

See README.mm.format

=head1 PROGRAM REQUIREMENTS

=over

=item * Perl (version 5.8.5 or better) - http://www.perl.org

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

eval(GetOptions( "version", "help"))or die ("Please check the above mentioned option(s).\n");

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

my $output_file = shift;
my $input_file  = shift;

#  check that destination has been supplied
if( !($output_file) ) {
    print STDERR "No output file (DESTINATION) supplied.\n";
    &askHelp();
    exit;
}
 
if( -e $output_file ) {
    print "Output file $output_file already exists! Overwrite (Y/N)?";
    my $reply = <STDIN>;  chomp $reply; $reply = uc($reply);
    exit 0 if ($reply ne "Y"); 
} 

open(DST, ">$output_file") || die "Could not open ($output_file) DESTINATION\n";

print DST $handler->getHeader("", ""); 

open(FILE, $input_file) || die "Could not open ($intput_file) SOURCE\n";
		
my $id         = "";
my $prolog     = "";
my $line       = "";

while(<FILE>) {
	    
    $prolog .= $_;
	    
    chomp;
    
    #  set the utterance information
    if($_=~/^utterance\(\'(.*?)\'\,\"(.*)\"\)\./) {
	
	$id   = $1;
	$line = $2;
	
	#  get the abstract id
	$id=~/([0-9]+)\./;  
    }
    if($_=~/\'EOU\'\./) {
	
	print DST $handler->getInstanceInfo($id, "", "", "", $line);
	
	open(FILE, ">tmp.prolog") || die "Could not open prologOutput file\n";
	print FILE "$prolog"; close FILE;
	
	print DST $handler->parseInstance("tmp.prolog", $line, $id, "", "", "1", $id);
	system("rm -rf tmp.prolog");
    } 
}
print DST $handler->getFooter();


##############################################################################
#  SUB FUNCTIONS
##############################################################################

#  function to output minimal usage notes
sub minimalUsageNotes {
    
    print STDERR "Usage: machinecode2mm.pl [OPTIONS] DESTINATION SOURCE\n";
    askHelp();
}

#  function to output help messages for this program
sub showHelp() {

    print "Usage: machinecode2mm.pl DESTINATION SOURCE\n\n";
    
    print "Takes as input a machine code MetaMap file and converts it\n";
    print "to our xml-like .mm format.\n\n";

    print "OPTIONS:\n\n";

    print "--version                Prints the version number\n\n";

    print "--help                   Prints this help message.\n\n";
}

#  function to output the version number
sub showVersion {
        print '$Id: machinecode2mm.pl,v 1.5 2008/06/11 00:03:17 btmcinnes Exp $';
        print "\nCopyright (c) 2007, Ted Pedersen & Bridget McInnes\n";
}

#  function to output "ask for help" message when user's goofed
sub askHelp {
    print STDERR "Type prolog2mm.pl --help for help.\n";
}
    
