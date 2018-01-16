#!/bin/bash
common_path="frameworks packages"
root_path=`pwd`
wind_path="$root_path/wind/custom_files/"
complete -F git_status_tab -A file git_status
complete -F git_add_tab -A file git_add
function current_error(){
if [ x"$1" == x"git_status" ];then
    echo -e "\033[40;31m ******************** 请输入-a,或者-d选项 ********************\033[0m"
    git_status_help
elif [ x"$1" == x"git_add" ];then
    echo -e "\033[40;32m ******************** 请输入-d选项或者不使用任何参数 **********\033[0m" 
    git_add_help
fi
}
function git_status_tab() {
local cur prev opts search
COMPREPLY=()
cur="${COMP_WORDS[COMP_CWORD]}"
prev="${COMP_WORDS[COMP_CWORD-1]}"
opts="-a -d --help"
search=""
if [[ ${cur} == -* ]]; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
fi
for((i=COMP_CWORD;i>=0;i--))
    do
        search="${COMP_WORDS[i]}"
        case $search in
            -d|-a|--help)
            COMPREPLY=()
            ;;
        esac
    done
}
function git_add_tab() {
local cur prev opts search
COMPREPLY=()
cur="${COMP_WORDS[COMP_CWORD]}"
prev="${COMP_WORDS[COMP_CWORD-1]}"
opts="-d --help"
search=""
if [[ ${cur} == -* ]]; then
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
fi
for((i=COMP_CWORD;i>=0;i--))
    do
        search="${COMP_WORDS[i]}"
        case $search in
            -d|--help)
            COMPREPLY=()
            ;;
        esac
    done
}
#下面是功能帮助说明
function git_status_help(){
echo -e "\033[40;36m **************************************************************************** \033[0m"
echo -e "\033[40;36m *                          git_status 用法                                 * \033[0m"
echo -e "\033[40;36m *                     git_status -a|-d codepath                            * \033[0m"
echo -e "\033[40;36m *         -a选项是在原来的配置搜索路径添加自己的路径（codepath）,          * \033[0m"
echo -e "\033[40;36m *         -d选项是把原来的配置搜索路径替换成自己的路径（codepath）.        * \033[0m"
echo -e "\033[40;36m **************************************************************************** \033[0m"
}
function git_add_help(){
echo -e "\033[40;36m **************************************************************************** \033[0m"
echo -e "\033[40;36m *                          git_add用法                                     * \033[0m"
echo -e "\033[40;36m *                git_add 或者git_add -d cleancodepath                      * \033[0m"
echo -e "\033[40;36m *         git_add不加任何参数，表示使用默认配置提交代码路径                * \033[0m"
echo -e "\033[40;36m *         git_add -d cleancodepath表示使用cleancodepath路径来作为提交路径  * \033[0m"
echo -e "\033[40;36m **************************************************************************** \033[0m"
}
function git_status(){
replace_flag=0
add_flag=0
status_path=""
status_flag=1
case $1 in
    -a)
    if [ x"$2" != x ] && [  -d $2 ];then
        add_flag=1
    else
    status_flag=0
    echo_error "请输入路径！"
    fi
    ;;
    -d)
    if [ x"$2" != x ] && [  -d $2 ];then
        replace_flag=1
    else
    status_flag=0
    echo_error "请输入路径！"
    fi
    ;;
    --help)
    git_status_help
    status_flag=0
    ;;
    *)
    current_error "git_status"
    status_flag=0
    ;;
esac
if [ x"$2" != x ] && [ "$2" == "." -o "$2" == "./" ];then
 echo_error "请不要使用./或者.作为查找目录，输入具体目录"
 return 0
