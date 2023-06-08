use "${outpath}/data/sankey.dta",clear

encode _2010 ,gen(owntype2010)
encode _2012 ,gen(owntype2012)
encode _2014 ,gen(owntype2014)
encode _2016 ,gen(owntype2016)
encode _2018 ,gen(owntype2018)

sankeyplot owntype2010 owntype2012 owntype2014 owntype2016 owntype2018, /*
    */title("Sankey Diagram of Ownership Type") /*
    */xlabel(0 "2010" 1 "2012" 2 "2014" 3 "2016" 4 "2018")/*
    */ytitle("Relative Frequencies") xtitle("Year")
graph export "${outpath}/graphs/sankey.png", replace