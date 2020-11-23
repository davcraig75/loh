#!/usr/bin/perl 
#########################
#MAIN
#########################
&ref;
&pileup;


#####################
# Load in Fasta Reference
######################
sub ref {
  open (REF,"$ARGV[0]");
  LOOP: while (<REF>) {
    if (/^#/) {next LOOP}
    chomp;
    @t=split(/\t/);
    $alt_al{"$t[0]-$t[1]-$t[2]"}=$t[3];
    $qual{"$t[0]-$t[1]-$t[2]"}=$t[4];
    $info{"$t[0]-$t[1]-$t[2]"}=$t[7];
  }
  close (REF);
} 
#####################
# Read in pileup
######################
sub pileup{
  $bq=20;
  open (PU,"$ARGV[1]");
  $header=1;
  LOOP: while (<PU>) {
  	my $buf="";
  	$print=0;
    chomp;
    $line=$_;
    my @nseq=();
    @temp=split(/\t/,$line);
    $chr=$temp[0];
	$tchr=$chr;
	$tchr=~s/chr//g;	
    $pos=$temp[1];
    $ref=$temp[2];
	if ($tchr eq "X" ||$tchr eq "Y" || $tchr eq "MT") {next LOOP};
	$lchr=$tchr+$pos/300000000;
    if (exists($alt_al{"$chr-$pos-$ref"})) {$alt=$alt_al{"$chr-$pos-$ref"}} else {next LOOP}
    if ($header) {
    	$buf = $buf . print "chr\tpos\tchrpos\tref\talt\tCountsAll\tAF_all\tClust\tAC\tAF\tT\tdiff\ttestT\n";
    	$pu=0;
	    $header=0;
    } else {
    	$buf=$buf . join ("\t",$chr,$pos,$lchr,$ref,$alt);
	    $pu=0;
		&get_total;
		if ($total<40) {next LOOP}
		
	    LOOP2:for ($j=4;$j<=$#temp;$j=$j+3) {	      
	      $temp[$j]=~s/\^.//g;
	      $temp[$j]=~s/\$//g;
	      @seq=split(//,$temp[$j]);
	      @qua=split(//,$temp[$j+1]);
	      @nseq=();
	      for ($i=0;$i<=$#seq;++$i) {
	        if ($seq[$i] eq "+" || $seq[$i] eq "-") {
	          ++$i;
	          $size=$seq[$i];
	          for ($k=1;$k<=$size;++$k) { ++$i; }
	         } else {
	          push(@nseq,$seq[$i])
	         }
	      }
	      $ref_c=0;
	      $alt_c=0;
	      for ($i=0;$i<=$#nseq;++$i) {
	        $q=ord($qua[$i])-33;
	        if ($q>=$bq ) {
	          if ($nseq[$i] eq "." || $nseq[$i] eq ",") {
	            ++$ref_c;
	          } elsif (uc($nseq[$i]) eq $alt) {
	            ++$alt_c;
	          } 
	        }
	      }
	      $clusTot=$ref_c+$alt_c;
			if ($clusTot>30) {
				++$print;
				$ref_c_1=$tot_c-$ref_c;
				$t_all_1=$total-$clusTot;
				if ($t_all_1>0 && $ref_c_1/$t_all_1>0.4 && $ref_c_1/$t_all_1<0.6) {
					$p1=$ref_c/$clusTot;
					$pT=$ref_c_1/$t_all_1;
					$test=abs(($p1-$pT)/sqrt($p1*(1-$p1)/($clusTot)+$pT*(1-$pT)/($t_all_1)));
					$fra=(0.5-$ref_c_1/$t_all_1);
					$s=(0.5-$ref_c/$clusTot);
					$d=abs($s-$fra);
					#if ($d>0.5) 
					$AFall=$ref_c_1/$t_all_1;
					$p=sprintf("%0.2f",$ref_c/$clusTot);
					$d=sprintf("%0.2f",$d);
					print $buf."\t$total\t$AFall\tC$pu\tAC$pu=$ref_c/$alt_c/$t\t$p\t$clusTot\t$d\t$test\n";
				}
				++$pu; 
			}
		}
	    
	 }
  }
}

sub get_total {
	$tot_alt=0;
	$tot_c=0;
	$total=0;
		for ($j=4;$j<=$#temp;$j=$j+3) {	      
	      $temp[$j]=~s/\^.//g;
	      $temp[$j]=~s/\$//g;
	      @seq=split(//,$temp[$j]);
	      @qua=split(//,$temp[$j+1]);
	      @nseq=();
	      for ($i=0;$i<=$#seq;++$i) {
	        if ($seq[$i] eq "+" || $seq[$i] eq "-") {
	          ++$i;
	          $size=$seq[$i];
	          for ($k=1;$k<=$size;++$k) { ++$i; }
	         } else {
	          push(@nseq,$seq[$i])
	         }
	      }
	      $ref_c=0;
	      $alt_c=0;
	      for ($i=0;$i<=$#nseq;++$i) {
	        $q=ord($qua[$i])-33;
	        if ($q>=$bq ) {
	          if ($nseq[$i] eq "." || $nseq[$i] eq ",") {
	            ++$ref_c;
	          } elsif (uc($nseq[$i]) eq $alt) {
	            ++$alt_c;
	          } 
	        }
	      }
	      $total+=$ref_c+$alt_c;
		  $tot_c+=$ref_c;
		  $tot_alt+=$alt_c;
	    }
}
