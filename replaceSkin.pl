#!/usr/bin/perl
use strict;
use warnings;

# parameters
#
# $ARGV[0] -- VRML skeleton with skin.  This skin has IndexedRaceSet
# $ARGV[1] -- VRML skin to replace.  This skin has IndexedTriangleSet...we are replacing it
# STDOUT -- combined VRML skeleton
#
# TODO, look up DEFs in mapping.txt, reject HAnim Joints (not sites or segments yet) that don't fit list
#

print STDERR "Extracting $ARGV[0]\n";

my $skin = "";
my $countBracketOpen = 0;
my $countBracketClosed = 0;
my $countBraceOpen = 0;
my $countBraceClosed = 0;
my $counting = 0;
open(SKIN, "<$ARGV[0]") or die "Cannot open $ARGV[0], skeleton with skin converted from X3D output from Blender\n";
print STDERR "Reading $ARGV[0]\n";
while(<SKIN>) {
	my $line = $_;
	if ($line =~ / Shape /) { # begin counting braces
		$counting = 1;
		$line =~ s/children//;
	}
	if ($counting == 1) {
		$skin .= $line;
		$countBracketOpen += $line =~ tr/\[//;
		$countBracketClosed += $line =~ tr/\]//;
		$countBraceOpen += $line =~ tr/\{//;
		$countBraceClosed += $line =~ tr/\}//;
		if ($countBraceOpen == $countBraceClosed && $countBraceOpen > 0 && $countBraceClosed > 0 &&
		  $countBracketOpen == $countBracketClosed && $countBracketOpen > 0 && $countBracketClosed > 0) {
			# end of skin
			$counting = 0;
	        }
	}
}
close(SKIN);

my $skinless = "";
$counting = 0;
$countBracketOpen = 0;
$countBracketClosed = 0;
$countBraceOpen = 0;
$countBraceClosed = 0;
open(SKINLESS, "<$ARGV[1]") or die "Cannot open $ARGV[1], skeleton without skin\n";
print STDERR "Reading $ARGV[1]\n";
while(<SKINLESS>) {
	my $line = $_;
	if ($line =~ / Shape /) { # begin counting braces
		$counting = 1;
	}
	if ($counting == 1) {
		$countBracketOpen += $line =~ tr/\[//;
		$countBracketClosed += $line =~ tr/\]//;
		$countBraceOpen += $line =~ tr/\{//;
		$countBraceClosed += $line =~ tr/\}//;
		if ($countBraceOpen == $countBraceClosed && $countBraceOpen > 0 && $countBraceClosed > 0 &&
		  $countBracketOpen == $countBracketClosed && $countBracketOpen > 0 && $countBracketClosed > 0) {
			$counting = 0;
			# replace entire skin
			$skinless .= $skin;
		}
	} else {
		$skinless .= $line;
	}
}
close(SKINLESS);


print STDERR "Outputting\n";
print STDOUT $skinless;

$skinless = "";
