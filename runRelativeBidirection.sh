#!/bin/bash
# PARAMETERS ==================================================================
GPARAM=" -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:5/50 "
GPARAM2=" -rm 4:1:0:0/0 -rm 6:1:1:0/0 -rm 13:20:1:0/0 -rm 20:200:1:0/50 "
#GPARAM=" -rm 20:100:1:3/10 "
PLOT=1;
DOWNLOAD=1;
rm -fr stmp;
mkdir stmp;
cd stmp/
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
./goose-genrandomdna -s 1    -n 100000 > SAM1;
./goose-genrandomdna -s 11   -n 100000 > SAM2;
./goose-genrandomdna -s 101  -n 100000 > SAM3;
./goose-genrandomdna -s 127  -n 100000 > SAM4;
./goose-genrandomdna -s 131  -n 100000 > SAM5;
./goose-genrandomdna -s 207  -n 100000 > SAM6;
./goose-genrandomdna -s 271  -n 100000 > SAM7;
./goose-genrandomdna -s 313  -n 100000 > SAM8;
./goose-genrandomdna -s 351  -n 100000 > SAM9;
./goose-genrandomdna -s 411  -n 100000 > SAM10;
./goose-genrandomdna -s 417  -n 100000 > SAM11;
./goose-genrandomdna -s 517  -n 100000 > SAM12;
./goose-mutatedna -s 2    -mr 0.000 < SAM1 > SAM1_MUT;
./goose-mutatedna -s 12   -mr 0.025 < SAM2 > SAM2_MUT;
./goose-mutatedna -s 102  -mr 0.050 < SAM3 > SAM3_MUT;
./goose-mutatedna -s 128  -mr 0.075 < SAM4 > SAM4_MUT;
./goose-mutatedna -s 132  -mr 0.100 < SAM5 > SAM5_MUT;
./goose-mutatedna -s 208  -mr 0.125 < SAM6 > SAM6_MUT;
./goose-mutatedna -s 272  -mr 0.150 < SAM7 > SAM7_MUT;
./goose-mutatedna -s 314  -mr 0.175 < SAM8 > SAM8_MUT;
./goose-mutatedna -s 352  -mr 0.200 < SAM9 > SAM9_MUT;
./goose-mutatedna -s 412  -mr 0.225 < SAM10 > SAM10_MUT;
./goose-mutatedna -s 499  -mr 0.250 < SAM11 > SAM11_MUT;
./goose-mutatedna -s 519  -mr 0.500 < SAM12 > SAM12_MUT;
cat SAM1_MUT SAM2_MUT SAM3_MUT SAM4_MUT SAM5_MUT SAM6_MUT SAM7_MUT SAM8_MUT \
SAM9_MUT SAM10_MUT SAM11_MUT SAM12_MUT > MUT;
cat SAM1_MUT SAM2_MUT SAM3_MUT SAM4_MUT SAM5_MUT SAM6_MUT SAM7_MUT SAM8_MUT \
SAM9_MUT SAM10_MUT SAM11_MUT SAM12_MUT > MUT2;
cat SAM1 SAM2 SAM3 SAM4 SAM5 SAM6 SAM7 SAM8 SAM9 SAM10 SAM11 SAM12 > SAMPLE;
cat SAM1 SAM2 SAM3 SAM4 SAM5 SAM6 SAM7 SAM8 SAM9 SAM10 SAM11 SAM12 > SAMPLE2;
./goose-reverse SAMPLE  > SAMPLE_REV;
./goose-reverse MUT     > MUT_REV;
./goose-reverse SAMPLE2 > SAMPLE_REV2;
./goose-reverse MUT2    > MUT_REV2;
./GeCo -v -e $GPARAM -r SAMPLE MUT;
./GeCo -v -e $GPARAM -r SAMPLE_REV MUT_REV;
#
./GeCo -v -e $GPARAM2 -r SAMPLE2 MUT2
./GeCo -v -e $GPARAM2 -r SAMPLE_REV2 MUT_REV2
mv MUT.iae profileR.iae;
mv MUT2.iae profileR2.iae;
tac MUT_REV.iae > profileL.iae;
tac MUT_REV2.iae > profileL2.iae;
./goose-min profileL.iae profileR.iae > profileLRmin.iae;
./goose-max profileL.iae profileR.iae > profileLRmax.iae;
./goose-filter -w 7001 -d 10 -1 profileLRmin.iae > profLRmin.fil;
./goose-filter -w 7001 -d 10 -1 profileLRmax.iae > profLRmax.fil;
./goose-filter -w 7001 -d 10 -1 profileR.iae  > profR.fil;
#
./goose-min profileL2.iae profileR2.iae > profileLRmin2.iae;
./goose-max profileL2.iae profileR2.iae > profileLRmax2.iae;
./goose-filter -w 7001 -d 10 -1 profileLRmin2.iae > profLRmin2.fil;
./goose-filter -w 7001 -d 10 -1 profileLRmax2.iae > profLRmax2.fil;
./goose-filter -w 7001 -d 10 -1 profileR2.iae  > profR2.fil;


