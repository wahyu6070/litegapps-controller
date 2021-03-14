#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Litegapps
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#29-12-2020
litegapps_menu_version=1.1
litegapps_menu_code=2
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#base func
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#Color
G='\e[01;32m'		# GREEN TEXT
R='\e[01;31m'		# RED TEXT
Y='\e[01;33m'		# YELLOW TEXT
B='\e[01;34m'		# BLUE TEXT
V='\e[01;35m'		# VIOLET TEXT
Bl='\e[01;30m'		# BLACK TEXT
C='\e[01;36m'		# CYAN TEXT
W='\e[01;37m'		# WHITE TEXT
BGBL='\e[1;30;47m'	# Background W Text Bl
N='\e[0m'			# How to use (example): echo "${G}example${N}"
####functions
getp(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }

getp5(){ grep "^$1" "$2" | head -n1 | cut -d = -f 2; }
spinner() {
  set +x
  PID=$!
  h=0; anim='-\|/';
  while [ -d /proc/$PID ]; do
    h=$(((h+1)%4))
    sleep 0.02
    printf "\r${@} [${anim:$h:1}]"
  done
  set -x 2>>$VERLOG
}
error() {
	print
	print "${RED}ERROR :  ${WHITE}$1${GREEN}"
	print
	}
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#dec
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
test -f /system_root/system/build.prop && SYSDIR=/system_root/system || test -f /system/system/build.prop && SYSDIR=/system/system || SYSDIR=/system
findarch=$(getp5 ro.product.cpu.abi $SYSDIR/build.prop | cut -d '-' -f -1)
SDK=$(getp5 ro.build.version.sdk $SYSDIR/build.prop)
case $findarch in
arm64) ARCH=arm64 ;;
armeabi) ARCH=arm ;;
x86) ARCH=x86 ;;
x86_64) ARCH=x86_64 ;;
*) abort " <$findarch> Your Architecture Not Support" ;;
esac

base=/data/litegapps
#system
system=/system

#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#main func
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒

install_package(){
	input="$1"
	rm -rf $base/tmp
	mkdir -p $base/tmp
	print "- Extracting package"
	print " "
	$bin2/busybox unzip -o "$input" -d  $base/tmp/ >/dev/null
	if [ -f $base/tmp/litegapps-install.sh ]; then
	chmod 755 $base/tmp/litegapps-install.sh
	. $base/tmp/litegapps-install.sh
	else
	print "${R} this package litegapps-install.sh not found ! $G"
	fi
	
	name_package_module=`getp package.module $base/tmp/litegapps-prop`
	[ ! -d $base/modules ] && mkdir -p $base/modules
	[ -d $base/modules/$name_package_module ] && rm -rf $base/modules/$name_package_module
	[ ! -d $base/modules/$name_package_module ] && mkdir -p $base/modules/$name_package_module
	for move_package in litegapps-prop litegapps-list litegapps-uninstall.sh module.prop; do
		[ -f $base/tmp/$move_package ] && cp -pf $base/tmp/$move_package $base/modules/$name_package_module/
	done
	}
	
	
	
download_file(){
url=$2
name=$1
if [ -f $base/modules/$name/litegapps-uninstall.sh ]; then
	while true; do
	clear
	printmid "${C}Select mode${G}"
	print
	print "1.Install"
	print "2.Uninstall"
	print
	echo -n "select menu : "
	read aswww
	case $aswww in
	1)
	modeselect=install
	break
	;;
	2)
	modeselect=uninstall
	break
	;;
	*)
	error "please select 1 or 2"
	;;
	esac
	done
else
modeselect=install
fi

if [ "$modeselect" = "install" ]; then
clear
printmid "${C}Install packages${G}"
print
[ -d $base2/download ] && rm -rf $base2/download
test ! -d $base2/download && mkdir -p $base2/download
print "- Download package"
cp -pf /sdcard/asw/package/package.zip $base2/download/$name.zip
#$bin2/curl -L -o $base2/download/$name.zip $url 2>/dev/null & spinner "- Downloading" 2>/dev/null
ZIP_TEST="$(file -b $base2/download/$name.zip | head -1 | cut -d , -f 1)"
case "$ZIP_TEST" in
    "Zip archive data") 
    ZIP_STATUS="file is not corrupt"
    ;;
    *)
    print "${R} !!! File Is Corrupt !!!"
    print " "
    print "${G}* Tips"
    print " "
    print "Please check your internet connection and try again${W}"
    print
    sleep 4s
    return 1
    ;;
