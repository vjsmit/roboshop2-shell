source common.sh

echo -e "\e${color}Enable Nodejs18 version\e${nocolor}"
dnf module disable nodejs -y    &>>${logfile}
dnf module enable nodejs:18 -y    &>>${logfile}
stat_check $?

echo -e "\e${color}Install Nodejs\e${nocolor}"
dnf install nodejs -y   &>>${logfile}
stat_check $?

echo -e "\e${color}Add App user\e${nocolor}"
id roboshop   &>>${logfile}
if [ $? -ne 0 ]; then
  useradd roboshop    &>>${logfile}
fi
stat_check $?

echo -e "\e${color}Create App Dir\e${nocolor}"
rm -rf /app   &>>${logfile}
mkdir /app    &>>${logfile}
stat_check $?

echo -e "\e${color}Download & Unzip App content\e${nocolor}"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip    &>>${logfile}
cd /app
unzip /tmp/catalogue.zip    &>>${logfile}
stat_check $?

echo -e "\e${color}Download App dependencies\e${nocolor}"
npm install   &>>${logfile}
stat_check $?

echo -e "\e${color}Setup Catalogue Service\e${nocolor}"
cp /home/centos/roboshop2-shell/catalogue.sh /etc/systemd/system/catalogue.service    &>>${logfile}
stat_check $?

echo -e "\e${color}Start Catalogue Service\e${nocolor}"
systemctl daemon-reload       &>>${logfile}
systemctl enable catalogue    &>>${logfile}
systemctl restart catalogue   &>>${logfile}
stat_check $?

echo -e "\e${color}Setup mongodb repo\e${nocolor}"
cp /home/centos/roboshop2-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>${logfile}
stat_check $?

echo -e "\e${color}Install mongodb client\e${nocolor}"
dnf install mongodb-org-shell -y    &>>${logfile}
stat_check $?

echo -e "\e${color}Load the schema\e${nocolor}"
mongo --host mongodb-dev.smitdevops.online </app/schema/catalogue.js    &>>${logfile}
stat_check $?