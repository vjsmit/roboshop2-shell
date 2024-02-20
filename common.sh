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

func_app_presetup() {
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
}

func_nodejs() {
  echo -e "\e${color}Enable Nodejs18 version\e${nocolor}"
  dnf module disable nodejs -y    &>>${logfile}
  dnf module enable nodejs:18 -y    &>>${logfile}
  stat_check $?

  echo -e "\e${color}Install Nodejs\e${nocolor}"
  dnf install nodejs -y   &>>${logfile}
  stat_check $?

  func_app_presetup

  echo -e "\e${color}Download App dependencies\e${nocolor}"
  npm install   &>>${logfile}
  stat_check $?

  func_systemd
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

func_mysql() {
  echo -e "${color}Install mysql client${nocolor}"
  dnf install mysql -y    &>>${logfile}
  stat_check $?

  echo -e "${color}Load Schema${nocolor}"
  mysql -h mysql-dev.smitdevops.online -uroot -p${mysql_pwd} </app/schema/shipping.sql   &>>${logfile}
  stat_check $?
}

func_systemd(){
  echo -e "\e${color}Setup ${component} Service\e${nocolor}"
  cp /home/centos/roboshop2-shell/${component}.service /etc/systemd/system/${component}.service    &>>${logfile}
  sed -i -e "s/roboshop_pwd/${roboshop_pwd}/" /etc/systemd/system/${component}.service  &>>${logfile}
  stat_check $?

  echo -e "\e${color}Start ${component} Service\e${nocolor}"
  systemctl daemon-reload   &>>${logfile}
  systemctl enable ${component}    &>>${logfile}
  systemctl restart ${component}   &>>${logfile}
  stat_check $?
}

func_maven() {
  echo -e "${color}Install Maven${nocolor}"
  dnf install maven -y    &>>${logfile}
  stat_check $?

  func_app_presetup

  echo -e "${color}Download App Dependencies${nocolor}"
  mvn clean package   &>>${logfile}
  mv target/shipping-1.0.jar shipping.jar   &>>${logfile}
  stat_check $?

  func_mysql

  func_systemd
}

func_python() {
  echo -e "${color}Install Python 3.6${nocolor}"
  dnf install python36 gcc python3-devel -y   &>>${logfile}
  stat_check $?

  func_app_presetup

  echo -e "${color}Download App Dependencies${nocolor}"
  pip3.6 install -r requirements.txt    &>>${logfile}
  stat_check $?

  func_systemd
}

func_golang() {
  echo -e "${color}Install golang${nocolor}"
  dnf install golang -y   &>>${logfile}
  stat_check $?

  func_app_presetup

  echo -e "${color}Download App Dependencies${nocolor}"
  go mod init dispatch    &>>${logfile}
  go get    &>>${logfile}
  go build    &>>${logfile}
  stat_check $?

  func_systemd
}