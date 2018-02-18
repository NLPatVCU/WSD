#!/usr/bin/perl

# 3 JUNE 2008: 
#
# THIS PROGRAM ORIGINALLY BELONGS TO THE nlm2sval PACKAGE DEVELOPED 
# BY Ted Pedersen and Mahesh Joshi. IT HAS BEEN INCLUDED IN CuiTools 
# DISTRIBUTION FOR CONVENIENCE REASONS.

=head1 NAME

nlm2sval2.pl

=head1 SYNOPSIS

A program to convert any Word Sense Disambiguation data file in NLM format (PMID version) to a file in SENSEVAL2 format.

=head1 DESCRIPTION

The National Library of Medicine (NLM) has a test collection for Word Sense Disambiguation. The data files in this collection are plain text files with certain formatting. This program converts these NLM data files (Basic Reviewed Results from the PMID version of this test collection) into the SENSEVAL2 format which is an XML format.

In the NLM data format, the context of the ambiguity is provided in 2 ways:

1. The actual sentence in the citation that contains the ambiguity
2. The entire citation containing the ambiguity (i.e. containing the above sentence)

This program provides two options by which the user can create SENSEVAL2 data files with either only the sentence as the context or the entire citation (abstract) as the context. These two modes are referred to as sentence mode and abstract mode in further documentation.

The PMID version of the NLM WSD data has the following format (note that the data has been re-formatted to suit the POD formatting and hence the offsets will not match if the text is simply copied from here and pasted in a text file):


 1|9337195.ab.7|M2
 The relation between birth weight and flow-mediated dilation
 was not affected by adjustment for childhood body build, 
 parity, cardiovascular risk factors, social class, or 
 ethnicity.
 adjustment|adjustment|78|90|81|90|by adjustment|
 PMID- 9337195
 TI  - Flow-mediated dilation in 9- to 11-year-old children: 
 the influence of intrauterine and childhood factors.  
 AB  - BACKGROUND: Early life factors, particularly size at 
 birth, may influence later risk of cardiovascular disease, 
 but a mechanism for this  influence has not been established.
 We have examined the relation between birth weight and 
 endothelial function (a key event in atherosclerosis) in 
 a population-based study of children, taking into account
 classic cardiovascular risk factors in childhood. METHODS
 AND RESULTS: We studied 333 British children aged 9 to 11
 years in whom information on birth weight, maternal factors,
 and risk factors (including blood pressure, lipid fractions,
 preload and postload glucose levels, smoking exposure, and
 socioeconomic status) was available. A noninvasive 
 ultrasound technique was used to assess the ability of the
 brachial artery to dilate in response to increased blood 
 flow (induced by forearm cuff occlusion and release), an 
 endothelium-dependent response. Birth weight showed a 
 significant, graded, positive association with flow-
 mediated dilation (0.027 mm/kg; 95% CI, 0.003 to 0.051 
 mm/kg; P=.02). Childhood cardiovascular risk factors (blood
 pressure, total and LDL cholesterol, and salivary cotinine
 level) showed no relation with flow-mediated dilation, but
 HDL cholesterol level was inversely related (-0.067 mm/mmol;
 95% CI, -0.021 to -0.113 mm/mmol; P=.005). The relation 
 between birth weight and flow-mediated dilation was not 
 affected by adjustment for childhood body build, parity,
 cardiovascular risk factors, social class, or ethnicity. 
 CONCLUSIONS: Low birth weight is associated with impaired
 endothelial function in childhood, a key early event in 
 atherogenesis. Growth in utero may be associated with long-
 term changes in vascular function that are manifest by the
 first decade of life and that may influence the long-term
 risk of cardiovascular disease.
 adjustment|adjustment|1521|1533|1524|1533|by adjustment|
 ...
 ...

