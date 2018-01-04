#!/bin/bash

# broken...

# If you wish a different installation folder, please change this line...
INSTALLATION_FOLDER=~/programs

# If your local bin folder is located elsewhere, please update this...
LOCAL_BIN_FOLDER=/usr/local/bin

printf "This script assumes the following:\n"
printf "1: this script will create a pgadmin4 directory on this path: '${INSTALLATION_FOLDER}'\n"
printf "2: an executable file will also be created and placed on you local bin folder\n"
printf "3: the path for your local bin folder is assumed to be '${LOCAL_BIN_FOLDER}'"
printf "\n\nIf you wish to change these settings please stop the script (CTRL + C) and edit this file.\n"

read -r -p "Press ENTER to continue..." key

sudo apt-get update
sudo apt-get install python2.7-dev virtualenv python-pip libpq-dev
mkdir -p $INSTALLATION_FOLDER/pgadmin4

printf "\nCreating the virtual environment for pgadmin4...\n"
sleep 0.5
cd $INSTALLATION_FOLDER
virtualenv pgadmin4

printf "\nInstalling pgadmin4..."
sleep 0.5
wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v2.0/pip/pgadmin4-2.0-py2.py3-none-any.whl
pip install pgadmin4-2.0-py2.py3-none-any.whl

printf "\nCreating a config_local.py file...."
sleep 0.5
cat > config_local.py << EOS
import os
DATA_DIR = os.path.realpath(os.path.expanduser(u'~/.pgadmin/'))
LOG_FILE = os.path.join(DATA_DIR, 'pgadmin4.log')
SQLITE_PATH = os.path.join(DATA_DIR, 'pgadmin4.db')
SESSION_DB_PATH = os.path.join(DATA_DIR, 'sessions')
STORAGE_DIR = os.path.join(DATA_DIR, 'storage')
SERVER_MODE = False
EOS

sudo mv config_local.py $INSTALLATION_FOLDER/pgadmin4/lib/python2.7/site-packages/pgadmin4

printf "\nCleaning unused files..."
sleep 0.5

rm pgadmin4-2.0-py2.py3-none-any.whl
printf "\nDone.."
sleep 0.5

cd ~

printf "\nCreating the shortcut to boot pgadmin4..."
sleep 0.5
cat > pgadmin4 << EOS
#! /bin/bash
cd ${INSTALLATION_FOLDER}
source bin/activate
xdg-open http://127.0.0.1:5050
python lib/python2.7/site-packages/pgadmin4/pgAdmin4.py
EOS

chmod +x pgadmin4

# If you don't want this file to be placed on your local bin folder, please comment this line.
sudo mv pgadmin4 $LOCAL_BIN_FOLDER

printf "\nAll done. You can now call 'pgadmin4' and\nyour browser will open up pointing to the pgadmin client url."
printf "\nEnjoy :)\n"