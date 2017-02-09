#!/bin/bash
GECOGOOSE=1;
DOWNLOAD=1;
RUN=1;
###############################################################################
if [[ "$DOWNLOAD" -eq "1" ]]; then
  wget ftp://climb.genomics.cn/pub/10.5524/101001_102000/101027/Haliaeetus_albicilla.fa.gz
  wget ftp://climb.genomics.cn/pub/10.5524/101001_102000/101040/Haliaeetus_leucocephalus.fa.gz
  zcat Haliaeetus_albicilla.fa.gz | grep -v ">" | tr -d -c "ACGT" > HA
  zcat Haliaeetus_leucocephalus.fa.gz | grep -v ">" | tr -d -c "ACGT" > HL
fi
###############################################################################
if [[ "$GECOGOOSE" -eq "1" ]]; then
  rm -f -r geco/ goose/
  git clone https://github.com/pratas/goose.git
  cd goose/src/
  make
  cp goose-* ../../
  cd ../../
  cp goose/src/goose-* .
  git clone https://github.com/pratas/geco.git
  cd geco/src/
  cmake .
  make
  cp GeCo ../../
  cd ../../
fi
###############################################################################
if [[ "$RUN" -eq "1" ]]; then
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:5/20 -c 100 -r HA HL ) &> REPORT_STMM;
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:0/0 -c 100 -r HA HL ) &> REPORT_MM;
fi
###############################################################################

