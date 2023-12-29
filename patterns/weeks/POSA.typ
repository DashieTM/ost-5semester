== Whole-Part Pattern
<whole-part-pattern>
Moderator: Joel Sauvain
=== Intro
<intro>
Das Whole-Part Pattern ist nicht so bekannt, wie ein Singleton- oder
Factory-Pattern. Es ist eher eine Art, wie man seine Software
organisiert, bzw. strukturiert. Es geht darum, grosse, komplexe
Software, in kleinere Subprobleme aufzuteilen, #strong[um die
Komplexität und Fehleranfälligkeit zu reduzieren]. #strong[Jeder
Komponent ist ein "Part" vom grösseren "Whole" System].
=== Problem
<problem>
#strong[Um komplexe Systeme entwickeln zu können, muss Software in
einzelne Teile struktuiert werden], damit es überhaupt möglich ist
weiterhin die Software anzupassen, da sonst die Komplexität eine Stufe
erreichen kann, bei welcher es nicht mehr möglich ist Software zu
entwickeln.
=== Forces
<forces>
#strong[Modularität]: Das "Ganzes-Teil" Muster fördert Modularität und
Kapselung, wodurch es einfacher wird, große Softwaresysteme zu verwalten
und zu warten.

#strong[Wiederverwendbarkeit]: Komponenten können oft in verschiedenen
Teilen des Systems oder in verschiedenen Projekten wiederverwendet
werden, was die Entwicklungszeit und den Aufwand reduziert.

#strong[Skalierbarkeit]: Wenn das System wachsen oder sich an sich
ändernde Anforderungen anpassen muss, ist es einfacher, Komponenten
innerhalb der Hierarchie hinzuzufügen oder auszutauschen.
=== Solution
<solution>
Man kann Strukturen so bauen, dass es für den Endbenutzer nach wie vor
nach einem Whole-Part aussieht, also der Benutzer merkt nicht, dass eine
Komponente aus einzelnen Teilkomponenten besteht. Dies kann primär durch
Abstrahierung geschehen.
=== Aktuelle Praxisbeispiele
<aktuelle-praxisbeispiele>
In einem Videospiel hat man meistens eine Spiel-Engine als gesamtes
System. Mit Komponenten kann man zb. Darstellung, Physiksimulation, Ton,
Eingabebehandlung und die Spiellogik beeinflussen.
=== Prüfungsfragen
<prüfungsfragen>
+ Fördert das Whole-Part Pattern die Wiederverwendbarkeit von
  Komponenten? \[ Ja \]
+ Wenn man das Whole-Part Pattern zu extrem anwendet und (zu) viele
  Komponenten hat, kann dies zu Überkomplexität führen? \[ Ja \]
== VWO5 POSA: Forwarder / Receiver
<vwo5-posa-forwarder-receiver>
==== Intro
<intro>
Das Forwarder / Receiver Pattern setzt sich mit der inter-process
Kommunikation zwischen verschiedenen Komponenten auseinander. Der
Forwarder auf der Client Seite erhält den Request und kümmert sich ums
Mapping für IPC (Inter-process communication) und der Receiver auf der
Server seite Packt die Nachricht aus und übergibt sie dem Server. Es
gibt hier keinen Broker.

==== Problem
<problem>
Das Problem welcher gelöst werden soll, ist wie man die Kommunikation
zwischen Komponenten in einer Distributed Applikation abstrahieren soll.
Es bezieht sich primär um Low-Level Mechanismen. Es soll eine
Architektur gebaut werden, welche die Abhängigkeiten der effektiven IPC
von der Applikation abkapselt.

==== Forces
<forces>
- Die IPC soll austauschbar sein mit möglichst minimalem impact auf die
  Applikation.

==== Solution
<solution>
Die Kommunikation wird nicht von den effektiven Peers durchgeführt
sondern in Intermediäres, den Forwarder und Receiver ausgelagert. Das
führt dazu, dass wenn es später Änderungen an der IPC gibt, muss diese
nicht bei allen Peers nachgezogen werden.
== Aktuelle Praxisbeispiele
<aktuelle-praxisbeispiele>
==== Benefits
<benefits>
- Es gibt keinen Broker. Deshalb ist es simpler und weniger code als
  z.B. beim Broker Pattern.
