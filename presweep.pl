#!/usr/bin/perl
use strict;
use warnings;

# tAke as input a VRML skeleton and clean it up

# STDIN -- input VRML skeleton
# STDOUT -- output VRML skeleton humanoid with fixes
#

while(<STDIN>) {
	my $line = $_;
	$line =~ s/(scaroiliac|Sacroiliac)/sacroiliac/g;
	$line =~ s/(EXPORT) (.*)//;
	print $line;
}
