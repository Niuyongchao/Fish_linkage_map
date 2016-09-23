#!/usr/bin/perl
unless (@ARGV>0) {
    print "perl $0 <*.QTL>\n";
    exit 0;
}
use SVG;

open IN, "$ARGV[0]" || die "$!";
open OUT, ">$ARGV[0].svg" ||die "$!";
my $svg= SVG->new(width=>2000,height=>1500);
my $head=<IN>;
my $Xs=100;
my $Ys=1200;
my $y1=$Ys;
my $x1=$Xs;
$hash{0}=0;
while (my $line=<IN>){
	if ($line=~/_/){
		chomp $line;
		my @temp=split/\s+/,$line;
		$temp[1]=~s/^\D+0?//;
		$hash{$temp[1]}=$temp[2];
	}
}
close IN;
open IN, "$ARGV[0]" || die "$!";
#my $head=<IN>;
while (my $line=<IN>){chomp $line;
	my @temp=split/\s+/,$line;
	my $chr_ID=$temp[1];
	$temp[1]=~s/^\D+0?//;
	$last{$temp[1]}=$temp[2]*4+$Xs; #same as line 18
}
close IN;
#======================Draw backgroud
my $cum_len;
foreach my $lg(1..24){
        my $LG_len=$hash{$lg};
        $cum_len+=$LG_len;
        my $x=($cum_len-$LG_len)/2+$Xs;
        my $width=$LG_len/2;
        if ($lg%2==1){$color="white";}else{$color="gray";}
        my $LG=$svg->rect (x=>$x, y=>$Ys-600, width=>"$width", height=>"600", style=>"fill:$color", "stroke-width"=>0, stroke=>"$color", "fill-opacity"=>0.5, "stroke-opacity"=>1);
	my $LG_ID=$svg->text(x=>$x+$width/2-8, y=>$Ys-150, 'font-size'=>'20', -cdata=>"$lg") if $lg<10;
	my $LG_ID=$svg->text(x=>$x+$width/2-12, y=>$Ys-150, 'font-size'=>'20', -cdata=>"$lg") if $lg>=10;

}
#++++++++++++++++++++++++++++++++++++



my $x_zhou=$svg->line(x1=>$Xs, y1=>$Ys, x2=>$Xs+1000, y2=>$Ys, style=>'fill:none', stroke=>'black',"stroke-width"=>3);
foreach my $xb(0..4){
        my $kd=$xb*250+$Xs;
        my $txt=($kd/4-25)*8;
        my $kedu=$svg->line(x1=>$kd, y1=>$Ys, x2=>$kd, y2=>$Ys+20, style=>'fill:none', stroke=>'black', "stroke-width"=>3); 
        my $text=$svg->text(x=>$kd, y=>$Ys+50, 'font-size'=>'20', -cdata=>$txt);

}
my $cM=$svg->text(x=>1080, y=>$Ys+20, 'font-size'=>'20', -cdata=>'cM');
foreach my $xb2(0..20){
        my $kd2=$xb2*50+$Xs;
        my $kedu2=$svg->line(x1=>$kd2, y1=>$Ys, x2=>$kd2, y2=>$Ys+10, style=>'fill:none', stroke=>'black', "stroke-width"=>3);

}

my $y_zhou=$svg->line(x1=>$Xs, y1=>$Ys, x2=>$Xs, y2=>$Ys-600, style=>'fill:none', stroke=>'black',"stroke-width"=>3);
###LOD=3.1;
my $LOD=$svg->line(x1=>$Xs, y1=>$Ys-102, x2=>$Xs+1000, y2=>$Ys-93, style=>'fill:none', "stroke-dasharray" =>10, stroke=>'black',"stroke-width"=>3);
my $LOD_text=$svg->text(x=>$Xs-40, y=>$Ys-92, 'font-size'=>'20', -cdata=>'3.4');
foreach my $xb(0..2){
        my $kd=$Ys-$xb*300;
        my $txt=($kd-1200)/30*(-1);
        my $kedu=$svg->line(x1=>$Xs, y1=>$kd, x2=>$Xs+20, y2=>$kd, style=>'fill:none', stroke=>'black', "stroke-width"=>3);
        my $text=$svg->text(x=>$Xs-40, y=>$kd, 'font-size'=>'20', -cdata=>$txt);

}
foreach my $xb2(1..4){
        my $kd2=$Ys-$xb2*60;
        my $kedu2=$svg->line(x1=>$Xs, y1=>$kd2, x2=>$Xs+10, y2=>$kd2, style=>'fill:none', stroke=>'black', "stroke-width"=>3);
	my $txt=($kd2-1200)/30*(-1);
	my $text=$svg->text(x=>$Xs-40, y=>$kd2, 'font-size'=>'20', -cdata=>$txt);

}


open IN, "$ARGV[0]" || die "$!";
my $head=<IN>;
my $y1=$Ys;
my $x1=$Xs;
$hash{0}=0;
while (my $line=<IN>){
if ($line=~/_/){
        chomp $line;
        my @temp=split/\s+/,$line;
        $temp[1]=~s/^\D+0?//;
        $y2=$Ys-($temp[4]*30);
        $cum_dis+=$temp[2];
        $hash{$temp[1]}=$temp[2];
        my $CCC;
        foreach $xxxx(1..$temp[1]){$CCC+=$hash{$temp[1]-$xxxx};}
        $x2=$Xs+($temp[2]+$CCC)/2;
        $color='red';
        my $marker = $svg->line(x1=>$x1, y1=>$y1,x2=>$x2, y2=>$y2, stroke=>$color,"stroke-width"=>3);
        $y1=$y2;
        $x1=$x2;
}
}
close IN;

print OUT $svg->xmlify;
close OUT;
print "Processing transform SVG to PDF ...\n";
`perl ~/bin/trans_svg/svg2xxx.pl -type pdf $ARGV[0].svg`;
