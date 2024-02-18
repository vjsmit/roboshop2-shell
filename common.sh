color="\e[35m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"
user_id=$(id -u)
if [ $user_id -ne 0 ]; then
  echo Script should run as root user, exiting script
  exit 1
fi

stat_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
  fi
}

func_nodejs() {
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
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip    &>>${logfile}
  cd /app
  unzip /tmp/${component}.zip    &>>${logfile}
  stat_check $?

  echo -e "\e${color}Download App dependencies\e${nocolor}"
  npm install   &>>${logfile}
  stat_check $?

  echo -e "\e${color}Setup ${component} Service\e${nocolor}"
  cp /home/centos/roboshop2-shell/${component}.service /etc/systemd/system/${component}.service    &>>${logfile}
  stat_check $?

  echo -e "\e${color}Start ${component} Service\e${nocolor}"
  systemctl daemon-reload   &>>${logfile}
  systemctl enable ${component}    &>>${logfile}
  systemctl restart ${component}   &>>${logfile}
  stat_check $?
}

func_mongodb() {
  echo -e "\e${color}Setup mongodb repo\e${nocolor}"
  cp /home/centos/roboshop2-shell/mongo.repo /etc/yum.repos.d/mongo.repo    &>>${logfile}
  stat_check $?

  echo -e "\e${color}Install mongodb client\e${nocolor}"
  dnf install mongodb-org-shell -y    &>>${logfile}
  stat_check $?

  echo -e "\e${color}Load the schema\e${nocolor}"
  mongo --host mongodb-dev.smitdevops.online </app/schema/${component}.js    &>>${logfile}
  stat_check $?
}
