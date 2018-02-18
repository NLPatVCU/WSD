#!/usr/bin/perl

my $a1File = shift;
my $a2File = shift;
my $s1File = shift;
my $s2File = shift;


open(A1, $a1File) || die "Could not open file : $a1File\n";
open(A2, $a2File) || die "Could not open file : $a2File\n";
open(S1, $s1File) || die "Could not open file : $s1File\n";
open(S2, $s2File) || die "Could not open file : $s2File\n";

my %a1Hash = ();
my %a2Hash = ();
my %s1Hash = ();
my %s2Hash = ();

my @array = qw (adjustment blood_pressure evaluation immunosuppression radiation sensitivity cold depression discharge extraction fat implantation japanese lead mole pathology reduction sex ultrasound degree growth man mosaic nutrition repair scale weight white association condition culture determination energy failure fit fluid frequency ganglion glucose inhibition pressure resistance secretion strains support surgery transient transport variation Overall);

my $tw = "";
my $accuracy = "";

format STDOUT =
@>>>>>>>>>>>>>>>>>>>>>>> @##.##  @##.##  @##.##  @##.##
$tw, $acc1, $acc2, $acc3, $acc4
.

while(<A1>) {
    chomp;
    $_=~s/^\s+//g;
    if($_=~/Overall Accuracy\s+([0-9]+\.[0-9]+)/) {
	$tw = "Overall"; $acc = $1;
    }
    else { ($tw, $acc) = split/\s+/; }
    $a1Hash{$tw} = $acc;
}
while(<A2>) {
    chomp;
    $_=~s/^\s+//g;
    if($_=~/Overall Accuracy\s+([0-9]+\.[0-9]+)/) {
	$tw = "Overall"; $acc = $1;
    }
    else { ($tw, $acc) = split/\s+/; }
    $a2Hash{$tw} = $acc;
}
while(<S1>) {
    chomp;
    $_=~s/^\s+//g;
    if($_=~/Overall Accuracy\s+([0-9]+\.[0-9]+)/) {
	$tw = "Overall"; $acc = $1;
    }
    else { ($tw, $acc) = split/\s+/; }
    $s1Hash{$tw} = $acc;
}
while(<S2>) {
    chomp;
    $_=~s/^\s+//g;
    if($_=~/Overall Accuracy\s+([0-9]+\.[0-9]+)/) {
	$tw = "Overall"; $acc = $1;
    }
    else { ($tw, $acc) = split/\s+/; }
    $s2Hash{$tw} = $acc;
}

print "                         a-1-cui a-2-cui s-1-cui s-2-cui\n";

for my $i (0..$#array) {
    $tw = $array[$i];
    $acc1 = $a1Hash{$tw};
    $acc2 = $a2Hash{$tw};
    $acc3 = $s1Hash{$tw};
    $acc4 = $s2Hash{$tw};
    
    write;
}
