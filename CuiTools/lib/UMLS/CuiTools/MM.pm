=head1 CuiTools
    
UMLS::CuiTools::MM.pm

=head1 SYNOPSIS

This program is used by the prolog2mm.pl to convert the 
prolog formatted text to our xml-like .mm format

use UMLS::CuiTools::MM;

#  create an instance of MM
my $handler = UMLS::CuiTools:::MM->new();

#  this is the plain text that will be converted to the .mm format
my $plain = "They were <head item="fit" instance="98184421.ab.5" sense="M1">fit</head>.";

#  Run MMTx on the plain text and get the prolog output
my $mmtxInputFile  = "tmp.mmtx.input";
my $mmtxOutputFile = "tmp.mmtx.output";
open(MMTX_INPUT, ">$mmtxInputFile") || die "Could not open file: $mmtxInputFile\n";
print MMTX_INPUT "$line\n"; close MMTX_INPUT;
system("$ENV{MMTX_PATH}/nls/mmtx/bin/MMTx --best_mappings_only -q --fileName=$mmtxInputFile --outputFileName=$mmtxOutputFile");

my @mmtxOutputArray = ();
open(MMTX_OUTPUT, $mmtxOutputFile) || die "Could not open file; $mmtxOutput\n";
while(<MMTX_OUTPUT>) { push @mmtxOutputArray, $_; }

#  information about the instance
my $possible_senses = "M1,M2, None";
my $instance_id     = "98184421";
my $target_word     = "fit";
my $target_word_id  = "98184421.ab.5";
my $sense           = "M1";
my $instance        = "They were fit"
my $tw              = "yes";	 
my $index           = 2;

my $prolog = ""; 

