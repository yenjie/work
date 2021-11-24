count=0
mypath=$1
d=PbPb80_0_10

mkdir $d
for (( c=0; c<=500; c++ ))
do
    cat template/parameterPbPb80_0_10|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_PbPb80_0_10_$c.dat
    ./pyquen.sh parameters/YenJie_PbPb80_0_10_$c.dat $d/PbPb_0_10_$c.pyquen $d/PbPb_0_10_$c.pu14>& logs/YenJie_PbPb80_0_10_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done
