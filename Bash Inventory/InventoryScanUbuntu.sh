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
echo "--------------------------------------------------------" | tee -a "./$today-$Scan.txt"
echo "-                  System Inventory                    -" | tee -a "./$today-$Scan.txt"   		  	#print title
echo "--------------------------------------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Date Created: $today" | tee -a "./$today-$Scan.txt"
echo "Created By: $agent" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee -a "./$today-$Scan.txt"
echo "-            Operating System Information              -" | tee -a "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
operatingSystem=$(lsb_release -dc)
echo "$operatingSystem" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
services=$(systemctl list-units --type=service --state=running)
echo "Running Services" | tee -a "./$today-$Scan.txt"
echo "----------------" | tee -a "./$today-$Scan.txt"
echo "$services" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Installed Services" | tee -a "./$today-$Scan.txt"
echo "-----------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
systemctl list-unit-files --type=service | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Installed Software Packages" | tee -a "./$today-$Scan.txt"
echo "---------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
dpkg -l|sed 1,3d | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Running Processes" | tee -a "./$today-$Scan.txt"
echo "-----------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
pstree -pnh | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
users=$(getent passwd) | tee -a "./$today-$Scan.txt"
systemUsers=$(getent passwd | grep -vwFf /etc/shells |awk -F: '{printf("%s:%s\n",$1,$3)}')
standardUsers=$(getent passwd | grep -wFf /etc/shells |awk -F: '{printf("%s:%s\n",$1,$3)}')
echo | tee -a "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee -a "./$today-$Scan.txt"
echo "-                    User Information                  -" | tee -a "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "     System Users      " | tee -a "./$today-$Scan.txt"
echo "-----------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "System User Accounts List (Username:UID)" | tee -a "./$today-$Scan.txt"
echo "----------------------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "$systemUsers" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
shellsCount=$(getent passwd | grep -vwFf /etc/shells|wc -l)
echo "Total System User Accounts: $shellsCount" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "    Standard Users    " | tee -a "./$today-$Scan.txt"
echo "----------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Standard User Account List (Username:UID)" | tee -a "./$today-$Scan.txt"
echo "-----------------------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "$standardUsers" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
totalStandard=$(echo "$standardUsers" | wc -l)
echo "Total Standard User Accounts: $totalStandard" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
totalUsers=$(echo "$users" | wc -l)
echo "Total Users: $totalUsers" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Group Memberships by User" | tee -a "./$today-$Scan.txt"
echo "-------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
cat /etc/passwd | awk -F':' '{ print $1}' | xargs -n1 groups | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Logged In Users" | tee -a "./$today-$Scan.txt"
echo "---------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
w | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Last Login of Each User" | tee -a "./$today-$Scan.txt"
echo "-----------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
lastlog | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee -a "./$today-$Scan.txt"
echo "-               Networking  Information                -" | tee -a "./$today-$Scan.txt"
echo "--------------------------------------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
ipAddress(){
 | tee -a "./$today-$Scan.txt"
  adapterName=$(sudo /sbin/ip route get 8.8.8.8 | awk '{ print $5; exit }')
  longIPAddress=$(sudo /sbin/ip route get 8.8.8.8 | awk '{ print $7 }') 	#find internal IPAddress
  _ipAddress=$(echo "$longIPAddress" | awk '{$1=$1};1')                 	#remove trailing space from longIPAddress
  ipAddress=$(hostname -I)													#confirm internal IP Address
  extipAddress=$(curl -s ifconfig.me/ip)									#pull external IP Address from website
  dfGateway=$(sudo /sbin/ip route get 8.8.8.8 | awk '{ print $3; exit }')	#find the default gateway
  macAddress=$(ip link show "$adapterName"|sed 1d |awk '{print $2}')

  echo "Adapter Name: $adapterName" | tee -a "./$today-$Scan.txt"
  echo "Default Gateway: $dfGateway" | tee -a "./$today-$Scan.txt"
  echo "IP Address: $_ipAddress" | tee -a "./$today-$Scan.txt"
  echo "Internal IP Address: $longIPAddress" | tee -a "./$today-$Scan.txt"
  echo "External IP Address: $extipAddress" | tee -a "./$today-$Scan.txt"
  echo "MAC Address: $macAddress" | tee -a "./$today-$Scan.txt"
}
ipAddress | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
nmap --iflist |sed 1,2d | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Routing Table" | tee -a "./$today-$Scan.txt"
echo "-------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
ip route show all | tee -a "./$today-$Scan.txt"				  							#Get the routing table
echo | tee -a "./$today-$Scan.txt"
echo "Interface Statistics" | tee -a "./$today-$Scan.txt"
echo "--------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
ip -s link | tee -a "./$today-$Scan.txt"            		  							#Get interface statistics
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Ports & Services" | tee -a "./$today-$Scan.txt"
echo "----------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
ports=$(nmap -p 1-65535 -sV "$ipAddress"|sed 1,3d)
echo "$ports" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Listening Ports" | tee -a "./$today-$Scan.txt"
echo "---------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
ss -taulpe | tee -a "./$today-$Scan.txt"													#Get tcp,udp,listening,process id's,numeric ports
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Open Network Sockets" | tee -a "./$today-$Scan.txt"
echo "--------------------" | tee -a "./$today-$Scan.txt"
lsof -i	| tee -a "./$today-$Scan.txt"				  									#List open socket files
echo | tee -a "./$today-$Scan.txt"
echo "Network Stat's by Protocol" | tee -a "./$today-$Scan.txt"
echo "--------------------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
ss -s	| tee -a "./$today-$Scan.txt"			  										#Get network statistics by protocol
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "Firewall Rules" | tee -a "./$today-$Scan.txt"
echo "--------------" | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
iptables -L	| tee -a "./$today-$Scan.txt"												#List all firewall rules
echo | tee -a "./$today-$Scan.txt"
echo | tee -a "./$today-$Scan.txt"
echo "'/etc/hosts' File Contents" | tee -a "./$today-$Scan.txt"
echo "--------------------------" | tee -a "./$today-$Scan.txt"
echo  | tee -a "./$today-$Scan.txt"
cat /etc/hosts	| tee -a "./$today-$Scan.txt"											#Read the /etc/hosts file
                                              #Adds the script to be run from cron every 30 mins if not being run in checkup mode
