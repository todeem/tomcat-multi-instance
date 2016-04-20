# Tomcat-multi-instance
# # TOMCAT 多实例部署 框架及多服务启动脚本与检测服务是否在线脚本（仅仅查看进程是否存在）

调试可使用 sh -x 参数
####
设置步骤
--------------------------------------------
1）chmod +x run.sh checkTomcatService.cron
2) vim .config.ini
3) vim bin/startup.sh
4) vim bin/shutdown.sh
3) vim conf/server.xml
4) vim conf/context.xml
5) vim conf/web.xml
6) sh run.sh xxx start
7) vim checkTomcatService.cron 并且添加 checkTomcatService.cron 到任务
8) **** 在实例下面的logs文件夹需要自己指定 ln -s 日志真实存储路径 logs 即可
####
具体配置，未按顺序编写：
--------------------------------------------
需要想bin下的startup.sh和shutdown.sh脚本增加java环境变量和接收参数的变量（JAVA环境变量请根据各自主机安装情况配置）

export JAVA_HOME=/usr/java/latest
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export CATALINA_BASE=$1
export CATALINA_HOME=$2
export JAVA_OPTS=$3
export SERVICE_NAME=$4

可使用下面的方式直接向 startup.sh和shutdown.sh 文件内添加
_appendShell='export JAVA_HOME=/usr/java/latest; export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar; export CATALINA_BASE=$1; export CATALINA_HOME=$2;export JAVA_OPTS=$3;export SERVICE_NAME=$4;'
sed  -i "/\#\!\/bin\/sh/a ${_appendShell}" ${_tomcatPath}bin/startup.sh
sed  -i "/\#\!\/bin\/sh/a ${_appendShell}" ${_tomcatPath}bin/shutdown.sh


####
连接池配置可修改实例conf下的：
--------------------------------------------
1）context.xml
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

2）web.xml
倒数第二行开始添加内的连接池信息 修改res-ref-name的属性值为context.xml文件内的name属性值
    <resource-ref>
            <description>Describe: Mysql db_pool_name </description>
            <res-ref-name>jdbc/db_pool_name</res-ref-name>
            <res-type>javax.sql.DataSource</res-type>
            <res-auth>Container</res-auth>
    </resource-ref>

    
####
脚本使用方法：
--------------------------------------------
run.sh篇，三种使用方式：

1）对单个实例进行启动|停止
    sh run.sh 实例名称 [start|stop]
    
2）对配置在“.config.ini”文件内的
    sh run.sh all [start|stop]
    
3）显示当前tomcat实例运行状态：
    sh run.sh
    
####
.config.ini 说明（Linux下为隐藏文件）：
--------------------------------------------
[TOMCATPATH]
### 查看后请删除掉注释
## T_PATH：Tomcat安装目录
T_PATH = /opt/webserver/tomcat

## T_DATA：项目存放目录 ,是后来用来设置权限添加的
T_DATA = /data/tomcat.data/

## T_LOGS: 日志存放路径 ,是后来用来设置权限添加的
T_LOGS = /data/tomcat.log/

[SERVER_LIST]
## S_LIST：只有在下面配置了实例目录的名称后，执行run.sh才会显示和执行启动停止对应的实例
S_LIST = pro.qq.s0303L pro.qq.s0302L

[T_VER]
## 用来过滤进程用的，显示所有跟这个配置有关的进程。
T_VERSION = tomcat

[USER_INFO]
## T_USER、T_GROUP：tomcat启动用户。
T_USER = nobody
T_GROUP = nobody

[FILTER]
## crond 任务脚本使用的过滤条件 
TOMCAT_FILTER = ClassLoaderLogManager

[MAIL]
## 发送邮箱地址，多个请用空格分割
TOMAIL = XXX@XXX.COM XXX@DDD.COM


####
修改checkTomcatService.cron任务脚本
--------------------------------------------
修改脚本内的tomcat安装目录即可
赋予可执行权限，并拷贝到/var/spool/cron/下（或自行修改路径）
echo  '*/1 * * * * /bin/bash /var/spool/cron/checkTomcatService.cron > /dev/null 2>&1' >> /var/spool/cron/root && service  crond restart


TOMCAT相关配置可参考：
http://kinggoo.com/app-tomcat-7057.htm
http://kinggoo.com/tomcat-serverconfig.htm