*----------------------------------econ2014----------------------------------
use "${rawpath}/cfps2014/cfps2014famecon_201906.dta",clear

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

clonevar otherprop = fr1
replace otherprop = . if otherprop < 0

clonevar othernumber = fr101
replace othernumber = . if othernumber < 0

clonevar othervalue = fr102
replace othervalue = . if othervalue < 0

clonevar lease = fr5
replace lease = . if lease < 0

clonevar total_rent = fr501
replace total_rent = . if total_rent < 0

*----------------------------------econ2014----------------------------------

*----------------------------------ind2014----------------------------------
use "${rawpath}/cfps2014/cfps2014adult_201906.dta",clear

clonevar age = cfps2014_age
replace age = . if age < 0

clonevar marry_raw = qea0
gen marry = .
replace marry = 1 if marry_raw == 2
replace marry = 0 if marry_raw !=2 & marry_raw >0

*大部分人的婚姻时间都要参考上一次的调查

clonevar first_mar_new = qea2071
replace first_mar_new = . if first_mar_new < 0

merge 1:1 pid using "${outpath}/temp/2012marriage.dta",keep(1 3) nogen

gen marry_y = .
replace marry_y = qea205y if qea2 == 2 & qea205y > 0
replace marry_y = marry_y2012 if cfps2012_marriage == 2 & marry_y2012 > 0 & marry_y == .

clonevar male = cfps_gender

clonevar edu = cfps2014edu
replace edu = . if edu < 0

save "${outpath}/temp/ind&econ_2014.dta",replace