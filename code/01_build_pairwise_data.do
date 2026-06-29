* ------------------------------------------------------------
* Supreme Court Cross-Ideological Alignment – Part 3
* Data Preparation File
* Terms 2020–2024
*
* This file:
* 1. Loads justice-centered SCDB voting data
* 2. Restricts to Terms 2020–2024
* 3. Constructs pairwise justice voting observations
* 4. Identifies ideological blocs
* 5. Generates same-side alignment indicator
* 6. Flags closely divided cases (close and very close)
* 7. Exports analysis-ready datasets
* ------------------------------------------------------------

* ------------------------------------------------------------
* Load justice-centered SCDB voting data
* ------------------------------------------------------------
use "SCDB_2025_01_justiceCentered_Citation", clear

* Restrict to Terms 2020–2024
keep if term >= 2020 & term <= 2024

* Retain only variables needed for alignment analysis
* (majVotes = number of justices in the case majority)
keep term justice caseId vote majVotes

* Drop equally divided votes and missing votes
drop if missing(vote) | vote == 8

* ------------------------------------------------------------
* Majority indicator
* maj1 = 1 if the justice voted with the case majority (vote code 1)
* ------------------------------------------------------------
gen in_majority = (vote == 1)

rename justice     justice1
rename in_majority maj1
rename vote        vote1

* ------------------------------------------------------------
* Define close vote status
* close  = 1 if the majority had 5 or 6 votes (5-4 or 6-3 cases)
* ------------------------------------------------------------
gen byte close = 1 if inlist(majVotes, 5, 6)

* ------------------------------------------------------------
* Define very close vote status
* close2 = 1 if the majority had exactly 5 votes (5-4 cases)
* ------------------------------------------------------------
gen byte close2 = 1 if majVotes == 5

* ------------------------------------------------------------
* Construct pairwise justice observations within each case
* Each justice is paired with every other participating justice
* ------------------------------------------------------------
tempfile temp
save `temp'

rename justice1 justice2
rename maj1     maj2
rename vote1    vote2

joinby caseId using `temp'

* Remove self-pairs (justice paired with themselves)
drop if justice1 == justice2

* ------------------------------------------------------------
* Identify ideological blocs (SCDB justice codes)
*
* Liberals:
*   Breyer = 110
*   Sotomayor = 113
*   Kagan = 114
*   Jackson = 118
*
* Conservatives:
*   Thomas = 108
*   Roberts = 111
*   Alito = 112
*   Gorsuch = 115
*   Kavanaugh = 116
*   Barrett = 117
* ------------------------------------------------------------
gen liberal1      = inlist(justice1, 110, 113, 114, 118)
gen liberal2      = inlist(justice2, 110, 113, 114, 118)
gen conservative1 = inlist(justice1, 108, 111, 112, 115, 116, 117)
gen conservative2 = inlist(justice2, 108, 111, 112, 115, 116, 117)

* ------------------------------------------------------------
* Generate same-side alignment indicator
* Equals 1 if both justices are on the same side of the case
* (both in the majority or both in dissent)
* ------------------------------------------------------------
gen same_side = maj1 == maj2

* ------------------------------------------------------------
* Export datasets for separate analysis
* ------------------------------------------------------------

* Conservative–Liberal pairs
preserve
keep if conservative1 == 1 & liberal2 == 1
save "data/conservative_close_2020_2024.dta", replace
restore

* Liberal–Conservative pairs
preserve
keep if conservative2 == 1 & liberal1 == 1
save "data/liberal_close_2020_2024.dta", replace
restore

* ------------------------------------------------------------
* End of data preparation file
* ------------------------------------------------------------
