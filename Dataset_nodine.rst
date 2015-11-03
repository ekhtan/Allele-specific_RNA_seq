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
        

2. Trim Data
------------

Dataset was trimmed using sickle::

        #!/bin/bash
        
        for i in *.gz
        do
          BASE=$(basename $i .gz)
          sickle se -f $i -t sanger -o $BASE.fq
        done
        
3. Assemble using Trinity
-------------------------

Run Trinity::

        Trinity --seqType fq --JM 50G \
        --single ColxCvi_2cell_fastq.fq,ColxCvi_32cell_fastq.fq,ColxCvi_8cell_fastq.fq,CvixCol_2cell_fastq.fq,CvixCol_32cell_fastq.fq,CvixCol_8cell_fastq.fq \
        --CPU 16
        

Performed the following renaming/parsing steps to get assembly ready::

        gzip -c trinity_out_dir/Trinity.fasta > trinity-ColCvi-raw.fa.gz
        
        


