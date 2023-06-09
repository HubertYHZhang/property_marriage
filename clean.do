global rawpath "/Users/hubertcheung/Desktop/parental retirement and labor time/"
global outpath "/Users/hubertcheung/Documents/GitHub/property_marriage"

*需要建构多种样本：1. 对比所有一直结婚了的但是处在不同房价地区的人，2. 对比2011年前结婚和2011年后结婚的人（2010年前的人的状态对比2011年后的状态），3. 对比2011年前结婚和2011年后结婚的人（同时期状态对比）

local clean = 1
local construct = 0

if `clean' == 1{

use "${rawpath}/cfps2010/cfps2010adult_202008.dta",clear
keep pid
clonevar pid10 = pid
save "${outpath}/temp/check2010.dta",replace

do "${outpath}/housing_crossyear.do"
do "${outpath}/marriage_crossyear.do"

do "${outpath}/clean2010.do"

/* do "${outpath}/2010marriage.do" */

do "${outpath}/clean2012.do"

/* do "${outpath}/2012marriage.do" */

do "${outpath}/clean2014.do"

do "${outpath}/clean2016.do"

do "${outpath}/clean2018.do"

use "${outpath}/temp/ind&econ_2010.dta",clear
append using "${outpath}/temp/ind&econ_2012.dta" "${outpath}/temp/ind&econ_2014.dta" "${outpath}/temp/ind&econ_2016.dta" "${outpath}/temp/ind&econ_2018.dta"

keep if male == 1
keep if propertytype == 1
keep if urban == 1

gen owntype = .
replace owntype = 1 if selfown == 1
replace owntype = 2 if spouseown == 1
replace owntype = 3 if coown == 1
replace owntype = 4 if otherown == 1
replace owntype = 5 if parentown == 1
label define owntype 1 "self" 2 "spouse" 3 "co" 4 "other" 5 "parent"
label values owntype owntype

*At least drop those who never get married or have all missings
preserve
keep pid marry year
reshape wide marry, i(pid) j(year)
keep if marry2010 == 1 | marry2012 == 1 | marry2014 == 1 | marry2016 == 1 | marry2018 == 1
keep pid
save "${outpath}/temp/marry_identify.dta",replace
restore

merge m:1 pid using "${outpath}/temp/marry_identify.dta",keep(3) nogen

merge m:1 provcd year using "${outpath}/data/housingprice.dta",keep(1 3) nogen
gen lnhp = ln(hp)

gen lnincome = ln(income+1)

save "${outpath}/data/ind&econ.dta",replace
export delimited "${outpath}/data/ind&econ.csv",replace
}

if `construct' == 1{

use "${outpath}/data/ind&econ.dta",clear



}

*这部分是准备看在2011年前后结婚的人的房产登记情况有什么不同
else if `construct' == 2{
    use "${outpath}/data/ind&econ.dta",clear

    keep if male == 1
    keep if propertytype == 1
    keep if urban == 1

    keep if inrange(marry_y,2006,2016)
    
    gen post_purchase = 1 if purchase_y >= 2011
    replace post_purchase = 0 if purchase_y < 2011
    tab owntype post_purchase  if inrange(purchase_y ,2006 ,2016) & marry_y >= purchase_y & year == 2018,co
    tab owntype purchase_y  if inrange(purchase_y ,2006 ,2016) & marry_y <= purchase_y & year == 2018,co
}

*这部分是对比一直存在的人，这是为了看他们房产登记上的变化
else if `construct' == 3{
    keep if male == 1
    keep if isin2010 == 1 | year == 2010
    keep if propertytype == 1
    keep if urban == 1

    gen post = 1 if year < 2011
    replace post = 0 if year > 2011
}