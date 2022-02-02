#!/bin/bash
#LOG_FILE=/var/log/darnc_out.log
ERR_FILE=/var/log/darnc_err.log
#exec 1> $LOG_FILE
exec 2> $ERR_FILE


bold=$(tput bold)
normal=$(tput sgr0)
echo_bold(){
  for i in $(seq 3); do
    printf "${bold}|\n"
  done
}


main(){
  echo "${bold}*********************************************************************"
  echo "${bold}**              Welcome to the 🅓🅐🅡🅝🅒's service                  **"
  echo "${bold}**                      by ⒼⓄⒽⒺⒶⓀⒶⓃ                           **"
  echo "${bold}*********************************************************************"
  echo_bold
  echo "${bold}| Update, the package lists, fix missing and broken packages :${normal}"
  apt --fix-missing update 2>/dev/null && apt --fix-broken install 2>/dev/null  && apt -f -y install 2>/dev/null
  echo_bold
  echo "${bold}| Clear out the package files :${normal}"
  apt autoclean -y 2>/dev/null && apt autoremove -y 2>/dev/null
  echo_bold
  echo "${bold}| Full-upgrade the packages :${normal}"
  apt full-upgrade -y 2>/dev/null
  echo_bold
  echo "${bold}| Clean up the local trash :${normal}"
  apt autoclean -y 2>/dev/null && apt autoremove -y 2>/dev/null
  rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
  rm -rf /root/.local/share/Trash/*/** &> /dev/null
  echo_bold
  echo "${bold}| Clean up the residues of uninstalled packages :${normal}"
  [[ $(dpkg -l | grep ^rc) ]] && dpkg -P "$(dpkg -l | awk '/^rc/{print $2}')" || echo "No residues found."
  echo_bold
  echo "${bold}| Clean up the old kernel unused :${normal}"
  apt autoremove --purge -y 2>/dev/null
  echo_bold
  echo "${bold}| Clean up the inoperative snaps :${normal}"
  snap list --all | awk '/désactivé|disabled/{print $1, $3}' | while read -r snapname revision; do snap remove "$snapname" --revision="$revision"; done
  echo_bold
  echo "${bold}| Clean up the independencies :${normal}"
  apt purge "$(dpkg -l | awk '/^rc/{print $2}')" -y 2>/dev/null
  echo_bold
  echo "${bold}| The 🅓🅐🅡🅝🅒's service is done !${normal}"
}


YELLOW="\033[1;33m"
RED="\033[0;31m"
ENDCOLOR="\033[0m"
if [ "$USER" != root ]; then
  echo -e $RED"[DARNC] : Need to run as root !"
  echo -e $YELLOW"[DARNC] : Exiting..."$ENDCOLOR
  echo -e
  exit 0
else
  main
fi
