# Author      : Kung
# Build       : 2022-04-17 14:58
# Version     : V1.0
# Description :            
# System      : CentOS 7.6 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}
    
A=B
echo "PID for Parent.sh before exec/source/fork:$$"
export A
echo "Parent.sh: \$A is $A"
    	
case $1 in
 exec)
	echo "using exec…"
        exec ./Child.sh ;;
 source)
        echo "using source…"
          . ./Child.sh ;;
 *)
        echo "using fork by default…"
            ./Child.sh ;;
esac
  	
echo "PID for Parent.sh after exec/source/fork:$$"
echo "Parent.sh: \$A is $A"
                                                                                                                                                                                                                           github/README.md                                                                                    0000644 0000000 0000000 00000000033 14277051713 012320  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   # Shell Script練習範本
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     github/add_ip.sh                                                                                    0000755 0000000 0000000 00000002313 14275154762 012631  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-12 23:58
# Version     : V1.0
# Description : Batch add/del Network Card IP Address           
# System      : CentOS 7.9 

export PS4='++ ${LINENO} ' 
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

RETVAL=0
add(){
	for ip in {1..5}
	do
		if [ $ip -eq 10 ]
		 then
		continue
		fi
		
	ip addr add 192.168.88.$ip/24 dev eth0 label eth0:$ip &>/dev/null
	RETVAL=$?

		if [ $RETVAL -eq 0 ]
		 then
			action "Success to add 192.168.88.$ip" /bin/true
		else
			action "Fail to add 192.168.88.$ip" /bin/false
		fi
	done
	return $RETVAL
}

del(){
	for ip in {5..1}
	do
		if [ $ip -eq 10 ]
		 then
			continue
		fi

	ifconfig eth0:$ip down &>/dev/null
	RETVAL=$?

		if [ $RETVAL -eq 0 ]
		 then
			action "Success to del 192.168.88.$ip" /bin/true
		else
			action "Fail to del 192.168.88.$ip" /bin/false
		fi
	done
	return $RETVAL
}

case "$1" in
	start)
		add
		;;
	stop)
		del
		;;
	restart)
		del
		sleep 2
		add
		;;
	*)
		printf "Usage:$0 {start|stop|restart}\n"

esac
exit $RETVAL
                                                                                                                                                                                                                                                                                                                     github/add_manyuser.sh                                                                              0000755 0000000 0000000 00000002336 14275133044 014057  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-13 00:22
# Version     : V1.0
# Description : Batch add/del account and password           
# System      : CentOS 7.9 

export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions

Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

User="student"
Password_File="/root/tmp/passwd.txt"
[ ! -f ${Password_File} ] && touch ${Password_File}

# Batch add user
for num in `seq -w 05`
do
 	useradd $User$num &>/dev/null 

 		if [ $? -eq 0 ]
  	 	 then
			action "$User$num add new account" /bin/true
 		else
			action "$User$num fail new account" /bin/false
 		fi

 	Password="`openssl rand -base64 10 |md5sum|cut -c 3-8`"
 	echo "${Password}|passwd --stdin $User$num &>/dev/null"  
	echo -e "User:$User$num\tPassword:$Password">>${Password_File}

done

echo "Wait 5 second................................................"
sleep 5

#Batch del user
for n in {01..05} 
do 
	userdel -r student$n 
		if [ $? -eq 0 ]
	 	 then
			action "$User$n success to del account" /bin/true
		else
			action "$User$n fail to del account" /bin/false
		fi
done
                                                                                                                                                                                                                                                                                                  github/backup_database.sh                                                                           0000755 0000000 0000000 00000004335 14300316722 014471  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-13 10:52
# Version     : V1.0
# Description : Create&Backup&Restore database on MySql5.7             
# System      : CentOS 7.9
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
#export MYSQL_PWD=${password}
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}
DBPATH=/root/tmp
[ ! -d "$DBPATH" ] && mkdir $DBPATH

SOCKET=/var/lib/mysql/mysql.sock
MYCMD="mysql --login-path=Kung -S $SOCKET -h localhost"
MYDUMP="mysqldump --login-path=Kung -S $SOCKET -h localhost --no-tablespaces --single-transaction"

Create_db(){
	$MYCMD -e "create database db2;use db2;create table test(id int(7) zerofill auto_increment not null,username varchar(20),servnumber varchar(30),password varchar(20),createtime datetime,primary key (id))DEFAULT CHARSET=utf8;source /root/tmp/sql.txt;"
}

Backup_db(){
	for dbname in `$MYCMD -e "show databases;"|sed '1d'|egrep -v "mysql|schema|performance_schema|sys|information_schema"` 
	do
 		mkdir -p $DBPATH/${dbname}_$(date +%F) 
		$MYDUMP $dbname |gzip >$DBPATH/${dbname}_$(date +%F)/${dbname}.sql.gz
	done
}

Del_db(){
	$MYCMD -e "use db2;truncate table test;"	
}

