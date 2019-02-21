// Grafiken

version 14
set more off
clear all

set scheme s2mono

use "../data/data.dta"


*** Verteilungsanalyse der Items ***

foreach num in 01 04 07 10 {
histogram latent`num', percent addlabel ///
	discret start(1) width(1) ///
	title(latent`num') ///
	xlabel(1 `" "stimme gar" "nicht zu" "' ///
	       2 `" "stimme eher" "nicht zu" "' ////
	       3 `" "stimme" "eher zu" "' ///
	       4 `" "stimme" "voll zu" "', labsize(*0.7)) ///
	xscale(range(1/5)) ///
	xtitle("") ytitle("") ///
	ylabel(0 (20) 80, angle(0) labsize(*0.9) gmax gex) ///
	fcolor("170 170 170") lcolor(white) ///
	plotregion(margin(l-5 r-5)) ///
	saving(../graph/graph_`num', replace) nodraw
}

foreach num in 02 05 06 08 09 11 12 {
histogram latent`num', percent addlabel ///
	discret start(1) width(1) ///
	title(latent`num') ///
	xlabel(1 `" "stimme gar" "nicht zu" "' ///
	       2 `" "stimme eher" "nicht zu" "' ///
	       3 `" "stimme" "eher zu" "' ///
	       4 `" "stimme" "voll zu" "', labsize(*0.7)) ///
	xtitle("") ytitle("") yscale(off) ylabel(0(20)80, gmax gex) ///
	xscale(range(1/5)) ///
	fcolor("170 170 170") lcolor(white) ///
	plotregion(margin(l-4 r-4)) ///
	saving(../graph/graph_`num', replace) nodraw
}

histogram latent03, percent addlabel ///
	discret start(0) width(1) ///
	title(latent03) ///
	xlabel(1 `" "stimme gar" "nicht zu" "' ///
	       2 `" "stimme eher" "nicht zu" "' ///
	       3 `" "stimme" "eher zu" "' ///
	       4 `" "stimme" "voll zu" "', labsize(*0.7)) ///
	xscale(range(0/5)) ///
	xtitle("") ytitle("") yscale(off) ylabel(0(20)80, gmax gex) ///
	fcolor("170 170 170") lcolor(white) ///
	plotregion(margin(l-4 r-4)) ///
	saving(../graph/graph_03, replace) text(5 1 "0.00", size(*0.8)) nodraw


graph combine "graph/graph_01.gph" ///
	      "graph/graph_02.gph" ///
	      "graph/graph_03.gph" ///
	      "graph/graph_04.gph" ///
	      "graph/graph_05.gph" ///
	      "graph/graph_06.gph" ///
	      "graph/graph_07.gph" ///
	      "graph/graph_08.gph" ///
	      "graph/graph_09.gph" ///
	      "graph/graph_10.gph" ///
	      "graph/graph_11.gph" ///
	      "graph/graph_12.gph" ///
	      , l1title("Antworthäufigkeit in Prozent", size(*.7)) ///
	      imargin(1 1 1 1) ///
	      xsize(10) ysize(9) ///
	      cols(3)

graph export "../export/graph_items_histo.png", replace width(1600)


*** "keine Angabe" und Schwierigkeit ***

foreach num in 01 02 03 04 05 06 07 08 09 10 11 12 {
quietly: count if latent`num' == .a
quietly: gen latent`num'_percent = r(N)/_N * 100
}

graph hbar (first) latent??_percent, ylab(, labsize(*0.7)) ///
	bargap(10) blab(bar, format(%5.2g)) legend(off) ///
	yreverse xalter yscale(range(0/27)) ///
	ytitle(`""keine Angabe" in Prozent"') ///
	graphregion(margin(r-1)) ///
	bar(1, color("170 170 170")) ///
	bar(2, color("170 170 170")) ///
	bar(3, color("170 170 170")) ///
	bar(4, color("170 170 170")) ///
	bar(5, color("170 170 170")) ///
	bar(6, color("170 170 170")) ///
	bar(7, color("170 170 170")) ///
	bar(8, color("170 170 170")) ///
	bar(9, color("170 170 170")) ///
	bar(10, color("170 170 170")) ///
	bar(11, color("170 170 170")) ///
	bar(12, color("170 170 170")) ///
	saving(../graph/graph_bar_01, replace) fxsize(50) nodraw

foreach num in 01 02 03 04 05 06 07 08 09 10 11 12 {
quietly: sum latent`num'
quietly: replace latent`num' = round(( (r(mean) - 1) / (4-1)) * 100,1)
}

graph hbar (first) latent??, ylab(0(20)80, labsize(*0.7)) ///
	bargap(10) blab(bar, format(%5.3g)) ///
	nolabel showyvars legend(off) ///
	ytitle("Itemschwierigkeit")  ///
	yline(20 80) yscale(range(0/95)) ///
	graphregion(margin(l-6)) ///
	bar(1, color("170 170 170")) ///
	bar(2, color("170 170 170")) ///
	bar(3, color("170 170 170")) ///
	bar(4, color("170 170 170")) ///
	bar(5, color("170 170 170")) ///
	bar(6, color("170 170 170")) ///
	bar(7, color("170 170 170")) ///
	bar(8, color("170 170 170")) ///
	bar(9, color("170 170 170")) ///
	bar(10, color("170 170 170")) ///
	bar(11, color("170 170 170")) ///
	bar(12, color("170 170 170")) ///
	saving(../graph/graph_bar_02, replace) nodraw


graph combine "../graph/graph_bar_01" ///
							"../graph/graph_bar_02", xsize(2) ysize(1.3) ///
	imargin(-1 -1 0 0)

graph export "../export/graph_items_bar.png", replace width(2000)

graph close


exit
