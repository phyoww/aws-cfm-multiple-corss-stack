#!/bin/bash
python3 list-stack.py > list.txt
sleep 10

for list in $(cat list.txt);
 do aws cloudformation delete-stack --stack-name $list;
 sleep 10;
done

