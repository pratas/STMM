#!/bin/bash
GECOGOOSE=1;
DOWNLOAD=1;
RUN=1;
###############################################################################
if [[ "$GECOGOOSE" -eq "1" ]]; then
  rm -f -r geco/ goose/
  git clone https://github.com/pratas/goose.git
  cd goose/src/
  make
  cp goose-* ../../
  cd ../scripts/
  cp GetHumanParse.sh ../../
  cp GetChimpParse.sh ../../
  cp GetGorillaParse.sh ../../
  cp GetOrangutanParse.sh ../../
  cp GetCallithrixjacchus.sh ../../
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
if [[ "$DOWNLOAD" -eq "1" ]]; then
  . GetHumanParse.sh
  cat HS* > XOR
  rm -f HS* ;
  cat XOR | grep -v ">" | tr -d -c "ACGT" > HS
  rm -f XOR
  #
  . GetChimpParse.sh
  cat PT* > XOR
  rm -f PT* ;
  cat XOR | grep -v ">" | tr -d -c "ACGT" > PT
  rm -f XOR
  # 
  . GetGorillaParse.sh
  cat GG* > XOR
  rm -f GG* ;
  cat XOR | grep -v ">" | tr -d -c "ACGT" > GG
  rm -f XOR
  #
  . GetOrangutanParse.sh
  cat PA* > XOR
  rm -f PA* ;
  cat XOR | grep -v ">" | tr -d -c "ACGT" > PA
  rm -f XOR
  #
  . GetCallithrixjacchus.sh
  cat CJ* > XOR
  rm -f CJ* ;
  cat XOR | grep -v ">" | tr -d -c "ACGT" > CJ
  rm -f XOR
fi

###############################################################################
if [[ "$RUN" -eq "1" ]]; then
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:5/20 -c 200 -r HS PT ) &> REPORT_PRIMATES_HS_PT_STMM;
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:0/0 -c 200 -r HS PT ) &> REPORT_PRIMATES_HS_PT_MM;
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:5/20 -c 200 -r HS GG ) &> REPORT_PRIMATES_HS_GG_STMM;
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:0/0 -c 200 -r HS GG ) &> REPORT_PRIMATES_HS_GG_MM;
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:5/20 -c 200 -r HS PA ) &> REPORT_PRIMATES_HS_PA_STMM;
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:0/0 -c 200 -r HS PA ) &> REPORT_PRIMATES_HS_PA_MM;
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:5/20 -c 200 -r HS CJ ) &> REPORT_PRIMATES_HS_CJ_STMM;
  (time ./GeCo -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:0/0 -c 200 -r HS CJ ) &> REPORT_PRIMATES_HS_CJ_MM;
fi
###############################################################################