- Der Code bleibt anpassbar.
- Die Skallierbarkeit ist auch besser, da die Lastenverteilung zentral
  beim Forwarder und Receiver geregelt werden kann.
- Die IPC ist effizient, jeder forwarder kennt die addresse der receiver
  (via name-to-address mapping).

==== #strong[Liabilities]
<liabilities>
- Weniger flexibel
== #strong[Prüfungsfragen]
<prüfungsfragen>
Wenn das Forwarder / Receiver Pattern eingesetzt wird, kann mit wenig
Aufwand die IPC implementiert werden, ist dann aber kaum noch anpassbar.
(Falsch)

Der Forwarder bestimmt die Physische addresse des Empfänger über das
name-to-address mapping. (Richtig)
== VW07 POSA: Blackboard
<vw07-posa-blackboard>=== Intro
<intro>
Stellt euch vor eine Expertengruppe sitzt vor einer Wandtafel und
versucht eine mathematische Gleichung schrittweise, mit dem Beitrag von
allen Experten, zu lösen. Hierbei werden immer wieder neue Hypothesen
ausprobiert und weiterverfolgt um zu einer Lösung zu kommen. Daraus
entsteht auch der Name Blackboard.
=== Problem
<problem>
Das Hauptproblem das gelöst werden soll ist es komplexe,
nicht-deterministische Probleme anzugehen, bei denen keine klaren
Algorithmen oder Lösungswege existieren. Es ermöglicht einer Gruppe von
spezialisierten Modulen, unabhängig voneinander Informationen
beizutragen und zu verarbeiten, um gemeinsam eine Lösung zu finden.
Dieses Pattern ist besonders nützlich in Anwendungen, in denen die beste
Lösung nicht von Anfang an offensichtlich ist und iterative Verarbeitung
erforderlich ist.
=== Forces
<forces>
#strong[Experimentation]: In Domains wo kein definitiver Ansatz
existiert. Es erlaubt ein ausprobieren von verschiedenen Algorithmen und
Heuristiken

#strong[Wiederverwendbare Knowledge Sources]: Knowledge Resources sind
unabhängig und spezialisiert für bestimmte Aufgaben. Voraussetzung für
Wiederverwendung jedoch müssen Blackboard und Knowledge Source gleiches
Protokoll und Daten kennen

#strong[Support für Fehlertoleranz]: Die Teillösungen oder auch
Hypothesen genannt "überleben" nur, wenn sie von anderen Hypothesen und
Daten unterstützt werden. Dies liefert eine gewisse Toleranz gegenüber
Noisy Data und unsicheren Schlussfolgerungen
=== Solution
<solution>
#figure([#image(width: 50%,"../presentations/uploads/65683560cc733705bb3a21e0e5d8759a/image.png")],
  caption: [
    image
  ]
)

Die Idee vom Blackboard Pattern ist es, dass unabhängige Programme
kooperativ mit einer gemeinsamen Datenstruktur an einem Problem
arbeiten. Während des Problemlösungsprozesses arbeitet das System mit
Teillösungen, die kombiniert, geändert oder abgelehnt werden.

System wird in folgende Komponenten unterteilt:

#strong[Blackboard:] Eine strukturierter Hauptspeicher, der
Teillösungen(Hypothesen) der Knowledge Sources enthält

#strong[Control]: wählt auszuführende Knowledge Source anhand einer
definierten (anpassbaren) Strategie

#strong[Knowledge Sources]: spezialisierte,unabhängige Module zur
Bildung von Teillösungen(Hypothesen) \#\#\# Strategie Es wird eine
gewisse Experimentation benötigt um eine optimale Strategie zu finden.
Die Strategie erfolgt nach dem Opportunistischem-Problemlösungs Prinzip.
Das heisst es wird die Knowledge Ressource ausgewählt, die am
wahrscheinlichsten etwas zur Lösung des Problems beitragen kann.
=== Liabilities
<liabilities>
-#strong[Testing:] Schwer zu testen, da es keine deterministische Lösung
gibt und somit die Lösungen oftmals nicht reproduzierbar sind. Ausserdem
sind falsche Hypothesen Teil des Lösungsprozesses

