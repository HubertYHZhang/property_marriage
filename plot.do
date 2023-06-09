use "${outpath}/data/ind&econ.dta",clear

keep if propwhethersame == 1 | year == 2010| year == 2012

keep pid owntype year marry_y marry
reshape wide owntype marry_y marry, i(pid) j(year)

count if owntype2010 !=. & owntype2012 !=. & owntype2014 !=.

/* keep if marry_y2010 <= 2010 */
sankeyplot owntype2010 owntype2012 owntype2014 owntype2016 owntype2018

foreach i in 2012 2014 2016 2018{
    local j = `i' - 2
    preserve
    /* keep if marry`i' == 1 & marry`j' == 1 */
    sankeyplot owntype`j' owntype`i', xtitle("Year") xlabel(0 "`j'" 1 "`i'") name(sankey`i')
    restore
}
/* graph combine sankey2012 sankey2014 sankey2016 sankey2018, rows(1) name(sankeyall) */
/* grc1leg sankey2012 sankey2014 sankey2016 sankey2018, legendfrom(sankey2012) row(1) title("Sankey Diagram of Ownership Type") xsize(15) ysize(3) */
graph combine sankey2012 sankey2014 sankey2016 sankey2018,row(1) title("Sankey Diagram of Ownership Type") xsize(15) ysize(8)

graph export "${outpath}/graphs_new/sankeyall_nonpanel.png", replace
graph drop _all

*----------------------------------------*
use "${outpath}/data/ind&econ.dta",clear

keep if propwhethersame == 1 | year == 2010| year == 2012

keep if marry_y >= purchase_y

keep pid owntype year marry_y marry
reshape wide owntype marry_y marry, i(pid) j(year)

count if owntype2010 !=. & owntype2012 !=. & owntype2014 !=.

/* keep if marry_y2010 <= 2010 */
/* sankeyplot owntype2010 owntype2012 owntype2014 owntype2016 owntype2018 */

foreach i in 2012 2014 2016 2018{
    local j = `i' - 2
    preserve
    keep if marry`i' == 1 & marry`j' == 1
    sankeyplot owntype`j' owntype`i', xtitle("Year") xlabel(0 "`j'" 1 "`i'") name(sankey`i')
    restore
}
/* graph combine sankey2012 sankey2014 sankey2016 sankey2018, rows(1) name(sankeyall) */
/* grc1leg sankey2012 sankey2014 sankey2016 sankey2018, legendfrom(sankey2012) row(1) title("Sankey Diagram of Ownership Type") xsize(15) ysize(3) */
graph combine sankey2012 sankey2014 sankey2016 sankey2018,row(1) title("Sankey Diagram of Ownership Type") xsize(15) ysize(8)

graph export "${outpath}/graphs_new/pbeforem_sankeyall_nonpanel.png", replace
graph drop _all


use "${outpath}/data/ind&econ.dta",clear

keep if marry_y <= purchase_y


keep pid owntype year marry_y marry
reshape wide owntype marry_y marry, i(pid) j(year)

count if owntype2010 !=. & owntype2012 !=. & owntype2014 !=.

/* keep if marry_y2010 <= 2010 */
/* sankeyplot owntype2010 owntype2012 owntype2014 owntype2016 owntype2018 */

foreach i in 2012 2014 2016 2018{
    local j = `i' - 2
    preserve
    keep if marry`i' == 1 & marry`j' == 1
    sankeyplot owntype`j' owntype`i', xtitle("Year") xlabel(0 "`j'" 1 "`i'") name(sankey`i')
    restore
}
/* graph combine sankey2012 sankey2014 sankey2016 sankey2018, rows(1) name(sankeyall) */
/* grc1leg sankey2012 sankey2014 sankey2016 sankey2018, legendfrom(sankey2012) row(1) title("Sankey Diagram of Ownership Type") xsize(15) ysize(3) */
graph combine sankey2012 sankey2014 sankey2016 sankey2018,row(1) title("Sankey Diagram of Ownership Type") xsize(15) ysize(8)

graph export "${outpath}/graphs_new/pafterm_sankeyall_nonpanel.png", replace
graph drop _all

/* use "${outpath}/data/sankey.dta",clear

encode _2010 ,gen(owntype2010)
encode _2012 ,gen(owntype2012)
encode _2014 ,gen(owntype2014)
encode _2016 ,gen(owntype2016)
encode _2018 ,gen(owntype2018)

sankeyplot owntype2010 owntype2012 owntype2014 owntype2016 owntype2018, /*
    */title("Sankey Diagram of Ownership Type") /*
    */xlabel(0 "2010" 1 "2012" 2 "2014" 3 "2016" 4 "2018")/*
    */ytitle("Relative Frequencies") xtitle("Year")
graph export "${outpath}/graphs_new/sankey.png", replace

sankeyplot owntype2012 owntype2014 */