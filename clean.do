global rawpath "/Users/hubertcheung/Desktop/parental retirement and labor time/"
global outpath "/Users/hubertcheung/Documents/GitHub/property_marriage"

*需要建构多种样本：1. 对比所有一直结婚了的但是处在不同房价地区的人，2. 对比2011年前结婚和2011年后结婚的人（2010年前的人的状态对比2011年后的状态），3. 对比2011年前结婚和2011年后结婚的人（同时期状态对比）

local clean = 0
local construct = 2

if `clean' == 1{

use "${rawpath}/cfps2010/cfps2010adult_202008.dta",clear
keep pid
clonevar pid10 = pid
save "${outpath}/temp/check2010.dta",replace

do "${outpath}/housing_crossyear.do"

do "${outpath}/clean2010.do"

do "${outpath}/2010marriage.do"

do "${outpath}/clean2012.do"

do "${outpath}/2012marriage.do"

do "${outpath}/clean2014.do"

do "${outpath}/clean2016.do"

use "${outpath}/temp/ind&econ_2010.dta",clear
append using "${outpath}/temp/ind&econ_2012.dta" "${outpath}/temp/ind&econ_2014.dta" "${outpath}/temp/ind&econ_2016.dta"

gen owntype = .
replace owntype = 1 if selfown == 1
replace owntype = 2 if spouseown == 1
replace owntype = 3 if otherown == 1 
label define owntype 1 "self" 2 "spouse" 3 "other"
label values owntype owntype

save "${outpath}/data/ind&econ.dta",replace

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