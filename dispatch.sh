source common.sh
roboshop_pwd=$1

if [ -z "$roboshop_pwd" ]; then
  echo roboshop pwd is missing, exiting
  exit 1
fi

func_golang

