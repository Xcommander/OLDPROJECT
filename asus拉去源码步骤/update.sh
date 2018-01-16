#!/bin/bash  
function echo_greeen(){
echo -e "\033[40;32m$1 \033[0m"
}  
echo_greeen  "========================start repo sync========================"    
repoc sync  
while [ $? != 0 ]; do    
echo_greeen "========================sync failed, re-sync again========================"    
sleep 3    
repoc sync  
done
echo_greeen  "========================repo sync success========================"    
