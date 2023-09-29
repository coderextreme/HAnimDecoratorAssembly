#!/usr/bin/perl
use strict;
use warnings;

# parameters
#
# STDIN - VRML Humaoid with move skin
# ARGV[0] -- copy of STDIN
# STDOUT -- VRML Humanoid with skin in place
#

my $skin = "";
my $skinCoord = "";
my $countBracketOpen = 0;
my $countBracketClosed = 0;
my $countBraceOpen = 0;
my $countBraceClosed = 0;
my $counting = 0;
while(<STDIN>) {
	my $line = $_;
	if ($line =~ / Shape /) { # begin counting braces
		$counting = 1;
	}
	if ($counting == 1) {
		if ($line =~ /DEF[ \t]+([^ \t]+)[ \t]+Coordinate[ \t]/) {
			$skinCoord = $1;
		}
		$skin .= $line;
		$countBracketOpen += $line =~ tr/\[//;
		$countBracketClosed += $line =~ tr/\]//;
		$countBraceOpen += $line =~ tr/\{//;
		$countBraceClosed += $line =~ tr/\}//;
		if ($countBraceOpen == $countBraceClosed && $countBraceOpen > 0 && $countBraceClosed > 0 &&
		  $countBracketOpen == $countBracketClosed && $countBracketOpen > 0 && $countBracketClosed > 0) {
			# end of skin
			print STDERR "Completed with skin, coordinate $skinCoord.\n";
			$counting = 0;
			last;
	        }
	}
}

$countBracketOpen = 0;
$countBracketClosed = 0;
$countBraceOpen = 0;
$countBraceClosed = 0;
$counting = 0;

open(STDIN2, "<$ARGV[0]") or die "Cannot open $ARGV[0] for replacement.\n";
while(<STDIN2>) {
	my $line = $_;
	if ($line =~ /(DEF[ \t]*[^ \t][^ \t]*[ \t]*HAnimHumanoid[^{]*\{)/) {
		$line =~ s/(DEF[ \t]*[^ \t][^ \t]*[ \t]*HAnimHumanoid[^{]*\{)/$1\nskin [\n $skin \n]\nskinCoord USE $skinCoord\n/;
		print STDERR "Substituted skin coordinate $skinCoord.\n";
	} elsif ($line =~ / Shape /) { # begin counting braces
		print STDERR "Started counting to remove old skin.\n";
		$counting = 1;
	} elsif ($line =~ /DEF[ \t]+([^ \t]+)[ \t]+Coordinate[ \t]/) {
		#if ($counting == 1) {
		#$skinCoord = $1;
		#print STDERR "Replaced $skinCoord (double check).\n";
		#}
	}
	if ($counting == 1) {
		# get rid of other skin
		$countBracketOpen += $line =~ tr/\[//;
		$countBracketClosed += $line =~ tr/\]//;
		$countBraceOpen += $line =~ tr/\{//;
		$countBraceClosed += $line =~ tr/\}//;
		if ($countBraceOpen == $countBraceClosed && $countBraceOpen > 0 && $countBraceClosed > 0 &&
		  $countBracketOpen == $countBracketClosed && $countBracketOpen > 0 && $countBracketClosed > 0) {
			# end of skin
			print STDERR "Found matching braces, exiting counting braces and brackets.\n";
			$counting = 0;
	        }
	} else {
		print $line;
	}
}
close(STDIN2);
