#!/bin/bash
today="$(date)"
ipAddress=$(hostname -I)												#confirm internal IP Address
read -p "Agent Name: " agent		  										#Ask for agent name
scan=""
if ["$0" == "-c"] || ["$0" == "-C"]; then
  $Scan = "Checkup-Scan"
else
  $Scan = "Base-Scan"
  crontab -l >> SetScanCron
  dir=$(pwd)
  echo "30 * * * * bash $dir/CheckUp.sh" >> SetScanCron
  crontab SetScanCron
  rm SetScanCron
  echo "--------------------------------------------------------"
  echo "-               Added Script to Cron Job               -"
  echo "--------------------------------------------------------"
fi
echo "--------------------------------------------------------" | tee "./$today-$Scan.txt"
echo "-                  System Inventory                    -" | tee "./$today-$Scan.txt"   		  	#print title
echo "--------------------------------------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Date Created: $today" | tee "./$today-$Scan.txt"
echo "Created By: $agent" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee "./$today-$Scan.txt"
echo "-            Operating System Information              -" | tee "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
operatingSystem=$(lsb_release -dc)
echo "$operatingSystem" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
services=$(systemctl list-units --type=service --state=running)
echo "Running Services" | tee "./$today-$Scan.txt"
echo "----------------" | tee "./$today-$Scan.txt"
echo "$services" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Installed Services" | tee "./$today-$Scan.txt"
echo "-----------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
systemctl list-unit-files --type=service | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Installed Software Packages" | tee "./$today-$Scan.txt"
echo "---------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
dpkg -l|sed 1,3d | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Running Processes" | tee "./$today-$Scan.txt"
echo "-----------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
pstree -pnh | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
users=$(getent passwd) | tee "./$today-$Scan.txt"
systemUsers=$(getent passwd | grep -vwFf /etc/shells |awk -F: '{printf("%s:%s\n",$1,$3)}')
standardUsers=$(getent passwd | grep -wFf /etc/shells |awk -F: '{printf("%s:%s\n",$1,$3)}')
echo | tee "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee "./$today-$Scan.txt"
echo "-                    User Information                  -" | tee "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "     System Users      " | tee "./$today-$Scan.txt"
echo "-----------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "System User Accounts List (Username:UID)" | tee "./$today-$Scan.txt"
echo "----------------------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "$systemUsers" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
shellsCount=$(getent passwd | grep -vwFf /etc/shells|wc -l)
echo "Total System User Accounts: $shellsCount" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "    Standard Users    " | tee "./$today-$Scan.txt"
echo "----------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Standard User Account List (Username:UID)" | tee "./$today-$Scan.txt"
echo "-----------------------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "$standardUsers" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
totalStandard=$(echo "$standardUsers" | wc -l)
echo "Total Standard User Accounts: $totalStandard" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
totalUsers=$(echo "$users" | wc -l)
echo "Total Users: $totalUsers" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Group Memberships by User" | tee "./$today-$Scan.txt"
echo "-------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
cat /etc/passwd | awk -F':' '{ print $1}' | xargs -n1 groups | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Logged In Users" | tee "./$today-$Scan.txt"
echo "---------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
w | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Last Login of Each User" | tee "./$today-$Scan.txt"
echo "-----------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
lastlog | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee "./$today-$Scan.txt"
echo "-               Networking  Information                -" | tee "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
ipAddress(){
 | tee "./$today-$Scan.txt"
  adapterName=$(sudo /sbin/ip route get 8.8.8.8 | awk '{ print $5; exit }')
  longIPAddress=$(sudo /sbin/ip route get 8.8.8.8 | awk '{ print $7 }') 	#find internal IPAddress
  _ipAddress=$(echo "$longIPAddress" | awk '{$1=$1};1')                 	#remove trailing space from longIPAddress
  ipAddress=$(hostname -I)													#confirm internal IP Address
  extipAddress=$(curl -s ifconfig.me/ip)									#pull external IP Address from website
  dfGateway=$(sudo /sbin/ip route get 8.8.8.8 | awk '{ print $3; exit }')	#find the default gateway
  macAddress=$(ip link show "$adapterName"|sed 1d |awk '{print $2}')

  echo "Adapter Name: $adapterName" | tee "./$today-$Scan.txt"
  echo "Default Gateway: $dfGateway" | tee "./$today-$Scan.txt"
  echo "IP Address: $_ipAddress" | tee "./$today-$Scan.txt"
  echo "Internal IP Address: $longIPAddress" | tee "./$today-$Scan.txt"
  echo "External IP Address: $extipAddress" | tee "./$today-$Scan.txt"
  echo "MAC Address: $macAddress" | tee "./$today-$Scan.txt"
}
ipAddress | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
nmap --iflist |sed 1,2d | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Routing Table" | tee "./$today-$Scan.txt"
echo "-------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
ip route show all | tee "./$today-$Scan.txt"				  							#Get the routing table
echo | tee "./$today-$Scan.txt"
echo "Interface Statistics" | tee "./$today-$Scan.txt"
echo "--------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
ip -s link | tee "./$today-$Scan.txt"            		  							#Get interface statistics
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Ports & Services" | tee "./$today-$Scan.txt"
echo "----------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
ports=$(nmap -p 1-65535 -sV "$ipAddress"|sed 1,3d)
echo "$ports" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Listening Ports" | tee "./$today-$Scan.txt"
echo "---------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
ss -taulpe | tee "./$today-$Scan.txt"													#Get tcp,udp,listening,process id's,numeric ports
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Open Network Sockets" | tee "./$today-$Scan.txt"
echo "--------------------" | tee "./$today-$Scan.txt"
lsof -i	| tee "./$today-$Scan.txt"				  									#List open socket files
echo | tee "./$today-$Scan.txt"
echo "Network Stat's by Protocol" | tee "./$today-$Scan.txt"
echo "--------------------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
ss -s	| tee "./$today-$Scan.txt"			  										#Get network statistics by protocol
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "Firewall Rules" | tee "./$today-$Scan.txt"
echo "--------------" | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
iptables -L	| tee "./$today-$Scan.txt"												#List all firewall rules
echo | tee "./$today-$Scan.txt"
echo | tee "./$today-$Scan.txt"
echo "'/etc/hosts' File Contents" | tee "./$today-$Scan.txt"
echo "--------------------------" | tee "./$today-$Scan.txt"
echo  | tee "./$today-$Scan.txt"
cat /etc/hosts	| tee "./$today-$Scan.txt"											#Read the /etc/hosts file
                                              #Adds the script to be run from cron every 30 mins if not being run in checkup mode
