#! /bin/bash
#while
i=0
s=0
while [ "$i" != "100" ]
do
i=$(($i+1))
s=$(($s+i))
done
echo "$s"