Restore_db(){
	gunzip ${DBPATH}/${dbname}_$(date +%F)/${dbname}.sql.gz 
	$MYCMD ${dbname}<${DBPATH}/${dbname}_$(date +%F)/${dbname}.sql	
}

Main(){
	echo "Create database and table. Please Wait ....."
	Create_db
	if [ $? -eq 0 ]
	 then
			action "Success to create db" /bin/true
	else
			action "Fail to create db and exit the script" /bin/false
			exit 2
	fi
	
	echo "Backup table. Please wait ........"
	Backup_db
	
	if [ $? -eq 0 ]
	 then
			action "Backup  db" /bin/true
	else
			action "Fail to bk db and exit the script" /bin/false
			exit 2
	fi

	echo "Del table.Please wait ........"
	Del_db	
	
	if [ $? -eq 0 ]
	 then
			action "delete  db" /bin/true
	else
			action "Fail to delete db and exit the script" /bin/false
			exit 3
	fi

	echo "Restore information Please wait....."
	Restore_db
	if [ $? -eq 0 ]
	 then
			action "restore  db" /bin/true
	else
			action "Fail to restore db and exit the script" /bin/false
			exit 4
	fi

}
Main $*
                                                                                                                                                                                                                                                                                                   github/cal_sum.sh                                                                                   0000755 0000000 0000000 00000001570 14275130366 013032  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-13 19:54
# Version     : V1.0
# Description : Cal Sum           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

a=1
sum_a=0
while [ $a -lt 5 ]
do
	echo $a
 	((sum_a=sum_a+a))
 	((a++))
done
[ "$sum_a" -ne 0 ] && printf "Total Sum:$sum_a\n"

echo "wait 5 second................."
sleep 5

sum_b=0
for ((b=1;b<5;b++))
do
	echo $b
	((sum_b=sum_b+b))
done
[ "$sum_b" -ne 0 ] && printf "Total Sum: $sum_b\n"

echo "wait 5 second................."
sleep 5 

sum_c=0
for c in {1..4}
do
	echo $c
	((sum_c=sum_c+c))
	((c++))
done
[ "$sum_c" -ne 0 ] && printf "Total Sum: $sum_c\n"


                                                                                                                                        github/choice_menu.sh                                                                               0000755 0000000 0000000 00000001403 14275132102 013646  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-07-30 22:00
# Version     : V1.0
# Description : Choice menu            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

function usage(){
	echo "Usage: $0 {1|2|3|4}"
	exit 1
}

function menu(){
	cat << END
	1.apple
	2.pear
	3.banana
END
}

function choice(){
	read -p "Please input your choice:" fruit 
	case "$fruit" in
	1)
		echo -e "apple";;
	2)
		echo -e "pear";;
	3)
		echo -e "banana";;	
	*)
		usage;;
	esac 
}
function main(){
	menu
	choice
}
main $*


                                                                                                                                                                                                                                                             github/create_randomfile.sh                                                                         0000755 0000000 0000000 00000001101 14275133210 015027  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:00
# Version     : V1.0
# Description : Random file
# System      : CentOS 7.9

export PS4='++ ${LINENO}'
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

Path=/root/tmp
[ -d "$PATH" ]|| mkdir -p $Path

for n in `seq 10`
do
	random=$(openssl rand -base64 40| sed 's#[^a-z]##g'|cut -c 1-10)
	touch $Path/${random}_.html
done
 
                                                                                                                                                                                                                                                                                                                                                                                                                                                               github/create_sqldata.sh                                                                            0000755 0000000 0000000 00000001440 14276314557 014366  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-05-05 23:22
# Version     : V1.0
# Description : Random lot of information to insert mysql5.6           
# System      : CentOS 7.6 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

echo "Please input server number:"
read server
echo "Please input sql number:"
read number

for (( i=0;i<$number;i++ ))
do
pass=`head /dev/urandom | tr -dc a-z | head -c 8`
let server=server+1
echo "insert into test(id,username,servnumber,password,createtime)
values('$i','user${i}','${server}','$pass',now());" >>/root/tmp/sql.txt
done
                                                                                                                                                                                                                                github/create_vpnuser.sh                                                                            0000755 0000000 0000000 00000003025 14275135433 014431  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-13 08:51
# Version     : V1.0
# Description : Batch Add/Del VPN User list
# System      : CentOS 7.9

export PS4='++ ${LINENO}'
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}
File_Path=/root/tmp/vpn.txt
[ ! -f ${File_Path} ] && touch ${File_Path}

usage(){
	echo "USAGE: $0 {-add|-del|-search} username"
}

if [ $UID -ne 0 ];then
	echo "You are not supper user,Please use root"
	exit 1;
fi

