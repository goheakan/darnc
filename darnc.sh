#!/bin/bash
#LOG_FILE=/var/log/darnc_out.log
ERR_FILE=/var/log/darnc_err.log

#GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RED="\e[0;31m"
#BKGGREEN="\e[1;42m"
BKGBLUE="\e[1;44m"
ENDCOLOR="\e[0m"

echo_bold(){
  i=3
  while (( i > 0 )); do
    echo "|"
    (( i=i-1 ))
  done
}

chapter(){
  stars_number=35
  stars=""
  if [[ -n "$1" ]]; then
      chapter_name=$1
      (( len_chapter=${#chapter_name}/2 ))
      (( stars_number=stars_number - len_chapter ))
  else
    chapter_name=""
  fi
  while (( stars_number > 0 )); do
    new_star='─'
    stars="$stars$new_star"
    (( stars_number=stars_number-1 ))
  done
  echo -e "|${BLUE}${stars}${ENDCOLOR}${BKGBLUE}${chapter_name}${ENDCOLOR}${BLUE}${stars}${ENDCOLOR}"
}

main(){
  chapter
  echo -e "${BLUE}┌─>${ENDCOLOR} ${BKGBLUE}Welcome to DARNC (Debian Automation Repair & Clean)${ENDCOLOR}"
  echo -e "${BLUE}└────────────────────────────────────────────────>${ENDCOLOR} ${BKGBLUE}by Goheakan${ENDCOLOR}"
  chapter
  echo_bold
  chapter "Fix missing files, broken packages and dependencies"
  apt --fix-missing update 2>/dev/null && apt --fix-broken install 2>/dev/null && apt -f -y install 2>/dev/null
  echo_bold
  chapter "Clear out the package files"
  apt autoclean -y 2>/dev/null && apt autoremove -y 2>/dev/null
  echo_bold
  chapter "Full-upgrade the packages"
  apt full-upgrade -y 2>/dev/null
  echo_bold
  chapter "Clean up the local trash"
  apt autoclean -y 2>/dev/null && apt autoremove -y 2>/dev/null
  rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
  rm -rf /root/.local/share/Trash/*/** &> /dev/null
  echo_bold
  chapter "Clean up the residues of uninstalled packages"
  if [[ $(dpkg -l | grep ^rc) ]]; then
    dpkg -P "$(dpkg -l | awk '/^rc/' | tr -s ' ' | cut -d ' ' -f2)" 2>/dev/null
  else
    echo "No residues found."
  fi
  #[[ $(dpkg -l | grep ^rc) ]] && dpkg -P "$(dpkg -l | awk '/^rc/{print $2}')" || echo "Aucun résidu trouvé."
  echo_bold
  chapter "Clean up the old kernel unused"
  apt autoremove --purge -y 2>/dev/null
  echo_bold
  chapter "Clean up the inoperative snaps"
  snap list --all | awk '/désactivé|disabled/{print $1, $3}' | while read -r snapname revision; do snap remove "$snapname" --revision="$revision" 2>/dev/null; done
  echo_bold
  chapter "DARNC service is done !"
}


if [ "$USER" != root ]; then
  echo -e "${RED}[Auto-Install] : Need to run as root ! Use sudo please."
  echo -e "${YELLOW}[Auto-Install] : Exiting...${ENDCOLOR}"
  echo -e
  exit 0
else
  #exec 1> $LOG_FILE
  exec 2> $ERR_FILE
  main
fi
