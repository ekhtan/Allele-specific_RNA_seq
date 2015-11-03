#!/bin/bash/

for i in {465..470}

do

  wget -r "ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR364/SRR364"$i"/SRR364"$i".fastq.gz" .

done