if [ $# -ne 2 ];then
	usage
	exit 2;
fi

case "$1" in
	-add)
	shift
	if grep "$1" ${File_Path} >/dev/null 2>&1
		then
			action $"VPN User $1 already exists" /bin/false
			exit
	else
		chattr -i ${File_Path}
		cp ${File_Path} ${File_Path}_$(date +%F%T).txt
		echo "$1" >> ${File_Path}
		[ $? -eq 0 ] && action $"Success to add VPN User $1" /bin/true
		chattr +i ${File_Path}
		exit
	fi
	;;

	-del)
	shift
	if [ `grep "$1" ${File_Path}|wc -l` -lt 1 ]
	 then
		action $"Not find VPN User $1" /bin/false
		exit 
	else
		chattr -i ${File_Path}
		cp ${File_Path} ${File_Path}_$(date +%F%T)
		sed -i "/^${1}$/d" ${File_Path}
		[ $? -eq 0 ] && action $"Success to del VPN User $1" /bin/true
		chattr +i ${File_Path}
		exit
	fi
	;;

	-search)
	shift
	if [ `grep -w "$1" ${File_Path}|wc -l` -lt 1 ]
	 then
		echo $"Not find VPN User $1"
		exit
	else
		echo $"VPN User $1 already exists"
		exit
	fi
	;;

	*)
	usage
	exit
	;;
esac
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           github/cut_nginxlog.sh                                                                              0000755 0000000 0000000 00000001243 14275710515 014104  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-05-28 19:46
# Version     : V1.0
# Description : Cut Nginx log every day            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}


DataFormat=`date +%Y%m%d -d -1day`
Basedir="/usr/local/nginx"
Nginxlog="$Basedir/logs"

[ -d $Nginxlog ] && cd $Nginxlog || exit 1
[ -f access.log ] || exit 1
mv access.log access_${DataFormat}.log
$Basedir/sbin/nginx -s reload



                                                                                                                                                                                                                                                                                                                                                             github/cycle_9X9.sh                                                                                 0000755 0000000 0000000 00000001251 14275136416 013155  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 19:50
# Version     : V1.0
# Description :            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

for num1 in `seq 9`
do
 for num2 in `seq 9`
  do
	if [ $num1 -ge $num2 ]
	  then
		if(((num1*num2)>9))
		 then
		   echo -en "${num1}X${num2}=$((num1*num2)) "
	  	
	         else
		   echo -en "${num1}X${num2}=$((num1*num2))  "
		fi
	fi	

  done
echo " "
done
 
                                                                                                                                                                                                                                                                                                                                                       github/deploy_sshkey.sh                                                                             0000755 0000000 0000000 00000001247 14275147776 014307  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-05-23 19:52
# Version     : V1.0
# Description : deploy ssh key to another server           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}


rm -f ~/.ssh/id_rsa*
ssh-keygen -f ~/.ssh/id_rsa -P " " >/dev/null 2>&1
SSH_PASS=
Key_Path=~/.ssh/id_rsa.pub
for ip in 100 200
do
	sshpass -p$SSH_Pass ssh-copy-id -i $Key_Path "-o StrictHostKeyChecking=no" 192.168.88.$ip

done
                                                                                                                                                                                                                                                                                                                                                         github/input_number.sh                                                                              0000755 0000000 0000000 00000001761 14275151063 014115  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:04
# Version     : V1.0
# Description :            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

print_usage(){
	printf "Please enter integer!!! Thks\n"
	exit 1
}

read -p "Please input first number:" firstnum
if [ -n "`echo $firstnum|sed 's/[0-9]//g'`" ]
 then
	print_usage	
fi

read -p "Please input the operators:" operators
if [ "${operators}" != "+" ]&&[ "${operators}" != "-" ]&&[ "${operators}" != "*" ]&&[ "${operators}" != "/" ]
 then
	echo "Please use {+|-|*|/}"
	exit 2
fi

read -p "Please input second number:" secondnum
if [ -n "`echo $secondnum|sed 's/[0-9]//g'`" ]
 then
	print_usage
fi
echo "${firstnum}${operators}${secondnum}=$((${firstnum}${operators}${secondnum}))"

               github/jump_server.sh                                                                               0000755 0000000 0000000 00000001451 14275720362 013747  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-20 21:48
# Version     : V1.0
# Description : Jump Server           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

trapper(){
	trap ':' INT EXIT TSTP TERM HUP
}

main(){
	while :
	do
		trapper
		clear
		cat <<end 
		1) 192.168.88.26	
		2) 192.168.88.27
		
end
		read -p "Please input a number:" num
		case "$num" in
		1)
		echo 'login in 192.168.88.26'
		ssh 192.168.88.26
		;;	
		2)
		echo 'login in 192.168.88.51'
		ssh 192.168.88.51
		;;
		*)
		echo 'Please select 1 or 2'
		esac
		
	done
}
main $*
                                                                                                                                                                                                                       github/monitor_file.sh                                                                              0000755 0000000 0000000 00000001734 14275730425 014101  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-05-07 23:42
