// Item- und Skalenanalyse

capture log close

version 14
set more off
clear all

set scheme s2mono

* Datensatz laden
use "../data/data.dta"


******* Stichprobe *******

* Häufigkeitstabelle für allgemeine Informationen
quietly: tabout sex age lage polint lrscale using "../export/table_sample.txt", ///
	replace oneway c(freq col) f(0c 2p)


******* Itemanalyse (latenter Antisemitismus) *******

*** ausführliche Tabelle für Antwortverteilung
tabout latent?? using "../export/table_items_overview.txt", cells(freq col) replace oneway mi


*** verschiedene Item-Kennzahlen (in einer Tabelle ausgeben)
foreach num in 01 02 03 04 05 06 07 08 09 10 11 12 {

* Verteilung
quietly: sum latent`num', d
matrix item`num' = r(N), r(mean), r(sd), r(skewness)

* Schwierigkeit
matrix diff`num' = round(( (r(mean) - 1) / (3)) * 100,1)

}

matrix item = item01 \ item02 \ item03 \ item04 \ item05 \ item06 \ ///
	      item07 \ item08 \ item09 \ item10 \ item11 \ item12

matrix diff = diff01, diff02, diff03, diff04, diff05, diff06, ///
	      diff07, diff08, diff09, diff10, diff11, diff12
matrix diff = diff'

* Trennschärfe
quietly: alpha latent??, item

matrix test = r(ItemTestCorr)'
matrix rest = r(ItemRestCorr)'

matrix all = item, diff, test, rest
matrix rownames all = latent01 latent02 latent03 latent04 latent05 latent06 ///
		      latent07 latent08 latent09 latent10 latent11 latent12
matrix colnames all = N mean sd skewness P r(it) r(it)i


logout, save("../export/table_items_summary") word replace: matrix list all, ///
	noheader format(%05.0g)



******* Dimensionalitätsprüfung *******

*** Korrelationsmatrix
pwcorr latent??, star(0.01)
matrix corr = r(C)
logout, save("../export/table_corrm") word replace: matrix list corr, ///
	noheader format(%5.3f)


*** Eignung der Korrelationsmatrix

* Signifikanztest
logout, save("../export/table_bartlett") excel replace: factortest latent01 latent04-latent12

* Anti-Image-Kovarianzmatrix
quietly: factor latent01 latent04 latent06-latent10 latent12
logout, save("../export/table_anti") word replace: estat anti, nocorr format(%3.2f)

* KMO-Kriterium
quietly: factor latent01 latent04 latent06-latent10 latent12
logout, save("../export/table_kmo") word replace: estat kmo

quietly: factor latent01 latent04 latent06-latent10 latent12
logout, save("../export/table_smc") word replace: estat smc


*** explorative Faktoranalyse
log using "../export/table_factor.txt", text replace

* Faktoranalyse aller 8 Variablen
factor latent01 latent04 latent06-latent10 latent12, blanks(0.3) altdivisor

screeplot, title("") yline(1, lcolor(gs10)) plotregion(margin(l+5 r+5)) ///
	   ytitle("Eigenwert") ylab(, angle(0)) ///
	   xtitle("Faktor") xlab(1(1)8)

graph export "../export/graph_screeplot.png", replace width(1600)
graph close

* nach Ausschluss mit den restlichen 6 Variablen
factor latent04 latent06 latent07 latent09 latent10 latent12, blanks(0.3) altdivisor
log close



******* Reliabilität *******

log using "../export/table_relia.txt", text replace

* Split-Half-R. (mit korrigierter Testverdoppelung)
egen latent_nonmiss = rownonmiss(latent04 latent06 latent07 ///
				 latent09 latent10 latent12)

egen half_1 = rowmean(latent04 latent07 latent10) if latent_nonmiss == 4
egen half_2 = rowmean(latent06 latent09 latent12) if latent_nonmiss == 4

quietly: corr half_1 half_2
display (2 * r(rho)) / (1 + r(rho))


* Cronbachs Alpha (interne Konsistenz)
alpha latent04 latent06 latent07 latent09 latent10 latent12, asis item


* Kongenerische R. (Raykovs composite reliability)
quietly: sem (latent_AS -> latent04 latent06 latent07 ///
			   latent09 latent10 latent12), ///
		latent(latent_AS ) nocapslatent //

relicoef

estat gof, stat(rmsea indices)
estat eqgof

log close



******* Skalenbildung *******

*** Mittelwert-Skala

* Skalenbildung bei mindestens 4 Kreuzungen
egen latent_AS = rowmean(latent04 latent06 latent07 latent09 latent10 latent12) if latent_nonmiss >= 4

histogram latent_AS, discret percent width(0.25) ///
	xtitle(Skalenwerte) ytitle(in Prozent) ylab(, angle(0)) ///
	fcolor("170 170 170")

graph export "../export/graph_skala.png", replace width(1600)
graph close



***** Überblick über Items zu manifestem AS und Kommunikationslatenz

*** verschiedene Item-Kennzahlen (in einer Tabelle ausgeben)
foreach var in mas1 mas2 mas3 mas4 mas5 komlat1 komlat2 komlat3 {

* Verteilung
quietly: sum `var', d
matrix item_`var' = r(N), r(mean), r(sd), r(skewness)

* Schwierigkeit
matrix diff_`var' = round(( (r(mean) - 1) / (3)) * 100,1)

}

matrix item = item_mas1 \ item_mas2 \ item_mas3 \ item_mas4 \ ///
	      item_mas5 \ item_komlat1 \ item_komlat2 \ item_komlat3

matrix diff = diff_mas1, diff_mas2, diff_mas3, diff_mas4, ///
	      diff_mas5, diff_komlat1, diff_komlat2, diff_komlat3
matrix diff = diff'

* Trennschärfe
quietly: alpha mas? komlat?, item

matrix test = r(ItemTestCorr)'
matrix rest = r(ItemRestCorr)'

matrix all = item, diff, test, rest
matrix rownames all = mas1 mas2 mas3 mas4 mas5 las1 las2 las3
matrix colnames all = N mean sd skewness P r(it) r(it)i

logout, save("../export/table_as_rest") word replace: matrix list all, ///
	noheader format(%05.0g)

*** Korrelation mit Skala zum latenten Antisemitismus
pwcorr latent_AS mas? komlat?
matrix corr = r(C)
logout, save("../export/table_corr_rest") word replace: matrix list corr, ///
	noheader format(%5.3f)


exit
