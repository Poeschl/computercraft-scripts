-- based on Stripmining Programm © 2013 SemOnLPs

--start: block der verhindert das der hautpfad unterborchen wird
function Sicherheitspfad()
	if turtle.detectDown() == false then -- wen kein block unter der turel ist
		turtle.select(1) -- slot 1 auswaehlen
    	turtle.placeDown() -- und unter die turel setzten
	end
end
--end: block der verhindert das der hautpfad unterborchen wird

--start: hier wird der Hauptgang gegraben
function Mittelgang()
	NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
	Sicherheitspfad() -- wird nur im Hauptgang gemacht, prueft ob unter der Turtel ein Block ist wen nein setzt sie einen aus slot 1
	KiesUp(ganghoehe - 1) -- haut den block uebersich weg, koennt sein das dan noch kies nach faellt

	NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
	Sicherheitspfad() -- wird nur im Hauptgang gemacht, prueft ob unter der Turtel ein Block ist wen nein setzt sie einen aus slot 1
	KiesUp(ganghoehe - 1) -- haut den block uebersich weg, koennt sein das dan noch kies nach faellt

	Fackel("mitte") -- fackel auf der rechten seite setzten
	NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
	Sicherheitspfad() -- wird nur im Hauptgang gemacht, prueft ob unter der Turtel ein Block ist wen nein setzt sie einen aus slot 1
	KiesUp(ganghoehe - 1) -- haut den block uebersich weg, koennt sein das dan noch kies nach faellt
end
--end: hier wird der Hauptgang gegraben

--start: baut einen Seitengang
function Seitengang()
	for i = 1, laengeSeitengang, 1 do -- grabe dich in den gang
		NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
		KiesUp(ganghoehe - 1) -- haut den block uebersich weg, koennt sein das dan noch kies nach faellt
	end
	
	turtle.turnRight() -- umdrehen
	turtle.turnRight() -- umdrehen
	for i = laengeSeitengang, 1, -1 do -- komm zur mitte zurueck
		if (i % fackelnSeitengang == 0 and fackelnSeitengang ~= 0) then -- wenn fackeln gesetzt werden sollen und diese dem abastand entsprechen 
			Fackel("seite")
		end
		NachVorne() -- 1 block nach vorne mit der pruefung ob die Turel fahren konnte
	end
end
--end: baut einen Seitengang

--start: geht 1 block nach vorne
function NachVorne()
	while turtle.detect() do -- prueft ob ein block vor der turel ist
		turtle.dig()
		sleep(0.25)
	end
	
	while(turtle.forward() == false) do --wenn er nicht fahren konnte
		turtle.dig()  -- einmal abbauen
		turtle.attack() -- einmal zuschlagen
	end
end
--end: geht 1 block nach vorne

--start: beim abbauen uebersich ob kies nachfaell, wen ja solange abbauen bis nichts mehr kommt
function KiesUp(hoehe)
	while turtle.detectUp() do -- prueft ob ueber ihm noch etwas ist 
		turtle.digUp() -- haut den block ueber sich ab
		sleep(0.25) -- wartet, funktioniert nur wen der block direck nachfaellt ist ein block 
	end
	if hoehe > 1 then
		turtle.up()
		KiesUp(hoehe-1)
		turtle.down()
	end
end
--end: beim abbauen uebersich ob kis nachfaell, wen ja solange abbauen bis nichts mehr kommt

--start: plaziert die Fackel
function Fackel(gang) -- ueber gibt gang oder seite
	if (fakelanzahl1 ~= 0) then
		turtle.select(slotFackeln1) -- waehlt die Fackeln aus
		fakelanzahl1 = fakelanzahl1 - 1
	elseif (fakelanzahl2 ~= 0) then
		slotFackeln1 = 0 -- setzt die slotz zurueck zum entleeren der kiste
		turtle.select(slotFackeln2) -- waehlt die Fackeln aus
		fakelanzahl2 = fakelanzahl2 - 1
	elseif (fakelanzahl3 ~= 0) then
		slotFackeln1 = 0 -- setzt die slotz zurueck zum entleeren der kiste
		slotFackeln2 = 0 -- setzt die slotz zurueck zum entleeren der kiste
		turtle.select(slotFackeln3) -- waehlt die Fackeln aus
		fakelanzahl3 = fakelanzahl3 - 1
	else
		slotFackeln1 = 0 -- setzt die slotz zurueck zum entleeren der kiste
		slotFackeln2 = 0 -- setzt die slotz zurueck zum entleeren der kiste
		slotFackeln3 = 0 -- setzt die slotz zurueck zum entleeren der kiste
		return -- keine fackeln mehr mach nichts
	end
	
	if (gang == "seite") then
			turtle.placeUp() -- plaziert die Fackel ueber sich
			turtle.select(1) -- waehlt wieder slot 1 oder den ersten der dan frei ist
	else	
		if (turtle.back()) then-- plaziert die fackel wen er 1 block zurueck fahren konnte
			turtle.placeUp() -- plaziert die Fackel ueber sich
			NachVorne() -- geht wieder nach vorne
		end
	end
	turtle.select(1) -- waehlt wieder slot 1 oder den ersten der dan frei ist
