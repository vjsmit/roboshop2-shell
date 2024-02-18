source common.sh

echo -e "${color}Setup Redis repo${nocolor}"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${logfile}
stat_check $?

echo -e "${color}Enable Redis 6.2${nocolor}"
dnf module enable redis:remi-6.2 -y   &>>${logfile}
stat_check $?

echo -e "${color}Install Redis${nocolor}"
dnf install redis -y    &>>${logfile}
stat_check $?

echo -e "${color}Update listen address${nocolor}"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf /etc/redis/redis.conf    &>>${logfile}
stat_check $?

echo -e "${color}Enable Redis Service${nocolor}"
systemctl enable redis    &>>${logfile}
systemctl restart redis   &>>${logfile}
stat_check $?