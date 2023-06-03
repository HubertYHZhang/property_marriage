*----------------------------------econ2012----------------------------------
use "${rawpath}/cfps2012/cfps2012famecon_201906.dta",clear

clonevar propertytype = fq1

local counter = 1
foreach var in fq3_s_1 fq3_s_2 fq3_s_3 fq3_s_4 fq3_s_5 fq3_s_6 fq3_s_7 fq3_s_8{
	clonevar regis_`counter' = `var'
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
replace othervalue1 = . if othervalue1 < 0 & fr2a_a_2 <0
replace othervalue1 = 0 if othervalue1 < 0 & fr2a_a_2 >=0 & fr2a_a_2 != .

clonevar othervalue2 = fr2a_a_2
replace othervalue2 = . if othervalue2 < 0 & fr2a_a_3 <0
replace othervalue2 = 0 if othervalue2 < 0 & fr2a_a_3 >=0 & fr2a_a_3 != .

clonevar othervalue3 = fr2a_a_3
replace othervalue3 = . if othervalue3 < 0 & fr2a_a_4 <0
replace othervalue3 = 0 if othervalue3 < 0 & fr2a_a_4 >=0 & fr2a_a_4 != .

clonevar othervalue4 = fr2a_a_4
replace othervalue4 = . if othervalue4 < 0 & fr2a_a_5 <0
replace othervalue4 = 0 if othervalue4 < 0 & fr2a_a_5 >=0 & fr2a_a_5 != .

clonevar othervalue5 = fr2a_a_5
replace othervalue5 = . if othervalue5 < 0 & fr2a_a_6 <0
replace othervalue5 = 0 if othervalue5 < 0 & fr2a_a_6 >=0 & fr2a_a_6 != .

clonevar othervalue6 = fr2a_a_6
replace othervalue6 = . if othervalue6 < 0 & fr2a_a_7 <0
replace othervalue6 = 0 if othervalue6 < 0 & fr2a_a_7 >=0 & fr2a_a_7 != .

clonevar othervalue7 = fr2a_a_7
replace othervalue7 = . if othervalue7 < 0

gen othervalue = othervalue1 + othervalue2 + othervalue3 + othervalue4 + othervalue5 + othervalue6 + othervalue7



local varlist fid12 fid10
keep `varlist'

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

merge 1:1 pid using "${outpath}/temp/2010marriage.dta",keep(1 3) nogen

/* gen panel2010 = .
replace panel2010 = 1 if marry2010 == 2 & marry_raw == 2 & qe201 == 1 */

gen control2012 = .
replace control2012 = 1 if marry2010 ==1 & marry_raw == 2

gen control2012_1 = .
replace control2012_1 = 1 if marry2010 == 1|marry2010 == 3 & marry_raw == 2

clonevar edu = kr1
replace edu = kw1 if kr1 < 0

save "${outpath}/temp/ind_2012.dta",replace
*----------------------------------ind2012----------------------------------