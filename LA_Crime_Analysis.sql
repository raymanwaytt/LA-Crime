-- LOS ANGELES CRIME DATA ANALYSIS (JAN 2020 - AUG 2024)

-- How have crime trends changed over the years for the top 5 crime types?
with top_5_crimes as 
	(select `Crm Cd Desc`
	from `la crime`
	group by `Crm Cd Desc`
	order by count(*) desc 
	limit 5)
select `YEAR OCC`, `Crm Cd Desc`, count(*) crime_count
from `la crime`
where `Crm Cd Desc` in (select `Crm Cd Desc` from top_5_crimes) and `MONTH OCC` < 9
group by `YEAR OCC`, `Crm Cd Desc`
order by `YEAR OCC`, crime_count desc;
/*
YEAR OCC		 Crm Cd desc										crime_count
2020		VEHICLE - STOLEN											20772
2020		BATTERY - SIMPLE ASSAULT									16331
2020		VANDALISM - FELONY ($400 & OVER, ALL CHURCH VANDALISMS)		12927
2020		BURGLARY FROM VEHICLE										12714
2020		THEFT OF IDENTITY											8984
2021		VEHICLE - STOLEN											23683
2021		BATTERY - SIMPLE ASSAULT									16199
2021		VANDALISM - FELONY ($400 & OVER, ALL CHURCH VANDALISMS)		13680
2021		BURGLARY FROM VEHICLE										13478
2021		THEFT OF IDENTITY											11317
2022		VEHICLE - STOLEN											24739
2022		THEFT OF IDENTITY											22113
2022		BATTERY - SIMPLE ASSAULT									18058
2022		BURGLARY FROM VEHICLE										14230
2022		VANDALISM - FELONY ($400 & OVER, ALL CHURCH VANDALISMS)		13359
2023		VEHICLE - STOLEN											24461
2023		BATTERY - SIMPLE ASSAULT									18833
2023		BURGLARY FROM VEHICLE										13554
2023		THEFT OF IDENTITY											13459
2023		VANDALISM - FELONY ($400 & OVER, ALL CHURCH VANDALISMS)		13170
2024		VEHICLE - STOLEN											15433
2024		BURGLARY FROM VEHICLE										6717
2024		VANDALISM - FELONY ($400 & OVER, ALL CHURCH VANDALISMS)		5980
2024		BATTERY - SIMPLE ASSAULT									5228
2024		THEFT OF IDENTITY											4417
*/


-- Which areas in LA have the highest and lowest crime rates?
select `AREA NAME`, count(*) `Total Crimes` 
from `la crime`
group by `AREA NAME`
order by `Total Crimes` desc
limit 5;
/*
AREA NAME	Total Crimes
Central		67095
77th Street	60513
Pacific		57193
Southwest	55342
Hollywood	50940
*/


-- What is the average delay in reporting crimes for different crime types?
select `Crm Cd Desc`, round(avg(`Days_taken_to_report`)) as 'average delay'
from `la crime`
group by `Crm Cd desc`
order by `average delay` desc
limit 10;
/*
Crm Cd Desc													average delay
CRM AGNST CHLD (13 OR UNDER) (14-15 & SUSP 10 YRS OLDER)	148
SEX OFFENDER REGISTRANT OUT OF COMPLIANCE					125
SEX,UNLAWFUL(INC MUTUAL CONSENT, PENETRATION W/ FRGN OBJ	118
DISHONEST EMPLOYEE ATTEMPTED THEFT							106
LEWD/LASCIVIOUS ACTS WITH CHILD								104
BIGAMY														99
SEXUAL PENETRATION W/FOREIGN OBJECT							79
ORAL COPULATION												76
GRAND THEFT / AUTO REPAIR									66
DOCUMENT WORTHLESS ($200.01 & OVER)							65
*/

-- What percentage of crimes occur during the day versus at night?
select day_night,round((count(*)/(select count(*) from `la crime`)) * 100) crime_percentage
from `la crime`
group by day_night;
/*
day/night	crime_percentage
Night		47
Day			53
*/


-- Which age groups are most affected by crimes?
select 
	case 
		when cast(`Vict Age` as signed) between 0 and 12 then 'Children (0-12)'
		when cast(`Vict Age` as signed) between 13 and 17 then 'Teenagers (13-17)'
		when cast(`Vict Age` as signed) between 18 and 50 then 'Adults (18-50)'
		when cast(`Vict Age` as signed) > 50 then 'Seniors (50+)'
		else null
	end as age_group,
	count(*) crime_count
from `la crime`
where `Vict Age` not like 'unknown' and `Vict Age` > 0
group by age_group
order by crime_count desc;
/*
age_group			crime_count	
Adults (18-50)		520282
Seniors (50+)		173274
Teenagers (13-17)	17113
Children (0-12)		8219
 */

