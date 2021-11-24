count=0
mypath=$1
d=ppZJet80
for (( c=1; c<=100; c++ ))
do
    cat template/parameterPP80|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_pp80_$c.dat
    ./pyquenZJet.sh parameters/YenJie_pp80_$c.dat $d/pp_$c.pyquen $d/pp_$c.pu14>& logs/YenJie_pp80_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done
