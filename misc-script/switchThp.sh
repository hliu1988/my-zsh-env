echo "before: cat /sys/kernel/mm/transparent_hugepage/enabled"
echo $(cat /sys/kernel/mm/transparent_hugepage/enabled)

echo ${2:-123456} | sudo -S bash -c "echo $1 > /sys/kernel/mm/transparent_hugepage/enabled"

echo "after: cat /sys/kernel/mm/transparent_hugepage/enabled"
echo $(cat /sys/kernel/mm/transparent_hugepage/enabled)
