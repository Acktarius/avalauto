# avalauto
Go fetch info in your Avalon Bitcoin Miner *and probably compatible with other miners since all the manufacturers are pretty much using the same interface*     
Thanks to this top bar extensions you'll monitor your Avalon Bitcoin miner status in just one click !  

## Disclaimer  
this script is delivered “as is” and I deny any and all liability for any damages arising out of using this script   

## Acknoledgment
Huge thanks to [Bitbar](https://github.com/matryer/bitbar) and [@p-e-w](https://github.com/p-e-w/argos) for creating the argos repositories  

## For who ?
**Ubuntu** users, running an **Avalon** miner on the same local network.  
*(probably works on other Debian, not tested)*  

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
within terminal ~$  (Ctrl + Alt + T)
`git clone https://github.com/Acktarius/avalauto.git`  
mv the downloaded directory to /opt  
`sudo mv /avalauto /opt/`   

## Install  
change directory  
`cd /opt/avalauto`  
 * copy the extension script  
`cp avalon_ext.3r+.sh ~/.config/argos/avalon_ext.3r+.sh`  
 * copy the icon
`cp miner.svg ~/.icons/miner`
 * add a cronjob to run every 30minutes
`crontab -e`
   * add the line and save (CTRL + S and CTRL + X)   
    `0,30 * * * * /opt/avalauto/launcher.sh`      
 * make sure the scripts files are executable  
`chmod 755 *.sh`

## Setup
1. Activate argos in extension (new icon on your launch pad)(just need to been for first use)  
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
it runs for 2minutes, and then runs 2minutes every 30 minutes, the date in the extension turns <span color='#ff7f50'>orange</span> if it did not receive input for more than 1/2hour.   
you can click on **Run Script** if you wnat to refresh. (no more need of the terminal).    
*(now you may have to log out and come back to see the extension appear in your top bar.)*  
  
---
  
## Contact
https://discord.gg/tw3wWR3q  
