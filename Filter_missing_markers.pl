#!/usr/bin/perl
unless (@ARGV>0) {
    print "perl $0 <Before filtered Loc file> <after filtered loc file>\n";
    exit 0;
}
open IN, "$ARGV[0]";
open OUT, ">$ARGV[1]";

while (<IN>){
	if (/^R/){
		chomp;
		@_=split;
		my $total_sample=$#_-1;
		my $missing=$_=~s/\-\-//g;
		my $miss_rate=$missing/$total_sample;
		print OUT "$_\n" if $miss_rate<=0.1;
	}
 }

close IN;
close OUT;

