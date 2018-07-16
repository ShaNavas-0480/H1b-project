h1b = load '/home/hduser/piginputfile' using PigStorage('\t') as (sno, casestatus:chararray, employername, socname, jobtitle:chararray, position:chararray, wage:double, year:chararray, lat, log);

--h1b10 = limit h1b 10;

--dump h1b10;

h1bfilter = foreach h1b generate casestatus, jobtitle, position, wage, year;

--h1bfilter10 = limit h1bfilter 10;

--dump h1bfilter10;

csfilter = filter h1bfilter by LOWER(casestatus) == 'certified' OR LOWER(casestatus) == 'certified-withdrawn';

--csfilter20 = limit csfilter 20;

--dump csfilter20;

fulltime = filter csfilter by LOWER(position) == 'y';

--fulltime5 = limit fulltime 5;

--dump fulltime5;

parttime = filter csfilter by LOWER(position) == 'n';

--parttime5 = limit parttime 5;

--dump parttime5;

--describe parttime5;

fullbyboth = group fulltime by (year,jobtitle);

--fullbyboth5 = limit fullbyboth 5;

--dump fullbyboth5;

--describe fullbyboth5;


fullbysum = foreach fullbyboth generate FLATTEN(group) as (year,jobtitle), fulltime.casestatus, fulltime.position, SUM(fulltime.wage) as sum, COUNT(fulltime.wage) as count;

--fullbysum10 = limit fullbysum 10;

--dump fullbysum10;

--describe fullbysum10;

fullbyavg = foreach fullbysum generate $0, $1, ROUND_TO((DOUBLE)($4 / $5),2) as average;

--fullbyavg10 = limit fullbyavg 10;

--dump fullbyavg10;

byorder = order fullbyavg by $2 desc;

--dump byorder;

byorder20 = limit byorder 20;

dump byorder20;















