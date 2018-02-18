#!/usr/bin/perl

# 3 JUNE 2008: 
#
# THIS PROGRAM ORIGINALLY BELONGS TO THE nlm2sval PACKAGE DEVELOPED 
# BY Ted Pedersen and Mahesh Joshi. IT HAS BEEN INCLUDED IN CuiTools 
# DISTRIBUTION FOR CONVENIENCE REASONS.

=head1 NAME

nlm2sval2driver.pl

=head1 SYNOPSIS

This program is a driver script which runs nlm2sval2.pl program for the entire NLM test collection directory.

=head1 DESCRIPTION

The National Library of Medicine test collection for Word Sense Disambiguation contains a set of 50 ambiguous words. The collection is organized in a directory hierarchy such that the data file for each word is in a separate directory (the name of which is the ambiguous word itself). nlm2sval2.pl is designed to run with only one input NLM data file at a time. This program therefore provides a helper interface to convert the entire NLM test colleciton to SENSEVAL2 format in one go. It assumes that the nlm2sval2.pl program is in the user's path.

The directory hierarchy for the NLM test collection (by default) is:

 Basic_Reviewed_Results
 |
 |_ _ word1
 |      |_ _ word1_set (data file)
 |
 |_ _ word2
 |      |_ _ word2_set (data file)
 |
 |
 .
 .
 .


nlm2sval2driver.pl assumes the above directory structure rigidly. The directory and file names can be flexible, but the 3 level hierarchy (upto the actual data file) should be the same.

By default, this program will assume that it is being run in a current directory which contains the top level directory Basic_Reviewed_Results. It will then create a similar target directory structure with the root directory as nlm2sval2_results. nlm2sval2.pl is run in dual mode by default so that both sentence and abstract context files are created. The output directory structure will be:

 nlm2sval2_results
 |
 |_ _ word1
 |      | 
 |      |_ _ word1.sentence.sval2 (sentence mode output file)
 |      |_ _ word1.abstract.sval2 (abstract mode output file)
 |
 |_ _ word2
 |      | 
 |      |_ _ word2.sentence.sval2 (sentence mode output file)
 |      |_ _ word2.abstract.sval2 (abstract mode output file)
 |
 .
 .
 .

The user can optionally specify the names of the source and the destination directories and also if only sentence or only abstract mode files are required. See 'nlm2sval2driver.pl --help' for usage.

IMPORTANT NOTE

The NLM data file for the word "fat" contains incomplete abstract 
extract for one instance (serial number 70, line number 553). 
Therefore the abstract offsets mentioned in the data file for 
this instance are out of bounds of the abstract string, due to 
which nlm2sval2.pl will issue an error for this instance. However, 
the SENSEVAL2 file is still complete (including all available 
text for this instance).


=head1 USAGE

See 'nlm2sval2driver.pl --help' for a list of options and their usage.

=head1 AUTHOR

Mahesh Joshi <joshi031@d.umn.edu>

Ted Pedersen <tpederse@d.umn.edu>

=head1 BUGS

=head1 SEE ALSO

NLM WSD Test Collection  :  http://wsd.nlm.nih.gov/

Senseval-2  :  http://www.sle.sharp.co.uk/senseval2/

nlm2sval2.pl

=head1 COPYRIGHT

Copyright (C) 2005, Ted Pedersen and Mahesh Joshi

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

=cut

##############################################################################
############################## CHANGE LOG ####################################
##############################################################################

# 1. Date: 01/13/2005 
#    Modified by: Mahesh Joshi
#    Comments: First version of script ready, with POD documentation

##############################################################################
########################### END OF CHANGE LOG ################################
##############################################################################


use strict;

use Getopt::Long 2.34;

# Variable declarations

# Binary variables that determine the verbosity and the trace output of the program (CURRENTLY NOT USED)
my $verbose = 0;
my $trace = 0;

# Checks if user has requested help at command line
my $help = 0;

# Binary variables that determine which mode the program is running in
my $mode_sent = 0;
my $mode_abst = 0;

# The variables that hold the names of input and output files
my $nlm_file;
my $sval_sent_file;
my $sval_abst_file;

