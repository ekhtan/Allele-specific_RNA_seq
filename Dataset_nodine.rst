Steps
=====

1. Download Data
----------------

Dataset was downloaded from SRA using a bash file::

        #!usr/bin/bash
        
        for i in {465..470}
          do
          wget -r "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR364/SRR364"$i"/SRR364"$i".fastq.gz" .
        done
        

Raw data files were symlinked and renamed based on the crosses and developmental stages::

        ln -s SRR364465.fastq.gz ColxCvi_2cell.fastq.gz
        ln -s SRR364466.fastq.gz ColxCvi_8cell.fastq.gz
        ln -s SRR364467.fastq.gz ColxCvi_32cell.fastq.gz
        ln -s SRR364468.fastq.gz CvixCol_2cell.fastq.gz
        ln -s SRR364469.fastq.gz CvixCol_8cell.fastq.gz
        ln -s SRR364470.fastq.gz CvixCol_32cell.fastq.gz
        

These files are pretty old solexa reads::

				@SRR364465.1713 HWI-EAS413:3:1:2873:1092/1
				GAGTTTTCAANTCTTACATCTGAATGCAGAGATATC
				+
				FBF@C??CA?#EEEEGGGGGHHHHHHHHEGFHHHB8
				

2. Trim Data
------------

Dataset was trimmed using sickle and scythe::

        #!/bin/bash
        
        for i in *.gz
        do
          BASE=$(basename $i _fastq.gz)
          sickle se -f $i -t sanger -o $BASE.sickle
          scythe -a adapter.fa $BASE.sickle -M 25 -o $BASE.fq
          rm $BASE.sickle
        done
        

These are the adapters used::

				>solAd1
				AGATCGGAAG
				>solB
				AGATCGGAAGAGC
				

3. Align using bwa
------------------

Run bwa-do-all from the comailab::

				bwa-do-all

4. Assemble using Cufflinks
---------------------------

Run Cufflinks on all the .bam files::

				for f in $(pwd)/*.bam; do
				  label=${f%_aln.sorted.bam}
				  mkdir ${label}_cufflinks && cd ${label}_cufflinks
				  cufflinks --label ${label} --num-threads 16 $f
				done
				

Run Cuffmerge on the combined .gtf files::

				for dir in $(pwd)/*_cufflinks; do
				  echo $dir/transcripts.gtf; done > assemblies.txt
				  
				cuffmerge -o isofrac0.05 --num-threads 16 --min-isoform-fraction 0.05 assemblies.txt 2&> cuffisofrac0.05.log
				cuffmerge -o isofrac0.2 --num-threads 16 --min-isoform-fraction 0.2 assemblies.txt 2&> cuffisofrac0.2.log
				cuffmerge -o isofrac0.5 --num-threads 16 --min-isoform-fraction 0.5 assemblies.txt 2&> cuffisofrac0.5.log
				cuffmerge -o isofrac0.7 --num-threads 16 --min-isoform-fraction 0.7 assemblies.txt 2&> cuffisofrac0.7.log
				cuffmerge -o isofrac0.9 --num-threads 16 --min-isoform-fraction 0.9 assemblies.txt 2&> cuffisofrac0.9.log
				

5. Check assembly
-----------------

Load the tracks into the gbrowse on TAIR to determine which assembly to use