-#strong[Korrektheit]: Keine gute Lösung ist garantiert. Blackboard
Systeme können nur einen gewissen Prozentsatz der Aufgaben richtig
lösen.

-#strong[Strategieentwicklung:] Schwierig gute Kontroll-Strategie zu
finden. Diese kann nur in experimentell ermittelt werden.

-#strong[Effizienz:] Geringe Effizienz. Es entsteht viel overhead bei
verworfenen Hypothesen. Jedoch besser als gar nichts.

-#strong[Aufwand:] Hoher Entwicklungsaufwand. Brauchen Jahre um sich zu
entwicklen, da man durch trial-and-error Programmierung nur schwer
vorankommt.

-#strong[Parallelisierung:] Kein Support für Parallelisierung. Es
verhindert zwar nicht eine Kontrollstrategie umzusetzten, welche
Parallelisierbarkeit unterstützt. Jedoch müssen auch Daten auf
Blackboard synchronisiert werden
=== Prüfungsfragen
<prüfungsfragen>
1.Kommunizieren im Blackboard-Pattern die spezialisierten Module
miteinander, um eine Lösung zu finden? \[Nein\]

2.Kann das Blackboard-Pattern verwendet werden, um komplexe und sich
schnell ändernde Probleme in der Softwareentwicklung anzugehen?\[Ja\]
== Lazy Acquisition
<lazy-acquisition>
Moderator: Joel Sauvain
=== Intro
<intro>
Das Lazy Acquisition Software Pattern ist ein Designansatz, der darauf
abzielt, die Ressourcennutzung zu optimieren und die Leistung des
Systems zu verbessern, indem die Beschaffung von Ressourcen verschoben
wird, bis sie tatsächlich benötigt werden. Dieses Muster ist besonders
nützlich in Szenarien, in denen die Beschaffung von Ressourcen von
Anfang an zu unnötigem Overhead führen kann oder wenn die Verfügbarkeit
von Ressourcen unsicher ist.
=== Problem
<problem>
In der traditionellen Softwareentwicklung werden Ressourcen wie
Datenbankverbindungen, Netzwerkverbindungen oder aufwendige Berechnungen
oft zu Beginn der Programmausführung erworben, unabhängig davon, ob sie
sofort benötigt werden. Diese vorausschauende Beschaffung kann zu
verschwendeten Ressourcen und längeren Startzeiten führen, insbesondere
in Fällen, in denen bestimmte Ressourcen nicht während der gesamten
Programmlaufzeit benötigt werden.
=== Forces
<forces>
#strong[Ressourceneffizienz]: Das trägerweise Erwerben von Ressourcen
ermöglicht eine effizientere Nutzung der Systemressourcen, da sie nur
dann bezogen werden, wenn sie tatsächlich benötigt werden.

#strong[Verbesserte Startleistung]: Das Hinauszögern der
Ressourcenbeschaffung bis zum tatsächlichen Bedarf kann zu schnelleren
Programmstartzeiten führen, was Anwendungen zugutekommt, die eine
schnelle Initialisierung priorisieren.

#strong[Dynamische Ressourcenverfügbarkeit]: In Situationen, in denen
die Verfügbarkeit von Ressourcen dynamisch oder unsicher ist, ermöglicht
die trägerweise Beschaffung Systemen, sich an wechselnde Bedingungen
anzupassen, ohne unnötige Ressourcen in Anspruch zu nehmen.

