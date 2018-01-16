#!/bin/bash

path=`pwd`
home=${path%/*}
git_config_path=$home/.gitconfig
ssh_config_path=$home/.ssh/config
#this code is modify asus c
flag=$(grep -n odm_* $ssh_config_path | cut -d ' ' -f 2 | tail -1 | awk -F '_' '{print $2}')
location=$(find -name "app-prebuilt" -type d)
project=$(ls $location | grep -n $1)
if [ x"$project" != x"" ];then
    if [ x"$1" == x"521" ];then
        sed -i "s/$flag/ZC521TL/g" $git_config_path
        sed -i "s/$flag/ZC521TL/g" $ssh_config_path
    elif [ x"$1" == x"520" ];then
        sed -i "s/$flag/ZC520TL/g" $git_config_path
        sed -i "s/$flag/ZC520TL/g" $ssh_config_path
    elif [ x"$1" == x"550" ];then
        sed -i "s/$flag/ZC550TL/g" $git_config_path
        sed -i "s/$flag/ZC550TL/g" $ssh_config_path
    elif [ x"$1" == x"500" ];then
        sed -i "s/$flag/ZB500TL/g" $git_config_path
        sed -i "s/$flag/ZB500TL/g" $ssh_config_path
    fi
    #do repo sync
    repo sync
    if [ $? == 0 ];then
        echo  -e "\033[40;32msync success \033[0m"
    else
        echo  -e "\033[40;31msync failed!please try again! \033[0m"
    fi
else
    echo  -e "\033[40;31mplease input correct project!!!! \033[0m"
fi


       
