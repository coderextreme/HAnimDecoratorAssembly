
#!/usr/bin/perl

# Node name cleanups
# STDIN -- original humanoid
# STDOUT -- humanoid with image texture in appearance

while(<STDIN>) {
	my $line = $_;
	$line =~ s/coords_ME_mesh_t_Lily_RV7_Shape/Coordinate/;
	$line =~ s/ Shape /DEF Shape Shape/;
	$line =~ s/normals_ME_mesh_t_Lily_RV7_Shape/Normal/;
	print $line;
}
