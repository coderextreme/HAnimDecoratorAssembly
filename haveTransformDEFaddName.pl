#!/usr/bin/perl
use strict;
use warnings;

# tAke as input a VRML skeleton and add HAnimHumanoid and name

# STDIN -- input VRML skeleton
# STDOUT -- output VRML skeleton humanoid with names added, and skeleton moved under Humanoid
#
# TODO, look up DEFs in mapping.txt, reject HAnim Joints (not sites or segments yet) that don't fit list

# my $lines = "";
my $startTransformation = 0;
my $countBracketOpen = 0;
my $countBracketClosed = 0;
my $countBraceOpen = 0;
my $countBraceClosed = 0;
my $nodeType = "";
my $skeletonOccur = 0;
while(<STDIN>) {
	my $line = $_;
	$line =~ s/(scaroiliac|Sacroiliac)/sacroiliac/g;
	if ($line =~ /DEF[ \t]*([^ \t][^ \t]*)[ \t]*Transform/) {
		my $def = $1;
		my $name = $def;
		$name =~ s/(Toddler|[gG]ramps|hanim)_//;
		$nodeType = "HAnimJoint";
		#print STDERR "****humanoid.4 name is $name, def is $def\n";
		if ($name =~ /[Hh]umanoid_[Rr]oot/) {
			$name = lc($name);
			#print STDERR "****humanoid.3 name is $name, def is $def\n";
			$nodeType = "HAnimJoint";
			$startTransformation = 1;
			$line =~ s/children/skeleton/;
		} elsif ($name =~ /_end$/) {
			$name =~ s/_end$/_pt/;
			$nodeType = "HAnimSite";
			$startTransformation = 1;
		} elsif ($name =~ /Skeleton/) {
			#print STDERR "****humanoid.0 name is $name, def is $def\n";
			# $name = "hanim";
			$nodeType = "HAnimHumanoid";
			$startTransformation = 1;
		} elsif ($name =~ /node_t_Lily_RV7_Shape/) {
			#print STDERR "****humanoid.1 name is $name, def is $def\n";
			# $name = "hanim";
			$nodeType = "HAnimHumanoid";
			$startTransformation = 1;
		} elsif ($name =~ /Armature$/) {
			#print STDERR "****humanoid.2 name is $name, def is $def\n";
			# $name = "hanim";
			$nodeType = "HAnimHumanoid";
			$startTransformation = 1;
		} elsif ($startTransformation == 1) {
			$nodeType = "HAnimJoint";
			$startTransformation = 1;
		} else {
			$nodeType = "Transform";
			$startTransformation = 0;
		}
		if ($startTransformation == 1) {
			$line =~ s/DEF[ \t]*[^ \t]+[ \t]*Transform([ \t\{]+)/DEF $def $nodeType $1 name "$name" /;
			#print STDERR $line;
		} else {
			print STDERR "Did not replace Transform, $line\n";
		}
#	} elsif ($line =~ /lily_7_3_animate/) {
#		$line =~ s/lily_7_3_animate/hanim/g;
	}
	$countBracketOpen += $line =~ tr/\[//;
	$countBracketClosed += $line =~ tr/\]//;
	$countBraceOpen += $line =~ tr/\{//;
	$countBraceClosed += $line =~ tr/\}//;
	if ($nodeType eq "HAnimHumanoid" && $startTransformation == 1 && $skeletonOccur == 0) {
			
		$skeletonOccur = 1;
	}
	if ($countBraceOpen == $countBraceClosed && $countBraceOpen > 0 && $countBraceClosed > 0 &&
	  $countBracketOpen == $countBracketClosed && $countBracketOpen > 0 && $countBracketClosed > 0) {
	  	if ($skeletonOccur == 1) {
			# $line .= "]\n"; # end skeleton
			$line .= "# TIS ALL GOOD!\n";
			$skeletonOccur = 2;
		}
		$startTransformation = 0;
	} else {
		# $line .= "# ace $countBraceOpen != $countBraceClosed acket $countBracketOpen != $countBracketClosed !\n";
	}
	# print STDERR $line;
	print $line;
	# $lines .= $line;	
}
