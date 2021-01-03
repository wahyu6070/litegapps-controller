# LiteGapps
# By wahyu6070
[ -d /data/litegapps ] && rm -rf /data/litegapps
print "- copying binary"
[ -d /data/litegapps ] && rm -rf /data/litegapps
cp -af $MODPATH/litegapps /data/
print "- Set Permissions"
chmod -R 755 /data/litegapps
if [ $TYPEINSTALL = magisk ]; then
chmod 755 /data/adb/modules_update/litegapps-control/system/bin/litegapps
else
chmod 755 $system/bin/litegapps
fi
print
print
print "*Tips"
print
print "- Open Terminal"
print
print "- su"
print "- litegapps"
print
print " report bug https://t.me/litegapps"
print