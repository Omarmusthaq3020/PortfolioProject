select*from housing

--Standardize Date Format

select saledate,convert(date,saledate)
from housing

alter table housing
add sale_date date;

update housing
set sale_date=convert(date,saledate)

select sale_date from housing


select*from housing 
order by parcelid

--Populate Propertyaddress

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from housing a
join housing b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

update a
set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
from housing a
join housing b
on a.parcelid=b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

select propertyaddress from housing

--Breaking out Address into different column(city,state)

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as address
,substring(propertyaddress, CHARINDEX(',',propertyaddress) +1, len(propertyaddress)) as State
from housing

--Alternative to Substring
 select
  parsename(replace(propertyaddress, ',', '.'), 2)
  , parsename(replace(propertyaddress, ',', '.'), 1)
  from housing

alter table housing
add [Property Address] nvarchar(255)

update housing
set[Property Address]=substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 

alter table HOUSING
add [City] nvarchar(255)

UPDATE housing
set [City]=substring(propertyaddress, CHARINDEX(',',propertyaddress) +1, len(propertyaddress))
  
  select propertyaddress from housing

  select owneraddress from housing

  select
  parsename(replace(owneraddress, ',', '.'), 3) as [Owner Address]
  ,parsename(replace(owneraddress, ',', '.'), 2) as [Owner City]
 ,parsename(replace(owneraddress, ',', '.'), 1) as [Owner State]
  from housing

  alter table housing
  add [Owner Address] nvarchar(255)

  update housing
  set [Owner Address]= parsename(replace(owneraddress, ',', '.'), 3) 

  alter table housing
  add [Owner City] nvarchar(255)

  update housing
  set [Owner City]=parsename(replace(owneraddress, ',', '.'), 2)

  alter table housing
  add [Owner State] nvarchar(255)

  update housing
  set [Owner State]=parsename(replace(owneraddress, ',', '.'), 1)

  select*from housing

--Changing n and y to no and yes
  
 select distinct soldasvacant, count(soldasvacant) 
 from housing
 group by soldasvacant
 order by 2

  select soldasvacant
  ,case when soldasvacant='y' then 'yes'
  when soldasvacant = 'n' then 'no'
  else soldasvacant
  end
  from housing

  update housing
  set  soldasvacant
  =case when soldasvacant='y' then 'yes'
  when soldasvacant = 'n' then 'no'
  else soldasvacant
  end
  from housing
--order propertyaddress


select*from housing

--Deleting Columns

alter table housing
drop column saledate,owneraddress,taxdistrict,propertyaddress