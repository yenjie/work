count=0
mypath=$1
d=ppQCDPhotonJet30
for (( c=4600; c<=10000; c++ ))
do
    cat template/parameterPP30|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_pp150_$c.dat
    ./pyquenPhotonJet.sh parameters/YenJie_pp150_$c.dat $d/pp_$c.pyquen $d/pp_$c.pu14>& logs/YenJie_pp150_$c.log &
    let count+=1
    [[ $((count%15)) -eq 0 ]] && wait
done