esac

install_package $base2/download/$name.zip


fi

print "1.Back"
print
echo -n "menu : "
read abc
}
download_menu(){
	while true; do
	clear
	printmid "${C}Packages List${G}"
	print
	print "1.Wellbeing"
	print "2.Youtube Vanced"
	print "3.Sound Picker"
	print "4.Goole Play Games"
	print "5.about"
	print "6.Exit"
	print
	echo -n " Select List : "
	read dmenu
	case $dmenu in
	1)
	download_file Wellbeing https://sourceforge.net/projects/litegapps/files/database/$ARCH/$SDK/Wellbeing.tar.xz/download
	;;
	2)
	download_file Youtube https://sourceforge.net/projects/litegapps/files/database/$ARCH/$SDK/YoutubeVanced.tar.xz/download
	;;
	3)
	download_file SoundPicker https://sourceforge.net/projects/litegapps/files/database/$ARCH/$SDK/SoundPicker.tar.xz/download
	;;
	4)
	download_file PlayGames https://sourceforge.net/projects/litegapps/files/database/$ARCH/$SDK/SoundPicker.tar.xz/download
	;;
	5)
	clear
	printmid "${C}About${G}"
	print
	print "This is a tool to download manual Litegapps packages."
	print
	print "Problem solving : "
	print "1.make sure you have a good internet connection"
	print "2.make sure you are using the latest version of litegapps control"
	print
	print "Report bug : https://t.me/litegapps"
	print
	print "1.Back"
	print
	echo -n "Select Menu : "
	read lololo
	;;
	6)
	break
	;;
	esac
	done
	
	}
tweaks(){
	while true; do
	clear
	printmid "${C}Litegapps Tweaks${G}"
	print
	print " 1. Fix Permissions"
	print " 2. Back"
	print
	echo -n "  Select Menu : "
	read perm33
	case $perm33 in
		1)
			clear
			printmid "Fix Permissions"
			print
			for iz in $SYSDIR/app $SYSDIR $SYSDIR/product/app $SYSDIR/product/priv-app; do
				if [ -d $iz ]; then
				 	find $iz -type f -name *.apk | while read asww; do
				 		print "${CYAN}set permissions $asww"
				 		chmod 644 $asww
				 		chcon -h u:object_r:system_file:s0 $asww
				 		print "${GREEN}set permission $(dirname $asww)"
				 		chmod 755 $(dirname $asww)
				 		chcon -h u:object_r:system_file:s0 $(dirname $asww)
				 	done
				fi
		     done
				
				print 
				print "1.Back"
				print
				echo -n "select menu : "
				read lul
			;;
		2)
		break
			;;
		*)
			error "please select menu"
			sleep 2s
			;;
	esac
	
   done
	

}
while true; do
clear
print
printmid "${C}Litegapps Menu${G}"
print
print "1.Download package"
print "2.Tweaks"
print "3.Update Litegapps menu"
print "4.about "
print "5.exit"
print
echo -n "Select Menu : "
read menu77
	case $menu77 in
		1)
		download_menu
		;;
		2)
		tweaks
		;;
		3)
		chmod 755 /data/litegapps/updater.sh
		. /data/litegapps/updater.sh
		;;
		4)
		clear
		printmid "${C}About Litegapps Menu${G}"
		print
		print "Litegapps Menu Version : $litegapps_menu_version ($litegapps_menu_code)"
		print "Litegapps Menu is an additional feature of Litegapps or Litegapps++"
		print " "
		print "telegram channel : https://t.me/litegapps"
		print " "
		print "1.Back"
		print
		echo -n "Select Menu : "
		read lzuz
		;;
		5)
		break
		;;
		*)
		error "please select"
		sleep 2s
		;;
		esac
done












#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
#▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