-- What are the areas with the highest crime rates during peak hours (6 PM - 12 AM)?
select `AREA NAME`, count(*) crime_count 
from `la crime`
where `HOUR OCC` between 18 and 23
group by `AREA NAME`;
/*
AREA NAME 	crime_count
Wilshire	14511
Central		21283
Van Nuys	12818
Southeast	15647
Rampart		14585
Northeast	13236
77th Street	18841
Hollywood	15481
Devonshire	12339
West LA		13101
Pacific		17543
N Hollywood	15327
Southwest	17217
Topanga		12401
Harbor		12891
Newton		14551
West Valley	12854
Olympic		15353
Foothill	9989
Mission		12612
Hollenbeck	11602
 */


-- How does the distribution of crime differ between male and female victims?
select `Vict Sex`, round(count(*)/
(select count(*) from `la crime` where `Vict Sex` <> 'unknown') * 100) `victim count percentage`
from `la crime`
where `Vict Sex` <> 'unknown'
group by `Vict Sex`;
/*
Vict Sex	victim count percentage
MALE		53
FEMALE		47
 */


-- How do crime rates vary across different months of the year?
select `MONTH OCC`, count(*) crime_rate 
from `la crime`
group by `MONTH OCC`
order by crime_rate desc;
/*
MONTH OCC	crime_rate
January		92516
March		87663
February	86283
July		83669
April		83382
May			82892
August		82616
June		81188
October		76245
December	73458
September	72821
November	71744
 */

-- What are the top 3 crime types affecting specific age groups?
with ranked_group as
	(with grouped as
		(select 
		case 
			when cast(`Vict Age` as signed) between 0 and 12 then 'Children (0-12)'
			when cast(`Vict Age` as signed) between 13 and 17 then 'Teenagers (13-17)'
			when cast(`Vict Age` as signed) between 18 and 50 then 'Adults (18-50)'
			when cast(`Vict Age` as signed) > 50 then 'Seniors (50+)'
			else null
		end as age_group, count(*) crimes_count, `Crm Cd Desc`
		from `la crime`
		where `Vict Age` > 0
		group by age_group, `Crm Cd Desc`
		order by age_group, crimes_count)
	select age_group, `Crm Cd Desc`, crimes_count, 
	row_number() over(partition by age_group order by age_group, crimes_count desc) as rank_within_group
	from grouped)
select age_group, `Crm Cd Desc`, crimes_count, rank_within_group
from ranked_group
where rank_within_group <= 3
order by age_group, rank_within_group;
/*
age_group			Crm Cd Desc											crimes_count	rank
Children (0-12)		CHILD ABUSE (PHYSICAL) - SIMPLE ASSAULT						1875	1
Children (0-12)		CRM AGNST CHLD (13 OR UNDER) (14-15 & SUSP 10 YRS OLDER)	1137	2
Children (0-12)		BATTERY - SIMPLE ASSAULT									 894	3

Teenagers (13-17)	BATTERY - SIMPLE ASSAULT									3147	1
Teenagers (13-17)	ASSAULT WITH DEADLY WEAPON, AGGRAVATED ASSAULT				1821	2
Teenagers (13-17)	CHILD ABUSE (PHYSICAL) - SIMPLE ASSAULT						1523	3

Adults (18-50)		BATTERY - SIMPLE ASSAULT									48293	1
Adults (18-50)		BURGLARY FROM VEHICLE										47782	2
Adults (18-50)		THEFT OF IDENTITY											43575	3

Seniors (50+)		BATTERY - SIMPLE ASSAULT									21377	1
Seniors (50+)		BURGLARY													15417	2
Seniors (50+)		THEFT OF IDENTITY											15345	3
 */



-- What are the most common premises where crimes occur?
select `Premis Desc`, count(*) crime_count
from `la crime`
group by `Premis Desc`
order by crime_count desc
limit 5;
/*
`Premices Description 							crime_count
STREET											250924
SINGLE FAMILY DWELLING							161162
MULTI-UNIT DWELLING (APARTMENT, DUPLEX, ETC)	116761
PARKING LOT										67151
OTHER BUSINESS									46329
 */


-- Which day of the week has the highest crime rate?
select Day_of_week_OCC, count(*) crime_count 
from `la crime`
group by Day_of_week_OCC
order by crime_count desc;
/*
Day_of_week_OCC		crime_count
Friday				148846
Saturday			142893
Wednesday			138528
Thursday			137466
Monday				137449
Sunday				135496
Tuesday				133799
 */

-- What are the most common crimes committed against female victims?
select `Vict Sex`, `Crm Cd Desc`, count(*) crime_count 
from `la crime`
where `Vict Sex` = 'FEMALE'
group by `Vict Sex`, `Crm Cd Desc`
order by crime_count desc 
limit 5;
/*
Vict Sex	Crm Cd Desc							crime_count
FEMALE		INTIMATE PARTNER - SIMPLE ASSAULT	35487
FEMALE		BATTERY - SIMPLE ASSAULT			35046
FEMALE		THEFT OF IDENTITY					34604
FEMALE		BURGLARY FROM VEHICLE				25352
FEMALE		THEFT PLAIN - PETTY ($950 & UNDER)	21943
 */