end
--end: plaziert die Fackel

--start: Steuerung fuer Hauptgang und Seitengang
function Strip()
	Mittelgang() -- hier wird der Hauptgang gegraben
	turtle.turnRight() -- startposition fuer die linke seite 
	Seitengang() -- graebt den ersten seitengang und kommt zurueck zur mitte
	Seitengang() -- graebt den zweiten seitengang und kommt zurueck zur mitte
end
--end: Steuerung fuer Hauptgang und Seitengang

--start: entleere das inventar in die endertruhe
function enderTruhe()
	if (endertruhe == 0) then -- wen keine kiste ausgewaehlt ist nicht in endertruhe leeren
		return
	end
	while turtle.detect() do -- die Truhe braucht platz um hingestell werden zu koennen also wird solange gegraben bis platz da ist
		turtle.dig()
		sleep(0.5)
	end
	turtle.select(slotEndertruhe) -- Truhe auswaehlen
	turtle.place() -- Truhe plazieren
	for i = 1,16 do -- k dient hier als zaehler um jeden platz leer zu machen
		turtle.select(i)
		if (turtle.getItemCount(i) == 0 and i ~= slotEndertruhe and i ~= slotFackeln1 and i ~= slotFackeln2 and i ~= slotFackeln3) then -- stop beachte die fackeln umzusetzend
			break -- hier wird abgebrochen wenn der slot leer ist 
			      -- eine schneller entladung der kist ist somit gegeben ^^
		elseif (turtle.getItemCount(i) ~= 0 and i ~= slotEndertruhe and i ~= slotFackeln1 and i ~= slotFackeln2 and i ~= slotFackeln3) then
			turtle.drop() -- legt die items in aus dem slot in die truhe
		end
	end
	turtle.select(slotEndertruhe) -- waehlt slot 15 aus 
	turtle.dig() -- und nimmt die truhe wieder auf
	turtle.select(1) -- waehlt wieder slot 1 oder den ersten der dan frei ist
end
--end: entleere das inventar in die endertruhe

--start: graebt den Tunnel solange wie eingegeben wurde
function tunnel()
	statusBildschirm(0) -- bereinigt den Bildschirm beim Start des Tunnelgrabens
	kistenabstand = entleerungEndertruhe  -- nach diesem gang wird das 1 mal die truhe geleert
	for aktuellergang = 1, ganganzahl, 1 do -- schleife die soviele gaenge macht wie eingeben
		Strip() -- hier wird der hauptgang mit einem Tunnel links und rechts gegraben
		-- entwerder nur nach links drehen oder nach links drehen und die kiste setzten
		if (aktuellergang  == kistenabstand and aktuellergang ~= ganganzahl) then
			turtle.turnLeft() -- gehe einmal nach links 
			kistenabstand = kistenabstand + entleerungEndertruhe -- kistenabstand wieder 3 hoch
			enderTruhe() -- entleer die in die Enertrue
		elseif (aktuellergang  == ganganzahl) then -- letzter gang nach rechts gehen und in die Truhe entlehren
			turtle.turnRight() -- zurueck in gang drehen fuer die fahrt zur Ausgangsposition
			enderTruhe() -- es war der letzte gang, sprich stell die kist das letzte mal und entleeren
		else 
			turtle.turnLeft() -- gehe nur einmal nach lings und mach mit dem hauptgan weiter
		end
		statusBildschirm(aktuellergang) -- Aktuallisierung des Bildschirms wenn ein Gang gegraben wurde (aktuellergang muss uebergeben werden)
	end
end
--end: graebt den Tunnel solange wie eingegeben wurde

--start: Zurueck zur Ausgangsposition
function back()
	for a = 1,ganganzahl * 3 do
		NachVorne()
	end
end
--end: Zurueck zur Ausgangsposition

--start: Aktuallisierung des Bildschirms wenn ein Gang gegraben wurde
function statusBildschirm(aktuellergang)
	-- start: Zeigt das Fuel-Level an
	term.setCursorPos( 1, 3)
	term.clearLine()
	fuellevel = turtle.getFuelLevel()
	print("Fuel-Level: " .. fuellevel)
	
	term.setCursorPos( 1, 4)
	term.clearLine()
	if (endertruhe == 1) then
		print("Endertruhe: Ja")
	else
		print("Endertruhe: Nein")
	end		
	
	-- start: Zeigt die anzahl der Fakeln an
	term.setCursorPos( 1, 5)
	term.clearLine()
	fackeln = fakelanzahl1 + fakelanzahl2 + fakelanzahl3
	print("Fackeln   : " .. fackeln)
	
	term.setCursorPos(1,7)
	term.clearLine()
	if (aktuellergang > 0) then
		print("Gang " .. aktuellergang .. " von " .. ganganzahl .. " wurde fertiggestellt!")
	else -- wen das programm startet
		term.setCursorPos(1,8)
		term.clearLine()
		term.setCursorPos(1,9)
		term.clearLine()
		term.setCursorPos(1,10)
		term.clearLine()
		term.setCursorPos(1,12)
		term.clearLine()
		turtle.select(1) -- waehlt zum start slot 1 aus
	end
