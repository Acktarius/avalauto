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
`sudo mv /avalauto /opt/`   

## Install  
change directory  
`cd /opt/avalauto`  
 * copy the extension    
`cp avalon_est.3r.sh ~/.config/argos/avalon_est.3r+.sh`  
 * copy the icon
`cp miner.svg ~/.icons/miner`
 * add a cronjob
`crontab -e`
  * add the line
    `0 * * * * /opt/avalauto/launcher.sh`      
make sure the scripts file are executable 
`chmod 755 *.sh`

## Setup
1. Activate argos in extension (just need to been for first use)
2. within Terminal (Ctrl + Alt + T)
   `cd /opt/avalauto`
   `./first.sh`
   (this is to store your credentials in an encrypted file, remember your new single use passphrase, you might need it sometimes)
3. still in terminal
   `./second.sh`
   (this is to give the ip address of the miner on your local network)  
## Run  
to test, run:
`./avalauto.sh`  

now you may have to log out and come back to see the extension appear in your top bar.
8. 
