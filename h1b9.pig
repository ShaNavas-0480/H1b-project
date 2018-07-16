 employee = load '/home/hduser/piginputfile' using PigStorage('\t') as (s_no:int, case_status:chararray, employer_name:chararray, soc_name:chararray, job_title:chararray, full_time_position:chararray, prevailing_wage:double, year:chararray, worksite:chararray, longitute:double, latitute:double);

top10 = limit employee 10;

dump top10;

emp1 = foreach employee generate case_status, employer_name, year;

top5 = limit emp1 5;

dump top5;

fil1 = filter emp1 by LOWER(case_status) == 'certified' or LOWER(case_status) == 'certified-withdrawn';

topfil = limit fil1 5;

dump topfil;

groupbyemp = GROUP fil1 by employer_name;

topemp = limit groupbyemp 5;

dump topemp;

count1 = foreach groupbyemp generate group, COUNT(fil1.$1);

topcount = limit count1 5;

dump topcount;

groupbyemp1 = GROUP emp1 by employer_name;

topemp1 = limit groupbyemp1 5;

dump topemp1;

count2 = foreach groupbyemp1 generate group, COUNT(emp1.$1);

topcount1 = limit count2 5;

dump topcount1;

join1 = join count1 by $0, count2 by $0;

cal = foreach join1 generate $0, $1, $3, (DOUBLE)(($1*100)/$3);

topcal = limit cal 5;

dump topcal;

calfinal = filter cal by $3 > 70.00 AND $2 >= 1000;

dump calfinal;
