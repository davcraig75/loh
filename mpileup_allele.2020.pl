#!/usr/bin/perl -w
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
  $bq=30;
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
    $pos=$temp[1];
    $ref=$temp[2];
    if (exists($alt_al{"$chr-$pos-$ref"})) {$alt=$alt_al{"$chr-$pos-$ref"}} else {next LOOP}
    if ($header) {
    	$buf = $buf .
    	print "chr\tpos\tdbsnp\tref\talt\tqual\tPASS\tINFO";
    	$pu=0;
    	for ($j=4;$j<=$#temp;$j=$j+3) {
    		++$pu;
	    	print "\tAC$pu\tAF$pu\tT$pu";
	    }
	    print "\n";
	    $header=0;
    } else {
    	$buf=$buf . join ("\t","chr".$chr,$pos,".",$ref,$alt,$qual{"$chr-$pos-$ref"},"PASS",$info{"$chr-$pos-$ref"});
	    $pu=0;
	    for ($j=4;$j<=$#temp;$j=$j+3) {
	      ++$pu;
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
	      $t=$ref_c+$alt_c;
	      if ($t>5) {
	      	++$print; 
	      	$p=sprintf("%0.2f",$ref_c/$t);
	      } else {
	      		$p=""
	      };
	      $buf=$buf."\tAC$pu=$ref_c/$alt_c/$t\t$p\t$t";
	    }
	    if ($print>0) {
	    	print "$buf\n";
	    }
	    
	 }
  }
}
