source common.sh
component=payment

roboshop_pwd=$1
if [ -z "$roboshop_pwd" ]; then
  echo roboshop password is missing, exiting
  exit 1
fi

func_python

