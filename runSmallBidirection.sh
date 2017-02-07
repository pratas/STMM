#!/bin/bash
# PARAMETERS ==================================================================
GPARAM=" -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:10:1:0/0 -rm 20:200:1:10/50 -c 10 "
GPARAM2=" -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:10:1:0/0 -rm 20:200:1:0/0 -c 10 "
PLOT=1;
DOWNLOAD=1;
rm -fr sstmp;
mkdir sstmp;
cd sstmp/
# GET GOOSE & GECO ============================================================
if [[ "$DOWNLOAD" -eq "1" ]]; then
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
# RUN =========================================================================
echo "TGGTGCCAACGCGCAGGCATAGTTCCAGGAGAATTATCCGGGGGCAGTGACAACCAACATCTCGGGTCTTGCCCAACCGGTCTACACGCTGATATAGCGAATCACCGAGAACCCGGCGCCACGCAATGGAACGTCCTTAACTCTGGCAGGCAATTAAAGGGAACGTATATATAACGCAAAAAAACTGGAAAATTGGCGAG" > SAM;
echo "TGGTGCCAACGCGCAGGCATAGTTCCAGGAGAATTATCCGGGGGCAGTGTCAACCAACATCTCGGGTCTTGCCCAACCGGTCTACACGCTGATATAGCGCATCACCGAGAACCCGGCGCCACGCAATGGAACGTCCTTAACTCTGGCAGACAATTAAAGGGAACGTATATATAACGCAAAAAAACTGGAAAATTGGCGAG" > SUBS; # SUBS OF SAM AT 50, 100 and 150
echo "TGGTGCCAACGCGCAGGCATAGTTCCAGGAGAATTATCCGGGGGCAGTGTCAACCAACATCTCGGGTCTTGCCCAACCGGTCTACACGCTGATATAGCGCTTCACCGAGAACCCGGCGCCACGCAATGGAACGTCCTTAACTCTGGCAGATGATTAAAGGGAACGTATATATAACGCAAAAAAACTGGAAAATTGGCGAG" > SUBSINC; # SUBS OF SAM AT 50(1), 100(2), 150(3)
echo "TGGTGCCAACGCGCAGGCATAGTTCCAGGAGAATTATCCGGGGGCAGTGTCAACCAACATCTCGGGTCTTGCCCAACCGGTCTACACGCTGATATAGCGTACCACCGAGAACCCGGCGCCACGCAATGGAACGTCCTTAACTCTGGCAGCCGAATAAAGGGAACGTATATATAACGCAAAAAAACTGGAAAATTGGCGAG" > SUBSINCINT; # SUBS OF SAM AT 50(1), 100(1)-102(1), 150(1)-152(1)-154(1)
./goose-reverse SAM        > SAM_REV;
./goose-reverse SUBS       > SUBS_REV;
./goose-reverse SUBSINC    > SUBSINC_REV;
./goose-reverse SUBSINCINT > SUBSINCINT_REV;
#------------------------------------------------------------------------------
# EXP 1
./GeCo -v -e $GPARAM -r SAM SUBS;
./GeCo -v -e $GPARAM -r SAM_REV SUBS_REV;
mv SUBS.iae profileR.iae;
tac SUBS_REV.iae > profileL.iae;
./goose-min profileL.iae profileR.iae > profileLRmin.iae;
./goose-max profileL.iae profileR.iae > profileLRmax.iae;
./goose-filter -w 0 -d 0 -1 profileLRmin.iae > profLRmin.fil;
./goose-filter -w 0 -d 0 -1 profileLRmax.iae > profLRmax.fil;
./goose-filter -w 0 -d 0 -1 profileR.iae  > profR.fil;
./goose-filter -w 0 -d 0 -1 profileL.iae  > profL.fil;
# PLOT ========================================================================
if [[ "$PLOT" -eq "1" ]]; then
gnuplot << EOF
set terminal pdfcairo enhanced color
set output "simples1.pdf"
set auto
set size ratio 0.8
set key outside top title 'Legend' box
set yrange [0:6] 
set xrange [0:200] 
set ytics 0.5
set xtics 5
set xtics ("0" -1, "20" 20, "40" 40, "60" 60, "80" 80, "100" 100, "120" 120,  "140" 140, "160" 160, "180" 180, "200" 201)
set ytics ("0.00" -0.01, "0.25" 0.25, "0.50" 0.50, "0.75" 0.75, "1.00" 1.00, "1.25" 1.25, "1.50" 1.50, "1.75" 1.75, "2.00" 2.00) 
set grid 
set ylabel "Compression (BPB)"
set xlabel "Length (B)"
plot "profR.fil" u 1:2 w l lw 2 lc 3 title "right", \
     "profL.fil" u 1:2 w l lw 2 lc 4 title "left", \
     "profLRmin.fil" u 1:2 w l lw 2 lc 1 title "min"
