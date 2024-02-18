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