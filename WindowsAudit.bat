::set working directory as the usb device
set filepath=%~dp0

::gets computername
set id=%computername%

::sets computername as output filenames
set uid=%id%.txt
set uidsecrep=%id%.cfg
set uidinstall=installlist.txt

::csv 
set uidinstallcsv=%id%.csv
set installcsv=%filepath%%uidinstallcsv%

::network
set uidnetwork=%id%network.txt
set filenamenetwork=%filepath%%uidnetwork%


::creates the full path of the output files
set filename=%filepath%%uid%
set filenamesecrep=%filepath%%uidsecrep%
set filenameinstall=%filepath%%uidinstall%
cls

echo on
cls
::gets system information and network information 
systeminfo.exe 1>> %filename%
echo "ipconfig" >> %filename%
ipconfig /all 1>> %filenamenetwork%
cls 
netsh advfirewall firewall show rule all >> %filenamenetwork%
cls



echo "license key" >> %filename%
wmic path softwarelicensingservice get oa3xoriginalproductkey >> %filename%

echo "current user" >> %filename%
whoami 1>> %filename%

echo all users" >> %filename%
net users 1>> %filename%

::gets users of under administrator group
echo "administrators" 
net localgroup administrators 1>> %filename%
cls

::gets users info 
net accounts 1>> %filename%
cls
auditpol /get /category:* 1>> %filename%
cls

::gets serial number
wmic bios get serialnumber >> %filename%
::wmic product get Name, Version /format:list >> %filename%
fsutil volume diskFree C: >> %filename%
cls

::gets installed applications
wmic /output:%filenameinstall% product get name,version
cls
::renames to installlist.txt
rename   %filenameinstall% %id%installlist.txt
cls


reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall" /s >> %filename%
reg query "HKEY_CLASSES_ROOT\Installer\Products" /s >> %filename%
cls


::echo getting installed software
wmic product get /format:csv >> %installcsv%
gpresult /scope computer /v >> %filename%
cls
gpresult /scope user /v >> %filename%
cls
dism /online /get-packages /format:table >> %filename%

::gets installed antivirus software
wmic /namespace:\\root\SecurityCenter2 path AntiVirusProduct get * /value >> %filename%
cls


::exports secedit
secedit.exe /export /cfg %filenamesecrep%
cls

echo Report Generated On %Date% %TIME% 1>> %filename%
cls
echo successfull generation of audit program file
pause
