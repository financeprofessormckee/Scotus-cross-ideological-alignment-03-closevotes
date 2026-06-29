set more off

* ------------------------------------------------------------
* Conservative Justices – Close Votes
* ------------------------------------------------------------

use "data/conservative_close_2020_2024.dta", clear

* ------------------------------------------------------------
* Construct sorted justice variable (ordered by alignment, descending)
* SCDB justice codes:
* Alito = 112
* Thomas = 108
* Barrett = 117
* Kavanaugh = 116
* Roberts = 111
* Gorsuch = 115
* ------------------------------------------------------------
gen justice_sorted = .
replace justice_sorted = 1 if justice1 == 112   // Alito
replace justice_sorted = 2 if justice1 == 108   // Thomas
replace justice_sorted = 3 if justice1 == 117   // Barrett
replace justice_sorted = 4 if justice1 == 116   // Kavanaugh
replace justice_sorted = 5 if justice1 == 111   // Roberts
replace justice_sorted = 6 if justice1 == 115   // Gorsuch

label define sortedlbl ///
    1 "Alito" ///
    2 "Thomas" ///
    3 "Barrett" ///
    4 "Kavanaugh" ///
    5 "Roberts" ///
    6 "Gorsuch"

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
    xscale(range(.05 .78)) ///
    xlabel(.05(.10).75, nogrid) ///
    yscale(reverse) ///
    ylabel(, nogrid valuelabel angle(0)) ///
    legend(off) ///
    xtitle("Probability of Voting with Liberal Justices") ///
    ytitle("") ///
    title("Cross-Ideological Alignment in Close Cases") ///
    name(cons_plot, replace)

graph export "output/figures/part03_conservatives_close.png", replace width(2400)

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
    xscale(range(.05 .78)) ///
    xlabel(.05(.10).75, nogrid) ///
    yscale(reverse) ///
    ylabel(, nogrid valuelabel angle(0)) ///
    legend(off) ///
    xtitle("Probability of Voting with Liberal Justices") ///
    ytitle("") ///
    title("Cross-Ideological Alignment in Very Close Cases") ///
    name(cons_plot, replace)

graph export "output/figures/part03_conservatives_veryclose.png", replace width(2400)

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
