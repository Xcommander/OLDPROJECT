#!/bin/sh


# cpfiles [APK name] [FILE]...
function cpfiles() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: cpfiles [APK name] [FILE]..."
		echo "eg. cpfiles Contacts packages/apps/Contacts packages/apps/ContactsCommon"
        return
    fi
    uid_name=`whoami`
    cur_time=`date +%m%d-%H%M%S`
    file_name=$1
    file_list=""
    shift 1
    for file in $@; do
        file_list=$file_list" "$file
    done
    echo "please wait..."
    tar -czvf $file_name.$cur_time.tar.gz $file_list --exclude='.git'
    zip $file_name.$cur_time.apk $file_name.$cur_time.tar.gz
    rm -rf $file_name.$cur_time.tar.gz
    cp $file_name.$cur_time.apk /data/mine/test/$uid_name/
    rm -rf $file_name.$cur_time.apk
    echo "done"
}

# cpex 
function cpex() {
    uid_name=`whoami`
	home_path=`cat /etc/passwd | grep $uid_name | awk -F ":" '{print $6}'`
	zip -qj Stk.apk $home_path/exchange.txt
    cp Stk.apk /data/mine/test/$uid_name/
    rm -rf Stk.apk
    echo "done"
}

# signapk [APK FILE]...
function signapk() {
    sign_tool=out/host/linux-x86/framework/signapk.jar
    sign_key1=device/mediatek/common/security/E281L/platform.x509.pem
    sign_key2=device/mediatek/common/security/E281L/platform.pk8
    echo "please wait..."
	for file in $@; do
        apk_name=$(echo $file | sed -r 's/\.apk$//i')
        java -jar $sign_tool $sign_key1 $sign_key2 $file ${apk_name}_signed.apk
        echo "sign $file to ${apk_name}_signed.apk done"
    done
    echo "All done."	
}

# verifysign [APK FILE]
function verifysign() {
	jarsigner -verify -verbose -certs $1
}

# sgrep [PATH] [WORD]
function sgrep()
{
	find $1 -name .repo -prune -o -name .git -prune -o  -type f -iregex '.*\.\(c\|h\|cc\|cpp\|S\|java\|xml\|sh\|mk\|aidl\)' -print0 | xargs -0 grep --color -n "$2"
}

# ggrep [PATH] [WORD]
function ggrep()
{
    find $1 -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f -name "*\.gradle" -print0 | xargs -0 grep --color -n "$2"
}

# jgrep [PATH] [WORD]
function jgrep()
{
    find $1 -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f -name "*\.java" -print0 | xargs -0 grep --color -n "$2"
}

# cgrep [PATH] [WORD]
function cgrep()
{
    find $1 -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \) -print0 | xargs -0 grep --color -n "$2"
}

# resgrep [PATH] [WORD]
function resgrep()
{
    for dir in `find $1 -name .repo -prune -o -name .git -prune -o -name out -prune -o -name res -type d`; do find $dir -type f -name '*\.xml' -print0 | xargs -0 grep --color -n "$2"; done;
}

# mangrep [PATH] [WORD]
function mangrep()
{
    find $1 -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -type f -name 'AndroidManifest.xml' -print0 | xargs -0 grep --color -n "$2"
}

# sepgrep [PATH] [WORD]
function sepgrep()
{
    find $1 -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -name sepolicy -type d -print0 | xargs -0 grep --color -n -r --exclude-dir=\.git "$2"
}

# rcgrep [PATH] [WORD]
function rcgrep()
{
    find $1 -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f -name "*\.rc*" -print0 | xargs -0 grep --color -n "$2"
}
