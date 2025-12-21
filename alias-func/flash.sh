echo "BMC ip:$1"
BUF_SIZE=0x2000  # or 0x7FFFF

set -x
ipmitool -I lanplus -H $1 -U ADMIN -P ADMIN chassis power off
# 0x01 for active, 0x03 for active & backup
ipmitool -I lanplus -H $1 -U ADMIN -P ADMIN raw 0x3c 0x0b 0x01
echo 'y' | ipmitool -I lanplus -H $1 -U ADMIN -P ADMIN -z $BUF_SIZE hpm upgrade EEPROM.hpm force
echo 'y' | ipmitool -I lanplus -H $1 -U ADMIN -P ADMIN -z $BUF_SIZE hpm upgrade spinor.hpm force
# ipmitool -I lanplus -H $1 -U ADMIN -P ADMIN chassis power on
