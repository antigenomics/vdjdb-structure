MIR="java -Xmx24G -jar mir-1.0-SNAPSHOT.jar"

mkdir $1/summary/
mkdir $1/summary/log/

echo "Annotating structures"
$MIR annotate-structures -I `ls -p $1/*.pdb` -O $1/summary/ 2>&1 | tee $1/summary/log/ann_log.txt
echo "Computing geometry"
$MIR compute-pdb-geom -I `ls -p $1/*.pdb` -O $1/summary/ 2>&1 | tee $1/summary/log/geom_log.txt
echo "Computing contacts"
$MIR compute-pdb-contacts -I `ls -p $1/*.pdb` -O $1/summary/ 2>&1 | tee $1/summary/log/contact_log.txt

cd $1/summary/
gzip *