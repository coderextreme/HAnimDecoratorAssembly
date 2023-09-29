
#!/usr/bin/perl
use strict;
use warnings;

while (<STDIN>) {
	my $line = $_;
	if ($line =~ /Skeleton/) {
		print "Joint Location\n";
		print "___________________________\n";
	} elsif ($line =~ /DEF/) {
		$line =~ s/.*DEF[ \t]+hanim_(.*)[ \t]+HAnimJoint.*/$1/;
		print "\n";
		print "$line";
	} elsif ($line =~ /center/) {
		$line =~ /.*center[ \t]+([^ \t\r\n]+)[ \t]+([^ \t\r\n]+)[ \t]+([^ \t\r\n]+)/;
		print "Location\n";
		print "X: $1 m\n";
		print "Y: $2 m\n";
		print "Z: $3 m\n";
		print "\n";
		print "___________________________\n";
	} else {
		print STDERR "What is $line?\n";
	}
}
