#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Time    : 2016/3/2 14:28
# @Author  : Aries (i@iw3c.com)
# @Site    : http://iw3c.com
# @File    : bakuptoemail.py
# @Software: PyCharm

import os,sys,getopt,time
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

try:
    opts, args = getopt.getopt(sys.argv[1:], 'h:s:t:u:p:f:')
except getopt.GetoptError, err:
    print str(err)
    exit()

SMTP_HOST = SMTP_SENDER = SMTP_TO = SMTP_USER = SMTP_PWD = ''
FILENAME = ''
CHARSET = 'utf-8'
for k,v in opts:
    if k=='-h':
        SMTP_HOST = v
    elif k=='-s':
        SMTP_SENDER = v
    elif k=='-t':
        SMTP_TO = v
    elif k=='-u':
        SMTP_USER = v
    elif k=='-p':
        SMTP_PWD = v
    elif k=='-f':
        FILENAME = v
    #print "k: %s ,v : %s" % (k,v)
def send_email():
    #创建一个带附件的实例
    msg = MIMEMultipart()
    #构造附件
    name = os.path.basename(FILENAME)
    att = MIMEText(open(FILENAME, 'rb').read(), 'base64', CHARSET)
    att["Content-Type"] = 'application/octet-stream'
    att["Content-Disposition"] = 'attachment; filename="%s"' % name #这里的filename可以任意写，写什么名字，邮件中显示什么名字
    msg.attach(att)
    #加邮件头
    msg['to'] = SMTP_TO
    msg['from'] = SMTP_USER
    msg['subject'] = '[备份]'+time.strftime('%Y-%m-%d',time.localtime())+'网站的备份邮件'
    #发送邮件
    try:
        server = smtplib.SMTP()
        server.connect(SMTP_HOST)
        server.login(SMTP_USER,SMTP_PWD)
        server.sendmail(msg['from'], msg['to'],msg.as_string())
        server.quit()
        return True
    except Exception, e:
        return False

if __name__ == '__main__':
    send_email()