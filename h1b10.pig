 job = load '/home/hduser/piginputfile' using PigStorage('\t') as (s_no:int, case_status:chararray, employer_name:chararray, soc_name:chararray, job_title:chararray, full_time_position:chararray, prevailing_wage:double, year:chararray, worksite:chararray, longitute:double, latitute:double);


topjob = limit job 5;


dump topjob;

job1 = foreach job generate $1, $4, $7;


topjob1 = limit job1 5;


dump topjob1;


cnt1 = filter job1 by LOWER(case_status) == 'certified' or LOWER(case_status) == 'certified-withdrawn';


topcnt = limit cnt1 5;

dump topcnt;


groupjob = GROUP cnt1 by job_title;


countc = foreach groupjob generate group, COUNT (cnt1.$1);


topcnt1 = limit countc 5;

dump topcnt1;


groupjob1 = GROUP job1 by job_title;


countall = foreach groupjob1 generate group, COUNT (job1.$1);


topcnt2 = limit countall 5;

dump topcnt2;


joining = join countc by $0, countall by $0;


jobper = foreach joining generate $0, $1, $3, (DOUBLE) (($1*100)/$3);


jobfinal = filter jobper by $2 >= 1000 AND $3 > 70.00;

jobfinal10 = limit jobfinal 10;

dump jobfinal10;

--store jobfinal into '$Out';
