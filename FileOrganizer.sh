#!/bin/bash

function menu()
{

	ADVSEL=$(whiptail --title "Menü" --fb --menu "Válasszon menüpontot" 20 60 10 \
	"1" "Forrás mappa ellenőrzése és megadása"	\
	"2" "Cél mappa ellenőrzése és megadása"		\
	"3" "Fájlokra vonatkozó beállítások"		\
	"4" "Segítség"					\
	"5" "Kilépés"	3>&1 1>&2 2>&3)

	case $ADVSEL in

	1)
		echo "Forrás mappa ellenőrzése és megadása"
		
		;;
	2)
		echo "Cél mappa ellenőrzése és megadása"
		;;
	3)
		echo "Fájlokra vonatkozó beállítások"
		;;
	4)
		echo "Segítség"
		;;
	5)
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