# The data directories on which we are operating
my $source_dir = "Basic_Reviewed_Results";
my $dest_dir = "nlm2sval2_results";

#######################
# SUB-ROUTINE SECTION #
#######################

#############
# showUsage #
#############

# This function prints out the usage of the program to STDOUT in a terse format
sub showUsage() {

    # Get the name of the program by which it is running currently
    my @tokens = split /\//, $0;
    my $filename = $tokens[@tokens-1];

    print "Usage: $filename [OPTIONS] [SOURCE_ROOT_DIRECTORY] [DESTINATION_ROOT_DIRECTORY]\n";
    print "Type \"$filename --help\" for a list of options or \"perldoc $filename\" for details.\n";
}

############
# showHelp #
############

# This function prints out an intermediate level of usage information to STDOUT
# For further details, user is expected to read the perldoc for the program.
sub showHelp() {

    # Get the name of the program by which it is running currently
    my @tokens = split /\//, $0;
    my $filename = $tokens[@tokens-1];

    print "\n$filename: Driver program to convert the NLM test collection for Word Sense Disambiguation (WSD) into SENSEVAL2 format.\n\n";

    print "Usage: $filename [OPTIONS] [SOURCE_ROOT_DIRECTORY] [DESTINATION_ROOT_DIRECTORY]\n\n";

    print "By default, $filename operates on \"Basic_Reviewed_Results\" directory in the current directory as source, and creates \"nlm2sval2_results\" directory as the default output directory. It creates a sentence and abstract file for each ambiguious word. User can optionally specify the source NLM data directory and the name of the target directory (not existing), in that order at the command line.\n\n";
    
    print "NOTE: nlm2sval2.pl should be in user path for nlm2sval2driver.pl to run correctly.\n\n";

    print "Valid options are:\n\n";

    print "--sentence     Switch to output SENSEVAL2 files for sentence\n";
    print "               context only\n\n";
    
    print "--abstract     Switch to output SENSEVAL2 files for abstract\n";
    print "               context only\n\n";

    print "               Note: Specifying both options above is the\n";
    print "               same as default behaviour.\n\n";

    print "--help         Prints this help message.\n\n";

    exit(0);
}

#####################
# getCmdLineOptions #
#####################

# This function parses the command line of the program using the GetOpt::Long package. Additionally, it does some validations on the command line and does some pre-processing tasks like opening input and output files if required.

# So, this function is where the $hout1 and $hout2 get their appropriate values - either actual file handles or STDOUT to any one of them
sub getCmdLineOptions() {

    # Get the state of various options at command line
    # GetOpt::Long leaves anything that it cannot parse in the @ARGV array
    GetOptions(verbose => \$verbose,
               trace => \$trace,
               sentence => \$mode_sent,
               abstract => \$mode_abst,
               'help|?' => \$help);

    if ($help == 1) {

        showHelp();
    }

    # Get the name of the source directory if explicitly specified
    if (defined($ARGV[0])) {

        $source_dir = shift @ARGV;
    }

    # Get the name of the destination directory if explicitly specified
    if (defined($ARGV[0])) {

        $dest_dir = shift @ARGV;
    }

    # If the user has not specified any mode explicitly, default is both
    if ($mode_sent == 0 && $mode_abst == 0) {

        $mode_sent = 1;
        $mode_abst = 1;
    }
}

##############
# fatalError #
##############

# This function should be called when a critical error has occurred and the program cannot proceed anymore. It prints out the specified message at STDERR and exits from the program.

# The first parameter to it indicates whether or not the caller wants this function to print out the program usage.

# Any subsequent parameters are treated as message to be printed. In case of just one additional parameter, we assume that a simple print is required by the caller. In case of multiple subsequent arguments, we assume that a formatted printing is required and we invoke printf

# A newline is added at the end of the message by default
sub fatalError {

    # Check if showUsage should be printed after the error or not
    my $show_usage = shift;

    # Print out the message depending upon the number of additional parameters
    print STDERR "ERROR: ";

    if (@_ > 1) {
        printf STDERR @_;
    } else {
        print STDERR $_[0];
    }

    print STDERR "\n";

    # Print out usage if required
    if ($show_usage) {
        showUsage();
    }

    # Terminate the program, since this is a critical error
    exit(-1);
}

