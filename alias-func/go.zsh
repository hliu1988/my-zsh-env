gto() {
  go tool objdump -S -gnu -s "$1" $2
}