In abstract mode (which is the default mode), the program will convert this to:

 <corpus lang='en'>
   <lexelt item="adjustment">
     <instance id="9337195.ab.7" pmid="9337195" alias="adjustment">
       <answer instance="9337195.ab.7" senseid="M2"/>
       <context>
         <title>Flow-mediated dilation in 9- to 11-year-old 
         children: the influence of intrauterine and childhood 
         factors.  </title> BACKGROUND: Early life factors, 
         particularly size at birth, may influence later risk 
         of cardiovascular disease, but a mechanism for this
         influence has not been established. We have examined 
         the relation between birth weight and endothelial 
         function (a key event in atherosclerosis) in a 
         population-based study of children, taking into 
         account classic cardiovascular risk factors in 
         childhood. METHODS AND RESULTS: We studied 333 
         British children aged 9 to 11 years in whom 
         information on birth weight, maternal factors, and 
         risk factors (including blood pressure, lipid 
         fractions, preload and postload glucose levels, 
         smoking exposure, and socioeconomic status) was 
         available. A noninvasive ultrasound technique was 
         used to assess the ability of the brachial artery 
         to dilate in response to increased blood flow 
         (induced by forearm cuff occlusion and release), 
         an endothelium-dependent response. Birth weight 
         showed a significant, graded, positive association 
         with flow-mediated dilation (0.027 mm/kg; 95% CI, 
         0.003 to 0.051 mm/kg; P=.02). Childhood 
         cardiovascular risk factors (blood pressure, total 
         and LDL cholesterol, and salivary cotinine level) 
         showed no relation with flow-mediated dilation, but 
         HDL cholesterol level was inversely related (-0.067 
         mm/mmol; 95% CI, -0.021 to -0.113 mm/mmol; P=.005). 
         The relation between birth weight and flow-mediated 
         dilation was not affected <local>by <head>adjustment
         </head></local> for childhood body build, parity, 
         cardiovascular risk factors, social class, or 
         ethnicity. CONCLUSIONS: Low birth weight is associated 
         with impaired endothelial function in childhood, a key 
         early event in atherogenesis. Growth in utero may be 
         associated with long-term changes in vascular function 
         that are manifest by the first decade of life and that 
         may influence the long-term risk of cardiovascular 
         disease.
       </context>
     </instance>
     ...
     ...
   </lexelt>
 </corpus>

And in the sentence mode, it will be converted to:

 <corpus lang='en'>
   <lexelt item="adjustment">
     <instance id="9337195.ab.7" pmid="9337195" alias="adjustment">
       <answer instance="9337195.ab.7" senseid="M2"/>
       <context>
         The relation between birth weight and flow-mediated 
         dilation was not affected <local>by <head>adjustment
         </head></local> for childhood body build, parity, 
         cardiovascular risk factors, social class, or ethnicity.
       </context>
     </instance>
     ...
     ...
   </lexelt>
 </corpus>

=head1 USAGE

See 'nlm2sval2.pl --help' for a list of options and their usage.

=head1 AUTHOR

Mahesh Joshi <joshi031@d.umn.edu>

Ted Pedersen <tpederse@d.umn.edu>

=head1 BUGS

=head1 SEE ALSO

NLM WSD Test Collection  :  http://wsd.nlm.nih.gov/

Senseval-2  :  http://www.sle.sharp.co.uk/senseval2/

nlm2sval2driver.pl

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

# 1. Date: 01/08/2005 
#    Modified by: Mahesh Joshi
#    Comments: Basic functionality ready

# 2. Date: 01/10/2005
#    Modified by: Mahesh Joshi
#    Comments: Command line interface changed based on Ted's feedback. Initially
#              the program required input and output file names at command line. 
#              Now the file names are optional, default input is STDIN and 
#              default output is STDOUT.

#              The abstract mode is set as the default mode.

#              Options --osentence and --oabstract supported for dual mode

# 3. Date: 01/12/2005
#    Modified by: Mahesh Joshi
#    Comments: Added showHelp() function and basic POD documentation

# 4. Date: 01/13/2005
#    Modified by: Mahesh Joshi
#    Comments: Updated the POD documentation and added detailed comments
#              throughout the program, first version ready.

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

# The variables that hold the names of input and output files (if any)
my $nlm_file;
my $sval_sent_file;
my $sval_abst_file;

# Variables that control the formatting of the output XML files
my $indent_level = 0;
my $tab_size = 2;

