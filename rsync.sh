#!/bin/bash
rm ./Mcs/*
cp ./Work/*.runs/impl*/*.bit ./Mcs/bitstream.bit
cp ./Work/*.runs/impl*/*.tcl ./Mcs/bitstream.tcl
cp ./Work/*.runs/impl*/*.bin ./Mcs/bitstream.bin
cp ./Work/*.runs/impl*/*.mcs ./Mcs/bitstream.mcs
find ./Work/*.srcs -name *.hwh -type f -exec cp {} ./Mcs/bitstream.hwh \;
find ./Src/*.srcs -name *.hwh -type f -exec cp {} ./Mcs/bitstream.hwh \;
sed 's/\.\/${_xil_proj_name_}/\.\.\/Work/g' ./Scripts/create_prj.tcl > ./Scripts/temp.tcl
cat ./Scripts/temp.tcl > ./Scripts/create_prj.tcl
rm ./Scripts/temp.tcl
