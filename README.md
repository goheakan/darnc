# Debian Automation Repair & Clean
<p align="top">
  <img align="right" width="20%" alt="PNG" src="https://upload.wikimedia.org/wikipedia/commons/9/94/Debian_record_2013.PNG"/>
</p>
  The purpose of this script bash it's to put together all interesting commands to maintain stable a Debian Linux distribution and all sub-distributions (Ubuntu, Mint, etc...) <p align="right"> Click on me -------></p>

## What does it do ?

- Update the package lists, fix missing and broken packages
- Clear out the package files
- Make a full-upgrade to the packages
- Clean up the local trash of the user and the root
- Clean up the residues of uninstalled packages
- Remove the old kernel unused
- Clean up the inoperative snaps
- Clean up the independencies (dependencies unused by any packages)

## <img align="left" width="5%" alt="PNG" src="https://media.giphy.com/media/QAPQujznKdHeiX5V3w/giphy.gif"/> Before <img align="right" width="5%" alt="PNG" src="https://media.giphy.com/media/QAPQujznKdHeiX5V3w/giphy.gif"/>
  If you are affraid to use it, or not shure if it does what you expect, you can save and restore your system's configuration easly with **Timeshift** :
  > https://teejeetech.com/timeshift/ (with vidéo tuto)
  > **or**
  > https://github.com/teejee2008/timeshift

## How to use it ?
### ***Prerequired***
- Git :
```
sudo apt install git
```
### ***There is 2 ways to use it***

#### A\ Method - On An Ad Hoc Basis (Just one time)
  - 1\ Open a terminal (ctrl+alt+t)
  - 2\ Copy and past this commands
```
cd Documents/
git clone https://github.com/goheakan/darnc.git
cd darnc/
chmod +x darnc.sh
sudo su
cd ~/Documents/darnc/
./darnc.sh
```
#### B\ Method - Regular Basis (To use it everytime you want easly)
  - 1\ Open a terminal (ctrl+alt+t)
  - 2\ Copy and past this commands to make the Debian Automation Repair & Clean like a command and use it easly.
      - (You can change the name of the command, instead of 'darnc', with the 5th command)
```
git clone https://github.com/goheakan/darnc.git
cd darnc/
chmod +x darnc.sh
mv darnc.sh /usr/bin/darnc
cd ..
rm -rf darnc/
```
 - 3\ Don't forget to run this as root
```
sudo su
darnc
```

## Et voilà !
