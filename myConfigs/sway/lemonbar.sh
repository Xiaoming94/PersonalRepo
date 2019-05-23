#!/bin/bash

segleftt='\UE0B0'
segleftl='\UE0B1'

segrightt='\UE0B2'
segrightl='\UE0B3'

python ./i3_workspace.py > "${i3ws}"

clock() {
    date +"%Y - %a %b %d ${segrightl} %H:%M:%S"
}
battery() {
    perc=$(cat /sys/class/power_supply/BAT0/capacity)
    stat=$(cat /sys/class/power_supply/BAT0/status)
    echo "BAT : ${perc}% $segrightl ${stat}"
}

cpu() {
    python ./cpu_info.py
}

mem(){
    used=$(free -m | grep Mem | awk '{printf "%.1f", $3/$2 * 100.0}')
    freem=$(echo "scale=1; 100 - $used" | bc -l)
    # mem=($(free -m | awk '/Mem:/ {print $2 "\n" $3}'))
   # totmem=${mem[1]}
   # usedmem=${mem[2]}
   # used=$(echo "scale=1; (100 * (${usedmem} / ${totmem}))" | bc)
   # freem=$(echo "scale=1; (100 - ${used})" | bc)
   # echo "RAM - free: $freem% ${segrightl} used: $used%"
    echo "RAM - used: $used%"

}

while true 
do
    BAR_INPUT="%{l}$(cat "${i3ws}") %{r} %{F#d81b60}$segrightt%{F#000000}%{B#d81b60} $(mem) %{F#ffd600}${segrightt}%{B#ffd600}%{F#000000}$(cpu) %{F#00bcd4}${segrightt}%{B#00bcd4}%{F#000000} $(battery) %{F#000000}${segrightt}%{B#000000}%{F-} $(clock) %{B-}"
    echo -e $BAR_INPUT
    sleep 0.5
done
