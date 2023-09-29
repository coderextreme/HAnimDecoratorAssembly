#!/usr/bin/perl
use strict;
use warnings;

# Node name cleanups
# STDIN -- original humanoid
# STDOUT -- humanoid with image texture in appearance
# ARGV[0] = if exists use x3d-tidy form (disabled)
# ARGV[1] = Second copy of STDIN

my %joints = ();
my $prefix = "Toddler_";
if (@ARGV > 0) {
	$prefix = $ARGV[0];  # do nothing
}
my $humanoid = "";
my $HREbegin = "";
my $HRE;
my $oldHRE = "node_t_Lily_RV7_Shape|humanoid_root|vl5|vl2|vt11|vt5|r_sternoclavicular|r_shoulder|r_elbow|r_radiocarpal|r_metacarpophalangeal_5|r_carpal_proximal_interphalangeal_5|r_carpal_distal_interphalangeal_5|r_carpal_distal_interphalangeal_5_end|r_metacarpophalangeal_4|r_carpal_proximal_interphalangeal_4|r_carpal_distal_interphalangeal_4|r_carpal_distal_interphalangeal_4_end|r_metacarpophalangeal_3|r_carpal_proximal_interphalangeal_3|r_carpal_distal_interphalangeal_3|r_carpal_distal_interphalangeal_3_end|r_metacarpophalangeal_2|r_carpal_proximal_interphalangeal_2|r_carpal_distal_interphalangeal_2|r_carpal_distal_interphalangeal_2_end|r_carpometacarpal_1|r_metacarpophalangeal_1|r_carpal_interphalangeal_1|r_carpal_interphalangeal_1_end|l_sternoclavicular|l_shoulder|l_elbow|l_radiocarpal|l_metacarpophalangeal_5|l_carpal_proximal_interphalangeal_5|l_carpal_distal_interphalangeal_5|l_carpal_distal_interphalangeal_5_end|l_metacarpophalangeal_4|l_carpal_proximal_interphalangeal_4|l_carpal_distal_interphalangeal_4|l_carpal_distal_interphalangeal_4_end|l_metacarpophalangeal_3|l_carpal_proximal_interphalangeal_3|l_carpal_distal_interphalangeal_3|l_carpal_distal_interphalangeal_3_end|l_metacarpophalangeal_2|l_carpal_proximal_interphalangeal_2|l_carpal_distal_interphalangeal_2|l_carpal_distal_interphalangeal_2_end|l_carpometacarpal_1|l_metacarpophalangeal_1|l_carpal_interphalangeal_1|l_carpal_interphalangeal_1_end|vc4|skullbase|skullbase_end|sacroiliac|r_hip|r_knee|r_talocrural|r_metatarsophalangeal_2|r_metatarsophalangeal_2_end|l_hip|l_knee|l_talocrural|l_metatarsophalangeal_2|l_metatarsophalangeal_2_end";
#if (@ARGV > 0) {
	#$oldHRE = "node-t-Lily-RV7-Shape|humanoid-root_1|humanoid-root|vl5|vl2|vt11|vt5|r-sternoclavicular|r-shoulder|r-elbow|r-radiocarpal|r-metacarpophalangeal-5|r-carpal-proximal-interphalangeal-5|r-carpal-distal-interphalangeal-5|r-carpal-distal-interphalangeal-5-end|r-metacarpophalangeal-4|r-carpal-proximal-interphalangeal-4|r-carpal-distal-interphalangeal-4|r-carpal-distal-interphalangeal-4-end|r-metacarpophalangeal-3|r-carpal-proximal-interphalangeal-3|r-carpal-distal-interphalangeal-3|r-carpal-distal-interphalangeal-3-end|r-metacarpophalangeal-2|r-carpal-proximal-interphalangeal-2|r-carpal-distal-interphalangeal-2|r-carpal-distal-interphalangeal-2-end|r-carpometacarpal-1|r-metacarpophalangeal-1|r-carpal-interphalangeal-1|r-carpal-interphalangeal-1-end|l-sternoclavicular|l-shoulder|l-elbow|l-radiocarpal|l-metacarpophalangeal-5|l-carpal-proximal-interphalangeal-5|l-carpal-distal-interphalangeal-5|l-carpal-distal-interphalangeal-5-end|l-metacarpophalangeal-4|l-carpal-proximal-interphalangeal-4|l-carpal-distal-interphalangeal-4|l-carpal-distal-interphalangeal-4-end|l-metacarpophalangeal-3|l-carpal-proximal-interphalangeal-3|l-carpal-distal-interphalangeal-3|l-carpal-distal-interphalangeal-3-end|l-metacarpophalangeal-2|l-carpal-proximal-interphalangeal-2|l-carpal-distal-interphalangeal-2|l-carpal-distal-interphalangeal-2-end|l-carpometacarpal-1|l-metacarpophalangeal-1|l-carpal-interphalangeal-1|l-carpal-interphalangeal-1-end|vc4|skullbase|skullbase-end|sacroiliac|r-hip|r-knee|r-talocrural|r-metatarsophalangeal-2|r-metatarsophalangeal-2-end|l-hip|l-knee|l-talocrural|l-metatarsophalangeal-2|l-metatarsophalangeal-2-end";
	#}
my $first = 1;
while(<STDIN>) {
	my $line = $_;
	if ($line =~ /DEF([ \t]+)([^ \t]+)([ \t]+)(Transform|HAnim(Humanoid|Joint|Segment|Site))/) {
		my $hanim = $2;
		$line =~ s/-/_/g;
		$hanim =~ s/-/_/g;
		if ($first == 1) {
			$first = 0;
			$HRE = $hanim;
		} else {
			$HRE .= "|".$hanim;
		}
	}
	if ($line =~ /USE([ \t]+)([^ \t]+)/) {  # perhaps captures too many
		$line =~ s/-/_/g;
	}
	if ($line =~ /ROUTE/) {  # perhaps captures too many
		$line =~ s/-/_/g;
	}
}
if ($oldHRE ne $HRE) {
	print STDERR "Old regular expression out of date, replace with the following:\n";
	print STDERR $HRE;
}

open(STDIN2, "<$ARGV[1]") or die "Cannot open $ARGV[1] for reading.\n";
while(<STDIN2>) {
	my $line = $_;
	$line =~ s/([ \t\$]+)($HRE)([ \t\$\.\]\n]+)/$1$prefix$2$3/gm;
	print $line;
}
close(STDIN2);
