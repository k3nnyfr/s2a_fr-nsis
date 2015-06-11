;NSIS Installer for s2a
;
;Ecrit par Alexandre Gauvrit

;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

	; The name of the installer
	Name "Scratch2Arduino Francais"
	VIProductVersion "0.2"

	; The file to write
	OutFile "Setup_S2Afr.exe"

	; The default installation directory
	InstallDir $PROGRAMFILES\S2Afr

	; Registry key to check for directory (so if you install again, it will 
	; overwrite the old one automatically)
	InstallDirRegKey HKLM "Software\S2Afr" "Install_Dir"

	; Request application privileges for Windows Vista
	RequestExecutionLevel admin

;--------------------------------
;Interface Settings

  !define MUI_HEADERIMAGE
  !define MUI_ICON "microcontroller.ico"
  !define MUI_HEADERIMAGE_BITMAP "s2a-nsis.bmp" ; optional
  !define MUI_WELCOMEFINISHPAGE_BITMAP "s2a-welcome.bmp" 
  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES

  
  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_NOTCHECKED
  !define MUI_FINISHPAGE_RUN_TEXT "Installer Adobe AIR + Scratch2 4.3.6"
  !define MUI_FINISHPAGE_RUN_FUNCTION "InstallScratch2";
  
  !insertmacro MUI_PAGE_FINISH
  
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
  Function InstallScratch2
		ExecWait "$INSTDIR\AdobeAIRInstaller.exe"
		ExecWait "$INSTDIR\Scratch-436.exe"
  FunctionEnd
  
;--------------------------------
;Languages
 
  !insertmacro MUI_LANGUAGE "French"

;--------------------------------
;Installer Sections

; Installation Scratch2 (a terminer)
;Section /o "Installer Scratch2 Offline" Scratch2
;	ExecWait '"$INSTDIR\Scratch-436.exe" -silent -eulaAccepted -desktopShortcut -programMenu'
;SectionEnd


; Installation de S2A_fr
Section "Scratch2Arduino" SecDummy

  SectionIn RO
  
  ; Definition du dossier d'installation
  SetOutPath $INSTDIR
  
  ; Copie des fichiers
  File /r "aide"
  File /r "bibliotheque"
  File /r "documentation"
  File /r "drivers"
  File /r "projets"
  File /r "s2a"
  File /r "Snap!Files"
  File /r "sources_Borland_C++"
  File /r "tools"
  File "Scratch-436.exe"
  File "AdobeAIRInstaller.exe"
  File "connect.bmp"
  File "flash_mega.bat"
  File "flash_uno.bat"
  File "label.xml"
  File "license.txt"
  File "microcontroller.ico"
  File "README.md"
  File "s2a.exe"
  File "s2a.ini"
  File "s2a_cmd.bat"
  File "Scratch2.bat"
  File "unconnect.bmp"
  File "unconnect.bmp"
    
  ; Ajout du répertoire d'installlation dans le registre
  WriteRegStr HKLM SOFTWARE\S2Afr "Install_Dir" "$INSTDIR"
  
  ; Ecriture des cles de registre de desinstallation pour Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\S2Afr" "DisplayName" "Scratch2Arduino"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\S2Afr" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\S2Afr" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\S2Afr" "NoRepair" 1
  WriteUninstaller "uninstall.exe"
  
  ; Reecriture des fichiers .bat  $PROGRAMFILES
	FileOpen $9 "$INSTDIR\Scratch2.bat" w ;Opens a Empty File an fills it
	FileWrite $9 "@echo off$\r$\n"
	FileWrite $9 "break ON$\r$\n"
	FileWrite $9 "rem fichiers BAT et fork créés par Sébastien CANET et Alexandre GAUVRIT$\r$\n"
	FileWrite $9 "cls$\r$\n"
	FileWrite $9 "SET currentpath=%~dp1$\r$\n"
	FileWrite $9 'SET dossier_scratch="$PROGRAMFILES\Scratch 2.exe"$\r$\n'
	FileWrite $9 'start %dossier_scratch% "$INSTDIR\bibliotheque\fichier_depart_s2a.sb2"$\r$\n'
	FileClose $9 ;Closes the filled file
	

SectionEnd

; Raccourcis dans le Menu Demarrer
Section "Raccourci dans le Menu Demarrer" MenuDemarrer

  CreateDirectory "$SMPROGRAMS\S2Afr"
  CreateShortCut "$SMPROGRAMS\S2Afr\Uninstall.lnk" "$INSTDIR\uninstall.exe" "" "$INSTDIR\uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\S2Afr\s2a.lnk" "$INSTDIR\s2a.exe" "" "$INSTDIR\s2a.exe" 0
  
SectionEnd

; Raccourci sur le Bureau
Section "Raccourci sur le Bureau" Bureau
	CreateShortCut "$DESKTOP\s2a.lnk" "$INSTDIR\s2a.exe" ""
SectionEnd

;--------------------------------
;Descriptions

  ;Language strings
  ;LangString DESC_Scratch2 ${LANG_FRENCH} "Installation de Scratch2 Offline 4.3.6"
  LangString DESC_SecDummy ${LANG_FRENCH} "Installation de la version francaise de Scratch2Arduino"
  LangString DESC_MenuDemarrer ${LANG_FRENCH} "Creation d'un raccourci dans le Menu Demarrer"
  LangString DESC_Bureau ${LANG_FRENCH} "Creation d'un raccourci sur le Bureau"

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	;!insertmacro MUI_DESCRIPTION_TEXT ${Scratch2} $(DESC_Scratch2)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
	!insertmacro MUI_DESCRIPTION_TEXT ${MenuDemarrer} $(DESC_MenuDemarrer)
	!insertmacro MUI_DESCRIPTION_TEXT ${Bureau} $(DESC_Bureau)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\S2Afr"
  DeleteRegKey HKLM SOFTWARE\NSIS_S2Afr

  ; Remove files and uninstaller
  
  Delete "$INSTDIR\*.*"
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\S2Afr\*.*"
  Delete "$DESKTOP\S2A.lnk"

  ; Remove directories used
  RMDir "$SMPROGRAMS\S2Afr"
  RMDir /r "$INSTDIR"

SectionEnd