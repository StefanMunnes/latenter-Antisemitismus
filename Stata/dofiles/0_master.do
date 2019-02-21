// Fragebogen latenter Antisemitismus
// Masterarbeit Stefan Munnes 18.06.2018

* Zusätzliche Pakete installieren
// ssc install tabout 		// Tabellenoutput
// ssc install logout 		// Tabellenoutput
// ssc install factortest 	// Bartlett's test for sphericity
// ssc install relicoef 	// Raykov's factor reliability coefficient

* Arbeitsverzeichnis
cd "dofiles"


*** Datensatz erstellen, aufbereiten und Variablen beschriften
do "1_data.do"

*** Grafiken zur Itemanalyse
do "2_graph.do"

*** Item- und Skalenanalyse
do "3_analyse.do"

exit
