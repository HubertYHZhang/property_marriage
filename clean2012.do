*----------------------------------econ2012----------------------------------
use "${rawpath}/cfps2012/cfps2012famecon_201906.dta",clear

clonevar propertytype = fq1

clonevar purchase_y = fq6
replace purchase_y = . if purchase_y < 0

local counter = 1
foreach var in fq3_s_1 fq3_s_2 fq3_s_3 fq3_s_4 fq3_s_5 fq3_s_6 fq3_s_7 fq3_s_8{
	clonevar regis_`counter' = `var'
    replace regis_`counter' = . if regis_`counter' < 0
    local counter = `counter' + 1
}

clonevar lease = fq2
replace lease = . if lease < 0

clonevar total_rent = fq201m
replace total_rent = . if total_rent < 0

clonevar value_mkt = fq4a_best
replace value_mkt = . if value_mkt < 0 | value_mkt > 9999

clonevar square = fq701
replace square = . if square < 0

clonevar otherprop = fr1
replace otherprop = . if otherprop < 0

clonevar othernumber = fr101
replace othernumber = . if othernumber < 0

clonevar othervalue1 = fr2a_a_1
replace othervalue1 = 0 if othervalue1 < 0 & fr2a_a_2 <0
replace othervalue1 = 0 if othervalue1 < 0 & fr2a_a_2 >=0 & fr2a_a_2 != .

clonevar othervalue2 = fr2a_a_2
replace othervalue2 = 0 if othervalue2 < 0 & fr2a_a_3 <0
replace othervalue2 = 0 if othervalue2 < 0 & fr2a_a_3 >=0 & fr2a_a_3 != .

clonevar othervalue3 = fr2a_a_3
replace othervalue3 = 0 if othervalue3 < 0 & fr2a_a_4 <0
replace othervalue3 = 0 if othervalue3 < 0 & fr2a_a_4 >=0 & fr2a_a_4 != .

clonevar othervalue4 = fr2a_a_4
replace othervalue4 = 0 if othervalue4 < 0 & fr2a_a_5 <0
replace othervalue4 = 0 if othervalue4 < 0 & fr2a_a_5 >=0 & fr2a_a_5 != .

clonevar othervalue5 = fr2a_a_5
replace othervalue5 = 0 if othervalue5 < 0 & fr2a_a_6 <0
replace othervalue5 = 0 if othervalue5 < 0 & fr2a_a_6 >=0 & fr2a_a_6 != .

clonevar othervalue6 = fr2a_a_6
replace othervalue6 = 0 if othervalue6 < 0 & fr2a_a_7 <0
replace othervalue6 = 0 if othervalue6 < 0 & fr2a_a_7 >=0 & fr2a_a_7 != .

clonevar othervalue7 = fr2a_a_7
replace othervalue7 = 0 if othervalue7 < 0

gen othervalue = othervalue1 + othervalue2 + othervalue3 + othervalue4 + othervalue5 + othervalue6 + othervalue7



save "${outpath}/temp/econ_2012.dta",replace

*----------------------------------econ2012----------------------------------

*----------------------------------ind2012----------------------------------
use "${rawpath}/cfps2012/cfps2012adult_201906.dta",clear

clonevar birthy = cfps2012_birthy_best
replace birthy = . if birthy < 0
gen age = 2012-birthy

clonevar marry_raw = qe104
gen marry = .
replace marry = 1 if marry_raw == 2
replace marry = 0 if marry_raw !=2 & marry_raw >0

*结婚年份和月份
gen marry_y = .
replace marry_y = cfps2010_e210y if qec104 == 1
replace marry_y = qe208y if marry_raw == 2 & cfps2010_marriage != 2 & qe208y > 0
replace marry_y = qec105y if qec104 == 5 & qec105y > 0
*依然有部分结婚的人结婚年份缺失，原因未知

merge 1:1 pid using "${outpath}/temp/marriage/2010marriage.dta",keep(1 3) nogen

/* gen panel2010 = .
replace panel2010 = 1 if marry2010 == 2 & marry_raw == 2 & qe201 == 1 */

gen control2012 = .
replace control2012 = 1 if marry2010 ==1 & marry_raw == 2

gen control2012_1 = .
replace control2012_1 = 1 if marry2010 == 1|marry2010 == 3 & marry_raw == 2

clonevar male = cfps2012_gender_best

gen f_id_lastdigit = mod(pid_f,10) if inrange(mod(pid_f,1000),100,199)
gen m_id_lastdigit = mod(pid_m,10) if inrange(mod(pid_m,1000),100,199)

rename income income1
clonevar income = income_adj
replace income = . if income < 0

clonevar edu = kr1
replace edu = kw1 if kr1 < 0
gen edu_y = .
replace edu_y = 0 if edu == 1 | edu == 9
replace edu_y = 6 if edu == 2
replace edu_y = 9 if edu == 3
replace edu_y = 12 if edu == 4
replace edu_y = 15 if edu == 5
replace edu_y = 16 if edu == 6
replace edu_y = 18 if edu == 7
replace edu_y = 21 if edu == 8

rename urban12 urban
rename fid12 fid
clonevar fid12 = fid

save "${outpath}/temp/ind_2012.dta",replace
*----------------------------------ind2012----------------------------------

*----------------------------------famconf2012----------------------------------

use "${rawpath}/cfps2012/cfps2012famconf_092015.dta",clear

keep if cfps_interv_p == 1
gen indno = code_a_p - 100 if inrange(code_a_p,100,199)

clonevar edu_s = tb4_a12_s
replace edu_s = . if edu_s < 0
gen edu_s_y = .
replace edu_s_y = 0 if edu_s == 1
replace edu_s_y = 6 if edu_s == 2
replace edu_s_y = 9 if edu_s == 3
replace edu_s_y = 12 if edu_s == 4
replace edu_s_y = 15 if edu_s == 5
replace edu_s_y = 16 if edu_s == 6
replace edu_s_y = 18 if edu_s == 7
replace edu_s_y = 21 if edu_s == 8

clonevar age_s = tb1y_a_s
replace age_s = . if age_s < 0

keep pid code_a_s pid_s indno edu_s edu_s_y age_s

save "${outpath}/temp/famconf_2012.dta",replace

*----------------------------------famconf2012----------------------------------
use "${outpath}/temp/ind_2012.dta",clear

merge m:1 fid12 using "${outpath}/temp/econ_2012.dta",keep(3) nogen
keep pid-urban age-edu_y propertytype-othervalue

merge 1:1 pid using "${outpath}/temp/famconf_2012.dta",keep(3) nogen

clonevar spouse_pid = pid_s
clonevar spouse_id = code_a_s
replace spouse_id = . if spouse_id < 0
/* gen spouse_id_lastdigit = spouse_id - 100 if inrange(spouse_id,100,199) */
gen spouse_id_lastdigit = mod(code_a_s,10) if inrange(code_a_s,100,199)

gen selfown = .
gen spouseown = .
gen coown = .
gen otherown = .
gen spouselisted = .
gen exist = .
gen parentown = .
gen parentlisted = .
foreach i in regis_1 regis_2 regis_3 regis_4 regis_5 regis_6 regis_7 regis_8{
	replace spouseown = 1 if `i' == spouse_id_lastdigit & `i' != .
	replace selfown = 1 if `i' == indno & `i' != .
	replace coown = 1 if spouseown == 1 & selfown == 1 & `i' != .
	replace spouseown = . if coown == 1
	replace selfown = . if coown == 1
    replace spouselisted = 1 if spouseown == 1 | coown == 1
    replace parentown = 1 if (`i' == f_id_lastdigit | `i' == m_id_lastdigit) & selfown == . & spouseown == . & coown == . & `i' != .
	replace parentlisted = 1 if (`i' == f_id_lastdigit | `i' == m_id_lastdigit) & `i' != .

    replace exist = 1 if `i' >0 & `i' != .
}
replace otherown = 1 if spouseown == . & selfown == . & coown == .  & parentown ==. & exist == 1
foreach i in spouseown selfown coown otherown spouselisted parentown parentlisted{
    replace `i' = 0 if `i' == .
}

gen year = 2012

save "${outpath}/temp/ind&econ_2012.dta",replace

merge 1:1 pid using "${outpath}/temp/check2010.dta",keep(1 3) nogen
gen isin2010 = 1 if pid10 != .
replace isin2010 = 0 if pid10 == .

save "${outpath}/temp/ind&econ_2012.dta",replace