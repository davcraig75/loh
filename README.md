# LOH Analysis
## Questions

1. Why is coloring of slides different for GC1 (pink vs. nonpink)?


## Generate Pileups

`
samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideDB1_cluster[1-7].bam > FFSlideDB1.pu&

samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideEB1_cluster[1-9].bam > FFSlideEB1.pu&
samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideEC1_cluster[1-9].bam > FFSlideEC1.pu&
samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideED1_cluster[1-9].bam > FFSlideED1.pu&

samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideGB1_cluster[1-9].bam > FFSlideGB1.pu&
samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideGC1_cluster[1-9].bam > FFSlideGC1.pu&
samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideGD1_cluster[1-9].bam > FFSlideGD1.pu&
samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideGE1_cluster[1-9].bam > FFSlideGE1.pu&

samtools mpileup --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed ~/loh/data/FF_D1/cluster[1-9].bam > FFD1.pu&


samtools mpileup -F 256 --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideDB1_cluster[1-7].bam > FFSlideDB1.pu.256.tsv
samtools mpileup -F 256 --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideDB1_cluster1.bam | head -500 | grep 1541864


samtools mpileup --ff 0 --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideDB1_cluster[1-7].bam > FFSlideDB1.ff.pu&
samtools mpileup --ff 0 --reference ~/loh/data/B38.fasta -l ~/loh/data/snps.input.bed FFSlideGD1_cluster[1-9].bam > FFSlideGD1.ff.pu&



`

## Generate Pileup TSVs
perl script

`
~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideDB1.pu > FFSlideDB1.pu.tsv&

~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideEB1.pu > FFSlideEB1.pu.tsv&
~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideEC1.pu > FFSlideEC1.pu.tsv&
~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideED1.pu > FFSlideED1.pu.tsv&

~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideGB1.pu > FFSlideGB1.pu.tsv&
~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideGC1.pu > FFSlideGC1.pu.tsv&
~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideGD1.pu > FFSlideGD1.pu.tsv&
~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideGE1.pu > FFSlideGE1.pu.tsv&

~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideGE1.pu > FFSlideGE1.pu.tsv&

~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed  FFSlideDB1.ff.pu >  FFSlideDB1.ff.pu.tsv&


~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed  FFSlideGD1.ff.pu >  FFSlideGD1.ff.pu.tsv&
~/loh/mpileup_allele.2020.fold.pl ~/loh/data/snps.mpileup.pl.bed FFSlideGD1.pu > FFSlideGD1.pu.tsv&






`

