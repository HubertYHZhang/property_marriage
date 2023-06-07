*-------------------------------ind2016-----------------------------*
use "${rawpath}/cfps2016/cfps2016adult_201906.dta",clear

clonevar age = cfps_age
replace age = . if age < 0

clonevar marry_raw = qea0
replace marry_raw = . if marry_raw < 0



clonevar male = cfps_gender

clonevar edu = cfps2016edu
replace edu = . if edu < 0

*-------------------------------ind2016-----------------------------*

*-------------------------------econ2016-----------------------------*
use "${rawpath}/cfps2016/cfps2016famecon_201807.dta",clear

clonevar propwhethersame = fq1

clonevar propertytype = fq2

local counter = 1
foreach var in fq3pid_a_1 fq3pid_a_2 fq3pid_a_3 fq3pid_a_4 fq3pid_a_5 fq3pid_a_6 fq3pid_a_7 fq3pid_a_8{
	clonevar regis_`counter' = `var'
	replace regis_`counter' = . if regis_`counter' <0
	local counter = `counter'+1
}

clonevar purchasebuild_y = fq4
replace purchasebuild_y = . if purchasebuild_y < 0

clonevar value_past = fq5
replace value_past = . if value_past < 0

clonevar value_mkt = fq6
replace value_mkt = . if value_mkt < 0
replace value_mkt = (fq6_max + fq6_min)/2 if fq6 < 0 & fq6_max > 0 & fq6_min > 0

*连面积都要参考上次……

clonevar square_new = fq801
replace square_new = . if square_new < 0

merge m:1 fid14 using "${outpath}/temp/housing/housing_2014.dta",keep(1 3) nogetn
replace square = square_new if (((fq8 == 2 |fq8 == 3) & fq1 == 1) | fq1 == 0 | fq1 < 0) & square_new != .

clonevar otherprop = fr1
replace otherprop = . if otherprop < 0

clonevar othernumber = fr101
replace othernumber = . if othernumber < 0
replace othernumber = 0 if otherprop == 0

clonevar othervalue = fr2
replace othervalue = . if othervalue < 0
replace othervalue = (fr2_max + fr2_min)/2 if othervalue == . & fr2_max > 0 & fr2_min > 0

clonevar lease = fr5
replace lease = . if lease < 0
*是否应该把缺失当作0？

clonevar total_rent = fr501
replace total_rent = . if total_rent < 0
replace total_rent = 0 if lease == 0

save "${outpath}/temp/econ_2016.dta",replace