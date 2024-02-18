source common.sh

echo -e "${color}Setup repo file${nocolor}"
cp /home/centos/roboshop2-shell /etc/yum.repos.d/mongo.repo     &>>${logfile}
stat_check $?

echo -e "${color}Install MongoDB${nocolor}"
dnf install mongodb-org -y    &>>${logfile}
stat_check $?

echo "${color}Update listen address${nocolor}"
sed -i -e "s/127.0.0.1/0.0.0.0/" /etc/mongod.conf   &>>${logfile}
stat_check $?

echo "${color}Start MongoD service${nocolor}"
systemctl enable mongod   &>>${logfile}
systemctl restart mongod    &>>${logfile}
stat_check $?

