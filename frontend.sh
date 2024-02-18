source common.sh

echo -e "${color}Installing Nginx${nocolor}"
dnf install nginx -y  &>>${logfile}
stat_check $?

echo -e "${color}Removing default content${nocolor}"
rm -rf /usr/share/nginx/html/*    &>>${logfile}
stat_check $?

echo -e "${color}Downloading frontend component${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip    &>>${logfile}
stat_check $?

echo -e "${color}Unzip frontend content${nocolor}"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip   &>>${logfile}
stat_check $?

echo -e "${color}Copy reverse proxy config${nocolor}"
cp /home/centos/roboshop2-shell/frontend.conf /etc/nginx/default.d/roboshop.conf &>>${logfile}
stat_check $?

echo -e "${color}Restart Nginx Service${nocolor}"
systemctl enable nginx    &>>${logfile}
systemctl restart nginx   &>>${logfile}
stat_check $?