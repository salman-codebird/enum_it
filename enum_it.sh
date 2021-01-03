#! /bin/bash
day=$(date +%A)
red=$(tput setaf 1;)
blue=$(tput setaf 4;)
reset=$(tput sgr 0;)
#bannner
banner()
{
echo -e "\n${blue}	
\n _________  ____    ___  ___       ___  ___      ___   _________  ______________
\n|         ||    |  |   ||   |     |   ||   |    |   | |         ||              |
\n|   ______||    \  |   ||   |     |   ||   |    |   | |___   ___||____     _____|
\n|  |___    |     \ |   ||   |     |   ||   |    |   |    |   |        |   |
\n|  |   |   |      \|   ||   |     |   ||    \  /    |    |   |        |   | 
\n|  |___|   |   |\      ||   |     |   ||     \/     |    |   |        |   |
\n|  |______ |   | \     ||    \___/    ||            |  __|   |__      |   |
\n|         ||   |  \    ||             ||   |\  /|   | |         |     |   |
\n _________||___|   \___| \___________/ |___| \/ |___| |_________|     |___|
\n______________________________# Coded by salman______________________________${reset}\n"

}
#greeting message
greeting()
{
echo -e "\nWelcome $USER! Today is $day. \nYou are using $SHELL shell for shell scripting."
}
#thankyou
thanku()
{
echo -e "\n-------------------------------------THANK YOU!!!-------------------------------------"
}
#reading a domain
read_dom()
{
	read -p "Please enter a domain:  " dom
}
#dns enumeration.Finding all dns records
dns_enum()
{
for rec in A AAAA MX CNAME TXT; do	
	echo "------------------------"
	echo "$rec Record of $dom" 
		dig $dom $rec +short
	echo "------------------------"
done
}
#dns enumeration from a file
file_enum()
{
	while read value; do
	
		for rec in A AAAA MX CNAME TXT; do
	
			echo "------------------------"
			echo "$rec Record of $value" 
				dig $value $rec +short
			echo "------------------------"
		done
		echo "+++++++++++++++++++++++++++++++++++++++++++++$value completed+++++++++++++++++++++++++++++++++++++++++++++"
	done < domain_names.txt
}
#case statement provide options to select
case_stat()
{
	if [[ -z $dom ]]; then
		echo -e "${red}Error!\nPlease provide a domain name to execute. ${reset} \nEg: example.com"
	else
		echo -e "\n[1] Check IPv4\n[2] Check IPv6\n[3] Check CNAME\n[4] Check MX\n[5] Check TXT\n[6] All DNS Informations\n[7] Find All Subdomains [Using sublist3r]\n[8] Find Alive Subdomains\n"
		read -p "Please select an option: " opt
		case $opt in
			1 )
			ipv4=$(dig $dom A +short)
			echo -e "ipv4 of $dom \n____________________________________________\n$ipv4"
				;;
			2 )
			ipv6=$(dig $dom AAAA +short)
			echo -e "ipv6 of $dom \n____________________________________________\n$ipv6"
				;;
			3 )
			cname=$(dig $dom CNAME +short)
			echo -e "CNAME of $dom \n____________________________________________\n$cname"
				;;			
			4 )
			mx=$(dig $dom MX +short)
			echo -e "MX of $dom \n____________________________________________\n$mx"
				;;
			5 )
			txt=$(dig $dom TXT +short)
			echo -e "TXT of $dom \n____________________________________________\n$txt"
				;;
			6 )
			dns_enum
				;;
			7 )
			sublist3r -d $dom -o ${dom}_subs.txt
			count=$(cat ${dom}_subs.txt | wc -l)
			echo -e "\n${red}[-] Total Subdomains Found: $count\n[-] Saving results to file: ${dom}_subs.txt ${reset}\n"	
				;;
			8 )
			sublist3r -d $dom -o ${dom}_subs.txt
			cat ${dom}_subs.txt | httprobe > alive.txt
			while read url; do
				echo ${url#*//} >> urls.txt
			done < alive.txt
			sort -u urls.txt > ${dom}_alive_subs.txt
			count=$(cat ${dom}_alive_subs.txt | wc -l)
			echo -e "\nAlive subdomains\n________________________\n"
			cat ${dom}_alive_subs.txt
			echo -e "\n${red}[-] Total Alive Subdomains Found: $count\n[-] Saving results to file: ${dom}_alive_subs.txt ${reset}\n"
			rm alive.txt
			rm urls.txt  
				;;
		esac
	fi
	quit_check
}
#changing domain
case_change_dom()
{
	read_dom
	case_stat

}
#checking for quit
quit_checking()
{
read -p "1. Continue       2. Change domain       3. Quit       " check 
if [[ $check == 2 ]]; then
	case_change_dom	
fi
until [[ $check == 3 ]]; do
	case_stat
done
}
quit_check()
{
read -p "[1] Continue With Same Domain      [2] Change Domain       [3] Quit       " check 
if [[ $check == 1 ]]; then
	case_stat
elif [[ $check == 2 ]]; then
		case_change_dom
elif [[ check == 3 ]]; then
		echo ""	
fi
}
#main script
banner
greeting
read_dom
case_stat
thanku
