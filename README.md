# FileOrganizer
A program futásához whiptail telepítése szükséges. (legtöbb rendszeren nagy valószínűséggel telepítve van)<br>
A segítség menüpont témaszt nyújt a program használatához.<br>
A program elsődleges célja, hogy egy rendezetlen, ömlesztett fájlokat tartalmazó mappából egy célmappába másolja a megadott típusú fájlokat. A fájlokat a paraméterek alapján dátumos almappákba rendezi vagy egy beolvasott prefix és a fájlból kiolvasott létrehozási idő alapján átnevezi.
## Menüpontok
### Forrás mappa ellenőrzése és megadása
Ebben a menüpontban a FileOrganizerFolders.cfg tartalmát lehet módosítani. A program alapértelmezetten, első indítás alkalmával létrehozza ezt a fájlt, majd Forrás mappa gyanánt a program mellé létrehoz egy source mappát, majd teljes elérési úttal a fájlba menti. Meglévő fájl esetén kiolvassa, és engedi szerkeszteni az elérési utat, manuálisan.
### Cél mappa ellenőrzése és megadása
Működése megegyezik az előző menüponttal, azzal a különbséggel, hogy alapértelmezetten target névvel hozza létre a mappát.
### Fájlokra vonatkozó beállítások
Ezen funkció a FileOrganizerFiles.cfg fájl tartalmát szerkeszti. Alapértelmezetten négy fájl kerül elmentésre és beállításra. Ezek szerkeszthetők, és fel lehet venni új fájlt. Az üzenetek segítenek a fájl beállítások eldöntésében, amennyiben nem egyértelmű.
### Fájlok másolása
Ez a menüpont elkezdi a fájlokat átmásolni az előző menüpontok alapértelmezett vagy testre szabott beállításai alapján. A FileOrganizerFolders.cfg fájlból kiolvassa és ha nem létezik létrehozza a mappákat. Amennyiben nem léteznek, akkor a megfelelő tájékoztató üzenet jelenik meg.
### Segítség
Itt információt kaphatunk a program működéséről. 
### Kilépés
Bezárja a programot.
