#!/usr/local/bin/perl -w

=head1 NAME

_program_name_

=head1 SYNOPSIS

_short_description_

=head1 USAGE

_program_name_ [OPTIONS] _INPUT_

=head1 INPUT

=head2 Required Arguments:

=head3 _INPUT_

=head2 Optional Arguments:

=head3 --param

_parameter_description_

=head3 Other Options :

=head4 --help

Displays this message.

=head4 --version

Displays the version information.

=head1 OUTPUT

_describe_the_output_format_here

=head1 SYSTEM REQUIREMENTS

_list_the_required_packages_or_modules_here

=head1 BUGS

_describe_any_limitations_here

=head1 AUTHOR

Ted Pedersen, University of Minnesota, Duluth

=head1 COPYRIGHT

Copyright (c) 2006,

 Ted Pedersen, University of Minnesota, Duluth
 tpederse@d.umn.edu

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


#############################################################################

#				CODE STARTS HERE

# you may include other packages, modules here

#############################################################################

#                           ================================
#                            COMMAND LINE OPTIONS AND USAGE
#                           ================================

# command line options
use Getopt::Long;
GetOptions ("help","version");
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


# make sure the user has specified the required arguments

##############################################################################

#                       ==========================
#                               CODE SECTION
#                       ==========================

# write code here ...

##############################################################################

#                      ==========================
#                          SUBROUTINE SECTION
#                      ==========================

#-----------------------------------------------------------------------------
#show minimal usage message
sub showminimal()
{
        print "Usage: program.pl [OPTIONS] INPUT";
        print "\nTYPE program.pl --help for help\n";
}

#-----------------------------------------------------------------------------

#show help
sub showhelp()
{
        print "Usage:  program.pl [OPTIONS] INPUT

Describe what your program does in one or two lines.

INPUT
	Specify INPUT requirements.

OPTIONS:

--help
        Displays this message.
--version
        Displays the version information.
Type 'perldoc program.pl' to view detailed documentation of this program.\n";
}

#------------------------------------------------------------------------------
#version information
sub showversion()
{
       print '$Id: pod-template.pl,v 1.1.1.1 2007/05/07 19:23:19 btmcinnes Exp $';
       print "\nCopyright (C) 2006, Ted Pedersen\n";
}

#############################################################################