# Version     : V1.0
# Description : Monitor Web file           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

RETVAL=0
CHECK_DIR=/var/www/html
[ -e $CHECK_DIR ]||exit 1

CONTEXT="/root/tmp/context.db.ori"
COUNT="/root/tmp/count.db.ori"
ERROR_LOG="/root/tmp/err.log"

[ -e $COUNT ]|| exit 1

md5sum -c --quiet  /tmp/context.db.ori &>>$ERROR_LOG
RETVAL=$?

find $CHECK_DIR -type f >/tmp/count_current.db.ori
diff /tmp/count* &>>$ERROR_LOG

if [ $RETVAL -ne 0 -o `diff /tmp/count*|wc -l` -ne 0 ] 
 then
	mail -s "`uname -n` $(date +%F) err asuka.2004@gmail.com<$ERROR_LOG"
 else
	echo "Site is normal"| mail -s "`uname -n` $(date +%F) is ok" asuka.2004@gmail.com
fi
                                    github/monitor_keepalived.sh                                                                        0000755 0000000 0000000 00000001223 14275153061 015257  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-08-11 18:11
# Version     : V1.0
# Description :            
# System      : CentOS 7.6 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

counter=$(ps -C nginx --no-heading|wc -l)
if [ "${counter}" -eq "0" ] 
 then
	/usr/bin/systemctl stop keepalived 
	echo 'NGINX Server is dead..Please fix this Nginx'
else
	/usr/bin/systemctl start keepalived
	echo "Everything is normal"
fi
                                                                                                                                                                                                                                                                                                                                                                             github/monitor_memcache.sh                                                                          0000755 0000000 0000000 00000001441 14275712423 014715  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-13 20:02
# Version     : V1.0
# Description : Monitor memorycache           
# System      : CentOS 7.6 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

if [ `netstat -ntulp|grep 11211 |wc -l` -lt 1 ]
 then
	echo "Memcache is error"
	exit 1
fi

printf "del key\r\n"| nc -v 127.0.0.1 11211 &>/dev/null
printf "set key 0 0 10 \r\n\r\n"| nc -v 127.0.0.1 11211 &>/dev/null
McValues=`printf "get key\r\n"|nc -v 127.0.0.1 11211|grep |wc -l`

if [ $McValues -eq 1 ]
 then
	echo "Memorycache is ok"
else
	echo "Memorycache fail"
fi
                                                                                                                                                                                                                               github/monitor_memory.sh                                                                            0000755 0000000 0000000 00000001252 14275154047 014465  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 19:52
# Version     : V1.0
# Description : Monitor memory           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

Memory=`free -m|awk 'NR==2 {print $NF}'`
Alarm="Warining!!! Current time is `date +%F-%T` and Memory leave over $Memory"
if [ $Memory -lt 13500 ]
 then
	echo $Alarm>> /root/tmp/message.txt
	mail -s "$Alarm" root@localhost</root/tmp/message.txt
fi
 
                                                                                                                                                                                                                                                                                                                                                      github/monitor_nginx.sh                                                                             0000755 0000000 0000000 00000001123 14275154351 014273  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-06-16 23:21
# Version     : V1.0
# Description : If nginx fail ,stop keepalived            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

if [ `netstat -ntulp|grep nginx|wc -l` -gt 0 ]
 then
	echo  "Web is running"  
else
	echo "Web will reboot"
	/usr/bin/systemctl restart nginx
fi
                                                                                                                                                                                                                                                                                                                                                                                                                                             github/monitor_web.sh                                                                               0000755 0000000 0000000 00000001626 14275705752 013744  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-14 23:40
# Version     : V1.0
# Description : Check Web is not OK!!           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

Check_Url(){
timeout=10
Fails=0
Success=0

while true
 	do
		wget --timeout=$timeout --tries=5 http://www.google.com -q -O /dev/null
 		if [ $? -ne 0 ]
  	 	then
        		((Fails=Fails+1))
 		else
			((Success=Success+1))
 		fi
 
 		if [ $Fails -ge 2 ]
  	 	then
			Critical="Waining!!!!websit is going down"
			echo $Critical | tee | mail -s "$Critical" root@localhost
			exit 2
 		fi

 		if [ $Success -ge 2 ]
  	 	then
			echo "Success"
			exit 0
 		fi

 	done
}
Check_Url

                                                                                                          github/optimize_system.sh                                                                           0000755 0000000 0000000 00000007073 14275155512 014657  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:07
# Version     : V1.0
# Description : Optimization system           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

if [ "$UID" != "0" ]
 then
	echo "Please run the script by root"
	exit 1
fi

function set_timezone(){
	cp /etc/locale.conf /etc/locale.conf.`date +"%Y-%m-%d"`
	localectl set-locale LANG=C
	cat  /etc/locale.conf
}

