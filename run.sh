#!/bin/bash
 #
# #
# #
# #
# #
# #
 #
cd `dirname $0`;
########### function #############
function __readINI() {
 INIFILE=$1;    SECTION=$2;     ITEM=$3
 _readIni=`awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$ITEM'/{print $2;exit}' $INIFILE`
echo ${_readIni}
}

function __permission(){
   userGroup=$1
   _tomcatData=$2
   _tomcat_Home=$3
   chown -R ${userGroup} ${_tomcatData}
   chown -R ${userGroup} ${_tomcat_Home}
}

function __runStatus() {
 _num=$1;  _serviceFileName=$2 
 if (( $_num==0 ));then
  __permission "${_tomcatUser}:${_tomcatGroup}" "${_tomcatDATA}" "${_tomcatHome}/${_serviceFileName}"
  cd ${_serviceFileName}
  sh tomcat.sh start > /dev/null 
  cd -
 elif (( ${_num}==1 ));then
  cd ${_serviceFileName}
  sh tomcat.sh stop > /dev/null && rm -fr ./work/*
  cd -
 else
  break
 fi
}

function __port(){
# input 
# return  port array
_serviceName="$1/conf/server.xml"

if [[ -e ${_serviceName} ]];then
echo $(grep -o -P -i 'port=\"(.*)\"\ {0,}protocol=\"HTTP' ${_serviceName} | tr -d "a-zA-Z=\"") 
else
 break
fi

}
#


########### end fun ############

declare -a arr
_serviceName=( $( __readINI .config.ini SERVER_LIST S_LIST ) ) 
_tomcatVersion=$( __readINI .config.ini T_VER T_VERSION ) 
_tomcatUser=$( __readINI .config.ini USER_INFO T_USER )
_tomcatGroup=$( __readINI .config.ini USER_INFO T_GROUP )
_tomcatHome=$( __readINI .config.ini TOMCATPATH T_PATH )
_tomcatDATA=$( __readINI .config.ini TOMCATPATH T_DATA )
_tomcatLog=$( __readINI .config.ini TOMCATPATH T_LOGS )

# server all start/stop
if [[ -n $1 ||  $1 == "all" ]];then
 if [[ $2 == "start" ]];then
  m=0;
 elif [[ $2 == "stop" ]];then
  m=1;
 else
  break
 fi
 echo ${_serviceName[@]} |grep -P -o -i " $1 " >/dev/null && _go=1 || _go=0 
 if [[ $1 == "all" && ${_go} -eq 0 ]];then
    for (( i=0;$i<${#_serviceName[@]};i++ ));do
        __runStatus $m ${_serviceName[$i]} 
    done 
 elif [[ ${_go} -eq 1 ]];then
  __runStatus $m $1
 fi

else

while true
do
clear
_description="使用方法：\n  sh run.sh all [start|stop]\n 或：\n  sh run.sh 实例名称 [start|stop] \n 或：\n  sh run.sh"
_len=$(echo ${_description}|wc -c)/3
for (( _t=0;${_t}<=${_len};_t++))
do
 F=${F}"-"
done
echo $F
echo -e ${_description}
echo $F
echo -e "\n--  本地Tomcat启动/关闭情况  --\n"
 _psTomcat=`ps -fe |grep  "${_tomcatVersion}"`
 count=0
 i=""
 for i in ${_serviceName[@]} ;do
  arr[$count]=0
  y="1"
  _status="\033[3${y}m stop  \033[0m"
   if [[ $(pgrep -f "$i") > 0 &&  $(echo ${_psTomcat}|grep -o -E "$i" |wc -l) > 0  ]];then
        y="6"
        _status="\033[3${y}m start \033[0m"   
        arr[$count]=1
   fi
  echo -e "${count}) - [ ${_status} ] - \033[3${y}m $i \033[0m [tomcat.port: $(__port $i) ]"
  
  ((count=$count+1))
 done
     
 echo -e "\n* 输入服务前的序号后，会将此序号对应服务状态置为相反状态"
 echo -n "请输入服务序号：" && read c
  
 if [[ "$(echo $c | sed 's/[0-9]/1/g')" == "1"  && -n $c ]];then
  if [[ $c -lt ${#_serviceName[@]} ]];then
  __runStatus ${arr[$c]} ${_serviceName[$c]}
  sleep  5
  fi
 else
  break
 fi
done
fi
echo -e "\n\n------------------------------------\nPowered by : http://www.kinggoo.com"
