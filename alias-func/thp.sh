echo "> getconf PAGE_SIZE: $(getconf PAGE_SIZE)"
echo "> cat /proc/sys/kernel/perf_event_paranoid: $(cat /proc/sys/kernel/perf_event_paranoid)"
echo "> cat /proc/sys/kernel/kptr_restrict: $(cat /proc/sys/kernel/kptr_restrict)"
echo "> cat /sys/kernel/mm/transparent_hugepage/enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled)"
echo "> cat /sys/kernel/mm/transparent_hugepage/defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"

case $1 in
on | always | o)
  echo ${2:-123456} | sudo -S bash -c "echo always > /sys/kernel/mm/transparent_hugepage/enabled"
  ;;
off | never | d)
  echo ${2:-123456} | sudo -S bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled"
  ;;
d_on | def_always | d_o)
  echo ${2:-123456} | sudo -S bash -c "echo always > /sys/kernel/mm/transparent_hugepage/defrag"
  ;;
d_off | def_never | d_d)
  echo ${2:-123456} | sudo -S bash -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag"
  ;;
d_res | def_reset)
  echo ${2:-123456} | sudo -S bash -c "echo madvise > /sys/kernel/mm/transparent_hugepage/defrag"
  ;;
pte) # default 511
  echo ${2:-123456} | sudo -S bash -c "echo $2 > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none"
  ;;
*)
  exit 0
  ;;
esac

echo
echo "> after: cat /sys/kernel/mm/transparent_hugepage/enabled: $(cat /sys/kernel/mm/transparent_hugepage/enabled)"
echo "> cat /sys/kernel/mm/transparent_hugepage/defrag: $(cat /sys/kernel/mm/transparent_hugepage/defrag)"
