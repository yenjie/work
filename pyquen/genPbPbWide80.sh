count=0
mypath=$1
d=PbPbWide80_0_10
mkdir $d
for (( c=1001; c<=2000; c++ ))
do
    cat template/parameterPbPbWide80_0_10|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_PbPbWide80_0_10_$c.dat
    ./pyquen.sh parameters/YenJie_PbPbWide80_0_10_$c.dat $d/PbPbWide_0_10_$c.pyquen $d/PbPbWide_0_10_$c.pu14>& logs/YenJie_PbPbWide80_0_10_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done