end
--end: Aktuallisierung des Bildschirms wenn ein Gang gegraben wurde


--START: Programmsteuerung eingabe
--start: Aktuellisuerung des Status fuer Fakeln, Endertruhe, und Fullevel
local function checkStatus()
	slotsAnzeige = {"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"}
	slotsAnzeige[slotEndertruhe] = "e"
	slotsAnzeige[slotFackeln1] = "f"
	slotsAnzeige[slotFackeln2] = "f"
	slotsAnzeige[slotFackeln3] = "f"
	slotsAnzeige[slotAutofuel] = "a"
	
	local blink = 0 -- wird benoetigt fuer das blinken der Warnung das das Fuellevel nidrig ist
	while true do --prueft endlos den status
		time() -- zeit die Uhrzeit oben rechts an

		-- start: Zeigt das Fuel-Level an
		term.setCursorPos( 1, 3)
		term.clearLine()
		fuellevel = turtle.getFuelLevel()
		if (fuellevel < 500 and blink == 0) then
  			print("Fuel-Level: " .. fuellevel .. " !! Warnung !!")
  			blink = 1 -- setz blinken der Warnung zurueck
		else
			print("Fuel-Level: " .. fuellevel)
			blink = 0 -- setz blinken der Warnung zurueck
		end
		-- end: Zeigt das Fuel-Level an
		-- start: Zeigt die aufladung des Fuel-Level an
		term.setCursorPos( 1, 7)
		term.clearLine()
		term.clearLine()
		ladeeinheiten = turtle.getItemCount(tonumber(slotAutofuel)) -- Einheiten zum Aufladen aus slot 13
		if (ladeeinheiten == 1) then
			print("Hinweis:                       !".. slotsAnzeige[1] .. "!".. slotsAnzeige[2] .. "!".. slotsAnzeige[3] .. "!".. slotsAnzeige[4])
			print("Fuelaufladung um eine Einheit  !".. slotsAnzeige[5] .. "!".. slotsAnzeige[6] .. "!".. slotsAnzeige[7] .. "!".. slotsAnzeige[8])
			print("                               !".. slotsAnzeige[9] .. "!".. slotsAnzeige[10] .. "!".. slotsAnzeige[11] .. "!".. slotsAnzeige[12])
			print("                               !".. slotsAnzeige[13] .. "!".. slotsAnzeige[14] .. "!".. slotsAnzeige[15] .. "!".. slotsAnzeige[16])
		elseif (ladeeinheiten > 9) then 
			print("Hinweis:                       !".. slotsAnzeige[1] .. "!".. slotsAnzeige[2] .. "!".. slotsAnzeige[3] .. "!".. slotsAnzeige[4])
			print("Fuelaufladung um " .. ladeeinheiten .. " Einheiten  !".. slotsAnzeige[5] .. "!".. slotsAnzeige[6] .. "!".. slotsAnzeige[7] .. "!".. slotsAnzeige[8])
			print("                               !".. slotsAnzeige[9] .. "!".. slotsAnzeige[10] .. "!".. slotsAnzeige[11] .. "!".. slotsAnzeige[12])
			print("                               !".. slotsAnzeige[13] .. "!".. slotsAnzeige[14] .. "!".. slotsAnzeige[15] .. "!".. slotsAnzeige[16])
		elseif (ladeeinheiten > 1) then 
			print("Hinweis:                       !".. slotsAnzeige[1] .. "!".. slotsAnzeige[2] .. "!".. slotsAnzeige[3] .. "!".. slotsAnzeige[4])
			print("Fuelaufladung um " .. ladeeinheiten .. " Einheiten   !".. slotsAnzeige[5] .. "!".. slotsAnzeige[6] .. "!".. slotsAnzeige[7] .. "!".. slotsAnzeige[8])
			print("                               !".. slotsAnzeige[9] .. "!".. slotsAnzeige[10] .. "!".. slotsAnzeige[11] .. "!".. slotsAnzeige[12])
			print("                               !".. slotsAnzeige[13] .. "!".. slotsAnzeige[14] .. "!".. slotsAnzeige[15] .. "!".. slotsAnzeige[16])
		else
			print("                               !".. slotsAnzeige[1] .. "!".. slotsAnzeige[2] .. "!".. slotsAnzeige[3] .. "!".. slotsAnzeige[4])
			print("                               !".. slotsAnzeige[5] .. "!".. slotsAnzeige[6] .. "!".. slotsAnzeige[7] .. "!".. slotsAnzeige[8])
			print("                               !".. slotsAnzeige[9] .. "!".. slotsAnzeige[10] .. "!".. slotsAnzeige[11] .. "!".. slotsAnzeige[12])
			print("                               !".. slotsAnzeige[13] .. "!".. slotsAnzeige[14] .. "!".. slotsAnzeige[15] .. "!".. slotsAnzeige[16])
		end
		-- end: Zeigt die aufladung des Fuel-Level an
		
		-- start: Pruefung fuer die Endertruhe
		term.setCursorPos( 1, 4)
		term.clearLine()
		endertruhe = turtle.getItemCount(tonumber(slotEndertruhe))
		if (endertruhe == 1) then
			print("Endertruhe: Ja")
			endertruhe = 1 --braucht man nicht ist nur zur sicherheit
		elseif (endertruhe > 1) then
			print("Endertruhe: Bitte nur 1 Kiste")
			endertruhe = 0
		else
			print("Endertruhe: Nein")
			endertruhe = 0
		end		
		-- end: Pruefung fuer die Endertruhe
		
		-- start: Zeigt die anzahl der Fakeln an
		term.setCursorPos( 1, 5)
		term.clearLine()
		fackeln = turtle.getItemCount(tonumber(slotFackeln1)) + turtle.getItemCount(tonumber(slotFackeln2)) + turtle.getItemCount(tonumber(slotFackeln3))
		if (fackeln == 0) then
			print("Fackeln   : Keine")
		elseif (fackeln == 1) then
			print("Fackeln   : " .. fackeln .. " (Eingabe 0 = ein Gang)")
		else
			print("Fackeln   : " .. fackeln .. " (Eingabe 0=" .. fackeln .." Gaenge)")
		end
		-- end: Zeigt die anzahl der Fakeln an
		
		term.setCursorPos(38,3)
		print("!a")
		term.setCursorPos(38,4)
		print("!e")
		term.setCursorPos(38,5)
		print("!f")
		term.setCursorPos(36, 12) -- setzt angezeigte curser zurueck zur eingabe
		sleep(0.4) -- minecraft minute dauert 0.8 Sekunden 
	end