#strong[Verringerter Overhead]: Das Vermeiden der vorausschauenden
Beschaffung von Ressourcen reduziert unnötigen Overhead, was
entscheidend ist, um die Leistung in ressourcenbeschränkten Umgebungen
zu optimieren.
=== Solution
<solution>
Das Lazy Acquisition-Muster schlägt vor, Ressourcen nur dann zu
beschaffen, wenn sie während der Programmausführung tatsächlich benötigt
werden. Anstatt alle Ressourcen zu Beginn des Programms zu erwerben,
initialisiert sich das System mit minimalen Ressourcen und beschafft
zusätzliche Ressourcen bei Bedarf. Diese Strategie der
bedarfsgesteuerten Beschaffung wird durch Mechanismen wie das
trägerweise Laden umgesetzt, bei dem Ressourcen nur geladen oder
initialisiert werden, wenn sie zum ersten Mal abgerufen werden. Dieses
Muster verbessert die Ressourceneffizienz, verringert die Startzeiten
und bietet eine größere Flexibilität im Umgang mit dynamischer
Ressourcenverfügbarkeit.
=== Aktuelle Praxisbeispiele
<aktuelle-praxisbeispiele>
Bei einem Patientendossier kann man zum Beispiel für alle Bilder einen
Proxy verwenden, statt diese direkt zu laden. Dann kann man dies bei
Bedarf nachladen.
=== Prüfungsfragen
<prüfungsfragen>
+ Das Lazy Acquisition Software Pattern zielt darauf ab, alle Ressourcen
  zu Beginn der Programmausführung zu erwerben. \[ Nein \]
+ Das Lazy Acquisition-Muster kann zur Verbesserung der Startleistung
  beitragen, indem die Beschaffung von Ressourcen verschoben wird, bis
  sie tatsächlich benötigt werden. \[ Ja \]
== VW 11 - Coordinator
<vw-11---coordinator>
=== Intro
<intro>
Das Coordinator pattern beschreibt wie in einem system konsistenz
behalten werden kann, in dem tasks mit mehreren teilnehmern koordiniert
werden können. Diese können jeweils eine resource, einen resource user
und einen resource provider enthalten. Das pattern sagt aus, das der
Task nur abgeschlossen ist, wenn alle teilnehmer abgeschlossen haben.
=== Problem
<problem>
Das Pattern setzt sich mit dem Problem auseinander, wie komplizierte
vorgänge koordiniert werden können, die verschiedene Teilnehmer haben.
Das ganze muss auch konsistent bleiben, wenn ein schritt des Tasks
fehlschlägt. Wenn andere sub-systeme ihre tasks aber schon erfolgreich
abgeschlossen haben, kann das zu änderungen auf ihrem system führen. Das
kann dann dazu führen, das der Zustand nicht konsistent ist, da auf dem
System, auf welchem der Task fehlgeschlagen ist, die Daten in einem
anderen Zustand sind.
=== Forces
<forces>
- Consistency: Ein Task soll einen neuen Validen zustand eines systems
  erstellen
- Atomicity: Bei einem Task mit mehreren Teilnehmern soll der gesamte
  Task oder garnichts abgeschlossen werden.
- Location transparency: Soll in distributed systems funktionieren.
- Scalability: Skalirbar ohne das die pefrormance schlechter wird
- Transparency: Transparent für system benutzer.
=== Solution
<solution>
Es soll ein Coordinator eingeführt werden, welcher für die ausführung
und den abschluss der arbeit jeder teilnehmer zustßndig ist. Die Arbeit
von jedem Teilnehmer ist unterteilt in prepare und commit.

Bei Prepare prüft jeder Teilnehmer die konsistenz und prüft ob die
durchführung zu einem fehler führen würde. Wenn ein Teilnehmer prepare
nicht Erfolgreich durchführen kann, wird die Task excecution
abgebrochen. Bei den Teilnehmern die erfolgreich prepared haben wird ein
abort ausgelöst durch den coordinator.

In der commit phase wird effektiv die arbeit verrichtet.

#figure([#image(width: 50%,"../presentations/uploads/62b311900aa6e59c08e89d932d0c3966/Screenshot_2023-12-01_at_11.44.32.png")],
  caption: [
    Screenshot 2023-12-01 at 11.44.32.png
  ]
)
=== Benefits
<benefits>
Gleich wie forces.
=== Liabilities
<liabilities>
- Overhead -\> jeder task wird in zwei Phasen unterteilt.
- Zusätzliche aufgaben -\> jeder Teilnehmer muss sich beim Coordinator
  registrieren.
=== Prüfungsfragen
<prüfungsfragen>
Die Arbeit jedes Teilnehmer wird in prepare und commit unterteilt. Ja

