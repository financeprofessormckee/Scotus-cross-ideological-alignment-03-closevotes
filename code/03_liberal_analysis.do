set more off

* ------------------------------------------------------------
* Liberal Justices – Close Votes
* ------------------------------------------------------------

use "data/liberal_close_2020_2024.dta", clear

* ------------------------------------------------------------
* Construct sorted justice variable (ordered by alignment, descending)
* SCDB justice codes:
* Sotomayor = 113
* Breyer = 110
* Kagan = 114
* Jackson = 118
* ------------------------------------------------------------
gen justice_sorted = .
replace justice_sorted = 1 if justice1 == 113   // Sotomayor
replace justice_sorted = 2 if justice1 == 110   // Breyer
replace justice_sorted = 3 if justice1 == 114   // Kagan
replace justice_sorted = 4 if justice1 == 118   // Jackson

label define sortedlbl ///
    1 "Sotomayor" ///
    2 "Breyer" ///
    3 "Kagan" ///
    4 "Jackson"

label values justice_sorted sortedlbl

* ------------------------------------------------------------
* Close cases (5-4 and 6-3): predicted alignment by justice
* ------------------------------------------------------------
logit same_side i.justice_sorted if close == 1, cluster(caseId)
margins justice_sorted

marginsplot, ///
    horizontal ///
    recast(scatter) ///
    recastci(rcap) ///
	ciopts(lwidth(thin)) ///
    plot1opts(msymbol(circle) mcolor(navy)) ///
	xscale(range(.05 .80)) ///
	xlabel(.05 .15 .25 .35 .45 .55 .65 .75 .85, nogrid) ///
	yscale(reverse) ///
    ylabel(, nogrid valuelabel angle(0)) ///
    legend(off) ///
    xtitle("Probability of Voting with Conservative Justices") ///
	ytitle("") ///
    title("Cross-Ideological Alignment in Close Cases")

graph export "output/figures/part03_liberals_close.png", replace

* ------------------------------------------------------------
* Very close cases (5-4 only): predicted alignment by justice
* ------------------------------------------------------------
logit same_side i.justice_sorted if close2 == 1, cluster(caseId)
margins justice_sorted

marginsplot, ///
    horizontal ///
    recast(scatter) ///
    recastci(rcap) ///
	ciopts(lwidth(thin)) ///
    plot1opts(msymbol(circle) mcolor(navy)) ///
	xscale(range(.05 .80)) ///
	xlabel(.05 .15 .25 .35 .45 .55 .65 .75 .85, nogrid) ///
	yscale(reverse) ///
    ylabel(, nogrid valuelabel angle(0)) ///
    legend(off) ///
    xtitle("Probability of Voting with Conservative Justices") ///
	ytitle("") ///
    title("Cross-Ideological Alignment in Very Close Cases")

graph export "output/figures/part03_liberals_veryclose.png", replace

* ------------------------------------------------------------
* Close cases pairwise comparisons
* ------------------------------------------------------------
logit same_side i.justice_sorted if close == 1, cluster(caseId)
margins justice_sorted, pwcompare(effects)

* ------------------------------------------------------------
* Very close cases pairwise comparisons
* ------------------------------------------------------------
logit same_side i.justice_sorted if close2 == 1, cluster(caseId)
margins justice_sorted, pwcompare(effects)
