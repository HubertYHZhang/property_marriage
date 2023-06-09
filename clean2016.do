

*-------------------------------ind2016-----------------------------*
use "${rawpath}/cfps2016/cfps2016adult_201906.dta",clear

clonevar age = cfps_age
replace age = . if age < 0

clonevar marry_raw = qea0
replace marry_raw = . if marry_raw < 0
gen marry = 1 if marry_raw == 2
replace marry = 0 if marry_raw != 2 & marry_raw > 0

*大部分人的婚姻时间都要参考上一次的调查

clonevar first_mar_new = qea2071
replace first_mar_new = . if first_mar_new < 0

merge 1:1 pid using "${outpath}/temp/2014marriage.dta",keep(1 3) nogen

gen marry_y = .
replace marry_y = qea205y if qea2 == 2 & qea205y > 0 & qea205y != .
replace marry_y = marry_y2014 if cfps2014_marriage == 2 & marry_y2014 > 0 & marry_y2014 != . & marry_y == .

clonevar male = cfps_gender

clonevar edu = cfps2016edu
replace edu = . if edu < 0

rename urban16 urban

save "${outpath}/temp/ind_2016.dta",replace

*-------------------------------ind2016-----------------------------*

*-------------------------------famconf2016-----------------------------*

use "${rawpath}/cfps2016/cfps2016famconf_201804.dta",clear

clonevar spouse_pid = pid_s
replace spouse_pid = . if pid_s < 0

clonevar f_pid = pid_f
replace f_pid = . if f_pid < 0

clonevar m_pid = pid_m
replace m_pid = . if m_pid < 0
keep pid spouse_pid f_pid m_pid

save "${outpath}/temp/famconf_2016.dta",replace

*-------------------------------econ2016-----------------------------*
use "${rawpath}/cfps2016/cfps2016famecon_201807.dta",clear

clonevar propwhethersame = fq1

clonevar propertytype = fq2

clonevar purchasebuild_y = fq4
replace purchasebuild_y = . if purchasebuild_y < 0

clonevar purchase_y = purchasebuild_y

local counter = 1
foreach var in fq3pid_a_1 fq3pid_a_2 fq3pid_a_3 fq3pid_a_4 fq3pid_a_5 fq3pid_a_6 fq3pid_a_7 fq3pid_a_8{
	clonevar regis_`counter' = `var'
	replace regis_`counter' = . if regis_`counter' <0
	local counter = `counter'+1
}


clonevar value_past = fq5
replace value_past = . if value_past < 0

clonevar value_mkt = fq6
replace value_mkt = . if value_mkt < 0
replace value_mkt = (fq6_max + fq6_min)/2 if fq6 < 0 & fq6_max > 0 & fq6_min > 0

*连面积都要参考上次……

clonevar square_new = fq801
replace square_new = . if square_new < 0

merge m:1 fid14 using "${outpath}/temp/housing/housing_2014.dta",keep(1 3) nogen
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

use "${outpath}/temp/ind_2016.dta",clear
merge m:1 fid16 using "${outpath}/temp/econ_2016.dta",keep(3) nogen force

keep pid-urban age-edu propwhethersame-total_rent

gen year = 2016

merge 1:1 pid using "${outpath}/temp/check2010.dta",keep(1 3) nogen
gen isin2010 = 1 if pid10 != .
replace isin2010 = 0 if pid10 == .

merge 1:1 pid using "${outpath}/temp/famconf_2016.dta",keep(3) nogen

gen selfown = .
gen spouseown = .
gen coown = .
gen otherown = .
gen spouselisted = .
gen exist = .
gen parentown = .
gen parentlisted = .
foreach i in regis_1 regis_2 regis_3 regis_4 regis_5 regis_6 regis_7 regis_8{
	replace spouseown = 1 if `i' == spouse_pid & `i' != .
	replace selfown = 1 if `i' == pid & `i' != .
	replace coown = 1 if spouseown == 1 & selfown == 1
	replace spouseown = . if coown == 1
	replace selfown = . if coown == 1
    replace spouselisted = 1 if spouseown == 1 | coown == 1
	replace parentown = 1 if (`i' == f_pid | `i' == m_pid) & selfown == . & spouseown == . & coown == .  & `i' != .
	replace parentlisted = 1 if (`i' == f_pid | `i' == m_pid)  & `i' != .
    replace exist = 1 if `i' >0 & `i' != .
}
replace otherown = 1 if spouseown == . & selfown == . & coown == . & exist == 1 & parentown == .
foreach i in spouseown selfown coown otherown spouselisted parentown parentlisted{
    replace `i' = 0 if `i' == .
}

save "${outpath}/temp/ind&econ_2016.dta",replace