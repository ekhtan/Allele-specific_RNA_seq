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
        

