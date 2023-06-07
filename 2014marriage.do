use "${outpath}/temp/ind_2014.dta",clear

keep pid marry_raw marry_y
rename marry_raw marry_raw2014
rename marry_y marry_y2014

save "${outpath}/temp/marriage/2014marriage.dta",replace