end
--end: Aktuellisuerung des Status fuer Fakeln, Endertruhe, und Fullevel

--start: Eingabe der Fackeln und Pruefung ob 0 oder zwischen 1 und 999 oder einstellungen
local function eingabeTunnellaenge()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Anzahl Gaenge? (e = Einstellungen):") -- anzeige des Hilfetextes
		                       
		term.setCursorPos(36, 12) -- setzt position auf eingabe
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	ganganzahl = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (ganganzahl >= 0 and ganganzahl <= 999) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (ganganzahl == 0) then 
					ganganzahl = fackeln
			    end
				einstellung = 0
				return -- wenn alles ok ist, beende die eingabe
			end
		end

		if (inputstring == "e") then
			einstellung = 1
			return -- einstellung aender
		else
			term.setCursorPos(1, 12) -- setzt den curser hier her
			term.clearLine()
			print("0 = Fakelanzahl oder 1-999 moeglich")
			sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
		end
	end
end
--end: Eingabe der Fackeln und Pruefung ob 0 oder zwischen 1 und 999 oder einstellungen

--start: eingabe der einstellungen fuer das programm
local function einstellungen()
	for i = 3, 10, 1 do -- loesch den bilschirm ab der dritten zeile
		term.setCursorPos(1,i) -- zeile fuer anzeige bereinigen 
		term.clearLine() -- zeile fuer anzeige bereinigen 
	end
	
	term.setCursorPos(1,12) -- zeile fuer anzeige bereinigen 
	term.clearLine() -- zeile fuer anzeige bereinigen 
	
	
	-- anzeige fuer die einstellungen
	term.setCursorPos(1, 3) -- setzt den curser in zeile 3
	print("Slot Endertruhe        : " .. slotEndertruhe) -- anzeige des Hilfetextes
	term.setCursorPos(1, 4) -- setzt den curser in zeile 3
	print("Slot eins fuer Fackeln : " .. slotFackeln1) -- anzeige des Hilfetextes
	term.setCursorPos(1, 5) -- setzt den curser in zeile 3
	print("Slot zwei fuer Fackeln : " .. slotFackeln2) -- anzeige des Hilfetextes
	term.setCursorPos(1, 6) -- setzt den curser in zeile 3
	print("Slot drei fuer Fackeln : " .. slotFackeln3) -- anzeige des Hilfetextes
	term.setCursorPos(1, 7) -- setzt den curser in zeile 3
	print("Slot Autofuelaufladung : " .. slotAutofuel) -- anzeige des Hilfetextes
	term.setCursorPos(1, 8) -- setzt den curser in zeile 3
	print("Laenge der Seitengaenge: " .. laengeSeitengang) -- anzeige des Hilfetextes
	term.setCursorPos(1, 9) -- setzt den curser in zeile 3
	print("Fakeln in Seitengaenge : " .. fackelnSeitengang) -- anzeige des Hilfetextes
	term.setCursorPos(1, 10) -- setzt den curser in zeile 3
	print("Entleerung Enderchest  : " .. entleerungEndertruhe) -- anzeige des Hilfetextes
	
	corsor = 3 -- eingabeposition, wird gebraucht bei der zeitanzeige
	einstellungenEndertruhe()
	term.setCursorPos(1, 3) -- setzt den curser in zeile 3
	print("Slot Endertruhe        : " .. slotEndertruhe) -- anzeige des Hilfetextes
	
	corsor = 4 -- eingabeposition, wird gebraucht bei der zeitanzeige
	einstellungenFackeln1()
	term.setCursorPos(1, 4) -- setzt den curser in zeile 3
	print("Slot eins fuer Fackeln : " .. slotFackeln1) -- anzeige des Hilfetextes
	
	corsor = 5 -- eingabeposition, wird gebraucht bei der zeitanzeige
	einstellungenFackeln2()
	term.setCursorPos(1, 5) -- setzt den curser in zeile 3
	print("Slot zwei fuer Fackeln : " .. slotFackeln2) -- anzeige des Hilfetextes
	
	corsor = 6 -- eingabeposition, wird gebraucht bei der zeitanzeige
	einstellungenFackeln3()
	term.setCursorPos(1, 6) -- setzt den curser in zeile 3
	print("Slot drei fuer Fackeln : " .. slotFackeln3) -- anzeige des Hilfetextes
	
	corsor = 7 -- eingabeposition, wird gebraucht bei der zeitanzeige
	einstellungenAutofuel()
	term.setCursorPos(1, 7) -- setzt den curser in zeile 3
	print("Slot Autofuelaufladung : " .. slotAutofuel) -- anzeige des Hilfetextes
	
	corsor = 8 -- eingabeposition, wird gebraucht bei der zeitanzeige
	einstellungenLaengeSeitengang()
	term.setCursorPos(1, 8) -- setzt den curser in zeile 3
	print("Laenge der Seitengaenge: " .. laengeSeitengang) -- anzeige des Hilfetextes
	
	corsor = 9 -- eingabeposition, wird gebraucht bei der zeitanzeige
	einstellungenFackelnSeitengang()
	term.setCursorPos(1, 9) -- setzt den curser in zeile 3
	print("Fakeln in Seitengaenge : " .. fackelnSeitengang) -- anzeige des Hilfetextes
	
	corsor = 10 -- eingabeposition, wird gebraucht bei der zeitanzeige
	einstellungenEntleerungEnderchest()
	term.setCursorPos(1, 10) -- setzt den curser in zeile 3
	print("Entleerung Enderchest  : " .. entleerungEndertruhe) -- anzeige des Hilfetextes
