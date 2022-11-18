select  distinct dp.dir_uid as username,
        de.mail as email,
        case  
        when dp.primaryaffiliation = 'Student' or daf.description like ('%Student%') 
        then 'Student'
        else 'Faculty/Staff'
        end as person_type
from dirsvcs.dir_person dp 
inner join dirsvcs.dir_affiliation daf
  on daf.uuid = dp.uuid
  and daf.campus = 'Boulder Campus' 
  and daf.description not in ('Admitted Student','Alum','Confirmed Student','Former Student','Member Spouse','Sponsored','Sponsored EFL','Retiree','Boulder3')
  and daf.description not like ('POI_%')
left join dirsvcs.dir_email de
  on de.uuid = dp.uuid
  and de.mail_flag = 'M'
  and de.mail is not null
left join dirsvcs.dir_acad_career dac
  on dp.uuid = dac.uuid
where dp.primaryaffiliation not in ('Not currently affiliated','Retiree','Affiliate','Member')
and ((dp.primaryaffiliation != 'Student') 
     or 
     (dp.primaryaffiliation = 'Student'
      and dac.uuid is not null))
and de.mail is not NULL
and lower(de.mail) not like ('%cu.edu')