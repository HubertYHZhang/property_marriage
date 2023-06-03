global rawpath "/Users/hubertcheung/Desktop/parental retirement and labor time/"
global outpath "/Users/hubertcheung/Desktop/The last dance/人口经济学论文/"

*需要建构多种样本：1. 对比所有一直结婚了的但是处在不同房价地区的人，2. 对比2011年前结婚和2011年后结婚的人（2010年前的人的状态对比2011年后的状态），3. 对比2011年前结婚和2011年后结婚的人（同时期状态对比）

do "${outpath}/2010marriage.do"
do "${outpath}/2012marriage.do"

do "${outpath}/clean2010.do"

do "${outpath}/clean2012.do"

do "${outpath}/clean2014.do"