Der Einsatz des Patterns führt zu overhead, weil der Task in vier Phasen
unterteilt wird. Nein
== VW 13 - Resource Lifecycle Manager(RLM)
<vw-13---resource-lifecycle-managerrlm>=== Intro
<intro>
Das Pattern des Ressourcen-Lebenszyklus-Managers(RLM) entkoppelt die
Verwaltung des Lebenszyklus von Ressourcen von ihrer Nutzung, indem es
einen separaten Ressourcen-Lebenszyklus-Manager einführt. Die alleinige
Verantwortung dieses Managers besteht darin, die Ressourcen einer
Anwendung zu verwalten.
=== Problem
<problem>
Ressourcenverwaltung in grossen Systemen ist aufwendig und bietet grosse
Herausforderungen. Ohne ein effektives Ressourcenmanagement kann es zu
Überlastungen, ineffizienter Nutzung und Leistungsproblemen kommen.
Manuelle Ressourcenfreigabe und -verwaltung können zu Fehlern führen und
die Wartbarkeit der Anwendung beeinträchtigen.
=== Forces
<forces>
- #strong[Availability:] In grossen Systemen ist es wichtig, Ressourcen
  effizient und effektiv zu verwalten, um sicherzustellen, dass sie für
  Benutzer verfügbar sind, wenn sie benötigt werden.
- #strong[Scalability:] Mit zunehmender Grösse von Systemen wächst auch
  die Anzahl der Ressourcen, die verwaltet werden müssen. Somit kann es
  für Benutzer erheblich schwieriger werden, sie direkt zu verwalten.
- #strong[Complexity:] Das Aufrechterhalten und Verfolgen von komplexen
  Abhängigkeiten zwischen Ressourcen in grossen Systemen ist wichtig, um
  eine ordnungsgemäße und rechtzeitige Freigabe von Ressourcen zu
  ermöglichen, wenn sie nicht mehr benötigt werden.
- #strong[Performance:] Bottlenecks verhindern. Die Bereitstellung
  solcher Optimierungen kann recht komplex sein, wenn sie von einzelnen
  Ressourcennutzern durchgeführt wird.
- #strong[Stability:] User könnten vergessen Ressourcen freizugeben, was
  zu Systeminstabilitäten führen kann. Die Steuerung der
  Ressourcenbeschaffung verhindert Starvation.
- #strong[Interdependencies:] Lebenszyklen von Ressourcen können
  voneinander abhängig sein und müssen entsprechend angemessen verwaltet
  werden.
- #strong[Flexibility:] Verschiedene Strategien sollten möglich und
  konfigurierbar sein
- #strong[Transparency:] Der Ressourcennutzer sollte nicht mit den
  Komplexitäten der Ressourcenverwaltung konfrontiert werden müssen.
=== Solution
<solution>
Der RLM-Ansatz umfasst die Definition klarer Lebenszyklusphasen für
Ressourcen, einschließlich Erstellung, Zuweisung, Nutzung und Freigabe.
Automatisierungswerkzeuge und -Strategien werden implementiert, um den
Lebenszyklus von Ressourcen zu verwalten.

#figure([#image(width: 50%,"../presentations/uploads/789b9dc78de8558c6553081c63611f42/RLMdynamics.PNG")],
  caption: [
    RLMdynamics
  ]
)
=== Liabilities
<liabilities>
- #strong[Single point of failure:] . Bug oder Fehler in RLM kann zu
  Ausfällen in grossen Teilen der Applikation führen.
- #strong[Flexibility:] Wenn individuelle Ressourceninstanzen eine
  spezielle Behandlung benötigen, könnte das RLM möglicherweise zu
  unflexibel sein
=== Prüfungsfragen
<prüfungsfragen>
- Erfordert der Ressource Lifecycle Manager, dass der Ressourcennutzer
  sich mit den Komplexitäten der Ressourcenverwaltung auseinandersetzt?
  \[Nein\]
- Hilft der Ressource Lifecycle Manager die Effizienz der
  Ressourcennutzung in einer Anwendung zu verbessern? \[Ja\]