fi
if [ $status_flag -eq 1 ];then
    if [  -f $root_path/.commit_path ];then
        > $root_path/.commit_path
    else
        touch $root_path/.commit_path
    fi
        
    if [ $replace_flag == 1 ] && [ $add_flag == 1 ];then
        echo "error!"
        status_flag=0
    fi
    if [ $replace_flag != 0 ] || [ $add_flag != 0 ];then
        case 1 in
            $replace_flag)
            status_path=$2
            ;;
        $add_flag)
            status_path=$common_path" "$2
            ;;
            *)
            ;;
        esac
    else
        status_path=$common_path
    fi
    home_path=$(pwd)
    
    for temp_path in $status_path
        do
            if [ -d $home_path/$temp_path ];then 
                get_gitpath $temp_path
                result=$?
                if [ $result -ne 0 ];then
                    i=0;
                    for tmp_path in $gitpath_list
                        do
                            get_commit $tmp_path #开始对比
                        done
                elif [ $result == 0 ];then
                    get_commit $temp_path
                fi
            else
                echo "$temp_path 路径不存在！"
                break
            fi
        done
        if [ -s $root_path/.commit_path ];then
            commit_path_opt
            parse_commit_file
            echo_commit "下面使用git_add 来进行提交"
        else
            echo_error "根目录未检测到相应需要提交的修改，可能已经完成提交，请尝试到wind下检查"
        fi
