### theme
https://draculatheme.com/tilix

### location
/home/hliu/.config/tilix/schemes/Dracula.json

### How to open the same directory within a new session

[VTE config](https://github.com/gnunn1/tilix/wiki/VTE-Configuration-Issue)

```bash
# ubuntu
sudo ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
# .zshrc
if [[ $TILIX_ID ]]; then
  source /etc/profile.d/vte.sh
fi
```

