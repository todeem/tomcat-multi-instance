#!/bin/sh
 . /etc/init.d/functions
RETVAL=$?
# tomcat实例目录
temp1="`pwd`"
temp2=$(dirname `pwd`)
# 可选
opts=" -server -Xms4096m -Xmx4096m -XX:PermSize=256M -XX:MaxNewSize=256m -XX:MaxPermSize=256m "
servername=$(basename $temp1)
export JVM_OPTIONS
case "$1" in
start)
if [ -f $temp2/bin/startup.sh ];then
echo $"Start Tomcat"
sudo -u nobody $temp2/bin/startup.sh "$temp1" "$temp2" "$opts" "$servername"
fi
;;
stop)
if [ -f $temp2/bin/shutdown.sh ];then
echo $"Stop Tomcat"
sudo -u nobody $temp2/bin/shutdown.sh "$temp1" "$temp2"
echo  $temp2
fi
;;
*)
echo $"Usage: $0 {start|stop}"
exit 1
;;
esac
#exit $RETVAL

