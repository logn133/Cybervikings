#!/bin/bash
###This script obtains the following:
#Machine Name
#Machine Use
#listening ports on mahcine TCP/UDP
#Installed programs 
#Hosts File
#Firewall status
#Processes
#installed drivers
#Firewall rules

#Check to see if the directories exsist
if [ ! -d "./Reports" ]; then
  mkdir ./Reports/
  mkdir ./Reports/Individuals/
fi
#Get agent name
printf "Please enter your name: "
read agentName

#Get Machine purpose
printf "\nPlease enter the purpose of this machine: "
read machinePurpose

#Get Time
time=`date +%d%m%Y%H%M%S`

#Write File header
printf "\n\nReport generated at: ${time}\nBy $agentName\nMachine Name: $HOSTNAME\nMachine Purpose: $machinePurpose\n\n" | tee -a "./Reports/Report_${time}.txt"

#Get network stats
connections=`sudo netstat -ano`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                    Netstat                    =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${connections}" >> "./Reports/Individuals/netstat.txt" 
echo "${connections}" | tee -a "./Reports/Report_${time}.txt"

#Get Installed programs using compgen
CGPrograms=`sudo compgen -c`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                   Programs                    =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${CGPrograms}" >> "./Reports/Individuals/CGPrograms.txt" 
echo "${CGPrograms}" | tee -a "./Reports/Report_${time}.txt"

#Get installed packages
packages=`sudo dpkg -l`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                   Packages                    =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${packages}" >> "./Reports/Individuals/packages.txt" 
echo "${packages}" | tee -a "./Reports/Report_${time}.txt"

#Get Installed repositories
repositories=`sudo apt-cache policy`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=               Package sources                 =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${repositories}" >> "./Reports/Individuals/packageSource.txt" 
echo "${repositories}" | tee -a "./Reports/Report_${time}.txt"

#Get installed repositories source
REPSource=`sudo grep -Erh ^deb /etc/apt/sources.list*`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                 Repositories                  =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${REPSource}" >> "./Reports/Individuals/Repositories.txt" 
echo "${REPSource}" | tee -a "./Reports/Report_${time}.txt"

#Get hosts file
hosts=`sudo cat /etc/hosts`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                  Hosts File                   =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${hosts}" >> "./Reports/Individuals/hosts.txt" 
echo "${hosts}" | tee -a "./Reports/Report_${time}.txt"

#Get resolv.conf file
resolvconf=`sudo cat /etc/resolv.conf`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                 Resolv.conf                   =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${resolvconf}" >> "./Reports/Individuals/resolvconf.txt" 
echo "${resolvconf}" | tee -a "./Reports/Report_${time}.txt"

#Get firewall rules
firewallRules=`sudo iptables -L -n`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                Firewall Rules                 =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${firewallRules}" >> "./Reports/Individuals/firewallRules.txt" 
echo "${firewallRules}" | tee -a "./Reports/Report_${time}.txt"

#Get process tree
pstree=`sudo pstree`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                 Process Tree                  =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${pstree}" >> "./Reports/Individuals/ProcessTree.txt" 
echo "${pstree}" | tee -a "./Reports/Report_${time}.txt"

#Get processes with initial command and user
psinfo=`ps -efl`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                 Process Info                  =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${psinfo}" >> "./Reports/Individuals/processInfo.txt" 
echo "${psinfo}" | tee -a "./Reports/Report_${time}.txt"

#Get a list of installed drivers
drivers=`sudo lsmod`
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
echo "=                    Drivers                    =" | tee -a "./Reports/Report_${time}.txt"
echo "=================================================" | tee -a "./Reports/Report_${time}.txt"
printf "\n\nReport generated on: ${time}\nBy ${agentName}\n\n${drivers}" >> "./Reports/Individuals/drivers.txt" 
echo "${drivers}" | tee -a "./Reports/Report_${time}.txt"
