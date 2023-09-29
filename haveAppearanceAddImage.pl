#!/usr/bin/perl


# STDIN -- original humanoid
# STDOUT -- humanoid with image texture in appearance

while(<STDIN>) {
	my $line = $_;
	print $line;
	if ($line =~ /appearance.*Appearance/) {
		print "texture ImageTexture { url [ \"gramps_uv.png\" \"lily_2t_BaseColor.png\" \"gramps.png\" ] }\n"
	}
}
