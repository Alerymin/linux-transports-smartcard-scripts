#!/bin/sh

echo <<EOF
##############################################################
Smart Card Plugin installer for Oùra
by Alerymin
https://github.com/Alerymin/linux-transports-smartcard-scripts
##############################################################
EOF

if type "xdg-mime" > /dev/null; then
  echo "xdg-mime found"
else
  echo "This script requires xdg-mime"
  exit
fi

if type "curl" > /dev/null; then
  echo "curl found"
else
  echo "This script requires curl"
  exit
fi

if type "7z" > /dev/null; then
  echo "p7zip found"
else
  echo "This script requires p7zip"
  exit
fi

if [ -z ${1+x} ]; then
  echo "Please add Java 17 binary path as argument";
  exit
else
  JAVA_BIN=$1
  echo "Java binary: '$JAVA_BIN'";
fi

EXTRACT_DIR=oura-smartcard-setup

BIN_DIR="$HOME/.local/bin"
BIN_NAME=XSCP.jar
BIN_PATH="$BIN_DIR/$BIN_NAME"

SHORTCUT_DIR="$HOME/.local/share/applications"
SHORTCUT_NAME=XSCP.desktop
SHORTCUT_PATH="$SHORTCUT_DIR/$SHORTCUT_NAME"

if [ -d "$EXTRACT_DIR" ]; then
  echo "$EXTRACT_DIR does exist."
else
  mkdir $EXTRACT_DIR
  echo "$EXTRACT_DIR created"
fi

cd $EXTRACT_DIR

curl -O https://oura.com/sites/all/modules/oab_xerox/js/card_reader/SetupSmartCardPlugin.msi
7z x SetupSmartCardPlugin.msi

if [ -d "$BIN_DIR" ]; then
  echo "$BIN_DIR does exist."
else
  mkdir $BIN_DIR
  echo "$BIN_DIR created"
fi

cp $BIN_NAME $BIN_DIR

if [ -d "$SHORTCUT_DIR" ]; then
  echo "$SHORTCUT_DIR does exist."
else
  mkdir $SHORTCUT_DIR
  echo "$SHORTCUT_DIR created"
fi

cat > $SHORTCUT_PATH <<EOF
[Desktop Entry]
Name=XSCP SmartCard
Exec=$JAVA_BIN -jar $BIN_PATH %U
Terminal=false
Type=Application
MimeType=x-scheme-handler/xscpsmartcard
EOF

echo "$SHORTCUT_PATH created"

xdg-mime default "$SHORTCUT_PATH" x-scheme-handler/xscpsmartcard

echo "MIME config done"

cd ..
rm -r $EXTRACT_DIR

echo "Cleanup done"
