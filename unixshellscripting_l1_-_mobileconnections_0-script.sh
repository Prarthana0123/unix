

#!/bin/bash

DIR=`pwd`
File_Name=`echo $1 | awk -F'/' '{print $NF}'`
touch name.txt
filename="name.txt"
line=`wc -l $filename | awk '{print $1}'`
regex_filter='[^a-zA-Z_0-9\s]'
ZERO=0
D=500

if [ "$line" -eq "$ZERO" ]; then

	echo "CustId":"AgentId":"GSMName":"MobileNo":"NoOfConn":"Bonus">>"$filename"

fi
PS3='Please enter your choice: '
options=("Creation of file" "Bonus calculation" "Report" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Creation of file")

	while
        	read -p "Please enter the CustID : " CustID
        	[[ -z "$CustID" ]] || [[ ${#CustID} -lt 2 ]] || [[ ${#CustID} -gt 15 ]] || [[ "$CustID" =~ $regex_filter ]]
	do
        	echo "Your entry must not contain special characters and its length must do between 2-15 characters."
	done
	
	read -p "Please enter the AgentID : " AgentID
	
	read -p "Please enter the GSMName : " GSMName
       GSM=('Airtel' 'Hutch' 'BSNL' 'Spice')
        while [[ ! $GSMName =~ $GSM ]]
        do
                echo "Your entry should be either Airtel or Hutch or BSNL or Spice."
                read -p "Please enter the GSMName : " GSMName
        done
	

	read -p "Please enter MobileNo: " MobileNo
        pat="^[0-9]{10}$"
        while [[ ! $MobileNo =~ $pat ]]
        do
                echo "Your entry should be as XXXXXXXXXX: "
		read -p "Please enter MobileNo: " MobileNo
        done
	read -p "Please enter the NoOfConn: " NoOfConn

	read -p "Please enter the Bonus: " Bonus
	
	echo "$CustID":"$AgentID":"$GSMName":"$MobileNo":"$NoOfConn":"$Bonus">>"$filename"

            ;;
        "Bonus calculation")
            
        while
                read -p "Please enter the CustID : " CustID
                [[ -z "$CustID" ]] || [[ ${#CustID} -lt 2 ]] || [[ ${#CustID} -gt 15 ]] || [[ "$CustID" =~ $regex_filter ]]
        do
                echo "Your entry must not contain special characters and its length must do between 2-15 characters."
        done

        read -p "Please enter the AgentID : " AgentID

	read -p "Please enter the GSMName : " GSMName
       GSM=('Airtel' 'Hutch' 'BSNL' 'Spice')
        while [[ ! $GSMName =~ $GSM ]]
        do
                echo "Your entry should be either Airtel or Hutch or BSNL or Spice."
                read -p "Please enter the GSMName : " GSMName
        done
	
	pat="^[0-9]{10}$"
	while 
		read -p "Please enter MobileNo: " MobileNo
		[[ ! $MobileNo =~ $pat ]]
    	do
   	 	echo "Your entry should be as XXXXXXXXXX: "
		read -p "Please enter MobileNo: " MobileNo
	
	done
	 read -p "Please enter the NoOfConn: " NoOfConn


        Bonus=$(($NoOfConn*$D))
	

        echo "$CustID":"$AgentID":"$GSMName":"$MobileNo":"$NoOfConn":"$Bonus">>"$filename"
            ;;
        "Report")
        
	Connection=`awk -F ":" 'BEGIN{a=0}{if ($5>0+a) a=$5} END{print a}' $filename`    
	Agent=`awk -F ":" '$5 == '$Connection' {print $2} ' $filename`
	echo "The agent having maximum number of connections $Connection is $Agent"
	awk -F ":" '$2 == '$Agent' {print $1":"$2":"$3":"$4":"$5} ' $filename
	;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
