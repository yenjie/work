count=0
mypath=$1

for (( c=0; c<=100; c++ ))
do
    cat template/parameterPbPb_0_10|sed "s/xxxx/$c/g">parameters/YenJie_PbPb_0_10_$c.dat
    ./pyquenZJet.sh parameters/YenJie_PbPb_0_10_$c.dat output/PbPb_0_10_$c.pyquen output/PbPb_0_10ZJet_$c.pu14>& logs/YenJie_PbPb_0_10_$c.log &
    let count+=1
    [[ $((count%15)) -eq 0 ]] && wait
done
