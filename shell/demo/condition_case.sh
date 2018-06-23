#! /bin/bash
#grade
read -p "请输入你的分数:" grade
case $grade in
[1-3])
echo "your grade is D"
;;
[4-6])
echo "your grade is C"
;;
[7-9])
echo "your grade is B"
;;
*)
echo "your grade is A"
;;
esac
