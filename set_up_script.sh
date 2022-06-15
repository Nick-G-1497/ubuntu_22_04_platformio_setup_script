#!/bin/bash

RED="\033[0;31m";
BLUE="\033[34m"
NOCOLOR="\033[0m";
GREEN="\033[32m"

echo "=================================================================";
echo -e "${BLUE}Platformio - Setup Script for Ubuntu 22.02       ";
echo -e "${BLUE}      - Nick Goralka (6/15/22)      ${NOCOLOR}";
echo "=================================================================";


echo -e "${RED}
     \\XXXXXX//
      XXXXXXXX
     //XXXXXX\\                      OOOOOOOOOOOOOOOOOOOO
    ////XXXX\\\\                     OOOOOOOOOOOOOOOOOOOO
   //////XX\\\\\\     |||||||||||||||OOOOOOOOOOOOOOOVVVVVVVVVVVVV
  ////////\\\\\\\\    |!!!|||||||||||OOOOOOOOOOOOOOOOVVVVVVVVVVV'
 ////////  \\\\\\\\ .d88888b|||||||||OOOOOOOOOOOOOOOOOVVVVVVVVV'
////////    \\\\\\\d888888888b||||||||||||            'VVVVVVV'
///////      \\\\\\88888888888||||||||||||             'VVVVV'
//////        \\\\\Y888888888Y||||||||||||              'VVV'
/////          \\\\\\Y88888Y|||||||||||||| .             'V'
////            \\\\\\|iii|||||||||||||||!:::.            '
///              \\\\\\||||||||||||||||!:::::::.
//                \\\\\\\\           .:::::::::::.
/                  \\\\\\\\        .:::::::::::::::.
                    \\\\\\\\     .:::::::::::::::::::.
                     \\\\\\\\
${NOCOLOR}
"

echo "Please press enter to continue"
read response;

if [ "$EUID" -ne 0 ]
	then echo -e "${GREEN}Error [-] Need to be root"
          echo "       - Drive your damm computer like you mean it and sudo"
	exit
fi

# Make sure packages and repos are up to date
apt-get update;
apt-get upgrade;
apt autoremove;

# Install apt dependancies
apt-get install git;
apt-get install doxygen;
apt-get install python3;
apt-get install python3-venv;
apt-get install graphviz;
apt-get install curl;

# Install VSCode
apt-get install wget gpg;
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg;
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/;
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list';
rm -f packages.microsoft.gpg;

apt install apt-transport-https;
apt update;
apt install code; # or code-insiders

# Abscure python dependancies needed for the debugger
apt-get install libpython2.7;
apt-get install libatlas3-base;

# Get rid of braile display driver b/c it messes up devices mounting to /dev
apt remove brltty;

# Configure udev
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/master/scripts/99-platformio-udev.rules | sudo tee /etc/udev/rules.d/99-platformio-udev.rules;

service udev restart;

# Make user able to dialout on the USB port
usermod -a -G dialout $USER;
usermod -a -G plugdev $USER;

# Download Slack
snap install slack;
