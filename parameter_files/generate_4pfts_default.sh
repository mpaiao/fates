#!/bin/bash


#---~---
#   List of paths
#---~---
tools_path=$(cd ../tools; pwd)
this_path=$(pwd)
#---~---


#---~---
#   List of files to use
#---~---
default_cdl="fates_params_default.cdl"
trimmed_cdl="fates_params_4trop_uncalibrated_api38+phen.cdl"
#---~---

#---~---
#   List of PFTs to keep (repeating the same PFT multiple times is fine)
#---~---
pft_in=1,1,1,1
#---~---


#---~---
#   List of NetCDF files
#---~---
default_nc="$(basename ${default_cdl} .cdl).nc"
trimmed_nc="$(basename ${trimmed_cdl} .cdl).nc"
#---~---



#---~---
#   Create a PFT  PFTs from the default.
#---~---
/bin/rm -f ${default_nc}
ncgen -o ${default_nc} ${default_cdl}
${tools_path}/FatesPFTIndexSwapper.py --pft-indices=${pft_in}                              \
   --fin=${this_path}/${default_nc} --fout=${this_path}/${trimmed_nc}
ncdump ${this_path}/${trimmed_nc} > ${this_path}/${trimmed_cdl}
/bin/rm -f ${default_nc} ${trimmed_nc}
#---~---


#---~---
#   Edit the CDL file.
#---~---
n_size_bins_old="fates_history_size_bins = 13 ;"
n_size_bins_new="fates_history_size_bins = 8 ;"
size_bins_old="fates_history_sizeclass_bin_edges = 0, 5, 10, 15, 20, 30, 40, 50, 60, 70, "
size_bins_new="fates_history_sizeclass_bin_edges = 0, 5, 10, 20, 35, 55, 80, 110 ;"
size_bins_bye="    80, 90, 100 ;"

sed -i".bck" s/"${n_size_bins_old}"/"${n_size_bins_new}"/g ${trimmed_cdl}
sed -i".bck" s/"${size_bins_old}"/"${size_bins_new}"/g     ${trimmed_cdl}
sed -i".bck" /"${size_bins_bye}"/d                         ${trimmed_cdl}
/bin/rm -f "${trimmed_cdl}.bck"
#---~---
