#!/usr/bin/bash
#
# Created by MrGamy (github.com/MrGamy | twitter.com/MrGamyVO | twitch.tv/MrGamy)
# This script will help you to update PhantomBot the easy way!
####################################


#Absolute path of the folder containing this script
scriptPath='/home/botuser'

#Absolute path to your PhantomBot installation

botPath="$scriptPath/phantombot"

#Path to the upstream PhantomBot repository
repoPath="https://api.github.com/repos/PhantomBot/PhantomBot/releases/latest"


####################################
#### Update Script starts here  ####
## don't change anything past here #
####################################


### Compartmentalize script into functions

# Check if there is a new update

function updatecheck()
{
    echo "PhantomBot updater started"

    dLink=$(curl --silent "$repoPath" | grep browser_download_url | grep -v -E '*-arm*|*-lin*|*-mac*|*-win*' | cut -d '"' -f 4)

    #Saving the Filename of the .zip as variable
    archive=${dLink##*/}

    #Extracting the version number from the .zip
    version=${archive:11:-4}

    #Check if a version.id file exists; create it if not
    if [ -e "$botPath/version.id" ]
        then
            :
        else
            printf "0.0.0" > $botPath/version.id
    fi

    #Save version.id to variable vID
    vID=$(<$botPath/version.id)

    #Compare current version number to stored version number
    if [ $version \> $vID ]
        then
            echo "Update found: $vID -> $version"
            update
        else
            echo "Already up to date ($vID)"
    fi

}

# Download and apply a new update

function update()
{

    echo "update"

    #Stop the bot and wait 15 seconds to ensure shutdown
    sudo /bin/systemctl stop phantombot
    sleep 15

    #Download
    wget -q $dLink

    backup

    #Unzip
    unzip -q $archive

    #Move to standard bot folder
    mv $scriptPath/${archive::-4} $botPath

    #Import Database
    cp -R $scriptPath/bot-backup/config/ $botPath
    cp -R $scriptPath/bot-backup/scripts/lang/custom $botPath/scripts/lang

    #Change Ownership
    chmod u+x $botPath/launch.sh $botPath/launch-service.sh $botPath/java-runtime-linux/bin/java

    #Delete the downloaded archive
    rm ./$archive
    
    #Update the version number
    printf $version > $botPath/version.id

    #Restart the bot
    sudo /bin/systemctl start phantombot

}

# Backup the current bot installation to a different folder

function backup()
{

    # Remove the folder if it already exists
    rm -rf $scriptPath/bot-backup
    # Backup current state
    mv $botPath $scriptPath/bot-backup

}

# Write to update logfile

function log()
{

logfile=$scriptPath/$(date +"%m_%Y-update.log")

printf "%s\n" >> $logfile
printf "Script run at $(printf '%(%Y-%m-%d %H:%M:%S)T\n')" >> $logfile
printf "%s\n" >> $logfile

if [ $version \> $vID ]
    then
        printf "Update from $vID to $version\n" >> $logfile
    else
        printf "Bot is up to date ($vID)\n" >> $logfile
fi

printf "%s\n" >> $logfile

}

#### Run the functions ####

#Start the update routine
updatecheck

#Log to file
log

#Done
echo "Done!"