function sync_time(){
	cron=/var/spool/cron/root
	if [ `grep -w "ntpdate" $cron|wc -l` -lt 1 ]
	 then
		echo '#Sync time by Kung' >>$cron
		echo '*/5 * * * * /usr/sbin/ntpdate time.stdtime.gov.tw>/dev/null 2>&1' >>$cron
		crontab -l 
	fi
}

function opt_file(){
	if [ `grep 65535 /etc/security/limits.conf|wc -l` -lt 1 ]
	 then
		echo '* - nofile 65535 '>>/etc/security/limits.conf
	fi
	ulimit -SHn 65535
}

function opt_profile(){
	echo 'export TMOUT=300' >>/etc/profile
	echo 'export HISTSIZE=5' >> /etc/profile
	echo 'export HISTFILESIZE=5' >> /etc/profile
	tail -3 /etc/profile
	. /etc/profile
}

function opt_kernel(){
	if [ `grep kernel_flag /etc/sysctl.conf|wc -l` -lt 1 ]
	 then
		cat >> /etc/sysctl.conf<<EOF
		net.ipv4.tcp_fin_timeout = 2
		net.ipv4.tcp_tw_reuse = 1
		net.ipv4.tcp_syncookies = 1
		net.ipv4.tcp_keepalive_time = 600
		net.ipv4.ip_local_port_range = 4000 65000
		net.ipv4.tcp_max_syn_backlog = 16384
		net.ipv4.tcp_max_tw_buckets = 36000
		net.ipv4.route.gc_timeout = 100
		net.ipv4.tcp_syn_retries = 1
		net.ipv4.tcp_synack_retries = 1
		net.core.somaxconn = 16384
		net.core.netdev_max_backlog = 16384
		net.ipv4.tcp_max_orphans = 16384
		net.nf_conntrack_max = 25000000
		net.netfilter.nf_conntrack_max = 25000000	
		net.netfilter.nf_conntrack_tcp_timeout_established = 180
		net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
		net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
		net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
EOF
		sysctl -p

	fi
}

function opt_sshd(){
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config.`date +"%Y-%m-%d"`
	sed -i -e "17s/.*/Port 55555/g" /etc/ssh/sshd_config
	sed -i -e "19s/.*/ListenAddress 192.168.88.51/g" /etc/ssh/sshd_config
	sed -i -e "38s/.*/PermitRootLogin no/g" /etc/ssh/sshd_config
	sed -i -e "64s/.*/PermitEmptyPasswords no/g" /etc/ssh/sshd_config 
	sed -i -e "79s/.*/GSSAPIAuthentication no/g" /etc/ssh/sshd_config
	sed -i -e "115s/.*/UseDNS no/g" /etc/ssh/sshd_config
	systemctl restart sshd	
}


function add_user(){
	if [ `grep -w Kung /etc/passwd|wc -l` -lt 1 ]
	 then
		useradd Kung
		echo P@ssw0rd| passwd --stdin Kung
		cp /etc/sudoers /etc/sudoers.ori
		echo "Kung ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers
		visudo -c &>/dev/null	
	fi
}


function disable_service(){
	systemctl list-unit-files | grep enable| egrep -v "sshd.service|firewalld.service|cron.service|sysstat|rsyslog|NetworkManager.service|irqbalance.service" |awk '{print "systemctl disable",$1}'|bash
}


function lock_file(){
	chattr +i /etc/passwd /etc/shadow /etc/group /etc/inittab /etc/fstab /etc/sudoers
	lsattr /etc/passwd /etc/shadow /etc/group /etc/inittab /etc/fstab /etc/sudoers
	mv /usr/bin/chattr /opt/
}

function clear_issue(){
	cat /dev/null>/etc/issue
	cat /dev/null>/etc/issue.net
}

function ban_ping(){
	echo "net.ipv4.icmp_echo_ignore_all=1">> /etc/sysctl.conf
}

main(){
	set_timezone
	sync_time
	opt_file
	opt_profile
	opt_kernel
	opt_sshd
	add_user
	disable_service
	lock_file
	clear_issue
	ban_ping
}
main
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     github/push_github.sh                                                                               0000755 0000000 0000000 00000001036 14275163500 013721  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 20:58
# Version     : V1.0
# Description :            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

script_path=/root/github
log_path=/root/tmp
	git add --all 
	git commit -m $(date +%Y-%m-%d-%R)
	git push -u origin master
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  github/rename_manyfile.sh                                                                           0000755 0000000 0000000 00000001052 14275155761 014543  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:05
# Version     : V1.0
# Description : rename file
# System      : CentOS 7.9
export PS4='++ ${LINENO}'
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

NewFile=_asuka.html
Dirname="/root/tmp"
cd $Dirname||exit 1
for n in `ls`
do
	name=$(echo $n|awk -F '_' '{print $1}' )
	mv $n ${name}${NewFile}
done
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      github/resist_ddos.sh                                                                               0000755 0000000 0000000 00000001563 14275161232 013727  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-20 22:45
# Version     : V1.0
# Description : Resist DDOS           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

