source common.sh

echo - e "${color}Configure Erlang YUM Repos${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash     &>>{logfile}
stat_check $?

echo - e "${color}Configure rabbitmq YUM Repos${nocolor}"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash    &>>{logfile}
stat_check $?

echo - e "${color}Install RabbitMQ${nocolor}"
dnf install rabbitmq-server -y    &>>{logfile}
stat_check $?

echo - e "${color}Start RabbitMQ Service${nocolor}"
systemctl enable rabbitmq-server    &>>{logfile}
systemctl restart rabbitmq-server   &>>{logfile}
stat_check $?

echo - e "${color}Create one user for the app${nocolor}"
rabbitmqctl add_user roboshop roboshop123   &>>{logfile}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"    &>>{logfile}
stat_check $?