EOF
fi
cp simples1.pdf ../../imgs/simples1.pdf
okular simples1.pdf &
#------------------------------------------------------------------------------
# EXP 2
./GeCo -v -e $GPARAM -r SAM SUBSINC;
./GeCo -v -e $GPARAM -r SAM_REV SUBSINC_REV;
mv SUBSINC.iae profileR.iae;
tac SUBSINC_REV.iae > profileL.iae;
./goose-min profileL.iae profileR.iae > profileLRmin.iae;
./goose-max profileL.iae profileR.iae > profileLRmax.iae;
./goose-filter -w 0 -d 0 -1 profileLRmin.iae > profLRmin.fil;
./goose-filter -w 0 -d 0 -1 profileLRmax.iae > profLRmax.fil;
./goose-filter -w 0 -d 0 -1 profileR.iae  > profR.fil;
./goose-filter -w 0 -d 0 -1 profileL.iae  > profL.fil;
# PLOT ========================================================================
if [[ "$PLOT" -eq "1" ]]; then
gnuplot << EOF
set terminal pdfcairo enhanced color
set output "simples2.pdf"
set auto
set size ratio 0.8
set key outside top title 'Legend' box
set yrange [0:6] 
set xrange [0:200] 
set ytics 0.5
set xtics 5
set xtics ("0" -1, "20" 20, "40" 40, "60" 60, "80" 80, "100" 100, "120" 120,  "140" 140, "160" 160, "180" 180, "200" 201)
set ytics ("0.00" -0.01, "0.25" 0.25, "0.50" 0.50, "0.75" 0.75, "1.00" 1.00, "1.25" 1.25, "1.50" 1.50, "1.75" 1.75, "2.00" 2.00) 
set grid 
set ylabel "Compression (BPB)"
set xlabel "Length (B)"
plot "profR.fil" u 1:2 w l lw 2 lc 3 title "right", \
     "profL.fil" u 1:2 w l lw 2 lc 4 title "Left", \
     "profLRmin.fil" u 1:2 w l lw 2 lc 1 title "min"
EOF
fi
cp simples2.pdf ../../imgs/simples2.pdf
okular simples2.pdf &
#------------------------------------------------------------------------------
# EXP 3
./GeCo -v -e $GPARAM -r SAM SUBSINCINT;
./GeCo -v -e $GPARAM -r SAM_REV SUBSINCINT_REV;
mv SUBSINCINT.iae profileR.iae;
tac SUBSINCINT_REV.iae > profileL.iae;
./goose-min profileL.iae profileR.iae > profileLRmin.iae;
./goose-max profileL.iae profileR.iae > profileLRmax.iae;
./goose-filter -w 0 -d 0 -1 profileLRmin.iae > profLRmin.fil;
./goose-filter -w 0 -d 0 -1 profileLRmax.iae > profLRmax.fil;
./goose-filter -w 0 -d 0 -1 profileR.iae  > profR.fil;
./goose-filter -w 0 -d 0 -1 profileL.iae  > profL.fil;
# PLOT ========================================================================
if [[ "$PLOT" -eq "1" ]]; then
gnuplot << EOF
set terminal pdfcairo enhanced color
set output "simples3.pdf"
set auto
set size ratio 0.8
set key outside top title 'Legend' box
set yrange [0:6] 
set xrange [0:200] 
set ytics 0.5
set xtics 5
set xtics ("0" -1, "20" 20, "40" 40, "60" 60, "80" 80, "100" 100, "120" 120,  "140" 140, "160" 160, "180" 180, "200" 201)
set ytics ("0.00" -0.01, "0.25" 0.25, "0.50" 0.50, "0.75" 0.75, "1.00" 1.00, "1.25" 1.25, "1.50" 1.50, "1.75" 1.75, "2.00" 2.00) 
set grid 
set ylabel "Compression (BPB)"
set xlabel "Length (B)"
plot "profR.fil" u 1:2 w l lw 2 lc 3 title "right", \
     "profL.fil" u 1:2 w l lw 2 lc 4 title "Left", \
     "profLRmin.fil" u 1:2 w l lw 2 lc 1 title "min"
EOF
fi
cp simples3.pdf ../../imgs/simples3.pdf
okular simples3.pdf &
#------------------------------------------------------------------------------
# EXP 4
./GeCo -v -e $GPARAM2 -r SAM SUBSINCINT;
./GeCo -v -e $GPARAM2 -r SAM_REV SUBSINCINT_REV;
mv SUBSINCINT.iae profileR.iae;
tac SUBSINCINT_REV.iae > profileL.iae;
./goose-min profileL.iae profileR.iae > profileLRmin.iae;
./goose-max profileL.iae profileR.iae > profileLRmax.iae;
./goose-filter -w 0 -d 0 -1 profileLRmin.iae > profLRmin.fil;
./goose-filter -w 0 -d 0 -1 profileLRmax.iae > profLRmax.fil;
./goose-filter -w 0 -d 0 -1 profileR.iae  > profR.fil;
./goose-filter -w 0 -d 0 -1 profileL.iae  > profL.fil;
# PLOT ========================================================================
if [[ "$PLOT" -eq "1" ]]; then
gnuplot << EOF
set terminal pdfcairo enhanced color
set output "simples4.pdf"
set auto
set size ratio 0.8
set key outside top title 'Legend' box
set yrange [0:6] 
set xrange [0:200] 
set ytics 0.5
set xtics 5
set xtics ("0" -1, "20" 20, "40" 40, "60" 60, "80" 80, "100" 100, "120" 120,  "140" 140, "160" 160, "180" 180, "200" 201)
set ytics ("0.00" -0.01, "0.25" 0.25, "0.50" 0.50, "0.75" 0.75, "1.00" 1.00, "1.25" 1.25, "1.50" 1.50, "1.75" 1.75, "2.00" 2.00) 
set grid 
set ylabel "Compression (BPB)"
set xlabel "Length (B)"
plot "profR.fil" u 1:2 w l lw 2 lc 3 title "right", \
     "profL.fil" u 1:2 w l lw 2 lc 4 title "left", \
     "profLRmin.fil" u 1:2 w l lw 2 lc 1 title "min"
EOF
fi
cp simples4.pdf ../../imgs/simples4.pdf
okular simples4.pdf &
cd ..
