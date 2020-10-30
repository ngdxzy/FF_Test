#!/bin/bash
rm ./Mcs/*
cp ./Work/*.runs/impl*/*.bit ./Mcs
cp ./Work/*.runs/impl*/*.tcl ./Mcs
cp ./Work/*.runs/impl*/*.bin ./Mcs
cp ./Work/*.runs/impl*/*.mcs ./Mcs
find ./Work/*.srcs -name *.hwh -type f -exec cp {} ./Mcs \;
find ./Src/*.srcs -name *.hwh -type f -exec cp {} ./Mcs \;
sed 's/\.\/${_xil_proj_name_}/\.\.\/Work/g' ./Scripts/create_prj.tcl > ./Scripts/temp.tcl
cat ./Scripts/temp.tcl > ./Scripts/create_prj.tcl
rm ./Scripts/temp.tcl
