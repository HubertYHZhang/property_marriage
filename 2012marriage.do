use "${outpath}/temp/ind_2012.dta",clear

keep pid marry_raw marry_y
rename marry_raw marry_raw2012
rename marry_y marry_y2012

save "${outpath}/temp/marriage/2012marriage.dta",replace