foreach my $line (@mmtxOutputArray) {
    if($_=~/^utterance\(\'(.*?)\'\,\"(.*)\"\)\./) {
	my $id = $1;
	$aoutput .= $handler->setSentenceHeader($_, $tw);
    }	
    elsif($_=~/\'EOU\'\./) {			      
	$aoutput .= $handler->setSentenceFooter();
	$prolog = ""; 
    }
    elsif($_=~/phrase\(/) {
	$aoutput .= $handler->parsePhrase($prolog, $tw, $index, $target_word, $target_word_id);
    }
    elsif($_=~/mappings/) {
	$prolog .= "$_\n";
    }
}
#  header information
print $handler->getHeader("fit", "M1,M2,None");

print $aoutput;
#  print the instance information in the .mm format
print $handler->setInstanceHeader($instance_id,
	  		          "adjustment",
				  $target_word_id, 
				  $sense, 
				  $instance);




The following is what would be printed by the above program:

<corpus lang='en'>
  <lexelt item="fit" senses="M1,M2,None">\n"
    <instance id="98184421" alias="fit">
      <answer instance="98184421.ab.5" senseid="M1"/>
        <context line="They were fit"/>
         <sentence tw="fit" id="98184421.ab.5" line="They were fit .">
          <phrase tw="" head="" line="They">
            <token word="they" pos="pron">
            </token>
          </phrase>
          <phrase tw="" head="" line="were">
            <token word="were" pos="aux">
            </token>
          </phrase>
          <phrase tw="fit" head="fit" line="fit ">
            <target word="fit" pos="adj">
              <mapping rank="1" score="1000" umls_cui="C0424576" umls_concept="Fit" semantic_types="fndg"/>
            </target>
            <Token word="." pos="punctuation">
            </token>
          </phrase>
        </sentence>
    </instance>
  </lexelt>
</corpus>


=head3 MM Functions

=item 1. getHeader

  Arguments: 
    1. target word
       the word to be disambiguated

    2. choices
       the possible senses

  Returns:
    
    <corpus lang='en'>
      <lexelt item="<target word>" senses="choices">\n"

=item 2. getInstanceHeader
  Arguments:
    1. abstract id
    2. target word
    3. target word id (sometimes different from the instance id
    4. the sense of the target word
    5. the instance

   Returns:

    <instance id="$id" alias="$tw">
      <answer instance="$instance" senseid="$sense"/>
        <context line="$line"/>
	
  </lexelt>
</corpus>

=item 3. setSentenceHeader
  Arguments:
    1. prolog utterance
    2. whether the instance contains the target wrod

  Returns:
  
     The sentence tags in the .mm format for the utterance in 
     the prolog file

     For the format on this please see the README.format.mm.pod
     located in the bin directory (or perldoc it).

=item 4. setSentenceFooter
  Returns:
  
     The closing sentence tags in the .mm format 
		      
=item 5. parsePhrase
  Arguments:
    1. prolog formated instance
    2. whether the instance containes the target word
    3. target word
    4. location of target word in the phrase
    5. the id

  Returns:
  
     The .mm format for each utterance in the prolog file

     For the format on this please see the README.format.mm.pod
     located in the bin directory (or perldoc it).

=item 6. getFooter

  Returns:

     </lexelt>
    </corpus>


=head1 AUTHOR

 Bridget T. McInnes, University of Minnesota

=head1 COPYRIGHT

 Copyright (c) 2007-2008,
 Bridget T. McInnes, University of Minnesota
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

package UMLS::CuiTools::MM;

use warnings;
use strict;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Array::Suffix ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw() ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw();

our $VERSION = '1.0';

#  variables 
my $targetFlag = "no";

sub new
{
    # First argument is class
    my $class = shift;

    my $self = {};

    bless $self, $class;

    $self->{dir} = shift if (defined(@_ > 0));
    $self->{verbose} = @_ ? shift : 0;

    warn "Dir = ", $self->{dir}, "\n" if ($self->{verbose});
    warn "Verbose = ", $self->{verbose}, "\n" if ($self->{verbose});

    return $self;
}

sub getHeader
{
    my $self = shift;
    
    my $item = shift;
    my $senses = shift;
    
    my $output = "";
    $output = "<corpus lang='en'>\n  <lexelt item=\"$item\" senses=\"$senses\">\n";

    return $output;

}

sub getFooter
{
    my $self = shift;

    my $output = "";
    $output  = "  </lexelt>\n";
    $output .= "</corpus>\n";

    return $output;
}

sub setInstanceFooter
{

    return "    </instance>\n";
}

sub setInstanceHeader
{
    my $self     = shift;
    
    my $id       = shift;
    my $tw       = shift;
    my $instance = shift;
    my $sense    = shift;
    my $line     = shift;
    
    my $output  = "    <instance id=\"$id\" alias=\"$tw\">\n";
    $output .= "      <answer instance=\"$instance\" senseid=\"$sense\"/>\n";
    $output .= "      <context line=\"$line\"/>\n";

    $targetFlag = "no";
    
    return $output;
}

sub setSentenceFooter 
{
    return "        </sentence>\n";
}


sub setSentenceHeader
{
    my $self       = shift;
    my $prolog     = shift;
    my $tw         = shift;
    
    if($tw=~/no/) { $tw = ""; }
    
    if($prolog=~/^utterance\(\'(.*?)\'\,\"(.*)\"/) {
	my $line = $2;
	my $id   = $1;
		
	my $output = "        <sentence tw=\"$tw\" id=\"$id\" line=\"$line\">\n";

	return $output;
    
    }

    return "ERROR: $prolog";
}

sub parsePhrase 
{
    my $self       = shift;
    my $prolog     = shift;
    my $tw         = shift;
    my $index      = shift;
    my $targetword = shift;
    my $id         = shift;

    my $targetregex = $targetword;

    if($tw=~/no/) { $tw = ""; }

    my @array = split/\n/, $prolog;

    my $phrase  = "";
    my $pOutput = "";

    my @order    = ();
    my @pos      = (); 
    my @tokens   = ();
    my @orig     = ();
    my @words    = ();
    my %ordermap = ();

    foreach (@array) {
	
	if($_=~/phrase\(\'?(.*?)\'?\,\[/) {
	    $phrase = $1;
	    
	    #  get the words from the phrsae
	    my $cleanphrase = $phrase;
	    $cleanphrase=~s/[\(\)\.\,]//g;  $cleanphrase=~s/\-/ /g;
	    $cleanphrase=~s/^\s*//g; 	    $cleanphrase=~s/\s*$//g; 

	    #  create an array of them
	    my @words = split/\s+/, $cleanphrase;

	    # get the pos tags and tokens from the metamap output
	    # looping through the tagged tokens getting the pos - problem
	    # not all terms are considered tokens - most notiably abbrevs
	    my $tokencounter = -1; my $wordcounter = 0;
	    while($_=~/inputmatch\((.*?)\,tokens\(\[\'?(.*?)\'?\]/g) { 
		
		#  get the token information
		my $before = $1; my $tok = $2;	my $p = "none";
		
		#  metamap ignores the ' and ,
		$tok=~s/\'//g; $tok=~s/\,/ /g; 
		
		# if this is blank just move on
		if($tok=~/^\s*$/) { next; }

		#  get rid of the extra white space that keeps popping up
		$tok=~s/^\s*//g; $tok=~s/\s*$//g; $tok=~s/\s+/ /g;

		#  make certain that there isn't a word between the 
		#  previous mapped token and this one
		my @toks = split/\s+/, $tok;
		for my $i (0..$#toks) { 
		    my $w = lc($words[$wordcounter]);

		    if($w eq $toks[$i]) { $wordcounter++; }
		    else { 
			push @pos, "NONE";
			push @tokens, $w;
			push @orig, $w;
			$wordcounter++; $wordcounter++;
			next;
		    }
		}
			
		if($before=~/(tag|features)\((.*?)\)/) { $p=$2; $p=~s/[\[\]]//g; }
		push @pos, $p;
		push @tokens, $tok; 
		push @orig, $tok;
		

		$tokencounter++;

		my @wtok = split/\s+/, $tok; 
		my $numberwords = $#wtok+1; 
		if($numberwords > 1 && $tokencounter < $index) { $index = $index - $#wtok; }
		if($index < 0) { $index = 0; }
		
	    }
	    
	    #  catch the extra words at athe end or phrase if they don't have explicit tokens
	    #  for mappings - this is happening to abbreviations
	    for my $i ($wordcounter..$#words) {
		my $w = lc($words[$i]);
		push @pos, "NONE";
		push @tokens, $w;
		push @orig, $w;
	    }

	    #  set the order of the mappings so they coincide with the tokens
	    my $count = 1;
	    foreach my $i (0..$#pos) {

		my @array = split/\s+/, $tokens[$i]; 
		
		if($pos[$i] eq "pron")                   { $order[$i][0] = 0; }
		elsif($pos[$i] eq "det")                 { $order[$i][0] = 0; }
		elsif($pos[$i] eq "prep" && $#array <= 0){ $order[$i][0] = 0; }
		elsif($pos[$i] eq "compl")               { $order[$i][0] = 0; }
		elsif($pos[$i] eq "punctuation")         { $order[$i][0] = 0; }
		else { 
		    for my $j(0..$#array) { 
			$ordermap{$count} = $i; 
			$order[$i][$j]    = $count++; 
		    } 
		}
	    }
	}

	#  get the mappings
	my %CuiID    = (); my %Cuis     = (); my %Sts      = (); my %Score    = (); 
	my @head     = (); my %CuiCount = (); my $mapCount = 0;  my %mapArray = ();
	if($_=~/mappings\(/) {
	    while($_=~/(ap\(.*?\))(\,m|\]\)\.)/g) {
		my $mymap = $1;
		
		while($mymap=~/ev\((.*?)\)/g) {
		
		    my $map = $1;
		    
		    $map=~/\-([0-9]+),\'(C[0-9]+)\',\'?(.*?)\'?,\'?(.*?)\'?,\[(.*?)\],\[(.*?)\]/;
		    
		    my $score    = $1;		    my $cuinum = $2;
		    my $cui      = $4;		    my $st     = $6;
		    my $mappings = $5;
		    
		    #  if the cuinum is not given then reget the values
		    if( (!(defined $st)) or ($st=~/^\s*$/) ) {

			$map=~/\-([0-9]+),\'?(.*?)\'?,\'?(.*?)\'?,\[(.*?)\],\[(.*?)\]/;

			$score    = $1;			$cuinum = "";
			$cui      = $3;			$st     = $5;
			$mappings = $4;
		    }
		    
		    #  determine if it is a head word or not
		    $map=~/(yes|no),(yes|no)/;
		    my $hw       = $1;
		    
		    #  get the order of the mapping for rank purposes
		    
		    while($map =~/\[\[(\d),(\d)\],\[\d,\d\],\d\]/g) {
			my $num  = $1; 
			push @{$mapArray{$num}}, $cui;

			push @{$CuiID{$num}}, $cuinum;
			push @{$Cuis{$num}},  $cui;
			push @{$Sts{$num}},   $st;
			push @{$Score{$num}}, $score;
			
			$head[$num] = $hw;
			
			my $cui_counter = $mapCount+1;
			$CuiCount{$cui}{$cui_counter}++;
		    }
		}
		$mapCount++;
	    } 

	    #  check if the tokens are given the same concept(s)
	    my @combine = ();
	    my $prev = ""; my $pnum = "";
	    foreach my $num (sort keys %mapArray) {
		my $current = join " ", @{$mapArray{$num}};
		#if($current eq $prev) {
		#    push @combine, $num;
		#    push @combine, $pnum;
		#}
		$prev = $current;
		$pnum = $num;
	    }

	    #  check if the combination crosses the tokens
	    my @sortedcombine = sort {$b <=> $a} @combine;
	    my $s1 = join " ", @sortedcombine;
	    my $s2 = join " ", @combine;
	    if($s1 ne $s2) { @combine = (); }
	    
	    #  combine tokens that are both given all of the same concepts
	    if($#combine > 0) {
		my $prev_num = "";
		foreach my $num (@combine) {
		    
		    if($prev_num eq "") { $prev_num = $num; next; }
		    
		    my $l = "";
		    if(exists $ordermap{$num}) { $l = $ordermap{$num}; }
		    else                       { $l = $num-1; }

		    my $t = "";
		    if(exists $ordermap{$prev_num}) { $t = $ordermap{$prev_num}; } 
		    else                            { $t = $l-1;                 }

		    
		    $tokens[$t] = "$tokens[$l] $tokens[$t]";
		    $tokens[$l] = ""; 
		    
		    if($t == $index || $l == $index) { $index = $t; }
		    		} 
	    }
	    
	    my $string  = "";
	    my $hw      = "";
	    my %printed = ();
	    
	    #  update the output string;
	    foreach my $i (0..$#tokens) {
		
		my $num = $order[$i][0];
		
		if($tokens[$i] eq "") { next; }
		
		#  check if word is a head word
		if( (exists $head[$num]) and ($head[$num]=~/yes/) ) {
		    $hw = "$orig[$i]";
		    $hw =~s/\,/ /g;
		}
	    
		#  set the mapping output
		my %mapHash = ();
		for my $j (0..($mapCount-1)) {
		    for my $k (0..$#{$order[$i]}) {

			my $n = $order[$i][$k];

			if( !(exists $CuiID{$n}) )       { next; }
			if($CuiID{$n}=~/^\s*$/)          { next; }
			if(! (exists ${$Cuis{$n}}[$j]))  { next; }
			
			my $cui   = "";
			my $score = "";
			my $rank  = "";
			
			#  get the cui
			$cui   = ${$Cuis{$n}}[$j];

			if($cui=~/^\s*$/) { next; }
			
			#  get the MTI score for a that cui
			$score = ${$Score{$num}}[$j] 
			    if (defined ${$Score{$num}}[$j]);

			#  get the rank of that cui in the mappings list
			foreach my $r (sort keys %{$CuiCount{$cui}}) {
			    $rank .= "$r,";
			} chop $rank;
			
						
			#  set the mappings output 
			my $mapString = "              <mapping ";
			$mapString .= "rank=\"$rank\" ";
			$mapString .= "score=\"$score\" ";
			$mapString .= "umls_cui=\"${$CuiID{$n}}[$j]\" ";
			$mapString .= "umls_concept=\"${$Cuis{$n}}[$j]\" ";
			$mapString .= "semantic_types=\"${$Sts{$n}}[$j]\"/>\n";
			
			$mapHash{$mapString}++;
			
		    } 
		} 

		#  set the tag as either a token or a target word
		my $header = "token"; 
		if( ($tw=~/yes/) && ($i == $index)) { 
		    $header   = "target"; 
		    $targetFlag = "yes";
		}
		
		#  set the word, pos, head and mapping output
		$string .= "            <$header ";
		$string .= "word=\"$tokens[$i]\" ";
		$string .= "pos=\"$pos[$i]\"";
		$string .= ">\n";      
		foreach my $mapString (sort keys %mapHash)  {
		    $string .= $mapString;
		}
		$string .= "            </$header>\n";
	    }
	    
	    #  set the output for the phrase
	    my $ptw = "";
	    if($string=~/\<target word/) { $ptw = $targetword; }
	    $pOutput .= "          <phrase tw=\"$ptw\" ";
	    $pOutput .= "head=\"$hw\" line=\"$phrase\">\n";	
	    $pOutput .= "$string"; 
	    $pOutput .= "          </phrase>\n";
	}
    }

    return $pOutput; 
} 

1;
    
__END__
