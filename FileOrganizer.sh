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

function setFileDetails()
{
	i=0
	# fájlok konfigból fájlnevek kiolvasása
	while read p; do   

    	if [[ "$p" == *"["* && "$p" == *"]"* ]]; then

			subStr=${p:1:-1}
			fileNames[$i]=$subStr
			i=$(($i+1))
			fileNames[$i]=""
			i=$(($i+1))
			fileNames[$i]=off
			i=$(($i+1))

		fi
 
	done < $fileNameFiles

	# kiolvasott fájlnevek alapján radio boxos kiválasztó menü
	selectedFileName=$(whiptail --title "Fájlok" --radiolist "Válassza ki a beállítani kívánt típust" 20 60 10 "${fileNames[@]}" "ÚJ" "" off  3>&1 1>&2 2>&3)
	# ellenőrzés, hogy az új beállítás lett-e kiválasztva
	if [ "${selectedFileName}" != "ÚJ" ]; then
		# meglévő beállítások felülírása 
		while read -r line; do
			if [[ $line == \[*${fileNames[$i]}*]* ]]; then
				section="${line#[}"
				section="${section%]}"
			elif [[ $section == $selectedFileName && $line == dir=* ]]; then
				attrDir="${line#*=}"
				newAttrDir=$(whiptail --inputbox "Adja meg a mappa nevét:" 8 50 "$attrDir" --title "${section}" 3>&1 1>&2 2>&3)
				sed -i "/^\[${selectedFileName}\]/,/^\[/s/^dir=.*/dir=$newAttrDir/" "$fileNameFiles"
			elif [[ $section == $selectedFileName && $line == subdir=* ]]; then
				attrSubdir="${line#*=}"
				newAttrSubdir=$(whiptail --inputbox "Szeretne dátummal ellátott almappát (0 nem, 1 igen):" 8 50 "$attrSubdir" --title "${section}" 3>&1 1>&2 2>&3)
				sed -i "/^\[${selectedFileName}\]/,/^\[/s/^subdir=.*/subdir=$newAttrSubdir/" "$fileNameFiles"
			elif [[ $section == $selectedFileName && $line == rename=* ]]; then
				attrRename="${line#*=}"
				newAttrRename=$(whiptail --inputbox "Át szeretné nevezni a fájlokat (0 nem vagy a fájl neve):" 8 50 "$attrRename" --title "${section}" 3>&1 1>&2 2>&3)
				sed -i "/^\[${selectedFileName}\]/,/^\[/s/^rename=.*/rename=$newAttrRename/" "$fileNameFiles"
			fi
		done < "$fileNameFiles"
	else
		# új fájltípus bekérése
		newFileName=$(whiptail --inputbox "Adja meg az új fájl kiterjesztését pont nélkül:" 8 50 3>&1 1>&2 2>&3)
		newAttrDir=$(whiptail --inputbox "Adja meg a mappa nevét:" 8 50 --title "${newFileName}" 3>&1 1>&2 2>&3)
		newAttrSubdir=$(whiptail --inputbox "Szeretne dátummal ellátott almappát (0 nem, 1 igen):" 8 50 --title "${newFileName}" 3>&1 1>&2 2>&3)
		newAttrRename=$(whiptail --inputbox "Át szeretné nevezni a fájlokat (0 nem vagy a fájl neve):" 8 50 --title "${newFileName}" 3>&1 1>&2 2>&3)
		# új fájltípus eltárolása
		printf "[%s]\n" $newFileName >> $fileNameFiles
		printf "dir=%s\n" $newAttrDir >> $fileNameFiles
		printf "subdir=%s\n" $newAttrSubdir >> $fileNameFiles
		printf "rename=%s\n" $newAttrRename >> $fileNameFiles
	fi

}

