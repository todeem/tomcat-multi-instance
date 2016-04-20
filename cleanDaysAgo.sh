#!/bin/bash
 #
# 
#  Author todeem
#  Blog   http://kinggoo.com
# 
 #

if [ "$1" -lt 0 ] 2>/dev/null ;then 
	
	exit;
fi 
dayAgo=$1
cd `dirname $0`;
########### function #############
function __readINI() {
 INIFILE=$1;    SECTION=$2;     ITEM=$3
 _readIni=`awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$ITEM'/{print $2;exit}' $INIFILE`
echo ${_readIni}
}

########### end fun ############

_serviceName=( $( __readINI .config.ini SERVER_LIST S_LIST ) ) 
_tomcatHome=$( __readINI .config.ini TOMCATPATH T_PATH )
title=0

 for i in ${_serviceName[@]} ;do
  echo -e "${title}) - $i "
  
  ((title=$title+1))
 done
     
 echo -e "\n* 输入要清理的服务下的日志文件"
 echo -n "请输入服务序号：" && read c
  
 if [[ "$(echo $c | sed 's/[0-9]/1/g')" == "1"  && -n $c ]];then
  if [[ $c -lt ${#_serviceName[@]} ]];then
    find ${_tomcatHome}${_serviceName[$c]}/logs/ ! -name 'catalina.out' -type f -mtime +${dayAgo} -exec rm -fr {} \;
  sleep  5
  fi
 else
  break
 fi
echo -e "\n\n------------------------------------\nPowered by : http://www.kinggoo.com"
