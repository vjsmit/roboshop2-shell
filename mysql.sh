source common.sh

echo -e "${color}Disable MySQL 8 version${nocolor}"
dnf module disable mysql -y     &>>{logfile}

echo -e "${color}Setup the MySQL5.7 repo file${nocolor}"
cp /home/centos/roboshop2-shell/mysql.repo /etc/yum.repos.d/mysql.repo   &>>{logfile}

echo -e "${color}Install MySQL Server${nocolor}"
dnf install mysql-community-server -y   &>>{logfile}

echo -e "${color}Start MySQL Service${nocolor}"
systemctl enable mysqld   &>>{logfile}
systemctl restart mysqld    &>>{logfile}

echo -e "${color}Change the default root password${nocolor}"
mysql_secure_installation --set-root-pass RoboShop@1    &>>{logfile}