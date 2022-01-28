# Debian Automation Repair & Clean

Script bash : Repairs some errors &amp; clean-up a Debian Linux distribution

## What does it do ?

- Update the package lists, fix missing and broken packages
- Clear out the package files
- Make a full-upgrade to the packages
- Clean up the local trash of the user and the root
- Clean up the residues of uninstalled packages
- Clean up the old kernel unused
- Clean up the inoperative snaps
- Clean up the independencies (dependencies unused by any packages)

## How to use it ?
You need to install git on yout debian machine
```
sudo apt install git
```
There is 2 ways to use it

### A\ Method - On An Ad Hoc Basis (Just one time)
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
### B\ Method - Regular Basis (To use it evertime you want easly)
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
