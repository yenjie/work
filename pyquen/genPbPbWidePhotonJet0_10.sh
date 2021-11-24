count=0
mypath=$1
d=PbPbWidePhotonJet150_0_10
for (( c=101; c<=1000; c++ ))
do
    cat template/parameterPbPbWide150_0_10|sed "s/xxxx/$c/g"|sed "s/yyyy/$d/g">parameters/YenJie_PbPbWide150_0_10_$c.dat
    ./pyquenPromptPhotonJet.sh parameters/YenJie_PbPbWide150_0_10_$c.dat $d/PbPbWide_0_10_$c.pyquen $d/PbPbWide_0_10_$c.pu14>& logs/YenJie_PbPbWide150_0_10_$c.log &
    let count+=1
    [[ $((count%5)) -eq 0 ]] && wait
done