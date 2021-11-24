count=0
mypath=$1

for (( c=1001; c<=2000; c++ ))
do
    cat template/parameterPbPbWide_0_10|sed "s/xxxx/$c/g">parameters/YenJie_PbPbWide_0_10_$c.dat
    ./pyquen.sh parameters/YenJie_PbPbWide_0_10_$c.dat output/PbPbWide_0_10_$c.pyquen output/PbPbWide_0_10_$c.pu14>& logs/YenJie_PbPbWide_0_10_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done