file=$1
while true
do
	awk '{print $1}' $1 | grep -v "^$" | sort | uniq -c >/root/tmp/tmp.log
 	exec</root/tmp/tmp.log
 	while read line
  	do
		ip=`echo $line|awk '{print $1}'`
		count=`echo $line|awk '{print $2}'`
		
		if [ $count -gt 50 ]
		 then
		firewall-cmd --add-rich-rule "rule family="ipv4" source address="$ip" port port="80" protocol="tcp"  reject"
		echo "$line is dropped">>/root/tmp/droplist_$(date +F%).log
		fi
  	done
  	sleep 20
done
                                                                                                                                             github/scp_file.sh                                                                                  0000755 0000000 0000000 00000001123 14275712127 013166  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-08-13 20:03
# Version     : V1.0
# Description : Use expect file to copy file           
# System      : CentOS 7.6 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

if [ $# -ne 2 ]
 then
	echo $"Usage:$0 file dir"
	exit
fi
file=$1
dir=$2

for n in 101 102 
do
	expect scp_remote.exp $file 192.168.88.$n $dir
done
                                                                                                                                                                                                                                                                                                                                                                                                                                             github/search_md5sum.sh                                                                             0000755 0000000 0000000 00000001213 14275161413 014135  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:05
# Version     : V1.0
# Description :            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

for n in {0..10}
do
	echo "`echo $n|md5sum` $n" >>/root/tmp/md5sum.log
done


md5search="fdd96b0a2ea29515"
while read line
do
	if [ `echo $line|grep "$md5search"|wc -l` -eq 1 ];then
	echo $line
	break
	fi
done</root/tmp/md5sum.log

                                                                                                                                                                                                                                                                                                                                                                                     github/start_nginx.sh                                                                               0000755 0000000 0000000 00000002510 14275154154 013743  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 20:59
# Version     : V1.0
# Description : Use script to choice           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

path=/usr/local/nginx/sbin/
pid=/usr/local/nginx/logs/nginx.pid
RETVAL=0

start(){
	if [ `netstat -ntulp|grep nginx|wc -l` -eq 0 ];then 
		$path/nginx
		RETVAL=$?		
				
		if [ $RETVAL -eq 0 ];then
			action "NGINX is starting" /bin/true
			return $RETVAL
		else
			action "NGINX fail to start " /bin/false
			return $RETVAL
		fi
	else
		echo "NGINX is normal,nothing to do"
		return 0

	fi
}


stop(){
	if [ `netstat -ntulp| grep nginx| wc -l` -gt 0 ];then
		$path/nginx -s stop
		RETVAL=$?
		
		if [ $RETVAL -eq 0 ];then
			action "NGINX is stopping" /bin/true
			return $RETVAL
		else
			action "NGINX fail to stop" /bin/false
			return $RETVAL
		fi

	else
		echo "NGINX stop always"
		return $RETVAL
	fi
}


case "$1" in
	start)
		start
		RETVAL=$?
	;;
	stop)
		stop
		RETVAL=$?
	;;
	restart)
		stop
		sleep 1
		start
		RETVAL=$?
	;;
	*)
		echo $"USAGE: $0 {start|stop|restart}"
		exit 1

esac
exit $RETVAL


                                                                                                                                                                                        github/start_rsyncd.sh                                                                              0000755 0000000 0000000 00000002176 14275457027 014137  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-05-22 16:39
# Version     : V1.0
# Description : Start Rsync           
# System      : CentOS 7.6 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

