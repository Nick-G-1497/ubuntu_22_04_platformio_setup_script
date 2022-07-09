#!/bin/bash

RED="\033[0;31m";
BLUE="\033[34m"
NOCOLOR="\033[0m";
GREEN="\033[32m"

echo "=================================================================";
echo -e "${BLUE}Platformio - Setup Script for Ubuntu 22.02   (ver 1.2) ";
echo -e "${BLUE}      - written by Nick Goralka (7/9/22)    ${NOCOLOR}";
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
	then echo -e "${RED}Error [-] Need to be root"
          echo -e "${GREEN}      - Drive your damm computer like you mean it and sudo"
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
apt-get install sl; # steam locamotive command

# Install VSCode
apt-get install wget gpg;
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg;
install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/;
sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list';
rm -f packages.microsoft.gpg;

apt install apt-transport-https;
apt update;
apt install code; # or code-insiders

# Install drawio
wget https://github.com/jgraph/drawio-desktop/releases/download/v19.0.3/drawio-amd64-19.0.3.deb;
dpkg -i drawio-amd64-19.0.3.deb;
mv drawio-amd64-19.0.3.deb /tmp/;

# Install Segger SystemView
wget https://www.segger.com/downloads/systemview/SystemView_Linux_V332_x86_64.deb;
dpkg -i SystemView_Linux_V332_x86_64.deb;
mv SystemView_Linux_V332_x86_64.deb /tmp/;

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

# Exit message
clear;

echo -e "${GREEN}[-] All dependancies should be installed ${NOCOLOR}";
echo "Leave this window open and complete the following:";
echo "         - Open up Slack and sign in";
echo "         - Open up VSCode and sign into credentials for git";
echo "         - Install Platformio IDE Extension for VSCode ";
echo "         - Install Doxygen Documentation Generator Extension for VSCode";
echo "         - Install GitHub Pull Requests and Issues Extension for VSCode";
echo "         - Install C/C++ Extension Pack Extension for VSCode";
echo "         - Run 'sl' in a terminal (steam locamotive command)";
echo "         - Then you should be ready to go";

exit; 
