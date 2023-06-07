use "${outpath}/temp/econ_2012.dta",clear

keep fid12 square

save "${outpath}/temp/housing/housing_2012.dta",replace

use "${outpath}/temp/econ_2014.dta",clear

keep fid14 square

save "${outpath}/temp/housing/housing_2014.dta",replace