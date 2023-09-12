#!/usr/bin/perl
use strict;
use warnings;
#
# parameters
#
# Taks as Input a VRML joints skeleton with DEF and name for HAnimJoints, and add a joints field

# STDIN -- old skeleton
# STDOUT -- new skeleton

my @skeleton = ();
my @joints = ();

# first find joints
while(<STDIN>) {
	my $line = $_;
	push(@skeleton, $line);
	if ($line =~ /^(.*)DEF[ \t]+([^ \t]+)[ \t]+HAnimJoint(.*)name[ \t]*["']([^\"\']*)['"]/) {
		my $header = $1;
		my $defjoint = $2;
		my $fields = $3;
		my $name = $4;
		my $joint = $2;
		push @joints, "USE $defjoint";
	} elsif ($line =~ /(HAnimJoint)/) {
		print STDERR $line;
		my $j = $1;
		$j =~ s/\r*$//g;
		print STDERR "Couldn't match $j in replacejoints.pl\n";
	}
}
my $joints = "\n".join("\n", @joints);

my $alreadyFoundJoints = 0;
my $first = 1;
my $countOpen = 0;
my $countClosed = 0;
my $readyToAddJoints = 0;
for (my $l = 0; $l < @skeleton; $l++) {
	my $line = $skeleton[$l];
	if ($line =~ /(.*)joints[\t ]+\[([^\]]*)\](.*)/) {
		my $header = $1;
		my $js = $2;
		my $footer = $3;
		if ($alreadyFoundJoints == 1) {
			print STDERR "Oops, already found joints...second skeleton?\n";
		}
		$skeleton[$l] = $header."joints [$joints]".$footer;
		$alreadyFoundJoints = 1;
	} elsif ($line =~ /skeleton/) {
		$readyToAddJoints = 1;
	}
	if ($readyToAddJoints == 1) {
		$countOpen += $line =~ tr/[//;
		$countClosed += $line =~ tr/]//;
		if ($countOpen == $countClosed && $countOpen > 0 && $countClosed > 0) {
			# maybe everything on one line
			$skeleton[$l] .= "joints [$joints]";
			$readyToAddJoints = 2;
		}
		$first = 0;
	} elsif ($readyToAddJoints == 2 && ($line =~ /skeleton/ || $line =~ /joints/)) {
			print STDERR "Oops, already found joints and/or skeleton?\n";
	}
}
print join("\n", @skeleton);
