global rawpath "/Users/hubertcheung/Desktop/parental retirement and labor time/"
global outpath "/Users/hubertcheung/Documents/GitHub/property_marriage"

*需要建构多种样本：1. 对比所有一直结婚了的但是处在不同房价地区的人，2. 对比2011年前结婚和2011年后结婚的人（2010年前的人的状态对比2011年后的状态），3. 对比2011年前结婚和2011年后结婚的人（同时期状态对比）

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
append using "${outpath}/temp/ind&econ_2012.dta" "${outpath}/temp/ind&econ_2014.dta"

keep if male == 1
keep if isin2010 == 1 | year == 2010
keep if propertytype == 1
keep if urban == 1

gen post = 1 if year < 2011
replace post = 0 if year > 2011