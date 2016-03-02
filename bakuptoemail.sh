#!/bin/bash
#author:Aries
#web:http://iw3c.com

## 备份配置信息 ##
# 备份名称，用于标记
BAKUP_NAME="bakup"
# 备份目录，多个请空格分隔
BAKUP_SRC="/home/wwwroot/iw3c.com"
# 备份文件临时存放目录，一般不需要更改
BAKUP_DIR="/tmp/bakuptoemail"
# Mysql主机地址
MYSQL_SERVER="localhost"
# Mysql用户名
MYSQL_USER="root"
# Mysql密码
MYSQL_PASS="password"
# Mysql备份数据库，多个请空格分隔
MYSQL_DBS="iw3c_com_db "
# 备份文件压缩密码
BAKUP_FILE_PASSWD="iw3c.com"
# 邮件SMTP地址
THESMTP_HOST="smtp.xxx.com"
# 邮件登录帐号
THESMTP_USER='aries@xxx.com'
# 邮件登录密码
THESMTP_PWD='password'
# 邮件接收地址
THESMTP_TO='xxx@xxx.com'
## 备份配置信息 End ##
NOW=$(date +"%Y%m%d%H%M%S") #精确到秒，统一秒内上传的文件会被覆盖
mkdir -p $BAKUP_DIR
# 备份Mysql
echo "start dump mysql"
for db_name in $MYSQL_DBS
do
    mysqldump -u $MYSQL_USER -h $MYSQL_SERVER -p$MYSQL_PASS $db_name > "$BAKUP_DIR/$BAKUP_NAME-$db_name.sql"
done
echo "dump ok"
#
# 打包
echo "start tar"
BAKUP_FILENAME="$BAKUP_NAME-$NOW.zip"
zip -q -r -P $BAKUP_FILE_PASSWD $BAKUP_DIR/$BAKUP_FILENAME $BAKUP_DIR/*.sql $BAKUP_SRC
echo "tar ok"

# 发送附件
echo "start send email"
REAL_FILE=${BAKUP_DIR}/${BAKUP_FILENAME}
python bakuptoemail.py -h $THESMTP_HOST -s $THESMTP_USER -t $THESMTP_TO -u $THESMTP_USER -p $THESMTP_PWD -f $REAL_FILE
echo "send ok"

# 清理备份文件
rm -rf $BAKUP_DIR
echo "bakup clean done"