source common.sh
component=shipping

mysql_pwd=$1

if [ -z "$mysql_pwd" ]; then
    echo mysql password is missing
    exit 1
fi
func_maven

