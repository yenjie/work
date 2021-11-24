count=0
mypath=$1
d=PbPbWidePhotonJet30_0_30
for (( c=300; c<=500; c++ ))
do
    cat template/parameterPbPbWide30_0_30|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_PbPbWide30_0_30_$c.dat
    ./pyquenPhotonJet.sh parameters/YenJie_PbPbWide30_0_30_$c.dat $d/PbPbWide_0_30_$c.pyquen $d/PbPbWide_0_30_$c.pu14>& logs/YenJie_PbPbWide30_0_30_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done