# PLOT ========================================================================
if [[ "$PLOT" -eq "1" ]]; then
gnuplot << EOF
set terminal pdfcairo enhanced color
set output "vb.pdf"
set auto
set size ratio 0.8
set key outside top title 'Legend' box
set yrange [0:2.5] 
set xrange [0:1200000] 
set ytics 0.25
set x2tics("0" 50000, "2.5" 150000, "5" 250000, "7.5" 350000, "10" 450000, "12.5" 550000, "15" 650000, "17.5" 750000, "20" 850000, "22.5" 950000, "25" 1050000, "50" 1150000)
set xtics ("0.0" -1, "0.1" 100000, "0.2" 200000, "0.3" 300000, "0.4" 400000, "0.5" 500000, "0.6" 600000,  "0.7" 700000, "0.8" 800000, "0.9" 900000, "1.0" 1000000, "1.1" 1100000, "1.2" 1200001)
set ytics ("0.00" -0.01, "0.25" 0.25, "0.50" 0.50, "0.75" 0.75, "1.00" 1.00, "1.25" 1.25, "1.50" 1.50, "1.75" 1.75, "2.00" 2.00, "2.25" 2.25, "2.50" 2.51) 
set grid 
set ylabel "Compression (BPB)"
set x2label "Sustitution rate (%)"
set xlabel "Length (M)"
plot "profR.fil" u 1:2 w l lw 2 lc 3 title "normal", \
 "profLRmin.fil" u 1:2 w l lw 2 lc 1 title "min", \
 "profLRmax.fil" u 1:2 w l lw 2 lc 4 title "max"
EOF
gnuplot << EOF
set terminal pdfcairo enhanced color
set output "vb2.pdf"
set auto
set size ratio 0.8
set key outside top title 'Legend' box
set yrange [0:2.5] 
set xrange [0:1200000] 
set ytics 0.25
set x2tics("0" 50000, "2.5" 150000, "5" 250000, "7.5" 350000, "10" 450000, "12.5" 550000, "15" 650000, "17.5" 750000, "20" 850000, "22.5" 950000, "25" 1050000, "50" 1150000)
set xtics ("0.0" -1, "0.1" 100000, "0.2" 200000, "0.3" 300000, "0.4" 400000, "0.5" 500000, "0.6" 600000,  "0.7" 700000, "0.8" 800000, "0.9" 900000, "1.0" 1000000, "1.1" 1100000, "1.2" 1200001)
set ytics ("0.00" -0.01, "0.25" 0.25, "0.50" 0.50, "0.75" 0.75, "1.00" 1.00, "1.25" 1.25, "1.50" 1.50, "1.75" 1.75, "2.00" 2.00, "2.25" 2.25, "2.50" 2.51) 
set grid 
set ylabel "Compression (BPB)"
set x2label "Sustitution rate (%)"
set xlabel "Length (M)"
plot "profR2.fil" u 1:2 w l lw 2 lc 3 title "normal", \
 "profLRmin2.fil" u 1:2 w l lw 2 lc 1 title "min", \
 "profLRmax2.fil" u 1:2 w l lw 2 lc 4 title "max"
EOF
fi
cp vb.pdf ../../imgs/directionSyn.pdf
cp vb2.pdf ../../imgs/directionSyn.pdf
okular vb.pdf
okular vb2.pdf
cd ..
