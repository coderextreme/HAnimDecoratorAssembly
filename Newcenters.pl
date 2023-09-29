#!/usr/bin/perl
use strict;
use warnings;

use Math::Trig;

# tAke as input a VRML skeleton with DEF/USE and name for Joints and Joint centers file and produce a skeleton with those centers replaced by values in joint centers file

# parameters
#
# $ARGV[0] -- JOint center and rotation
# $ARGV[1] -- a skeleton source of DEFs (same as STDIN)
# STDIN -- X3DV file with HAnimJoints
#
#

my %joints = ();
my $joint = "WRONG JOINT";
my @joints = ();
open (DEFS, "<$ARGV[1]") or die "Couldn't open DEFs file $ARGV[1]";
while (<DEFS>) {
	my $line = $_;

	if ($line =~ /(DEF|USE)[ \t]+([^ \t]+)[ \t]+HAnimJoint/) {
		my $defjoint = $2;
		# print STDERR $line;
		$defjoint =~ s/(Toddler|[Gg]ramps|hanim)_//;
		my $joint = $defjoint;
		$joints{$joint} = {};
		print STDERR "Creating joint object $joint\n";
		my $jointobj = $joints{$joint};
		$jointobj->{DEF} = $defjoint;
		push @joints, $jointobj;
	} elsif ($line =~ /HAnimJoint/) {
		print STDERR "Couldn't match $_ in Newcenters.pl DEFS loop\n";
	}
}
close(DEFS);
print STDERR "Now proceeding with getting centers from $ARGV[0]\n";
open (CENTERS, "<$ARGV[0]") or die "Couldn't open center locations and rotations file $ARGV[0]";
$joint = "WRONG JOINT";

while (<CENTERS>) {
	chomp;
	$joint = $_;
	if (/^S/) {  # Sacroiliac, etc.
		$joint = lc($joint);
	}
	if (/^([ \t]*)\r$/) {
		$joint = $1;
		print STDERR "skipping blank line\n";
		next;  #  line with white space, skip to next
	}
	# 
	if (/^([ \r\t]*)$/) {
		# skip blank lines
		print STDERR "skipping blank line\n";
		next;
	}
	while ($joint =~ /(.*)\r$/) {
		# spin until no new carriage returns
		print STDERR "stripping carriage returns\n";
		$joint = $1;
	}
	if ($joint =~ /(.*) end\r*$/) {
		print STDERR "Bogus6 joint '$joint', continuing, expect problems\r\n";
		$joint = $1;
		next;
	}
	if ($joint =~ /^[xyz]/) {  # centers and rotations
		$joint =~ tr/xyz/XYZ/;
	} elsif ($joint =~ /([^ ][^ ]*) .*\r*$/) {  # vc4 (neck)
		print STDERR "Warning, Bogus-2 joint '$joint'\r\n";
		$joint = $1;
	}
	print STDERR "Looking up joint object $joint\n";
	my $jointobj = $joints{$joint};
	print STDERR "Joint object is $jointobj\n";
	if ($jointobj->{DEF}) {
		print STDERR "Entering $joint \r\n";
		while(<CENTERS>) {
			chomp;
			my $line = $_;
			if ($line =~ /(.*)\r*$/) {
				$line = $1;
			}
			if ($line =~ /___/) {
				print STDERR "Exiting $joint \r\n";
				last;
			} elsif ($line =~ /^([XYZxyz]):  *([-0-9.e][-0-9.e]*) m ?\r*$/) {
				my $axis = uc($1);
				my $number = 0 + $2;
				$jointobj->{$axis} = $number;
			} elsif ($line =~ /^([XYZxyz]):  *([-0-9.e][-0-9.e]*) ° *\r*$/) {
				my $axis = lc($1);
				my $number = $2;
				$jointobj->{$axis} = $number;
			}
		}
		$jointobj->{Center} = "$jointobj->{X} $jointobj->{Y} $jointobj->{Z}";

	} elsif ($joint =~ /^[ \t\r]*$/) {
		print STDERR "Bogus7 empty $joint \r\n";
	} elsif ($joints{$joint}) {
		print STDERR "Bogus11 Warning, joint $joint found in map, but not processed \r\n";
	} elsif ($joint =~ /____/) {
		# pass
	} elsif ($joint =~ /^$/) {
		print STDERR "Bogus10 empty $joint \r\n";
	} else {
		print STDERR "Bogus9 (no def?) $joint \r\n";
	}
}

close(CENTERS);
my $joints = "\r\n".join("\r\n", @joints);
my $jointBindingPositions = "";
# my $jointBindingRotations = "";

for (@joints) {
	#$jointBindingPositions .= $_->{Center};
	#$jointBindingPositions .= "\n";
	#$jointBindingRotations .= $_->{Rotation};
	#$jointBindingRotations .= "\n";
}
while(<STDIN>) {
	my $line = $_;
	if ($line =~ /(.*DEF[ \t]*)([^ \t]*)([ \t]*HAnimJoint.*\{)(.*)$/) {
		my $header = $1;
		my $defjoint = $2;
		my $tag = $3;
		my $trailer = $4;
		my $joint = $defjoint;
		$joint =~ s/(Toddler|[Gg]ramps|hanim)_//;
		my $jointobj = $joints{$joint};
		my $center = "0 0 0";
		if ($jointobj && $jointobj->{Center}) {
			$center = $jointobj->{Center};
			print STDERR "Defined center $center for $joint\n";
#			my $offset = $jointobj->{Center};
#			my @center = split(/[ \t\r]+/, $center);
#			my @offset = split(/[ \t\r]+/, $offset);
#			my @newcenter = ();
#			for (my $i = 0; $i < 3; $i++) {
#				$newcenter[$i] = 0 + $center[$i]; # + $offset[$i];
#				print STDERR "0 + $center[$i] /* + $offset[$i]*/ = $newcenter[$i]";
#				print STDERR ",\t";
#				$center = join(" ", @newcenter);
#			}
		} else {
			print STDERR "Undefined Center for $joint choosing 0 0 0\n";
			$center = "0.0 0.0 0.0";
		}
		# replace the existing line
		$line = "$header$defjoint$tag\n center $center\n$trailer";
	} elsif ($line =~ /HAnimJoint/) {
		$line =~ s/^[ \t][ \t]*//g;
		$line =~ s/[ \t][ \t]*$//g;
		print STDERR "Couldn't match $line in Newcenters.pl stdin loop, not defining a center\n";
	} elsif ($line =~ /[ \t]rotation[ \t]/) {
		$line = "";
	} elsif ($line =~ /[ \t]translation[ \t]/) {
		$line = "";
	} elsif ($line =~ /[ \t]scale[ \t]/) {
		$line = "";
	}
	print $line;
}
