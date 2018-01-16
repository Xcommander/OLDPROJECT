#!/bin/bash
PROJECT="E169F_PAC"
USER_NAME=`whoami`
OUT_PATH="/data/mine/test/$USER_NAME/"
OUT_INFO=
function go(){
	path="./device/ginreen/E169F/BoardConfig.mk"
	location=$(grep -n "WITH_DEXPREOPT :=*" $path | cut -d ":" -f 1)
	sort="WITH_DEXPREOPT := false"
	sed -i ''$location's/.*/'"$sort"'/' $path
}
function karl(){
	echo -e "\033[46;35m ***********************************开始编译***********************************\033[0m"
	go
	./quick_build.sh $PROJECT mmm $1
	#cresult=$?
	is_success=`grep -rsn "make failed to build some targets" ./build-log/mmm.log | awk -F ':' '{print $1}'`
	#echo $is_success
	if [ x$is_success == x"" ];then
	{
		result=$(grep "Install: out/target/*" ./build-log/mmm.log | head -1| awk -F ':' '{print $2}' )
		echo $result
		product=`echo $result| awk -F '/' '{print $4}'`
		#echo $tmp
		OUT_INFO=$(echo $result|awk -vFS=$product '{print $2}')
		#echo $result
		if [ x"$result" != x"" ];then
		{
			echo -e "\033[46;35m ***********************************编译成功***********************************\033[0m"
			apkname=${result##*/}
			echo -e "\033[42;33m 编译出来的文件为$apkname\033[0m"
			#压缩生成的信息--start
			echo $OUT_INFO >out.txt
			zip  out.txt.apk out.txt
			cp out.txt.apk $OUT_PATH
			#压缩生成的信息--end
			cp $result $OUT_PATH
			#| awk -F 'E169F' '{print $2}'
		}
		else
		{
			echo -e "\033[44;33m要编译的项目没有任何修改，请修改后再编译\033[0m"
		}
		fi
	}
	else
	{
		echo -e "\033[44;35m ***********************************编译失败***********************************\033[0m"
	}
	fi
	
}

karl $1