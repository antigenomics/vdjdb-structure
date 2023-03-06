MIR="java -Xmx20G -cp ../mir-1.0-SNAPSHOT.jar com.milaboratory.mir.scripts.Examples"

DIR=$1

mkdir $1/../out_mir 
mkdir $1/../out_mir/log

echo "Annotating structures"
$MIR annotate-structures -I `ls -p $1/*.pdb` -O $1/../out_mir/ 2>&1 | tee $1/../out_mir/log/ann_log.txt
echo "Computing geometry"
$MIR compute-pdb-geom -I `ls -p $1/*.pdb` -O $1/../out_mir/ 2>&1 | tee $1/../out_mir/log/geom_log.txt
echo "Computing contacts"
$MIR compute-pdb-contacts -I `ls -p $1/*.pdb` -O $1/../out_mir/ 2>&1 | tee $1/../out_mir/log/contact_log.txt

cd $1/../out_mir
gzip *