#!/bin/bash 
show_menu()
{
    NORMAL=`echo "\033[m"`
    MENU=`echo "\033[36m"` #Blue
    NUMBER=`echo "\033[33m"` #yellow
    FGRED=`echo "\033[41m"`
    RED_TEXT=`echo "\033[31m"`
    ENTER_LINE=`echo "\033[33m"`
    echo -e "${MENU}**********************APP MENU***********************${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1) ${MENU} 1a) Is the number of petitions with Data Engineer job title increasing over time? ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 1b) ${MENU} 1b) Find top 5 job titles who are having highest avg growth in applications.[ALL] [no sub menu is required] ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2a)${MENU} 2a) Which part of the US has the most Data Engineer jobs for each year? ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 2b)${MENU} 2b) find top 5 locations in the US who have got certified visa for each year.[certified] [sub menu - year option is required] ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 3)${MENU} 3) Which industry(SOC_NAME) has the most number of Data Scientist positions? [certified] [no sub menu is required] ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 4)${MENU} 4) Which top 5 employers file the most petitions each year? - Case Status - ALL [sub menu - year option is required] ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 5a)${MENU} 5a) Find the most popular top 10 job positions for H1B visa applications for each year? a) for all the applications [second sub menu - year option is required]${NORMAL}"
    echo -e "${MENU}**${NUMBER} 5b)${MENU} 5b) Find the most popular top 10 job positions for H1B visa applications for each year?
b) for only certified applications [second sub menu - year option is required] ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 6)${MENU} 6) Find the percentage and the count of each case status on total applications for each year. Create a line graph depicting the pattern of All the cases over the period of time. [no sub menu is required] ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 7)${MENU} 7) Create a bar graph to depict the number of applications for each year [All] [no sub menu is required] ${NORMAL}"
    
    echo -e "${MENU}**${NUMBER} 8)${MENU} 8) Find the average Prevailing Wage for each Job for each Year (take part time and full time separate). Arrange the output in descending order - [Certified and Certified Withdrawn.] [Top 20 only required] [first sub menu - full time OR part time] [second sub menu - year option is required] ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 9)${MENU} 9) Which are the employers along with the number of petitions who have the success rate more than 70%  in petitions. (total petitions filed 1000 OR more than 1000) ? Display the values in descending order of success rate.[no sub menu is required] ${NORMAL}"
    echo -e "${MENU}**${NUMBER} 10)${MENU} 10) Which are the  job positions along with the number of petitions which have the success rate more than 70%  in petitions (total petitions filed 1000 OR more than 1000)? Display the values in descending order of success rate.[no sub menu is required] ${NORMAL}"
     echo -e "${MENU}**${NUMBER} 11)${MENU} 11) Export result for question no 10 to MySql database ${NORMAL}"
     echo -e "${MENU}*********************************************${NORMAL}"
     echo -e "${ENTER_LINE}Please enter a menu option and enter or ${RED_TEXT}enter to exit. ${NORMAL}"
     read opt
}
function option_picked() 
{
    COLOR='\033[01;31m' # bold red
    RESET='\033[00;00m' # normal white
    MESSAGE="$1"  #modified to post the correct option selected
    echo -e "${COLOR}${MESSAGE}${RESET}"
}

function getpinCodeBank(){
	echo "in getPinCodebank"
	echo $1
	echo $2
	#hive -e "Select * from AppData where PinCode = $1 AND Bank = '$2'"
}

