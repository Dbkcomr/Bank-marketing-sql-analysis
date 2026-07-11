
select COUNT(*) from train;
select COUNT(*),y from train
group by y;

select job from train
group by job;
SELECT 5289 * 100.0 / (39922 + 5289) AS evet_oranı;

select job,
count(*) filter (where y ='yes')*100.00/count(*) AS evet_oranı
from train 
group by job
order by evet_oranı  desc; 

select education,
count(*) filter (where y ='yes')*100.00/count(*) AS evet_oranı
from train 
group by education
order by evet_oranı  desc; 

select marital,
count(*) filter (where y ='yes')*100.00/count(*) AS evet_oranı
from train 
group by marital
order by evet_oranı  desc; 

select 
	ROUND(count(*) filter (where y='yes') *100.0 /count(*),2) as evet_oranı
from train
where balance <0;

SELECT
    ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
FROM train
WHERE marital = 'single' AND job != 'student';

select job,
	count(*) as kısı_sayısı,
    ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_oranı
from train
group by job
Having count(*)>100
order by evet_oranı desc;


select 
	case 
		when age<30 then 'genç'
		when age<=50 then 'orta'
	else ' yaşlı'
	end as yas_grubu,
	    ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_oranı
	    from train
	    group by yas_grubu
		order by evet_oranı DESC;
select
	case 
		when balance<=0 then 'düşük alım gücü'
		when balance>0 and balance <1000 then 'orta alım gücü'
	else 'yüksek alım gücü'
	end as alım_gucu,
		   ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_oranı
			from train
			group by alım_gucu
			order by evet_oranı DESC;

select job,round(avg(balance),0) as ort_bakıye 
from train
group by job 
having job!='unknown'
order by ort_bakıye DESC;

select poutcome,
count(*) filter (where y ='yes')*100.00/count(*) AS evet_oranı
from train 
group by poutcome
order by evet_oranı  desc; 

select count(poutcome) from train 
group by poutcome 
having poutcome='success';

select 
case 
	when campaign = 1 THEN '1 kere arananlar'
	when campaign = 2 THEN '2 kere arananlar'
	when campaign = 3 THEN '3 kere arananlar'
	when campaign = 4 THEN '4 kere arananlar'
	when campaign = 5 THEN '5 kere arananlar'
	else '5den fazla arananlar'
end as aranma_sayısı,
		   ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_oranı
from train
group by aranma_sayısı
order by evet_oranı desc;

select 
	case 
		when previous=0 then 'daha önce aranmamış kişiler'
	else 'daha önce aranan kişiler'
	end as gecmıste_ulasılanlar,
	ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_oranı
	from train
	group by gecmıste_ulasılanlar
	order by evet_oranı DESC;
	
with meslek_oranlari  as (
		select job,
		ROUND(COUNT(*) FILTER (WHERE y = 'yes') * 100.0 / COUNT(*), 2) AS evet_orani
from train
group by job ) 
select
	job,
	evet_orani,
	rank() over (order by evet_orani desc ) as meslek_sıralaması
	from meslek_oranlari  ;
