count=0
mypath=$1

for (( c=0; c<=100; c++ ))
do
    cat template/parameterPbPb|sed "s/xxxx/$c/g">parameters/YenJie_PbPb_$c.dat
    ./pyquen.sh parameters/YenJie_PbPb_$c.dat output/PbPb_$c.pyquen output/PbPb_$c.pu14>& logs/YenJie_PbPb_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done
