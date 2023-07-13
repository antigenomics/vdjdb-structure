############# Set paths to the needed files
order=ORDER  ## Set the mutation order. It is crucial to model the structures sequentionaly. EXAMPLE: 2

pdb=PDBID  ## Set the original PDB template EXAMPLE: 1ao7

str_dir=STR_DIR ## Set the folder containing previously modeled structures. In case of using mutation 
order = 1, the folder must contain all the modeled structures with the order=1

list_mut=/PATH/TO/PDBID_TCR_order2_path  ## Set the file, containing the information about the substitution. Part of the ../neighbors.mut_v_3aa_mhc_tcr_cdr3_HM_ONLY_same_pept_sorted_2022_04.txt file for the PDBID(1ao7) template

rosetta_mut_xml=/PATH/TO/1.Mutate_rosetta.xml 
rosetta_min_xml=/PATH/TO/2.Optimization_min.xml
rosetta_rep_xml=/PATH/TO/2.Optimization_rep.xml

rosetta_bin=ROSETTA_BIN_DIR ## Set the path to the installed Rosetta package (...main/source/bin/)

database=ROSETTA_DATABASE ## Set the path to the database folder of the installed Rosetta package (...main/database/)
##############

mkdir -p ${pdb}/TRA/${order}
cd ${pdb}/TRA/${order}
cp ${list_mut} ./
CDR3a_orig=$(head -n1 ${list_mut} | awk '{print $30}')
CDR3b_orig=$(head -n1 ${list_mut} | awk '{print $31}')

cp ${rosetta_rep_xml} ./${pdb}_repack.xml
cp ${rosetta_min_xml} ./${pdb}_min.xml

##### Get PDB chains containing TCRs, MHCs and peptides
chain_TRA=$(head -n1 ${list_mut} | awk '{print $27}')
chain_TRB=$(head -n1 ${list_mut} | awk '{print $28}')
chain_MHCa=$(head -n1 ${list_mut} | awk '{print $25}')
chain_MHCb=$(head -n1 ${list_mut} | awk '{print $26}')
chain_pept=$(head -n1 ${list_mut} | awk '{print $29}')


###### Modify xml Rosettascripts files, controlling minimization and repacking 
sed -i s/PEPTIDE_CHAIN/${chain_pept}/g ./${pdb}_repack.xml
sed -i s/MHCA_CHAIN/${chain_MHCa}/g ./${pdb}_repack.xml
sed -i s/MHCB_CHAIN/${chain_MHCb}/g ./${pdb}_repack.xml
sed -i s/TCRA_CHAIN/${chain_TRA}/g ./${pdb}_repack.xml
sed -i s/TCRB_CHAIN/${chain_TRB}/g ./${pdb}_repack.xml

sed -i s/PEPTIDE_CHAIN/${chain_pept}/g ./${pdb}_min.xml
sed -i s/MHCA_CHAIN/${chain_MHCa}/g ./${pdb}_min.xml
sed -i s/MHCB_CHAIN/${chain_MHCb}/g ./${pdb}_min.xml
sed -i s/TCRA_CHAIN/${chain_TRA}/g ./${pdb}_min.xml
sed -i s/TCRB_CHAIN/${chain_TRB}/g ./${pdb}_min.xml


cat ${list_mut} | sort -k15 | while read path_line ; 
 do 
 
 ##### get the information from the ${list_mut} file
 pdb_from=$(echo ${path_line} | awk '{print $1}')
 TCR=$(echo ${path_line} | awk '{print $4}')
 CDR3_from=$(echo ${path_line} | awk '{print $5}')
 CDR3_to=$(echo ${path_line} | awk '{print $6}')
 mutation_cdr3_0=$(echo ${path_line} | awk '{print $19}')
 mutation_cdr3_pdb0=$(echo ${path_line} | awk '{print $3}')
 
 mutation_cdr3_pdb=$(echo ${path_line} | awk '{print $21}')
 mutation_resn_from=$(echo ${path_line} | awk '{print $17}')
 mutation_resn3_from=$(echo ${path_line} | awk '{print $23}')
 mutation_resn_to=$(echo ${path_line} | awk '{print $18}')
 mutation_resn3_to=$(echo ${path_line} | awk '{print $24}')
 chain=$(echo ${path_line} | awk '{print $2}')

 cp ${str_dir}/${pdb}_TRA_${CDR3_from}_TRB_${CDR3b_orig}_min.pdb ./

 ### Modify xml Rosettascripts files, controlling mutaion process 
 cp ${rosetta_mut_xml} ./${pdb}_${TCR}_${CDR3_from}_to_${CDR3_to}_Mutate_rosetta.xml
 sed -i s/RESID/${mutation_cdr3_pdb}/g ./${pdb}_${TCR}_${CDR3_from}_to_${CDR3_to}_Mutate_rosetta.xml
 sed -i s/CHAIN/${chain}/g ./${pdb}_${TCR}_${CDR3_from}_to_${CDR3_to}_Mutate_rosetta.xml
 sed -i s/RESNAME/${mutation_resn3_to}/g ./${pdb}_${TCR}_${CDR3_from}_to_${CDR3_to}_Mutate_rosetta.xml
 
 rm ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}.pdb

 ### Execution of the modeling of substitutions
 ${rosetta_bin}/rosetta_scripts.linuxgccrelease -s  ./${pdb}_TRA_${CDR3_from}_TRB_${CDR3b_orig}_min.pdb -parser:protocol ./${pdb}_${TCR}_${CDR3_from}_to_${CDR3_to}_Mutate_rosetta.xml -overwrite
 mv ${pdb}_TRA_${CDR3_from}_TRB_${CDR3b_orig}_min_0001.pdb ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}.pdb
 cp ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}.pdb ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_from1_TRA_${CDR3_from}_TRB_${CDR3b_orig}_order${order}.pdb

 mv score.sc ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_from1_TRA_${CDR3_from}_TRB_${CDR3b_orig}_order${order}.score

 ### Execution of the minimization of model
 rm ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_min.pdb  
 ${rosetta_bin}/rosetta_scripts.linuxgccrelease -s ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}.pdb -parser:protocol ${pdb}_min.xml
 mv ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_0001.pdb ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_min.pdb
 cp ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_min.pdb ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_from1_TRA_${CDR3_from}_TRB_${CDR3b_orig}_order${order}_min.pdb

 mv score.sc ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_from1_TRA_${CDR3_from}_TRB_${CDR3b_orig}_order${order}_min.score

 ### Execution of the repacking of model
 rm ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_min_repacked.pdb
 ${rosetta_bin}/rosetta_scripts.linuxgccrelease -s ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}.pdb -parser:protocol ${pdb}_repack.xml
 mv ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_0001.pdb ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_repacked.pdb
 cp ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_repacked.pdb ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_from1_TRA_${CDR3_from}_TRB_${CDR3b_orig}_order${order}_repacked.pdb
 mv score.sc ${pdb}_TRA_${CDR3_to}_TRB_${CDR3b_orig}_from1_TRA_${CDR3_from}_TRB_${CDR3b_orig}_order${order}_repacked.score

done
