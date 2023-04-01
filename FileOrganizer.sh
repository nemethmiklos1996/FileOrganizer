#!/bin/bash

function selectSourceFolder() 
{
	# forrás mappa fájlból beolvasása és módosítása
	firstLine=$(head -n 1 $fileNameFolder)

 	src=$(whiptail --inputbox "" 8 80 $firstLine --title "Kérem írja be a forrás mappa elérési útját" 3>&1 1>&2 2>&3)
	# kicseréli a beírt elérési utat a jelenlegivel
 	if [[ $src != "" && $firstLine != "" ]]; then		
	 	sed -i "s@$firstLine@$src@" $fileNameFolder
	fi
}

function selectTargetFolder() 
{
	# cél mappa fájlból beolvasása és módosítása
	secondLine=$(head -n 2 $fileNameFolder | tail -n -1)

 	trg=$(whiptail --inputbox "" 8 80 $secondLine --title "Kérem írja be a cél mappa elérési útját" 3>&1 1>&2 2>&3)
	# kicseréli a beírt elérési utat a jelenlegivel
	if [[ $trg != "" && $secondLine != "" ]]; then		
		sed -i "s@$secondLine@$trg@" $fileNameFolder
	fi
}


function help()
{
	whiptail --title "Segítség" --msgbox "Ez a program egy megadott mappából (első menüpontban lehet beállítani) egy cél mappába (második menüpontban lehet beállítani) rendezetten másolja a fájlokat a beállított paraméterek (hármas menüpont) alapján. A fájl paraméterrek beállításához a SPACE gombbal kell megjelölni egy fájl típust, majd ENTER billentyűvel lehet tovább menni. Ha nem létezik a konfigurációs fájl, akkor a program azt automatikusan létrehozza." 16 60
}

function menu()
{
	# fájl nevek beállítása
	fileNameFolder="FileOrganizerFolders.cfg"
	fileNameFiles="FileOrganizerFiles.cfg"
	# fájlok létezésének ellenőrzése, ha nem létezik alap beállításokkal létrehozása
	if [ ! -f $fileNameFolder ]; then
		printf "%s/source\n" $PWD > $fileNameFolder
		printf "%s/target\n" $PWD >> $fileNameFolder
	fi

	if [ ! -f $fileNameFiles ]; then
		printf "[JPG]\n" > $fileNameFiles
		printf "dir=Pictures\n" >> $fileNameFiles
		printf "subdir=1\n" >> $fileNameFiles
		printf "rename=IMG\n" >> $fileNameFiles
		printf "[PDF]\n" >> $fileNameFiles
		printf "dir=Documents\n" >> $fileNameFiles
		printf "subdir=0\n" >> $fileNameFiles
		printf "rename=0\n" >> $fileNameFiles
		printf "[ODT]\n" >> $fileNameFiles
		printf "dir=Documents\n" >> $fileNameFiles
		printf "subdir=0\n" >> $fileNameFiles
		printf "rename=0\n" >> $fileNameFiles
		printf "[ODS]\n" >> $fileNameFiles
		printf "dir=Documents\n" >> $fileNameFiles
		printf "subdir=0\n" >> $fileNameFiles
		printf "rename=0\n" >> $fileNameFiles
	fi
	# menü megjelenítése
	ADVSEL=$(whiptail --title "Menü" --fb --menu "Válasszon menüpontot" 20 60 10 \
	"1" "Forrás mappa ellenőrzése és megadása"	\
	"2" "Cél mappa ellenőrzése és megadása"		\
	"3" "Fájlokra vonatkozó beállítások"		\
	"4" "Fájlok másolása"						\
	"5" "Segítség"								\
	"6" "Kilépés"	3>&1 1>&2 2>&3)
	# választott menüpontnak megfelelő függvény hívása
	case $ADVSEL in

	1)
		echo "Forrás mappa ellenőrzése és megadása"
		selectSourceFolder "$fileNameFolder"
		;;
	2)
		echo "Cél mappa ellenőrzése és megadása"
		selectTargetFolder "$fileNameFolder"
		;;
	3)
		echo "Fájlokra vonatkozó beállítások"
		setFileDetails "$fileNameFiles"
		;;
	4)
		echo "Fájlok másolása"
		;;
	5)
		echo "Segítség"
		help
		;;
	6)
		echo "Kilépés"
		exit
		;;
	esac
}

while true
do
	clear
	menu
done