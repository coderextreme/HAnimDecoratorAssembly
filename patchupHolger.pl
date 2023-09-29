
#!/usr/bin/perl

# Node name cleanups
# STDIN -- original humanoid
# STDOUT -- humanoid with image texture in appearance

while(<STDIN>) {
	my $line = $_;
	$line =~ s/.*description.*//;   # remove descrition from time sensor
	$line =~ s/.* translation .*//;   # remove translation, but keep centers
	$line =~ s/.* rotation .*//;   # remove rotation
	$line =~ s/.* scale .*//;   # remove scale
	print $line;
}
