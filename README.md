# Tomcat-multi-instance
>TOMCAT ��ʵ������ ��ܼ�����������ű���������Ƿ����߽ű��������鿴�����Ƿ���ڣ�

* ���Կ�ʹ�� sh -x ����

### ���ò���
 1) chmod +x   ` run.sh ` ` checkTomcatService.cron `  
 2) vim `.config.ini`   
 3) vim `bin/startup.sh`    
 4) vim `bin/shutdown.sh`    
 5) vim `conf/server.xml`   
 6) vim `conf/context.xml`      
 7) vim `conf/web.xml`    
 8) sh `run.sh` xxx start     
 9) vim `checkTomcatService.cron` ������� `checkTomcatService.cron` ������    
 10) ��ʵ�������`logs`�ļ�����Ҫ�Լ�ָ�� **ln -s `��־��ʵ�洢·��` `logs`** ����    

[TOC]
## ���ýű�Ȩ��
>��Ҫ��**bin**�µ�`startup.sh`��`shutdown.sh`�ű�����**java��������**��**���ղ����ı���**��JAVA������������ݸ���������װ������ã�
```shell
export JAVA_HOME=/usr/java/latest
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export CATALINA_BASE=$1
export CATALINA_HOME=$2
export JAVA_OPTS=$3
export SERVICE_NAME=$4
```
*��ʹ������ķ�ʽֱ���� `startup.sh`��`shutdown.sh` �ļ������
```shell
_appendShell='export JAVA_HOME=/usr/java/latest; export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar; export CATALINA_BASE=$1; export CATALINA_HOME=$2;export JAVA_OPTS=$3;export SERVICE_NAME=$4;';
sed  -i "/\#\!\/bin\/sh/a ${_appendShell}" ${_tomcatPath}bin/startup.sh;
sed  -i "/\#\!\/bin\/sh/a ${_appendShell}" ${_tomcatPath}bin/shutdown.sh;
```

## ����tomcat
**���ӳ����ã�**  
1���༭�ļ�**context.xml**
```xml
    <Resource 
        name="jdbc/db_pool_name"
        auth="Container"
        type="javax.sql.DataSource"
        driverClassName="com.mysql.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/dbname?useUnicode=true&amp;autoReconnect=true&amp;characterEncoding=UTF-8"
        username="db_username"
        password="db_password"
        maxActive="3000"
        maxIdle="3000"
        maxWait="10000"
        timeBetweenEvictionRunsMillis="2860000"
        minEvictableIdleTimeMillis="2200000"
    />
```
2���༭�ļ�**web.xml**
>�����ڶ��п�ʼ����ڵ����ӳ���Ϣ �޸�res-ref-name������ֵΪcontext.xml�ļ��ڵ�name����ֵ
```xml
    <resource-ref>
            <description>Describe: Mysql db_pool_name </description>
            <res-ref-name>jdbc/db_pool_name</res-ref-name>
            <res-type>javax.sql.DataSource</res-type>
            <res-auth>Container</res-auth>
    </resource-ref>
```


    
## run.sh�ű�ʹ�÷�����
**run.shƪ������ʹ�÷�ʽ��**
**1���Ե���ʵ����������|ֹͣ**
```shell
    sh run.sh ʵ������ [start|stop]
```    
**2���������ڡ�.config.ini���ļ��ڵ�**
```shell
    sh run.sh all [start|stop]
```
**3����ʾ��ǰtomcatʵ������״̬**
```shell
    sh run.sh
``` 
## .config.ini ˵��
` �鿴������.config.ini�ļ���ɾ����ע�� `
>��.config.ini��linux��Ϊ�����ļ���
```
[TOMCATPATH]   
T_PATH = Tomcat��װĿ¼
T_DATA = ��Ŀ���Ŀ¼ ,�Ǻ�����������Ȩ����ӵ� 
T_LOGS = ��־���·�� ,�Ǻ�����������Ȩ����ӵ� 

[SERVER_LIST]     
S_LIST =  ֻ��������������ʵ��Ŀ¼�����ƺ�ִ��run.sh�Ż���ʾ��ִ������ֹͣ��Ӧ��ʵ�� [����S_LIST = pro.qq.s0303L pro.qq.s0302L ]

[T_VER]    
T_VERSION = �������˽����õģ���ʾ���и���������йصĽ��̡������������ʱtomcat��װĿ¼��ʲô������tomcat��ֱ��дtomcat���� [����tomcat] 

[USER_INFO]     
T_USER = tomcat�����û� [����nobody] 
T_GROUP = tomcat�����û������� [����nobody] 

[FILTER]     
TOMCAT_FILTER = ����(crond)�ű�ʹ�õĹ�������[����ClassLoaderLogManager]  

[MAIL]     
## ���������ַ��������ÿո�ָ�     
TOMAIL = ���������ַ��������ÿո�ָ� [����XXX@XXX.COM XXX@DDD.COM]
```

## �޸�checkTomcatService.cron����ű�

�޸Ľű��ڵ�tomcat��װĿ¼����   
�����ִ��Ȩ�ޣ���������/var/spool/cron/�£��������޸�·����    
```shell
echo  '*/1 * * * * /bin/bash /var/spool/cron/checkTomcatService.cron > /dev/null 2>&1' >> /var/spool/cron/root && service  crond restart
```

## TOMCAT������ÿɲο���
* [tomcat��������ʵ��������޷�������Ŀ�Ĵ���](http://kinggoo.com/app-tomcat-7057.htm)   
* [��תTomcat��������](http://kinggoo.com/tomcat-serverconfig.htm)