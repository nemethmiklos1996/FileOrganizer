#!/bin/bash

function selectSourceFolder() 
{
	firstLine=$(head -n 1 FileOrganizer.cfg)

 	COLOR=$(whiptail --inputbox "" 8 80 $firstLine --title "Kérem írja be a forrás mappa elérési útját" 3>&1 1>&2 2>&3)
}

function selectTargetFolder() 
{
	secondLine=$(head -n 2 FileOrganizer.cfg | tail -n -1)

 	COLOR=$(whiptail --inputbox "" 8 80 $secondLine --title "Kérem írja be a cél mappa elérési útját" 3>&1 1>&2 2>&3)
}

function help()
{
	whiptail --title "Segítség" --msgbox "Ez a program egy megadott mappából (első menüpontban lehet beállítani) egy cél mappába (második menüpontban lehet beállítani) rendezetten másolja a fájlokat a beállított paraméterek (hármas menüpont) alapján. Ha nem létezik a konfigurációs fájl, akkor a program azt automatikusan létrehozza." 16 60
}

function menu()
{
	if [ ! -f FileOrganizer.cfg ]; then
		printf "%s/source\n" $PWD > FileOrganizer.cfg
		printf "%s/target\n" $PWD >> FileOrganizer.cfg
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
		selectSourceFolder
		;;
	2)
		echo "Cél mappa ellenőrzése és megadása"
		selectTargetFolder
		;;
	3)
		echo "Fájlokra vonatkozó beállítások"
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