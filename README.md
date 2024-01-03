# avalauto
Go fetch key info of you Avalon Bitcoin Miner  
This top bar extensions useful to monitor Avalon Bitcoin miner status 
in just one click !

## Acknoledgment
Huge thanks to [Bitbar](https://github.com/matryer/bitbar) and [@p-e-w](https://github.com/p-e-w/argos) for creating the argos repositories  

## For who ?
Ubuntu users, running an Avalon miner on the same local network.  
(probably works on Debian)  

## Prerequisite
an Avalon miner with known username, password and IP address

## Install
### Dependencies and application requirements
`sudo apt update`  
 * argos  
need to be able to toggle the **argos** extention :  
`sudo apt-get -y install gnome-shell-extension-prefs`  
 * emojis  
`sudo apt install gnome-characters`
 * zenity  
`sudo apt install -y zenity`
 * gpg  
`sudo apt-get -y install gpg`

### Argos extension :
from [@p-e-w](https://github.com/p-e-w/argos) repository  
copy the argos folder in your extensions folder  
`cp argos@pew-worldwidemann.com ~/.local/share/gnome-shell/extensions/`  
  
logout , log back in, open Extension and toggle Argos  

## Download this repository
`https://github.com/Acktarius/avalauto.git`  
mv the downloaded directory to /opt  
`mv /avalauto /opt/`  

## Install  
change directory  
`cd /opt/avalauto`  
 * copy the extension    
`cp avalon_est.3r+.sh ~/.config/argos/avalon_est.3r+.sh`  
 * copy the icon
`cp miner.svg ~/.icons/miner`
 * add a cronjob
`crontab -e`
  * add the line
    `0 * * * * /opt/avalauto/launcher.sh`     
make sure the scripts file  
`chmod 755 gpu.2r.5m+.sh`  
`chmod 755 a`
