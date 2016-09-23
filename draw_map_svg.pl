#!/usr/bin/perl
unless (@ARGV>0) {
    print "perl $0 <*.loct> <out_file_prefix>\n";
    exit 0;
}
use SVG;

open IN, "$ARGV[0]" || die "$!";
open OUT, ">$ARGV[0].svg" ||die "$!";
my $svg= SVG->new(width=>1000,height=>750);
#my $head=<IN>;
while (my $line=<IN>){
	chomp $line;
	my @temp=split/\s+/,$line;
	my $chr_ID=$temp[1];
	$temp[1]=~s/^\D+0?//;
	my $y=25*$temp[1];
	my $x=100+$temp[2]*4;
	if ($temp[5]=~/lm/){ $color='red'; }
        if ($temp[5]=~/np/){ $color='blue';}
        if ($temp[5]=~/hk/){ $color='yellow'; }
	my $marker = $svg->line(x1=>$x, y1=>$y,x2=>$x, y2=>$y+15, stroke=>$color,"stroke-width"=>0.1);
}
close IN;
open IN, "$ARGV[0]" || die "$!";
#my $head=<IN>;
while (my $line=<IN>){chomp $line;
	my @temp=split/\s+/,$line;
	my $chr_ID=$temp[1];
	$temp[1]=~s/^\D+0?//;
	$last{$temp[1]}=$temp[2]*4+100; #same as line 18
}
close IN;
foreach(1..24){
	my $y=25*$_;
	my $y2=$y+15;
	my $s1 = "M 100 $y A 5 5 90 0 0 100 $y2";
	my $s2="M $last{$_} $y A 5 5 90 0 1 $last{$_} $y2";
	my $chr_start=$svg->path(d=> $s1,  stroke => 'black', "stroke-width"=>0.5, fill   => 'none');
	my $chr_end=$svg->path(d=> $s2,  stroke => 'black', "stroke-width"=>0.5, fill   => 'none');
	my $bian_xian_up = $svg->line(x1=>100, y1=>$y,x2=>$last{$_}, y2=>$y, stroke=>'black',"stroke-width"=>0.5 );
	my $bian_xian_down = $svg->line(x1=>100, y1=>$y2,x2=>$last{$_}, y2=>$y2, stroke=>'black',"stroke-width"=>0.5 );
}
my $x_zhou=$svg->line(x1=>100, y1=>665, x2=>900, y2=>665, style=>'fill:none', stroke=>'black',"stroke-width"=>1);
foreach my $xb(0..4){
        my $kd=$xb*200+100;
        my $txt=$kd/4-25;
        my $kedu=$svg->line(x1=>$kd, y1=>665, x2=>$kd, y2=>655, style=>'fill:none', stroke=>'black', "stroke-width"=>1); 
        my $text=$svg->text(x=>$kd, y=>680, 'font-size'=>'14', -cdata=>$txt);

}
foreach my $xb2(0..20){
        my $kd2=$xb2*40+100;
        my $kedu2=$svg->line(x1=>$kd2, y1=>665, x2=>$kd2, y2=>660, style=>'fill:none', stroke=>'black', "stroke-width"=>0.5);

}
foreach my $lg(1..24){
	$LG="LG0$lg" if $lg<10;
	$LG="LG$lg" if $lg>9;
	my $y=25*$lg;
	my $lg_name=$svg->text(x=>50, y=>$y+10.5, 'font-size'=>'14', -cdata=>$LG);
}


print OUT $svg->xmlify;
close OUT;
