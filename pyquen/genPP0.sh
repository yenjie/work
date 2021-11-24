count=0
mypath=$1
d=pp0
for (( c=101; c<=1000; c++ ))
do
    cat template/parameterPP0|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_pp0_$c.dat
    ./pyquen.sh parameters/YenJie_pp0_$c.dat $d/pp_$c.pyquen $d/pp_$c.pu14>& logs/YenJie_pp0_$c.log &
    let count+=1
    [[ $((count%15)) -eq 0 ]] && wait
done