end

--end: eingabe der einstellungen fuer das programm

--start: eingabe der einstellungen fuer das programm
function einstellungenEndertruhe()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Slot fuer die Endertruhe") -- anzeige des Hilfetextes
		
		term.setCursorPos(1, 3) -- setzt den curser in zeile 3
		term.clearLine()
		print("Slot Endertruhe        :") -- anzeige des Hilfetextes
		term.setCursorPos(26, 3) -- setzt position auf eingabe
		
		
		local inputstring1 = read() -- auswertung der eingabe
		if (tonumber(inputstring1) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	slotEndertruhe = tonumber(inputstring1) --macht aus dem Strin ein zahl
			if (slotEndertruhe >= 0 and slotEndertruhe <= 16) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (slotEndertruhe == 0) then 
					slotEndertruhe = 15
			    end
				return -- wenn alles ok ist, beende die eingabe
			end
		end

		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine()
		print("Nur Slot 1 bis 16 moeglich, 0=Standard")
		sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
	end
end

--start: eingabe der einstellungen fuer das programm
function einstellungenFackeln1()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		gleichslot = 0 -- erstmal keine ueberlagerung
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Slot eins fuer die Fackeln") -- anzeige des Hilfetextes
		
		term.setCursorPos(1, 4) -- setzt den curser in zeile 3
		term.clearLine()
		print("Slot eins fuer Fackeln :") -- anzeige des Hilfetextes
		term.setCursorPos(26, 4) -- setzt position auf eingabe
		
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	slotFackeln1 = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (slotFackeln1 >= 0 and slotFackeln1 <= 16) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (slotFackeln1 == 0) then 
					slotFackeln1 = 16
				end

				if (slotFackeln1 ~= slotEndertruhe) then -- gleicher slot wie die endertruhe
					return -- wenn alles ok ist, beende die eingabe
				else
					gleichslot = 1 -- wen sich 2 slots ueberlagern wuerden
				end
			end
		end


		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine()
		if (gleichslot == 1) then
			print("Slot bereits in Verwendung")
		else
			print("Nur Slot 1 bis 16 moeglich, 0=Standard")
		end
		sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
	end
end
--end: 
--start: eingabe der einstellungen fuer das programm
function einstellungenFackeln2()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		gleichslot = 0 -- erstmal keine ueberlagerung
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Slot zwei fuer die Fackeln") -- anzeige des Hilfetextes
		
		term.setCursorPos(1, 5) -- setzt den curser in zeile 3
		term.clearLine()
		print("Slot zwei fuer Fackeln :") -- anzeige des Hilfetextes
		term.setCursorPos(26, 5) -- setzt position auf eingabe
		
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	slotFackeln2 = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (slotFackeln2 >= 0 and slotFackeln2 <= 16) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (slotFackeln2 == 0) then 
					slotFackeln2 = 12
			    end
				
				if (slotFackeln2 ~= slotEndertruhe and slotFackeln2 ~= slotFackeln1) then -- gleicher slot wie die endertruhe
					return -- wenn alles ok ist, beende die eingabe
				else
					gleichslot = 1 -- wen sich 2 slots ueberlagern wuerden
				end
			end
		end

		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine()
		if (gleichslot == 1) then
			print("Slot bereits in Verwendung")
		else
			print("Nur Slot 1 bis 16 moeglich, 0=Standard")
		end
		sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
	end
end
--end: 
--start: eingabe der einstellungen fuer das programm
function einstellungenFackeln3()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Slot drei fuer die Fackeln") -- anzeige des Hilfetextes
		
		term.setCursorPos(1, 6) -- setzt den curser in zeile 3
		term.clearLine()
		print("Slot drei fuer Fackeln :") -- anzeige des Hilfetextes
		term.setCursorPos(26, 6) -- setzt position auf eingabe
		
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	slotFackeln3 = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (slotFackeln3 >= 0 and slotFackeln3 <= 16) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (slotFackeln3 == 0) then 
					slotFackeln3 = 8
			    end
				if (slotFackeln3 ~= slotEndertruhe and slotFackeln3 ~= slotFackeln1 and slotFackeln3 ~= slotFackeln2) then -- gleicher slot wie die endertruhe
					return -- wenn alles ok ist, beende die eingabe
				else
					gleichslot = 1 -- wen sich 2 slots ueberlagern wuerden
				end
			end
		end

		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine()
		if (gleichslot == 1) then
			print("Slot bereits in Verwendung")
		else
			print("Nur Slot 1 bis 16 moeglich, 0=Standard")
		end
		sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
	end
end
--end: 

--start: eingabe der einstellungen fuer das programm
function einstellungenAutofuel()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Slot fuer Autofuelaufladung beim Start") -- anzeige des Hilfetextes
		
		term.setCursorPos(1, 7) -- setzt den curser in zeile 3
		term.clearLine()
		print("Slot Autofuelaufladung :") -- anzeige des Hilfetextes
		term.setCursorPos(26, 7) -- setzt position auf eingabe
		
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	slotAutofuel = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (slotAutofuel >= 0 and slotAutofuel <= 16) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (slotAutofuel == 0) then 
					slotAutofuel = 13
			    end
				if (slotAutofuel ~= slotEndertruhe and slotAutofuel ~= slotFackeln1 and slotAutofuel ~= slotFackeln2 and slotAutofuel ~= slotFackeln3) then -- gleicher slot wie die endertruhe
					return -- wenn alles ok ist, beende die eingabe
				else
					gleichslot = 1 -- wen sich 2 slots ueberlagern wuerden
				end
			end
		end

		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine()
		if (gleichslot == 1) then
			print("Slot bereits in Verwendung")
		else
			print("Nur Slot 1 bis 16 moeglich, 0=Standard")
		end
		sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
	end
end
--end: 


--start: eingabe der einstellungen fuer das programm
function einstellungenLaengeSeitengang()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Laenge eines Seitenganges") -- anzeige des Hilfetextes
		
		term.setCursorPos(1, 8) -- setzt den curser in zeile 3
		term.clearLine()
		print("Laenge der Seitengaenge:") -- anzeige des Hilfetextes
		term.setCursorPos(26, 8) -- setzt position auf eingabe
		
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	laengeSeitengang = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (laengeSeitengang >= 0 and laengeSeitengang <= 999) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (laengeSeitengang == 0) then 
					laengeSeitengang = 5
			    end
				return -- wenn alles ok ist, beende die eingabe
			end
		end

		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine()
		print("Nur 0 bis 999 moeglich, 0=Standard")
		sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
	end
end
--end: 

--start: eingabe der einstellungen fuer das programm
function einstellungenFackelnSeitengang()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Abstand zwischen Fakeln im Seitengang") -- anzeige des Hilfetextes
		
		term.setCursorPos(1, 9) -- setzt den curser in zeile 3
		term.clearLine()
		print("Fakeln in Seitengaenge :") -- anzeige des Hilfetextes
		term.setCursorPos(26, 9) -- setzt position auf eingabe
		
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	fackelnSeitengang = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (fackelnSeitengang <= laengeSeitengang) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (fackelnSeitengang == 0) then 
					fackelnSeitengang = 0
			    end
				return -- wenn alles ok ist, beende die eingabe
			else
				term.setCursorPos(1, 12) -- setzt den curser hier her
				term.clearLine()
				print("Seitenganz waere zu kurz")
				sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
			end
		end	
	end
end
--end: 

--start: eingabe der einstellungen fuer das programm
function einstellungenEntleerungEnderchest()
	while true do -- ergibt eine endlosschleife bis man auf return kommt
		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine() -- loescht eventuell den Hilfetext
		term.setCursorPos(1, 12) -- setzt den curser hier her
		print("Anzahl Gaenge bis zur leerung") -- anzeige des Hilfetextes
		
		term.setCursorPos(1, 10) -- setzt den curser in zeile 3
		term.clearLine()
		print("Entleerung Enderchest  :") -- anzeige des Hilfetextes
		term.setCursorPos(26, 10) -- setzt position auf eingabe
		
		
		local inputstring = read() -- auswertung der eingabe
		if (tonumber(inputstring) ~= nil) then -- prueft ob eine Zahl eingegeben wurde
		   	entleerungEndertruhe = tonumber(inputstring) --macht aus dem Strin ein zahl
			if (entleerungEndertruhe >= 0 and entleerungEndertruhe <= 999) then -- wen die zahl zwischen 0 und 999 liegt alles ok
				if (entleerungEndertruhe == 0) then 
					entleerungEndertruhe = 3 -- standard
			    end
				return -- wenn alles ok ist, beende die eingabe
			end
		end

		term.setCursorPos(1, 12) -- setzt den curser hier her
		term.clearLine()
		print("Nur 0 bis 999 moeglich, 0=Standard")
		sleep(1.5) -- zeit fuer die anzeigt des Hilfetextets
	end
end
--end: 


--start: Uhrzeit und Tag in Minecraft auslesen und anzeigen
function time()
	term.setCursorPos(1, 1) -- position auf Zeit setzten
	local day -- locale Variable fuer den Tag in Minecraft
	local zeit -- locale Variable fuer die Uhrzeit in Minecraft
	day = os.day() -- nicht im Gebrauch!
	zeit = textutils.formatTime(os.time(), true) -- wandelt die anzeige in das 24 Stunden Format
	if (string.len(zeit) == 4) then -- zeit Anzeigt vor oder nach 10 Uhr
		print("Systemhinweis               Zeit:  " .. zeit) -- vor 10 Uhr, es geht um die laenge
	else
		print("Systemhinweis               Zeit: " .. zeit) -- nach 10 Uhr
	end
end
--end: Uhrzeit und Tag in Minecraft auslesen und anzeigen
local function timeshow()
	while true do --prueft endlos den status
		term.setCursorPos(1, 1) -- position auf Zeit setzten
		local day -- locale Variable fuer den Tag in Minecraft
		local zeit -- locale Variable fuer die Uhrzeit in Minecraft
		day = os.day() -- nicht im Gebrauch!
		zeit = textutils.formatTime(os.time(), true) -- wandelt die anzeige in das 24 Stunden Format
		if (string.len(zeit) == 4) then -- zeit Anzeigt vor oder nach 10 Uhr
			print("Einstellungen               Zeit:  " .. zeit) -- vor 10 Uhr, es geht um die laenge
		else
			print("Einstellungen               Zeit: " .. zeit) -- nach 10 Uhr
		end
		 
		term.setCursorPos(26, corsor) -- setzt angezeigte curser zurueck zur eingabe
		sleep(0.4) -- minecraft minute dauert 0.8 Sekunden 
	end
end

--end: Programmsteuerung eingabe

--start: bereinigt den Bildschirm und baut das eingabe Fenster auf
function bildschirmStart()
	shell.run("clear") -- lÃƒÂ¶scht allties auf dem Bildschirm
	print("Systemhinweis")
	print("=======================================")
	term.setCursorPos(1,6)
	term.clearLine()
	print("---------------------------------------")
	term.setCursorPos(1,11)
	print("---------------------------------------")
end
--end: bereinigt den Bildschirm und baut das eingabe Fenster auf

--start: zeigt an das die Turel fertig sit
function zeigtFertig()
	term.setCursorPos(1,10) -- zeile 10 fuer anzeige bereinigen 
	term.clearLine() -- zeile 10 fuer anzeige bereinigen 
	print("!!!Fertig - Programm beendet!!!") -- fertig meldung
	term.setCursorPos(1,12) -- letzte zeile bereinigen 
	term.clearLine() -- letzte zeile bereinigen 
end
--end: zeigt an das die Turel fertig sit

function einstellungenSpeichern()
	config = fs.open("strip.conf", "w") -- oeffent die config datei
	config.writeLine("slotEndertruhe       = " .. slotEndertruhe)
	config.writeLine("slotFackeln1         = " .. slotFackeln1)
	config.writeLine("slotFackeln2         = " .. slotFackeln2)
	config.writeLine("slotFackeln3         = " .. slotFackeln3)
	config.writeLine("slotAutofuel         = " .. slotAutofuel)
	config.writeLine("fackelnSeitengang    = " .. fackelnSeitengang) 
	config.writeLine("laengeSeitengang     = " .. laengeSeitengang) 
	config.writeLine("entleerungEndertruhe = " .. entleerungEndertruhe)
	config.close() -- schließt die einstellungen
end


function einstellungenLesen()
	config = fs.open("strip.conf", "r")
	if config then
		line = config.readLine()
		slotEndertruhe = tonumber(string.sub(line,24,30))
		line = config.readLine()
		slotFackeln1 = tonumber(string.sub(line,24,30))
		line = config.readLine()
		slotFackeln2 = tonumber(string.sub(line,24,30))
		line = config.readLine()
		slotFackeln3 = tonumber(string.sub(line,24,30))
		line = config.readLine()
		slotAutofuel = tonumber(string.sub(line,24,30))
		line = config.readLine()
		fackelnSeitengang = tonumber(string.sub(line,24,30))
		line = config.readLine()
		laengeSeitengang = tonumber(string.sub(line,24,30))
		line = config.readLine()
		entleerungEndertruhe = tonumber(string.sub(line,24,30))
		config.close()
	else
		slotEndertruhe = 15 -- Slot fuer die Endertruhe
		slotFackeln1 = 16    -- Slot fuer Fakeln 1
		slotFackeln2 = 12    -- Slot fuer Fakeln 2 stop
		slotFackeln3 = 8    -- Slot fuer Fakeln 3 stop
		slotAutofuel = 13    -- Slot fuer Autofuel
		fackelnSeitengang = 0 -- fackeln im seitengang, 0=keine
		laengeSeitengang = 5  -- laenge des seitengangs 0 = 5
		entleerungEndertruhe = 3 --nach wieielen gaengen wird die Endertruhe geleert, Standart 3    stop
	end
end


--**Hauptprogrammsteuerung
--Setzen der globale Variablen (diese sind ueberall verfuegbar)
endertruhe = 0           -- Endertruhe = nein
fackeln = 0              -- Fackeln = 0
ganganzahl = 0           -- Anzahl Gaenge = 0
fuellevel = 0            -- Fuel-Level = 0
einstellung = 0          -- keine einstellungen vornehmen
slotEndertruhe = 0       -- Slot fuer die Endertruhe
slotFackeln1 = 0         -- Slot fuer Fakeln 1
slotFackeln2 = 0         -- Slot fuer Fakeln 2 stop
slotFackeln3 = 0         -- Slot fuer Fakeln 3 stop
fakelanzahl1 = 0         -- anzahl der fakeln in slot 1 nach dem start
fakelanzahl2 = 0         -- anzahl der fakeln in slot 2 nach dem start
fakelanzahl3 = 0         -- anzahl der fakeln in slot 3 nach dem start
slotAutofuel = 0         -- Slot fuer Autofuel
fackelnSeitengang = 0    -- fackeln im seitengang, 0=keine
laengeSeitengang = 0     -- laenge des seitengangs 0 = 5
entleerungEndertruhe = 0 -- nach wieielen gaengen wird die Endertruhe geleert, Standart 3
slotsAnzeige = {"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"}
corsor = 0               -- line of the cursor
ganghoehe = 3
-- bereinigt den Bildschirm und baut das eingabe Fenster auf
bildschirmStart()
einstellungenLesen()
-- fuerht 2 funktionen gleichzeitig aus, eingab und aktuellisuerung der Fakeln, Endertruhe, und Fullevel

parallel.waitForAny(eingabeTunnellaenge, checkStatus) 
while (einstellung == 1) do
	parallel.waitForAny(einstellungen,timeshow) -- bearbeitung der einstellung
	einstellungenSpeichern()
	bildschirmStart()
	einstellungenLesen()
	parallel.waitForAny(eingabeTunnellaenge, checkStatus) 
end

--Laed die Turtel vor dem start wieder auf wen etwas in slot 13 abgelegt wurde und merke die fakeln
turtle.select(slotAutofuel) -- Slot 13 auswaehlen
turtle.refuel(turtle.getItemCount(slotAutofuel)) -- auffuellung mit der anzahl Items in Slot 13

fakelanzahl1 = turtle.getItemCount(slotFackeln1)
fakelanzahl2 = turtle.getItemCount(slotFackeln2)
fakelanzahl3 = turtle.getItemCount(slotFackeln3)


-- hier wird der tunnel gegraben
if (ganganzahl ~= 0) then -- mach das nur wen du auch wirklich was gemacht hast
	tunnel() -- vielleicht so oder doch ueber einen extra status anzeige
	back() -- hier komm die turtel wieder zurueck zum ausgangspunkt
end
--zeit an das die Turtel fertig ist
zeigtFertig()