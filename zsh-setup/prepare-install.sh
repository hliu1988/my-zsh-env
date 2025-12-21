# TODO try build_slave.sh

# on local
ssh-copy-id hliu@

# on server
sudo adduser hliu # add user
sudo passwd hliu  # add passwd
sudo usermod -aG wheel hliu # centos/fedora

# on fileserver
c2h_ip <IP> .ssh/

git config --global user.email "hliu@amperecomputing.com"
git config --global user.name "Hao Liu"

