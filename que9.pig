
H1b9 = load '/home/hduser/pig project/piginputfile' using PigStorage('\t') as (s_no:int, case_status:chararray, employer_name:chararray, soc_name:chararray, job_title:chararray, full_time_position:chararray, prevailing_wage:double, year:chararray, worksite:chararray, longitute:double, latitute:double);

csemp = foreach H1b9 generate case_status, employer_name;

--csemp10 = limit csemp 10;

--dump csemp10;

crtfd = filter csemp by LOWER(case_status) == 'certified' OR LOWER(case_status) == 'certified-withdrawn';

--crtfd10 = limit crtfd 10;
 
--dump crtfd10;

csgrp = group crtfd by employer_name;

--csgrp10 = limit csgrp 10;

--dump csgrp10;

--describe csgrp;

cscount = foreach csgrp generate group, (DOUBLE)COUNT(crtfd.case_status) as count;

--cscount10 = limit cscount 10;

--dump cscount10;



totlgrp = group csemp by employer_name;

--describe totlgrp;

totlsum = foreach totlgrp generate group, (DOUBLE)COUNT(csemp.case_status);

joingrp = join cscount by $0, totlsum by $0;

--joingrp10 = limit joingrp 10;

--dump joingrp10;

--describe joingrp;

cssum = foreach joingrp generate ROUND_TO((($1 * 100) / $3),2);

cssum10 = limit cssum 10;

dump cssum10;

describe cssum;