if [ $# -ne 1 ]
 then
	echo $"Usage:$0 {Start|Stop|Restart}"
	exit 1
fi

if [ "$1" = "start" ]
 then
	systemctl start rsyncd
	sleep 2
	if [ `netstat -ntulp|grep rsync|wc -l` -ge 1 ]
	 then
		echo "Rsync started"
		exit 0
	fi
elif [ "$1" = "stop" ]
 then
	systemctl stop rsyncd 
	sleep 2
	if [ `netstat -ntulp| grep rsync|wc -l` -eq 0 ]
	 then
		echo "Rsync is Stopped"
		exit 0
	fi

elif [ "$1" = "Restart" ]
 then
	systemctl stop rsyncd	
	sleep 1
	killpro=`netstat -ntulp|grep rsync|wc -l`
	systemctl start rsyncd
	sleep 1
	startpro=`netstat -ntulp| grep rsync|wc -l`
	if [ $killpro -eq 0 -a $startpro -ge 1 ]
	 then
		echo "Rsyncd is Restarted"
		exit 0
	fi

else
	echo $"Usage:$0 {Start|Stop|Restart}"
	exit 1	
fi



                                                                                                                                                                                                                                                                                                                                                                                                  github/study_array_1.sh                                                                             0000755 0000000 0000000 00000001525 14275642274 014203  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-13 10:50
# Version     : V1.0 
# Description : Study array            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

# Test lengh less than 4 
array=( I am Tony Kung not William Gilson )

for ((a=0;a<${#array[*]};a++))
do
 	if [ ${#array[$a]} -lt 4 ]
	 then
		echo "${array[$a]}"
 	fi
done
			       
echo "Wait 3 second..."
sleep 3

b=0
while ((b<${#array[*]})) 
do
	if [ ${#array[$b]} -lt 4 ]
	 then
		echo "${array[$b]}"
	fi
	((b++))
done

c=0
for c in ${array[*]}
do
	if [ `expr length $c` -lt 4 ]
	 then
		echo $c
	fi
	((c++))
done

                                                                                                                                                                           github/study_array_2.sh                                                                             0000755 0000000 0000000 00000001247 14275647012 014200  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-13 10:50
# Version     : V1.0 
# Description : Study array            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}


arr=(1 2 3 4 5)

for((a=0;a<${#arr[*]};a++))
do
	echo ${arr[a]}
done

echo "Wait 5 second..."
sleep 5

b=0
for b in ${arr[*]}
do
	echo $b
	((b++))
done

echo "Wait 5 second..."
sleep 5

c=0
while ((c<${#arr[*]}))
do
	echo ${arr[c]}
	((c++))
done
                                                                                                                                                                                                                                                                                                                                                         github/study_break.sh                                                                               0000755 0000000 0000000 00000001212 14275162052 013711  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-05-11 23:27
# Version     : V1.0
# Description : Study break continue exit return           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

if [ $# -ne 1 ]
 then
	echo "Please input {break|continue|exit|return}"
	exit 1
fi

test(){
 for ((i=0;i<=5;i++))
 do
	if [ $i -eq 3 ];then
		$*	
	fi
	echo $i	
 done
 echo "I am in func"
}
test $*
 
                                                                                                                                                                                                                                                                                                                                                                                      github/sum_wwwlog.sh                                                                                0000755 0000000 0000000 00000001164 14275162203 013613  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:08
# Version     : V1.0
# Description : Log sum           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

sum=0
exec<$1
while read line
do
 size=`echo $line |awk '{print $10}'`
 expr $size + 1 &>/dev/null
 if [ $? -ne 0 ]
  then
	continue
 fi
 ((sum=sum+$size))
done
echo "Total: `echo $((${sum}/1024)) KB`"
                                                                                                                                                                                                                                                                                                                                                                                                            github/test_ping_ip.sh                                                                              0000755 0000000 0000000 00000001141 14275155632 014070  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-16 11:41
# Version     : V1.0
# Description : Ping IP
# System      : CentOS 7.9
export PS4='++ ${LINENO} '
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

CMD="ping -w 2 -c 2"
IP="192.168.88."
for N in `seq 50` 
do
	$CMD $IP$N &>/dev/null
	if [ $? -eq 0 ]
	 then
		action "Success to ping $IP$N" /bin/true
	else
		action "Fail to ping $IP$N" /bin/false
	fi
done
                                                                                                                                                                                                                                                                                                                                                                                                                               github/test_urlist.sh                                                                               0000755 0000000 0000000 00000001700 14275131637 013765  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-13 20:04
# Version     : V1.0
# Description : Monitor Web list           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

Url_Count=0
Url_List=(
www.google.com
www.kung.roc
www.yahoo.com.tw
www.sina.com.tw
www.ithome.com.tw
)
function Url_Check(){
	for((i=0;i<${#Url_List[*]};i++))
	do
		wget -o /dev/null -T 3 --tries=1 --spider ${Url_List[$i]}>/dev/null 2>&1
		if [ $? -eq 0 ]
		 then
			action "${Url_List[$i]}" /bin/true
		else
			action "${Url_List[$i]}" /bin/false
		fi		
	done
	((Url_Count++))
}

function main(){
	while true
	do
		Url_Check
		echo "Please wait me five second!!! The count is $Url_Count time "
		sleep 5  
	done
}
main $* 
                                                                github/test_web.sh                                                                                  0000755 0000000 0000000 00000001314 14275716422 013222  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 19:47
# Version     : V1.0
# Description : Check Web to use input           
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}


if [ $# -ne 1 ]
 then
	echo $"Usage $0 Url"
	exit 1
fi

while true
do
	if [ `curl -o /dev/null --connect-timeout 5 -s -w "%{http_code}" $1| egrep -w "200|301|302"|wc -l` -ne 1 ]
	 then
		action "$1 fail" /bin/false
	else
		action "$1 is normal" /bin/true
	fi
	sleep 5
done

                                                                                                                                                                                                                                                                                                                    github/tmp/                                                                                         0000755 0000000 0000000 00000000000 14277612736 011655  5                                                                                                    ustar   root                            root                                                                                                                                                                                                                   github/tmp/rsyncd_server.sh                                                                         0000644 0000000 0000000 00000001204 14242373210 015055  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-05-22 16:18
# Version     : V1.0
# Description :            
# System      : CentOS 7.6 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}


useradd rsync -s /sbin/nologin -M
mkdir -p /backup
chown -R rsync.rsync /backup
echo "rsync_backup:P@ssw0rd">/etc/rsync.password
chmod 600 /etc/rsync.password
systemctl start rsyncd
systemctl enable rsyncd
systemctl status rsyncd


                                                                                                                                                                                                                                                                                                                                                                                            github/tmp/monitor_keepalived_2.sh                                                                  0000755 0000000 0000000 00000001217 14275153471 016310  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-25 15:34
# Version     : V1.0
# Description :            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}


VIP=192.168.88.27
PORT=80
IPVS=`rpm -qa ipvsadm|wc -l`

while true
do
	ping -w2 -c2 ${VIP} >/dev/null 2>&1

	if [ $? -ne 0 ]
	 then
		sh ./monitor_lvs.sh start >/dev/null 2>&1
	else
		sh ./monitor_lvs.sh stop >/dev/null 2>&1
	fi
	sleep 5
done
                                                                                                                                                                                                                                                                                                                                                                                 github/tmp/select_menu.sh                                                                           0000755 0000000 0000000 00000002221 14275711221 014477  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:06
# Version     : V1.0
# Description :            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}
			       

Usage(){
	echo "Usage: $0 argv"
	return 1
}

Install_Service(){
	if [ $# -ne 1 ]
	 then
		Usage
	fi
	local retval=0
	echo "Ready for installation ${1}"
	sleep 2

	if [ ! -x "$Script_Path/${1}.sh" ]
	 then
		echo "$Script_Path/${1}.sh do not exist or cat not exec"
		return 1
	else
		$Script_Path/${1}.sh
		return $retval
	fi
}

function main(){
	PS3="Please select a num from menu:"
	select var in "Install lamp" "Install lnmp" "exit"
	do
		case "$var" in
			"Install lamp")
				Install_Service lamp
				retval=$?
				;;
			"Install lnmp")
				Install_Service lnmp
				retval=$?
				;;
			exit)
				echo bye
				return 3
				;;
			*)
				echo "Please input these menu {1|2|3}"
				echo "Input error"

		esac	
	done
exit $ retval
}
main $*
                                                                                                                                                                                                                                                                                                                                                                               github/trap.sh                                                                                      0000755 0000000 0000000 00000001054 14275162473 012356  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   #!/bin/bash
# Author      : Kung
# Build       : 2022-04-21 21:07
# Version     : V1.0
# Description :            
# System      : CentOS 7.9 
			       
export PS4='++ ${LINENO}'  
export LANG=C
export PATH=$PATH
[ -f /etc/init.d/functions ] && . /etc/init.d/functions
Script_Path=/root/project/github
[ ! -d ${Script_Path} ] && mkdir -p ${Script_Path}
Log_Path=/root/tmp
[ ! -d ${Log_Path} ] && mkdir -p ${Log_Path}

trap "find /tmp -type f -name "_*" |xargs rm -rf && exit" INT
while true
do
	touch /tmp/_$(date +F-%H-%M-%S)
	sleep
	ls -l /tmp/*
done
 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    github/vimrc.txt                                                                                    0000644 0000000 0000000 00000002603 14236175663 012735  0                                                                                                    ustar   root                            root                                                                                                                                                                                                                   set nu
map <F2> :call TitleDet()<cr>
 function AddTitle()
     call append(0,"#!/bin/bash")
     call append(1,"# Author      : Tony")
     call append(2,"# Build       : ".strftime("%Y-%m-%d %H:%M")) 
     call append(3,"# Version     : V1.0")
     call append(4,"# Description :            ")
     call append(5,"# System      : CentOS 7.6 ")
     call append(6,"# ************************************************ ")
     call append(7,"export PS4='++ ${LINENO}'  ")
     call append(8,"export LANG=C")
     call append(9,"export PATH=$PATH")
     call append(10,"[ -f /etc/init.d/functions ] && . /etc/init.d/functions")
     call append(11,"Script_Path=/root/github")
     call append(12,"Log_Path=/root/tmp")
     echohl WarningMsg | echo "Successful in adding copyright." | echohl None
 endf

 function UpdateTitle()
      normal m'
      execute '/# Last modified/s@:.*$@\=strftime(":\t%Y-%m-%d %H:%M")@'
      normal ''
      normal mk
      execute '/# Filename/s@:.*$@\=":\t".expand("%:t")@'
      execute "noh"
      normal 'k
      echohl WarningMsg | echo "Successful in updating the copyright." | echohl None
 endfunction

 function TitleDet()
     let n=1
     while n < 10
         let line = getline(n)
         if line =~ '^\#\s*\S*Last\smodified\S*.*$'
             call UpdateTitle()
             return
         endif
         let n = n + 1
     endwhile
     call AddTitle()
 endfunction

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
