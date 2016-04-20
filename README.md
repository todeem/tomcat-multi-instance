# Tomcat-multi-instance
# # TOMCAT ��ʵ������ ��ܼ�����������ű���������Ƿ����߽ű��������鿴�����Ƿ���ڣ�

���Կ�ʹ�� sh -x ����
####
���ò���
--------------------------------------------
1��chmod +x run.sh checkTomcatService.cron
2) vim .config.ini
3) vim bin/startup.sh
4) vim bin/shutdown.sh
3) vim conf/server.xml
4) vim conf/context.xml
5) vim conf/web.xml
6) sh run.sh xxx start
7) vim checkTomcatService.cron ������� checkTomcatService.cron ������
8) **** ��ʵ�������logs�ļ�����Ҫ�Լ�ָ�� ln -s ��־��ʵ�洢·�� logs ����
####
�������ã�δ��˳���д��
--------------------------------------------
��Ҫ��bin�µ�startup.sh��shutdown.sh�ű�����java���������ͽ��ղ����ı�����JAVA������������ݸ���������װ������ã�

export JAVA_HOME=/usr/java/latest
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export CATALINA_BASE=$1
export CATALINA_HOME=$2
export JAVA_OPTS=$3
export SERVICE_NAME=$4

��ʹ������ķ�ʽֱ���� startup.sh��shutdown.sh �ļ������
_appendShell='export JAVA_HOME=/usr/java/latest; export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar; export CATALINA_BASE=$1; export CATALINA_HOME=$2;export JAVA_OPTS=$3;export SERVICE_NAME=$4;'
sed  -i "/\#\!\/bin\/sh/a ${_appendShell}" ${_tomcatPath}bin/startup.sh
sed  -i "/\#\!\/bin\/sh/a ${_appendShell}" ${_tomcatPath}bin/shutdown.sh


####
���ӳ����ÿ��޸�ʵ��conf�µģ�
--------------------------------------------
1��context.xml
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

2��web.xml
�����ڶ��п�ʼ����ڵ����ӳ���Ϣ �޸�res-ref-name������ֵΪcontext.xml�ļ��ڵ�name����ֵ
    <resource-ref>
            <description>Describe: Mysql db_pool_name </description>
            <res-ref-name>jdbc/db_pool_name</res-ref-name>
            <res-type>javax.sql.DataSource</res-type>
            <res-auth>Container</res-auth>
    </resource-ref>

    
####
�ű�ʹ�÷�����
--------------------------------------------
run.shƪ������ʹ�÷�ʽ��

1���Ե���ʵ����������|ֹͣ
    sh run.sh ʵ������ [start|stop]
    
2���������ڡ�.config.ini���ļ��ڵ�
    sh run.sh all [start|stop]
    
3����ʾ��ǰtomcatʵ������״̬��
    sh run.sh
    
####
.config.ini ˵����Linux��Ϊ�����ļ�����
--------------------------------------------
[TOMCATPATH]
### �鿴����ɾ����ע��
## T_PATH��Tomcat��װĿ¼
T_PATH = /opt/webserver/tomcat

## T_DATA����Ŀ���Ŀ¼ ,�Ǻ�����������Ȩ����ӵ�
T_DATA = /data/tomcat.data/

## T_LOGS: ��־���·�� ,�Ǻ�����������Ȩ����ӵ�
T_LOGS = /data/tomcat.log/

[SERVER_LIST]
## S_LIST��ֻ��������������ʵ��Ŀ¼�����ƺ�ִ��run.sh�Ż���ʾ��ִ������ֹͣ��Ӧ��ʵ��
S_LIST = pro.qq.s0303L pro.qq.s0302L

[T_VER]
## �������˽����õģ���ʾ���и���������йصĽ��̡�
T_VERSION = tomcat

[USER_INFO]
## T_USER��T_GROUP��tomcat�����û���
T_USER = nobody
T_GROUP = nobody

[FILTER]
## crond ����ű�ʹ�õĹ������� 
TOMCAT_FILTER = ClassLoaderLogManager

[MAIL]
## ���������ַ��������ÿո�ָ�
TOMAIL = XXX@XXX.COM XXX@DDD.COM


####
�޸�checkTomcatService.cron����ű�
--------------------------------------------
�޸Ľű��ڵ�tomcat��װĿ¼����
�����ִ��Ȩ�ޣ���������/var/spool/cron/�£��������޸�·����
echo  '*/1 * * * * /bin/bash /var/spool/cron/checkTomcatService.cron > /dev/null 2>&1' >> /var/spool/cron/root && service  crond restart


TOMCAT������ÿɲο���
http://kinggoo.com/app-tomcat-7057.htm
http://kinggoo.com/tomcat-serverconfig.htm