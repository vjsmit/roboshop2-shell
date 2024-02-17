color="\e[35m"
nocolor="\e[0m"
logfile="/tmp/roboshop.log"

stat_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[33mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
  fi
}