// Datensatz erstellen

version 14
set more off
clear all

* CSV-Datei (AMC-Output) importieren
import delimited using "../data/data.csv"


***** Variablen bereinigen und recodieren *****

* numerische Codierung anpassen
foreach var of varlist _all {
	capture replace `var' = 1 if ticked`var' == "A"
	capture replace `var' = 2 if ticked`var' == "B"
	capture replace `var' = 3 if ticked`var' == "C"
	capture replace `var' = 4 if ticked`var' == "D"
	capture replace `var' = 5 if ticked`var' == "E"
}


* überflüssige Variablen löschen
drop ticked* name note a


* Variablen uumbenennen
rename prãfung ID
rename v5a lrscale
rename las1 komlat1
rename las2 komlat2
rename las3 komlat3


* Fehlende Werte zuweisen
recode _all (. = .b)
recode latent* mas? komlat? (5 = .a) // "keine Angabe" als Missing

* Ratingskala recodieren
recode latent?? mas? komlat? (1 = 4) (2 = 3) (3 = 2) (4 = 1)

* Item-Polung umkehren
recode latent02 latent05 latent11 (1 = 4) (2 = 3) (3 = 2) (4 = 1)

* Dummyvariable fürs Geschlecht
gen male = 1 if sex == 1
replace male = 0 if sex == 2
replace male = .a if sex == 3


* Missing Suche
egen row_miss = rowmiss(_all)
list ID row_miss if row_miss

* Antwortmuster rausfiltern (Kreuzung nur alle positiv, alle negativ)
egen muster_1 = anycount(latent*), values(1)
egen muster_4 = anycount(latent*), values(4)

drop if muster_1 == 12
drop if muster_4 == 12

drop muster* row_miss



***** Beschriftung *****

* Variablennamen beschriften
label var ID 	  	"Fragebogennummer"
label var sex  	  "Was ist Ihr Geschlecht"
label var age 	  "Wie alt sind Sie zum jetzigen Zeitpunkt"
label var lage 	  "Wie beurteilen Sie ganz allgemein die heutige wirtschaftliche Lage in Deutschland"
label var polint  "Wie stark interessieren Sie sich für Politik?"
label var lrscale "Wenn Sie an Ihre eigenen politischen Ansichten denken, wo würden Sie sich auf dieser Skala einstufen?"

label var male 	  "Geschlecht (DV)"

label var latent01 "Wir hätten heute weniger Probleme wenn sich der Mensch nicht so sehr von seiner Natur entfernt hätte."
label var latent02 "(gepolt) Mir fällt es schwer zu glauben, dass eine kleine Minderheit in der Lage ist uns alle zu lenken."
label var latent03 "Wir müssen endlich aufhören uns gegeneinander aufhetzen zu lassen."
label var latent04 "Unter uns gibt es Mächte, deren einziges Ziel die Zerstörung unserer Gemeinschaft ist."
label var latent05 "(gepolt) Wir leben zwar in Nationalstaaten, aber die Menschen sind viel zu verschieden, als dass es noch eine Rolle spielen sollte."
label var latent06 "Ereignisse wie die Flüchtlingskrise sind Resultat eines gezielten Plans, der nicht von allen durchschaut wird."
label var latent07 "In Anbetracht der vielen Konflikte auf der Welt müssen wir endlich aufwachen und erkennen wo die eigentlichen Schuldigen sitzen."
label var latent08 "Wir sollten nicht künstlich in die natürliche Ordnung der nationalen Gemeinschaften eingreifen."
label var latent09 "Die Gier einer hemmungslosen Finanzelite ist das Grundproblem unserer Gesellschaft."
label var latent10 "Wenn es uns nicht gelingt, die im Verborgenen agierende Weltregierung zu beseitigen, wird sie die Welt in den Abgrund stürzen."
label var latent11 "(gepolt) Unsere kapitalistische Gesellschaft zeichnet sich dadurch aus, dass alle Menschen strukturellen Zwängen unterliegen und niemand die volle Kontrolle darüber hat."
label var latent12 "Die, die uns regieren, handeln nicht im Interesse des Volkes."

label var mas1 "Auch heute noch ist der Einfluss der Juden zu groß."
label var mas2 "Die Juden arbeiten mehr als andere Menschen mit üblen Tricks, um das zu erreichen, was sie wollen."
label var mas3 "Die Juden haben einfach etwas Besonderes und Eigentümliches an sich und passen nicht so recht zu uns."
label var mas4 "Juden haben in Deutschland zu viel Einfluss."
label var mas5 "Durch ihr Verhalten sind Juden an ihren Verfolgungen mitschuldig."

label var komlat1 "Ich glaube, dass sich viele nicht trauen, ihre wirkliche Meinung über Juden zu sagen."
label var komlat2 "Mir ist das ganze Thema „Juden“ irgendwie unangenehm."
label var komlat3 "Was ich über Juden denke, sage ich nicht jedem."


* Ausprägungen beschriften
label define sex_3 1 "männlich" ///
		   2 "weiblich" ///
		   3 "weiteres" ///
		   .b "Auslassung"

label values sex sex_3


label define age_4 1 "16-20 Jahre" ///
		   2 "21-25 Jahre" ///
		   3 "26-30 Jahre" ///
		   4 "31 Jahre und älter" ///
		   .b "Auslassung"

label values age age_4


label define lage_5 1 "sehr gut" ///
		    2 "gut" ///
		    3 "teils gut, teils schlecht" ///
		    4 "schlecht" ///
		    5 "sehr schlecht" ///
		    .b "Auslassung"

label values lage lage_5


label define polint_5 1 "sehr stark" ///
		      2 "stark" ///
		      3 "mittel" ///
		      4 "wenig" ///
		      5 "gar nicht" ///
		      .b "Auslassung"

label values polint polint_5


label define pol_scale 1 "links" ///
		       5 "rechts" ///
		       .b "Auslassung"

label values lrscale pol_scale


label define male_dv 1 "männlich" ///
		     0 "weiblich" ///
		     .a "weiteres" ///
		     .b "Auslassung"

label values male male_dv


label define scale_4 	1 "stimme gar nicht zu" ///
			2 "stimme eher nicht zu" ///
			3 "stimme eher zu" ///
			4 "stimme voll zu" ///
			.a "keine Angabe" ///
			.b "Auslassung"

label values latent* mas? komlat? scale_4


*** Speichern
save "../data/data.dta", replace


exit
