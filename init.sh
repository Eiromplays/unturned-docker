#!/bin/bash
SCRIPT_DIR=$PWD
curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -vxz

# Update / install server
./steamcmd.sh +login $STEAM_USERNAME $STEAM_PASSWORD $STEAM_GUARD_TOKEN $STEAM_CMD_ARGS +force_install_dir $GAME_INSTALL_DIR +@sSteamCmdForcePlatformBitness 64 +app_update $GAME_ID +quit

# Move the steamclient
mkdir -p /home/steam/.steam/sdk64/
cp -f linux64/steamclient.so /home/steam/.steam/sdk64/steamclient.so

# Optionlly install RocketMod, OpenMod or both
export EXTRAS_DIR=$GAME_INSTALL_DIR/Extras
export MODULES_DIR=$GAME_INSTALL_DIR/Modules
mkdir -p $MODULES_DIR
cd $MODULES_DIR

if [ ! -d "$MODULES_DIR/Rocket.Unturned" ]; then
    if [[ "$SERVER_TYPE"  == "rm" || "$SERVER_TYPE"  == "rm4" ||  "$SERVER_TYPE" == "ldm"  ||  "$SERVER_TYPE" == "both" ]]; then
        cp -r /$EXTRAS_DIR/Rocket.Unturned ./
    fi
fi

if [ ! -d "$MODULES_DIR/OpenMod.Unturned" ]; then
    if [[ "$SERVER_TYPE"  == "om"  ||  "$SERVER_TYPE" == "both" ]]; then
        curl -L https://github.com/openmod/openmod/releases/latest/download/OpenMod.Unturned.Module.zip -o OpenMod.zip
        unzip OpenMod.zip
        rm Readme.txt
        rm OpenMod.zip
    fi
fi

# Start game
cd $SCRIPT_DIR
./start_gameserver.sh "$@"