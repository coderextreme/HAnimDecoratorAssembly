
#!/usr/bin/perl

# Node name cleanups
# STDIN -- original humanoid
# STDOUT -- humanoid with image texture in appearance

while(<STDIN>) {
	my $line = $_;
	$line =~ s/coords_ME_ID6410/Coordinate/;
	$line =~ s/Shape\./ME_ID6410./;
	$line =~ s/Normal\./normals_ME_ID6410./;
	print $line;
}
