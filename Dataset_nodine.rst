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

        ColxCvi_2cell_fastq.gz -> Raw_data/SRR364465.fastq.gz
        CvixCol_2cell_fastq.gz -> Raw_data/SRR364466.fastq.gz
        ColxCvi_8cell_fastq.gz -> Raw_data/SRR364467.fastq.gz
        CvixCol_8cell_fastq.gz -> Raw_data/SRR364468.fastq.gz
        ColxCvi_32cell_fastq.gz -> Raw_data/SRR364469.fastq.gz
        CvixCol_32cell_fastq.gz -> Raw_data/SRR364470.fastq.gz
        

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

3. Assemble using Trinity
-------------------------

Run Trinity::

        Trinity --seqType fq --JM 50G \
        --single ColxCvi_2cell_fastq.fq,ColxCvi_32cell_fastq.fq,ColxCvi_8cell_fastq.fq,CvixCol_2cell_fastq.fq,CvixCol_32cell_fastq.fq,CvixCol_8cell_fastq.fq \
        --CPU 16
        

Performed the following renaming/parsing steps to get assembly ready::

        gzip -c trinity_out_dir/Trinity.fasta > trinity-ColCvi-raw.fa.gz
        
        