# The file handles to which the output is written
# $hout1 is used in sentence mode
# $hout2 is used in abstract mode
# By default they are set to STDOUT, when no output file names are provided
my ($hout1, $hout2);

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

    print "Usage: $filename [OPTIONS] [INPUT_FILE]\n";
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

    print "\n$filename: Program to convert any Word Sense Disambiguation (WSD) file in NLM format to a file in SENSEVAL2 format.\n\n";

    print "Usage: $filename [OPTIONS] [INPUT_FILE]\n\n";

    print "The name of the input file is optional. If not specified, the program reads the NLM formatted input file from STDIN.\n\n";

    print "Valid options are:\n\n";

    print "--sentence      Optional switch to consider only the sentence as the \n";
    print "                context of the ambiguity.\n\n";

    print "--abstract      Optional switch to consider the entire abstract as the\n";
    print "                context of the ambiguity. This is the default.\n\n";

    print "--osentence filename\n";
    print "                Option to specify the name of the output file\n";
    print "                for sentence mode of the program. This is optional\n";
    print "                and by default the output is shown at STDOUT.\n";
    print "                However, note that this is mandatory if both the\n";
    print "                --sentence and --abstract options are specified\n";
    print "                at the same time.\n\n";

    print "--oabstract filename\n";
    print "                Option to specify the name of the output file\n";
    print "                for abstract mode of the program. This is optional\n";
    print "                and by default the output is shown at STDOUT.\n";
    print "                However, note that this is mandatory if both the\n";
    print "                --sentence and --abstract options are specified\n";
    print "                at the same time.\n\n";

    print "--help          Prints out this help message.\n\n";

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
               'help|?' => \$help,
               'osentence=s' => \$sval_sent_file,
               'oabstract=s' => \$sval_abst_file);

    # Check if the name of input file is specified at command line
    $nlm_file = shift @ARGV;

    if ($help == 1) {

        showHelp();
    }

    if (defined($nlm_file)) {

        # Open the file in read mode, if name specified
        open (HIN, "$nlm_file") || fatalError(0, "Failed to read file $nlm_file");

    } else {

        # Else, assume that the user will be / has given input at STDIN (for example through piping)
        *HIN = *STDIN;
    }

    # Check if we are running in a dual mode. In such a case, we require names of both output files.
    if ($mode_sent && $mode_abst) {

        # Check that both output files are specified
        if (!defined($sval_sent_file) || !defined($sval_abst_file)) {

            # Exit with error if not
            fatalError(1, "Please specify names of both output files. This is required when both sentence and abstract modes are specified.");
        }

        # Now create both the output files
        open ($hout1, ">$sval_sent_file") || fatalError(0, "Failed to create output file $sval_sent_file");
        open ($hout2, ">$sval_abst_file") || fatalError(0, "Failed to create output file $sval_abst_file");

    } elsif ($mode_sent) {

        # Here we are not in a dual mode, but in a "sentence" mode

        # Check if the user has accidently specified the name of the output file for "abstract" mode
        if (defined($sval_abst_file)) {
            # Exit with error if so
            fatalError(1, "Name of abstract output file specified in sentence mode. Drop output file option for output at STDOUT or use \"--osentence\" option.");
        }

        # Now check if the user has specified the name of the output file
        if (defined($sval_sent_file)) {

            # Create it, if so
            open ($hout1, ">$sval_sent_file") || fatalError(0, "Failed to create output file $sval_sent_file");
            
        } else {

            # Else, the default is that we print the output at STDOUT
            $hout1 = *STDOUT;
        }

    } else {

        # This is the default mode for the program. If not anything else, we run in abstract mode.
        $mode_abst = 1;

        # Check if the user has accidentally specified the name of the output file for sentence mode
        if (defined($sval_sent_file)) {

            # Exit with error if so
            fatalError(1, "Name of sentence output file specified in abstract mode. Drop output file option for output at STDOUT or use \"--oabstract\" option.");
        }

        # Now, check if the user has specified the output file name
        if (defined($sval_abst_file)) {

            # Create it, if so
            open ($hout2, ">$sval_abst_file") || fatalError(0, "Failed to create output file $sval_abst_file");
            
        } else {

            # Else, the default is that we print the output at STDOUT
            $hout2 = *STDOUT;
        }

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

###############
# commonPrint #
###############

# Most of the output is common to both the sentence mode and the abstract mode. This function helps in such cases. In a single call of this function, the desired string is printed to both the output files.

# When only a single mode is operative, the $hout1 and $hout2 are appropriately undefined. The function checks for this and prints the string only to the required handle.

# A single argument is treated as a plain string to be printed using print.
# Multiple arguments are treated as a request for formatted print, with the first argument being the format string.

# This function takes care of the indentation in the output file based on the value of $indent_level variable which is changed in the Main script according to requirements

# A newline is added at the end of the message by default
sub commonPrint {

    # Print out the string to the sentence output file, if required
    if (defined($hout1)) {

        # Indent with spaces as required
        print $hout1 " " x ($indent_level*$tab_size);

        if (@_ > 1) {
            printf $hout1 @_;
        } else {
            print $hout1 $_[0];
        }

        print $hout1 "\n";
    }

    # Print out the string to abstract output file, if required
    if (defined($hout2)) {

        # Indent with spaces as required
        print $hout2 " " x ($indent_level*$tab_size);

        if (@_ > 1) {
            printf $hout2 @_;
        } else {
            print $hout2 $_[0];
        }

        print $hout2 "\n";
    }
}

###############
# indentPrint #
###############

# This function is used to print to only a specific output file as required

# The first argument is therefore the output file handle - which is removed using shift.

# After that, a single argument is treated as a plain string to be printed using print.
# Multiple arguments are treated as a request for formatted print, with the first argument being the format string.

# This function takes care of the indentation in the output file based on the value of $indent_level variable which is changed in the Main script according to requirements

# A newline is added at the end of the message by default
sub indentPrint {

    # Get the output file handle to be used
    my $hout = shift;

    if (defined($hout)) {

        # Indent as required
        print $hout " " x ($indent_level*$tab_size);

        if (@_ > 1) {
            printf $hout @_;
        } else {
            print $hout $_[0];
        }

        print $hout "\n";
    }
}


#######################
# MAIN PROGRAM BEGINS #
#######################

# Get the command line options and set up the input and output file handles
getCmdLineOptions();

# Print out the main outer tag in the output
commonPrint("<corpus lang=\'en\'>");

# As we go on writing sub-tags inside outer tags, we increment the indentation level.
$indent_level++;

# Process the input NLM data line by line
my $line;

while ($line = <HIN>) {

    # Inside one run of this loop, we aim to process one entire instance in the input NLM data file. An example of an instance (which spans multiple lines) is as follows:


    ###########################################################################
    # 1|9337195.ab.7|M2
    # The relation between birth weight and flow-mediated dilation was not affected by adjustment for childhood body build, parity, cardiovascular risk factors, social class, or ethnicity.
    # adjustment|adjustment|78|90|81|90|by adjustment|
    # PMID- 9337195
    # TI  - Flow-mediated dilation in 9- to 11-year-old children: the influence of intrauterine and childhood factors.  
    # AB  - BACKGROUND: Early life factors, particularly size at birth, may influence later risk of cardiovascular disease, but a mechanism for this influence has not been established. We have examined the relation between birth weight and endothelial function (a key event in atherosclerosis) in a population-based study of children, taking into account classic cardiovascular risk factors in childhood. METHODS AND RESULTS: We studied 333 British children aged 9 to 11 years in whom information on birth weight, maternal factors, and risk factors (including blood pressure, lipid fractions, preload and postload glucose levels, smoking exposure, and socioeconomic status) was available. A noninvasive ultrasound technique was used to assess the ability of the brachial artery to dilate in response to increased blood flow (induced by forearm cuff occlusion and release), an endothelium-dependent response. Birth weight showed a significant, graded, positive association with flow-mediated dilation (0.027 mm/kg; 95% CI, 0.003 to 0.051 mm/kg; P=.02). Childhood cardiovascular risk factors (blood pressure, total and LDL cholesterol, and salivary cotinine level) showed no relation with flow-mediated dilation, but HDL cholesterol level was inversely related (-0.067 mm/mmol; 95% CI, -0.021 to -0.113 mm/mmol; P=.005). The relation between birth weight and flow-mediated dilation was not affected by adjustment for childhood body build, parity, cardiovascular risk factors, social class, or ethnicity. CONCLUSIONS: Low birth weight is associated with impaired endothelial function in childhood, a key early event in atherogenesis. Growth in utero may be associated with long-term changes in vascular function that are manifest by the first decade of life and that may influence the long-term risk of cardiovascular disease.
    # adjustment|adjustment|1521|1533|1524|1533|by adjustment|
    ###########################################################################

    # Excluding the Perl comment lines, the above instance shows 7 lines. Out of the line numbers 5 and 6, *any one* may be absent, depending on the data. So, at least one of them has to be present. Everything starting from line 4 (excluding the last line) is known as the citation.

    # Different instances are separated by a blank line in the NLM data format

    # Details of the data format are present on http://wsd.nlm.nih.gov/

    # The first line is the one that contains the serial number of the instance, a unique identifier for it and the sense of the ambiguity in that instance.
    chomp $line;

    # Get the instance id and the sense of the ambiguity, we do not want the serial number
    my (undef, $inst_id, $sense) = split /\|/, $line;

    # The next line is the sentence that contains the ambiguity. This may be from the title on line 5 or the abstract on line 6
    my $sentence = <HIN>;
    chomp $sentence;

    # The next line contains the actual ambiguity and information regarding its position in the sentence above. The offsets are zero based, from the beginning of the sentence.
    $line = <HIN>;
    chomp $line;

    # Get the ambiguity, its alias - which can be the actually used inflectional form of the ambiguous word, the start and end offset of the immediate context, the start and end offset of the ambiguity and finally the immediate context - IN THAT SPECIFIC ORDER.
    my ($word, $alias, $cs, $ce, $ws, $we, $context) = split /\|/, $line;
    

    # Now, from the fourth line, the citation begins. We check what key words we find at the beginning of the oncoming lines and decide accordingly
    $line = <HIN>;
    chomp $line;

    # Varibles to store the various parts of the citation, namely the PMID, the title and the abstract
    my ($pmid, $title, $abstract);

    # The last line of the instance is again a line containing the ambiguity an d it alias and this time the ONE BASED offsets in the entire citation. - starting from the beginning of the fourth line - usually PMID.
    my ($a_word, $a_alias, $a_cs, $a_ce, $a_ws, $a_we, $a_context);

    # Since we insert some tags into the data, discard some keywords in liu etc., we need to adjust the offsets in the citation accordingly - to mark the ambiguity appropriately

    # $len is the adjustment which we will add in each of the abstract offsets
    my $len = 0;

    # The tricky part is that the ambiguity may come in the title or the abstract part. In the output, we want this information to go as:

    # <context><title>_TITLE_</title>_ABSTRACT_</context>
    
    # The ambiguity which has to be marked in the <head>...</head> tags can be a part of _TITLE_ or _ABSTRACT_. If it a part of _ABSTRACT_ then we should add 8 to $len (which is the length of the string "</title>".

    # The $title_len variable tracks at what offset from the beginning of the citation does the title end. If this is greater than the beginning of the ambiguity, then we need not add 8 to $len. Else we should add 8 to $len.
    my $title_len = 0;

    # $abstract will store the entire citation as we read it line by line
    $abstract = "";

    # This is the inner while loop which processes the entire remaining part of the current instance. It exits when it encounters a blank line which is the seperator between two instances.
    while ($line ne "") {

        # Check if the line we read was the PMID
        if ($line =~ /^PMID- /) {

            # Append to abstract
            $abstract .= "$line ";

            # Increment the title length, the additional one is for the newline that was chomped from $line
            $title_len += length($line) + 1;

            # Extract the actual PMID
            $line =~ s/^PMID- //;
            $pmid = $line;

        } elsif ($line =~ /^TI  - /) {

            # This is a line containing the title of the document

            # Append the title to the abstract
            $abstract .= "<title>$line</title> ";

            # Increment the title length, again the additional one is for the newline
            $title_len += length($line) + 1;

            # Here we have to increment the $len variable which will adjust the offsets, by 7, the length of the "<title>" tag
            $len += 7;

            # Extract the actual title
            $line =~ s/^TI  - //;
            $title = $line;

        } elsif ($line =~ /^AB  - /) {

            # This is the abstract, simply append it to $abstract
            $abstract .= $line;

        } else {

            # This must be the last line of the citation, which contains the offsets

            # Get the ambiguity, alias and offsets
            ($a_word, $a_alias, $a_cs, $a_ce, $a_ws, $a_we, $a_context) = split /\|/, $line;

            # print "WORD $a_word ALIAS $a_alias CS $a_cs CE $a_ce WS $a_ws WE $a_we CONTEXT $a_context\n";

            # Now check if the ambiguity starts inside the title or after it
            if  ($title_len < $a_ws) {

                # It starts after the title, therefore we need to add 8 to $len, the length of "</title>" tag
                $len += 8;
            }

            # Here is where we adjust the citation offsets, using $len
            $a_cs += $len;
            $a_ce += $len;
            $a_ws += $len;
            $a_we += $len;

            # print "WORD $a_word ALIAS $a_alias CS $a_cs CE $a_ce WS $a_ws WE $a_we CONTEXT $a_context\n";
        }

        # Remember, we are in the inner while loop which should finish off the current instance
        # Read the next line
        $line = <HIN>;
        chomp $line;
    }

    # print "ABSTRACT = $abstract\n";

    # Before writing out the first instance, we need to add the "lexelt" tag which contains the ambiguity in question
    # Since this is immediately after the top level "corpus" tag, the indentation level should be 1
    if ($indent_level == 1) {

        # Add the beginning of the lexelt tag
        commonPrint("<lexelt item=\"$word\">");

        # Increment the indentation level
        $indent_level++;
    }

    # Check if the PMID was found
    if (defined($pmid)) {
        # Add that as additional information in the instance tag
        # Note that we also add the ambiguity alias in the instance tag
        # This represents the actual (possibly an inflection) form of the ambiguity that appeared in the citation
        commonPrint("<instance id=\"$inst_id\" pmid=\"$pmid\" alias=\"$alias\">");
    } else {

        # Simply add the instance id and the alias, no PMID
        commonPrint("<instance id=\"$inst_id\" alias=\"$alias\">");
    }


    $indent_level++;

    # Now we add the answer tag which contains the sense identifier of the ambiguity for that instnace
    commonPrint("<answer instance=\"$inst_id\" senseid=\"$sense\"/>");
    commonPrint("<context>");
    $indent_level++;

    my ($sent_out, $abst_out);

    # Now we need to add the "local" and "head" around the immediate context and the ambiguity respectively
    # e.g. we need to convert "The relation between birth weight and flow-mediated dilation was not affected by adjustment for childhood body build, parity, cardiovascular risk factors, social class, or ethnicity." to:
    # The relation between birth weight and flow-mediated dilation was not affected <local>by <head>adjustment</head></local> for childhood body build, parity, cardiovascular risk factors, social class, or ethnicity.

    # Do the above processing for sentence mode
    $sent_out = "";
    $sent_out .= substr($sentence, 0, $cs);
    $sent_out .= "<local>";
    $sent_out .= substr($sentence, $cs, $ws-$cs);
    $sent_out .= "<head>";
    $sent_out .= substr($sentence, $ws, $we-$ws+1);
    $sent_out .= "</head>";
    $sent_out .= substr($sentence, $we+1, $ce-$we);
    $sent_out .= "</local>";
    $sent_out .= substr($sentence, $ce+1);

    # Print sentence to the output
    indentPrint($hout1, $sent_out);

    # Do the above processing for abstract mode
    $abst_out = "";
    $abst_out .= substr($abstract, 0, $a_cs-1);
    $abst_out .= "<local>";
    $abst_out .= substr($abstract, $a_cs-1, $a_ws-$a_cs);
    $abst_out .= "<head>";
    $abst_out .= substr($abstract, $a_ws-1, $a_we-$a_ws+1);
    $abst_out .= "</head>";
    $abst_out .= substr($abstract, $a_we, $a_ce-$a_we);
    $abst_out .= "</local>";
    $abst_out .= substr($abstract, $a_ce);

    # Finally, remove the special identifiers in the citation
    $abst_out =~ s/PMID- .*?\<title\>/\<title\>/;
    $abst_out =~ s/\n//;
    $abst_out =~ s/TI  - //;
    $abst_out =~ s/AB  - //;

    # Print abstract to output
    indentPrint($hout2, $abst_out);

    # We decrease the indentation whenever we want to close a tag
    $indent_level--;

    # Close the context tag
    commonPrint("</context>");

    # Close the instance tag
    $indent_level--;
    commonPrint("</instance>");

    # At the end of one iteration of this loop, we have processed one instance completely
}

# Close the lexelt tag
$indent_level--;
commonPrint("</lexelt>");

# Close the top level corpus tag
$indent_level--;
commonPrint("</corpus>");

# Close all the open file handles
close HIN;

if (defined($hout1)) {
    close $hout1;
}

if (defined($hout2)) {
    close $hout2;
}
