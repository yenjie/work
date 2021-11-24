count=0
mypath=$1
d=ee_wide_MB
for (( c=1; c<=100; c++ ))
do
    cat template/parameterPbPbWide_MB|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_PbPbWide_MB_$c.dat
    ./pyquen_ee.sh parameters/YenJie_PbPbWide_MB_$c.dat $d/PbPbWide_MB_$c.pyquen $d/PbPbWide_0_10_$c.pu14>& logs/YenJie_PbPbWide_MB_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done
