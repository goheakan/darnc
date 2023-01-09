#!/bin/bash
#LOG_FILE=/var/log/darnc_out.log
ERR_FILE=/var/log/darnc_err.log
darnc_version="v1.0"
darnc_year="2023"
github_darnc_version=$(w3m https://github.com/goheakan/darnc/blob/master/README.md | awk '/Debian Automation Repair & Clean : DARNC/ {print $8}' | head -1)

#Variables Colors
#GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
RED="\e[0;31m"
#BKGGREEN="\e[1;42m"
BKGBLUE="\e[1;44m"
ENDCOLOR="\e[0m"

#The tricks to work the notification in root
Notify_User(){
    sudo -u "${SUDO_USER}" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "${SUDO_USER}")/bus notify-send "$1" "$2"
}

echo_bold(){
  echo -e "|\n|\n|"
}

#The display in terminal mode
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

#Function to check and do the update
Darnc_Update(){
    if [[ ${github_darnc_version} > ${darnc_version} ]]; then
        #ask to the user if he wants to update
        if zenity --question --text "A new version of DARNC is available. Do you want to upgrade it now ?"; then
            Notify_User "DARNC" "DARNC is going to update."
            #create a file to do the update
        #
    #
#
cat > /tmp/darnc_update << EOF
    #!/bin/bash
    #mise à jour de darnc
    exec 2> $/var/log/darnc_update_err.log

    git clone https://github.com/goheakan/darnc.git /tmp/  && chmod +x /tmp/darnc/darnc.sh && mv /tmp/darnc/darnc.sh /usr/bin/darnc && rm -rf /tmp/darnc/

    sudo -u "${SUDO_USER}" DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u "${SUDO_USER}")/bus notify-send "DARNC" "DARNC is updated."

    darnc
    rm /tmp/darnc_update
    exit 0
EOF
#
    #
        #
            #
            bash /tmp/darnc_update
            exit 0
        fi
    fi
}

main(){
  chapter
  echo -e "${BLUE}┌─>${ENDCOLOR} ${BKGBLUE}Welcome to DARNC ${darnc_version} [${darnc_year}]${ENDCOLOR}"
  echo -e "${BLUE}└────────>${ENDCOLOR} ${BKGBLUE}(Debian Automation Repair & Clean) by Goheakan${ENDCOLOR}"
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
  echo -e "${RED}[DARNC] : Need to run as root ! Use sudo please."
  echo -e "${YELLOW}[DARNC] : Exiting...${ENDCOLOR}"
  echo -e
  exit 0
else
  #exec 1> $LOG_FILE
  exec 2> $ERR_FILE
  Darnc_Update
  main
  exit 0
fi
