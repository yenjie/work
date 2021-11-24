count=0
mypath=$1
d=PbPbWideQCDPhotonJet30
for (( c=6080; c<=10000; c++ ))
do
    cat template/parameterPbPbWide30|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_PbPbWide30__$c.dat
    ./pyquenPhotonJet.sh parameters/YenJie_PbPbWide30__$c.dat $d/PbPbWide_0_30_$c.pyquen $d/PbPbWide_0_30_$c.pu14>& logs/YenJie_PbPbWide30__$c.log &
    let count+=1
    [[ $((count%10)) -eq 0 ]] && wait
done