clear
show_menu
while [ opt != '' ]
    do
    if [[ $opt = "" ]]; then 
            exit;
    else
        case $opt in
        1a) clear;
	option_picked "Selected program is 1a";
	   echo "Enter output path"
        read path
        echo "You've selected ${path}"
	
        hadoop jar /home/hduser/1aproject.jar h1b.Q1A /H1bproject/h1b_final /projectoutput/$path
        hadoop fs -cat /projectoutput/$path/p*
        hadoop fs -rm -r /projectoutput/$path
        show_menu;     
        ;;

        1b) clear;
         option_picked "Selected program is 1b";
    
                echo "Top 5 Job Positions having highest average growth" 
		


		pig -x local /home/hduser/h1b1b.pig
		
		show_menu;
      	        
        ;;
    
        
        2a) clear;
	option_picked "Selected program is 2a";
       echo "Worksite has most Data Engineer jobs for each year"                                        	

		hive -e "select * from h1bproject.site a where most in (select max(most) from h1bproject.site b where b.year=a.year) order by a.year"
                    
		show_menu;
		;;	

       2b) clear;
	option_picked "Selected program is 2b";
       echo "Top 5 locations in the US who have got certified visa for each year"
		hive  -e "select count(worksite) as tot,worksite,case_status,year from h1bproject.h1b_final where case_status='CERTIFIED' and year=2016 group by worksite,case_status,year order by tot desc limit 5;;"
		
		show_menu;


		;;

    
        3) clear;
	option_picked "Selected program is 3";
        echo "Industry(SOC_NAME) has the most number of Data Scientist positions?"
       
            hive -e "select * from h1bproject.SOC where HIGHEST in (select max(HIGHEST) from h1bproject.SOC);" 
        show_menu;
        ;;
	
        
        
        4) clear;
	option_picked "Selected program is 4";
	echo "Enter output path"
        read path
	
	echo "Enter the year from 2011 to 2016"
	read year
	
        echo "You've selected ${path}"
	
        hadoop jar /home/hduser/4project.jar h1b.Ans4 /H1bproject/h1b_final /projectoutput/$path $year
	hadoop fs -cat /projectoutput/$path/p*
	hadoop fs -rm -r /projectoutput/$path

 	show_menu;     
	;;
            
	    5a) clear;
	option_picked "Selected program is 5a";
        echo "Enter year from 2011 to 2016"
        read year
        echo "You've selected ${year}"
	    hive -e "select count(job_title) as total,job_title,year from h1bproject.h1b_final where year = '$year' group by job_title,year order by total desc limit 10;"
        show_menu;
        ;;

                       
        5b) clear;
	option_picked "Selected program is 5b";
        echo "Enter year from 2011 to 2016"
        read year
        echo "You've selected ${year}"
	    hive -e "select count(job_title) as total,job_title,case_status,year from h1bproject.h1b_final where year = '2016' and lower(case_status)='certified' group by job_title,case_status,year order by total desc limit 10;" 
        show_menu;
        ;;
              
       6) clear;
       option_picked "Selected program is 6";
    
                echo "Percentage of each casestatus" 
			

		pig -x local /home/hduser/h1b6.pig
		
		display graph6.png
		
		show_menu;
                ;;
       7) clear;
	option_picked "Selected program is 7";
	echo "Enter output path"
        read path
        echo "You've selected ${path}"
	
        hadoop jar 7project.jar h1b.Applications /H1bproject/h1b_final /projectoutput/$path
	hadoop fs -cat /projectoutput/$path/p*
	hadoop fs -rm -r /projectoutput/$path
	
	display graph7.png

 	show_menu;     
	;;

       8) clear;
	option_picked "Selected program is 8";
        echo "Enter full time 'Y' or part time 'N'"
        read fulpart
        echo "You've selected ${fulpart}"
	echo "Enter year from 2011 to 2016"
        read year
        echo "You've selected ${year}"
	hive -e "select job_title,case_status,year,full_time_position, avg(prevailing_wage) as avg_wage from h1bproject.h1b_final where full_time_position='$fulpart' and year='$year' group by job_title,full_time_position,case_status,year having case_status == 'CERTIFIED-WITHDRAWN' or case_status == 'CERTIFIED' order by avg_wage desc limit 20"
        show_menu;
        ;;                     

       9) clear;

		option_picked "Selected program is 9";
    
                echo "Employers success rate percentage" 
	                                        	

		pig -x local /home/hduser/h1b9.pig
		
		show_menu;
		;;
                
       10) clear;
    
         
		option_picked "Selected program is 10";
    
                echo "Job Positions success rate percentage" 
		                                  	

		pig -x local /home/hduser/h1b10.pig
		
		show_menu;
		;;
      
	 11) clear;
	option_picked "Selected program is 11";
	sqoop export --connect jdbc:mysql://localhost/h1bproject --username root --password '' --table Ans11 --update-mode  allowinsert --update-key jobtitle --export-dir /projectoutput/10pigoutput/part-r-00000 --input-fields-terminated-by '\t';

mysql -u root -p'' -e 'select * from h1bproject.Ans11';
mysql -u root -p '' -e "delete from h1bproject.Ans11";

	show_menu;
	;;
          *) clear;
        option_picked "Pick an option from the menu";
        show_menu;
        ;;
    esac

fi

done


