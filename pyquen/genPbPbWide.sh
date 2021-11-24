count=0
mypath=$1

for (( c=100; c<=500; c++ ))
do
    cat template/parameterPbPbWide|sed "s/xxxx/$c/g">parameters/YenJie_PbPbWide_$c.dat
    ./pyquen.sh parameters/YenJie_PbPbWide_$c.dat output/PbPbWide_$c.pyquen output/PbPbWide_$c.pu14>& logs/YenJie_PbPbWide_$c.log &
    let count+=1
    [[ $((count%3)) -eq 0 ]] && wait
done
