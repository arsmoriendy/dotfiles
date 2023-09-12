EXTENSIONS_FILE_PATH="./extensions"
VSCODIUM_EXECUTABLE_NAME="com.vscodium.codium"

for i in $(cat $EXTENSIONS_FILE_PATH)
do
  eval "$VSCODIUM_EXECUTABLE_NAME --install-extension $i"
done