############
# tr_print #
############

# This function prints out the specified trace message at STDERR only when the tracing mode is on

# A single argument is treated as a plain string to be printed using print.
# Multiple arguments are treated as a request for formatted print, with the first argument being the format string.

# A newline is added at the end of the message by default
sub tr_print {

    if ($trace == 1) {

        if (@_ > 1) {
            printf STDERR @_;
        } else {
            print STDERR $_[0];
        }

        print STDERR "\n";
    }
}

############
# vb_print #
############

# This function prints out the specified verbose message at STDERR only when the verbose mode is on

# A single argument is treated as a plain string to be printed using print.
# Multiple arguments are treated as a request for formatted print, with the first argument being the format string.

# A newline is added at the end of the message by default
sub vb_print {

    if ($verbose == 1) {

        if (@_ > 1) {
            printf STDERR @_;
        } else {
            print STDERR $_[0];
        }

        print STDERR "\n";
    }
}

############
# sysCall #
############

# This function simply makes a system function call. It adds an error checking functionality and exits from the program if the system call has returned a non-zero exit status for the command that was executed.

sub sysCall {

    my $status = system(@_);
    
    # Error handling below taken from documentation of system call from 'perldoc perlfunc'
    unless ($status == 0) {

        if ($? == -1) {

            fatalError(0, "Failed to execute \"@_\": $!");

        } elsif ($? & 127) {

            fatalError(0, "Failed while executing \"@_\". Process died with signal %d, %s coredump",
                     ($? & 127),  ($? & 128) ? 'with' : 'without');
        } else {

            fatalError(0, "Failed while executing \"@_\". Process exited with value %d", $? >> 8);
        }
    }
}

#######################
# MAIN PROGRAM BEGINS #
#######################

# Process the command line options
getCmdLineOptions();

# Do a sanity check on the existence of the source directory
#sysCall("cd", $source_dir);

# Create the target directory
sysCall("mkdir", $dest_dir);

# We need to enlist all the directories in the source directory
opendir(HSRCDIR, $source_dir) or fatalError("Failed to open the directory $source_dir for reading.");

my $word;

while (($word = readdir(HSRCDIR))) {

    print STDERR "Processing directory $source_dir/$word\n";

    # We read each of the sub-directories from the source directory
    # Check that we are not dealing with the . and .. directories
    if ($word !~ /^\..*/ && -d "$source_dir/$word") {

        # Open the word directory
        if (!opendir(HWORDDIR, "$source_dir/$word")) {

            print STDERR "WARNING: Failed to open directory $source_dir/$word for reading. Continuing with next word.\n";
            next;
        }

        # Create the word directory in the target directory
        sysCall("mkdir", "$dest_dir/$word");

        # Now we are interested in the data file inside the word directory
        my $datafile;

        # Read the directory till we get the first file
        while (($datafile = readdir(HWORDDIR))) {

            if ($datafile !~ /^\..*/ && -f "$source_dir/$word/$datafile") {

                # Launch the nlm2sval2.pl program depending upon the options specified by the user
                if ($mode_sent && $mode_abst) {

                    sysCall("nlm2sval2.pl", "--sentence", "--abstract", "--osentence", "$dest_dir/$word/$word.sentence.sval2", "--oabstract", "$dest_dir/$word/$word.abstract.sval2", "$source_dir/$word/$datafile");

                } elsif ($mode_sent) {

                    sysCall("nlm2sval2.pl", "--sentence", "--osentence", "$dest_dir/$word/$word.sentence.sval2", "$source_dir/$word/$datafile");

                } elsif ($mode_abst) {
            
                    sysCall("nlm2sval2.pl", "--abstract", "--oabstract", "$dest_dir/$word/$word.abstract.sval2", "$source_dir/$word/$datafile");
                }

                # Process just one data file
                last;
            }
        }

        closedir HWORDDIR;
    }
}

closedir HSRCDIR;
