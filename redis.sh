echo -e "${color}Setup Redis repo${nocolor}"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "${color}Enable Redis 6.2${nocolor}"
dnf module enable redis:remi-6.2 -y

echo -e "${color}Install Redis${nocolor}"
dnf install redis -y

echo -e "${color}Update listen address${nocolor}"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/redis.conf /etc/redis/redis.conf

echo -e "${color}Enable Redis Service${nocolor}"
systemctl enable redis
systemctl restart redis