fi        
}
#去除commit_path文件中重复的文件,此功能还没做好，暂且不做处理
function commit_path_opt(){
if [ -s $root_path/.commit_path_tmp  ];then
    > $root_path/.commit_path_tmp
fi
num_array=""
while read line
    do
        for opt_tmp in $line
            do
                if [[ $opt_tmp =~ file_dir ]];then
                    opt_tmp_one=$(echo $opt_tmp | awk -F "=" '{print $2}')
                elif [[ $opt_tmp =~ mofity_file ]];then
                    opt_tmp_two=$(echo $opt_tmp | awk -F "=" '{print $2}')
                    opt_tmp_path=$opt_tmp_one"/"$opt_tmp_two
                    echo $opt_tmp_path"|"$line >> $root_path/.commit_path_tmp
                fi
               
            done
    done < $root_path/.commit_path
#排序优化,再去掉重复部分，这点理解最为关键。利用awk逐行读入的特点，类似于冒泡排序法，去掉重复的部分
sort -k2n $root_path/.commit_path_tmp | awk -F "|" '{ if($1!=line) print $2;line=$1}' | tee $root_path/.commit_path &> /dev/null
}
function get_gitpath(){
if [ $# == 1 ];then 
    gitpath_list=$(find $1/ -name ".git" -type d | awk -F ".git" '{ print $1}')
    if [ x"$gitpath_list" != x"" ];then
        cel_flag=0
        for cel_gitpath in $gitpath_list
            do
                if [ x"$cel_gitpath" != x ];then
                    let cel_flag=cel_flag+1
                fi
            done
        return $cel_flag
    else
        return 0
    fi
else
    return 0
fi
}
function get_commit(){
new_file_list=""
modify_file_list=""
cd $1
srcfile=$root_path/.git_path
git status -s . > $srcfile
if [ -s $srcfile ];then
    while  read line
        do 
            commit_tmp=""
            modify_tmp=""
            new_tmp=""
            commit_tmp=$(echo $line | awk '{print substr($0,1,2)}')
            if [ -n "$commit_tmp" ];then
                if [ "$commit_tmp" == "M " ];then
                    modify_tmp=$(echo $line | awk -F "$commit_tmp" '{print $2}')
                    modify_file_list=$modify_file_list" "$modify_tmp
                elif [ "$commit_tmp" == "??" ];then
                    new_tmp=$(echo $line | awk -F "$commit_tmp " '{print $2}')
                    new_file_list=$new_file_list" "$new_tmp
                fi
             fi
        done < $root_path/.git_path
        compare_file
    rm -rf $srcfile
fi
cd - > /dev/null
}
function compare_file(){
now_path=`pwd`
compare_middle_file=$(echo $now_path | awk -F "$root_path/" '{print $2}' )
#根目录修改文件
if [ x"$modify_file_list" != x"" ];then
        compare_list=$modify_file_list
        for compare_tmp in $compare_list
            do
                wind_file_tmp="$wind_path$compare_middle_file/$compare_tmp"
                if [ -f $wind_file_tmp ];then
                    diff $compare_tmp $wind_file_tmp > /dev/null
                    if [  $? -ne 0 ];then
                        echo "file_dir=$compare_middle_file mofity_file=$compare_tmp file_flag=mm file_type=file" >> $root_path/.commit_path
                    fi
                else
                    echo "file_dir=$compare_middle_file mofity_file=$compare_tmp file_flag=mn file_type=file" >> $root_path/.commit_path
                fi
            done
fi
if [ x"new_file_list" != x"" ];then
    compare_list=$new_file_list
    for compare_tmp in $compare_list
        do
            if [ -f $compare_tmp ];then
                wind_file_tmp="$wind_path$compare_middle_file/$compare_tmp"
                if [ -f $wind_file_tmp ];then
                    diff $compare_tmp $wind_file_tmp > /dev/null
                    if [ $? -ne 0 ];then
                        echo "file_dir=$compare_middle_file mofity_file=$compare_tmp file_flag=nm file_type=file" >> $root_path/.commit_path
                    fi
                else
                    echo "file_dir=$compare_middle_file mofity_file=$compare_tmp file_flag=nn file_type=file" >> $root_path/.commit_path
                fi
            elif [ -d $compare_tmp ];then
                    wind_dir_tmp="$wind_path$compare_middle_file/$compare_tmp"
                    if [ -d $wind_dir_tmp ];then
                        root_wind_middle_tmp="$wind_path$compare_middle_file"
                        compare_root_wind $compare_tmp
                    else
                        echo "file_dir=$compare_middle_file mofity_file=$compare_tmp file_flag=nn file_type=dir" >> $root_path/.commit_path
                    fi
                fi
        done
fi
}
function compare_root_wind(){
source_tmp=$1
source=${source_tmp%?}
diff_root_wind=""
for compare_tmp_rw in $source/*
    do
        if [ -d $compare_tmp_rw ];then
            compare_root_wind $compare_tmp_rw"/"
        elif [ -f $compare_tmp_rw ];then
            diff_root_wind="$root_wind_middle_tmp/$compare_tmp_rw"
            if [ -f $diff_root_wind ];then
                diff $compare_tmp_rw $diff_root_wind > /dev/null
                if [ $? -ne 0 ];then
                    echo "file_dir=$compare_middle_file mofity_file=$compare_tmp_rw file_flag=nm file_type=file" >> $root_path/.commit_path
                fi
            else
                echo "file_dir=$compare_middle_file mofity_file=$compare_tmp_rw file_flag=nn file_type=file" >> $root_path/.commit_path
            fi
        fi
    done
}
function parse_commit_file(){
if [ -f $root_path/.commit_path ];then
    dir_flag=""
    for parse_line in `cat $root_path/.commit_path`
        do
            if [ x"$parse_line" != x ];then
                #解析每一行
                for file_string in $parse_line
                    do
                        if [[ $file_string =~ file_dir ]];then
                            parse_dir_tmp=$(echo $file_string | awk -F "=" '{print $2}')
                            if [ x"$dir_flag" != x"$parse_dir_tmp" ];then
                                dir_flag=$parse_dir_tmp
                                echo_commit "----------修改的模块为:$dir_flag----------"
                            fi
                        elif [[ $file_string =~ mofity_file ]];then
                            parse_modify_file=$(echo $file_string | awk -F "=" '{print $2}')
                            parse_modify_add_patch="$dir_flag/$parse_modify_file"
                        elif [[ $file_string =~ file_flag ]];then
                            parse_flag=$(echo $file_string | awk -F "=" '{print $2}')
                            if [[ $parse_flag =~ mm|nm ]];then
                                echo_commit "$parse_modify_add_patch ------------------修改"
                            elif [[ $parse_flag =~ mn|nn ]];then
                                echo_commit "$parse_modify_add_patch ------------------新增"
                            fi
                        fi
                    done
                fi
        done
fi
}
#仅仅是为了显示作用
function echo_error(){
echo -e "\033[40;31m ***************************************$1*********************************** \033[0m"
}
function echo_commit(){
echo -e "\033[40;32m $1 \033[0m"
}
#将wind下没有的，但是根目录修改的文件，在wind下进行提交
function git_add(){
clean_code_flag=0
git_add_flag=0
if [ $# == 1 ];then
    case $1 in
        -d)
        echo_error "请输入你配置的提交代码文件名，例如cleancode!"
        ;;
        --help)
        git_add_help
        ;;
        *)
        echo_error "请输入正确选项，您可以使用--help来查看相关使用方法"
        ;;
    esac
elif [ $# == 2 ];then
    case $1 in
        -d)
        clean_code_flag=1
        git_add_flag=1
        clean_code_path=$root_path/.$2
        if [ ! -d $clean_code_path ];then
            mkdir $clean_code_path
        else
            cd $clean_code_path  > /dev/null
            rm -rf *
            cd - > /dev/null
        fi
        ;;
        *)
        echo_error "请输入正确选项，您可以使用--help来查看相关使用方法"
        ;;
    esac
elif [ $# == 0 ];then
    clean_code_flag=1
    git_add_flag=1
    clean_code_path=$root_path/.cleancode
    if [ ! -d $clean_code_path ];then
        mkdir $clean_code_path
    else
        cd $clean_code_path > /dev/null
        rm -rf *
        cd - > /dev/null
    fi
else
    echo_error "请输入正确选项，您可以使用--help来查看相关使用方法"
fi
if [ $clean_code_flag -ne 1 ] || [ ! -f $root_path/.commit_path ] || [ $git_add_flag -eq 0 ] ;then
    if [ $git_add_flag -eq 0 ];then
        #do nothing
        echo "" > /dev/null
    elif [ ! -f $root_path/.commit_path ];then
        echo_commit "似乎根目录没什么要提交的，请尝试使用git_status -a/-d 来获取提交列表！"
    elif [ $clean_code_flag -eq 0 ];then
        current_error "git_add"
    fi
    if [ -d $clean_code_path ];then
        rm -rf $clean_code_path
    fi
    
else
    wind_no_source_code=""
    for git_add_line in `cat $root_path/.commit_path`
        do
            for git_add_string in $git_add_line
                do
                    case $git_add_string in 
                        file_dir*)
                        git_add_module=$(echo $git_add_string | cut -d "=" -f 2)
                        ;;
                        mofity_file*)
                        git_add_modify=$(echo $git_add_string | cut -d "=" -f 2)
                        ;;
                        file_flag*)
                        git_add_module_flag=$(echo $git_add_string | cut -d "=" -f 2)
                        git_add_file_tmp=$git_add_module"/"$git_add_modify
                        if [ x$git_add_module_flag = x"mn" ];then
                            cp --parents $git_add_file_tmp $clean_code_path
                            cd $git_add_module
                            git checkout $git_add_modify
                            cd - > /dev/null
                            cp --parents $git_add_file_tmp $wind_path
                            
                            if [ x"$wind_no_source_code" == x ];then
                                wind_no_source_code=$wind_path$git_add_file_tmp
                            else
                                wind_no_source_code=$wind_no_source_code" "$wind_path$git_add_file_tmp
                            fi
                            cp $clean_code_path"/"$git_add_file_tmp $git_add_file_tmp
                        fi
                        ;;
                        *)
                        ;;
                    esac
                done
                
        done            
        if [ x"$wind_no_source_code" != x ];then
            cd wind/
            for git_add_wind_no_source in $wind_no_source_code
                do
                    git add $git_add_wind_no_source
                done
            git commit -m "just add"
            cd - > /dev/null
        fi
    for git_add_line in `cat $root_path/.commit_path`
        do
            for git_add_string in $git_add_line
                do
                    case $git_add_string in 
                        file_dir*)
                        git_add_module=$(echo $git_add_string | cut -d "=" -f 2)
                        ;;
                        mofity_file*)
                        git_add_modify=$(echo $git_add_string | cut -d "=" -f 2)
                        ;;
                        file_type*)
                        git_add_file_tmp=$git_add_module"/"$git_add_modify
                        git_add_type=$(echo $git_add_string | cut -d "=" -f 2)
                        if [ x"$git_add_type" == x"dir" ];then
                            git_add_foreach_list=$(find $git_add_file_tmp -type f)
                            for git_add_foreach_line in $git_add_foreach_list
                                do
                                    cp --parents $git_add_foreach_list $wind_path
                                done
                        else
                            cp --parents $git_add_file_tmp $wind_path
                        fi
                        ;;
                        *)
                        ;;
                    esac
                done
                
        done   
        
        cd_flag=0
        if [ -s $root_path/.commit_path ];then
            cd $root_path/wind/
            cd_flag=1
        fi
        if [ -f $root_path/.commit_path ];then
            rm $root_path/.commit_path
        fi
        rm -rf $clean_code_path

        if [ $cd_flag -eq 1 ];then
            git status .
        else
            echo_error "未检测到根目录有需要提交的,可能没有修改或者已经在wind目录修改完成,请尝试在wind目录下使用 git status ."
        fi
        
fi
}
