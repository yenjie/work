count=0
mypath=$1
d=pp80
for (( c=501; c<=2000; c++ ))
do
    cat template/parameterPP80|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_pp80_$c.dat
    ./pyquen.sh parameters/YenJie_pp80_$c.dat $d/pp_$c.pyquen $d/pp_$c.pu14>& logs/YenJie_pp80_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done
