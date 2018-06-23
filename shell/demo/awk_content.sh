#!/bin/bash
ip='192.168.1.1';export ip;
pwd
f='file.txt'
cat $f
#$(awk -v vars="$ip" '$1~/wang/{$2=vars}1' $f 1<>$f)
$(awk '$1~/wang/{$2=ENVIRON["ip"]}1' $f 1<>$f)
cat $f
