#!/bin/bash

function selectSourceFolder() 
{
	firstLine=$(head -n 1 $fileNameFolder)

 	src=$(whiptail --inputbox "" 8 80 $firstLine --title "Kérem írja be a forrás mappa elérési útját" 3>&1 1>&2 2>&3)

 	if [[ $src != "" && $firstLine != "" ]]; then		
	 	sed -i "s@$firstLine@$src@" $fileNameFolder
	fi
}

function selectTargetFolder() 
{
	secondLine=$(head -n 2 $fileNameFolder | tail -n -1)

 	trg=$(whiptail --inputbox "" 8 80 $secondLine --title "Kérem írja be a cél mappa elérési útját" 3>&1 1>&2 2>&3)
	 	
	if [[ $trg != "" && $secondLine != "" ]]; then		
		sed -i "s@$secondLine@$trg@" $fileNameFolder
	fi
}

function setFileDetails()
{
	echo "sajt"
}

function help()
{
	whiptail --title "Segítség" --msgbox "Ez a program egy megadott mappából (első menüpontban lehet beállítani) egy cél mappába (második menüpontban lehet beállítani) rendezetten másolja a fájlokat a beállított paraméterek (hármas menüpont) alapján. Ha nem létezik a konfigurációs fájl, akkor a program azt automatikusan létrehozza." 16 60
}

function menu()
{

	fileNameFolder="FileOrganizerFolders.cfg"

	if [ ! -f $fileNameFolder ]; then
		printf "%s/source\n" $PWD > $fileNameFolder
		printf "%s/target\n" $PWD >> $fileNameFolder
	fi

	if [ ! -f FileOrganizerFiles.cfg ]; then
		touch FileOrganizerFiles.cfg
	fi

	ADVSEL=$(whiptail --title "Menü" --fb --menu "Válasszon menüpontot" 20 60 10 \
	"1" "Forrás mappa ellenőrzése és megadása"	\
	"2" "Cél mappa ellenőrzése és megadása"		\
	"3" "Fájlokra vonatkozó beállítások"		\
	"4" "Fájlok másolása"						\
	"5" "Segítség"								\
	"6" "Kilépés"	3>&1 1>&2 2>&3)

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
		setFileDetails
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