function runCopy()
{

	source=$(head -n 1 $fileNameFolder)
	target=$(head -n 2 $fileNameFolder | tail -n -1)
	# elvileg ezek nem szükségesek, de már marad, legalább tájékoztatja a felhasználót,
	# hogy a forrás mappa létre lett hozva és másoljon bele fájlokat
	# ha nem létezik a forrás mappa, akkor létre kell hozni, illetve tájékoztatni a felhasználót
	if [ ! -d "$source" ]; then
 		mkdir -p $source;
		whiptail --title "Információ" --msgbox "A forrás mappa nem létezett, ezért létre lett hozva. Kérem másolja bele a rendezni kívánt fájlokat." 16 60
	fi
	# ha nem létezik a cél mappa, akkor létre kell hozni, illetve tájékoztatni a felhasználót
	if [ ! -d "$target" ]; then
 		mkdir -p $target;
		whiptail --title "Információ" --msgbox "A cél mappa nem létezett, ezért létre lett hozva." 16 60
	else
		if (whiptail --title "Információ" --yesno "A cél mappa létezik. Törli a tartalmát? (megtartott tartalom esetén előfordulhat, hogy bizonyos fájlok duplikálódnak)" 8 78); then
			rm -rf "$target"
			mkdir -p $target;
		fi
	fi
	# fájlok konfigból fájlnevek kiolvasása
	while read p; do   

    	if [[ "$p" == *"["* && "$p" == *"]"* ]]; then

			subStr=${p:1:-1}
			fileNames[$i]=$subStr
			i=$(($i+1))

		fi
 
	done < $fileNameFiles

	while read -r line; do
		endSection=false

		if [[ $line == \[*${fileNames[$i]}*]* ]]; then
			section="${line#[}"
			section="${section%]}"
		elif [[ $line == dir=* ]]; then
			attrDir="${line#*=}"
		elif [[ $line == subdir=* ]]; then
			attrSubdir="${line#*=}"
		elif [[ $line == rename=* ]]; then
			attrRename="${line#*=}"
			endSection=true
		fi

		if [ $endSection == true ]; then
			if [[ "${target}" != */ ]]; then
				target="${target}/"
			fi

			mkdir -p "$target$attrDir"

			find "$source" -type f \( -iname "*${section,,}*" -o -iname "*${section^^}*" \) | while read -r file; do		
				creationTime=$(stat -c %W "$file")
				formattedTime=$(date -d "@$creationTime" "+%Y-%m-%d")
				formattedTimeWT=$(date -d "@$creationTime" "+%Y-%m-%d-%H-%M-%S")
				newFileName="${attrRename}_${formattedTimeWT}.${section}"
		
				case $attrSubdir in
				0)
					temp=$(cp -v "$file" "$target$attrDir" 2>&1)
					copiedFile=$(echo "$temp" | awk -F"-> " '{print $NF}' | tr -d "'")					

					if [[ $attrRename != "0" ]]; then
						mv "$copiedFile" "$target$attrDir/$newFileName"
					fi
					;;
				1)
					dirToCopy="$target$attrDir/$formattedTime"
					mkdir -p "$dirToCopy"
					temp=$(cp --verbose "$file" "$dirToCopy" 2>&1 | awk '{print $NF}')
					copiedFile=$(echo "$temp" | awk -F"-> " '{print $NF}' | tr -d "'")					
					
					if [[ $attrRename != "0" ]]; then
						mv "$copiedFile" "$dirToCopy/$newFileName"
					fi
					;;
				esac
			done
		fi
	done < "$fileNameFiles" | whiptail --gauge "Fájlok másolása folyamatban" 6 50 0
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
		selectSourceFolder "$fileNameFolder"
		;;
	2)
		selectTargetFolder "$fileNameFolder"
		;;
	3)
		setFileDetails "$fileNameFiles"
		;;
	4)
		runCopy "$fileNameFiles" "$fileNameFolder"
		;;
	5)
		help
		;;
	6)
		exit
		;;
	esac
}

while true
do
	clear
	menu
done