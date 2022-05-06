[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html) [![GitHub latest commit](https://badgen.net/github/last-commit/MrGamy/PhantomBotUpdateScript)](https://GitHub.com/MrGamy/PhantomBotUpdateScript/commit/)

# What's this?

PhantomBotUpdate.sh is a bash script to keep [PhantomBot](https://github.com/phantombot/phantombot) instances deployed on linux servers up to date the easy way.

The script will
- check for available updates while keeping track of its own version
- update your bot
- migrate your configuration
- restart the bot

The standard configuration assumes you followed the [Linux setup guide](https://github.com/PhantomBot/PhantomBot/blob/master/docs/guides/content/setupbot/ubuntu.md)

I would suggest using an additional backup utility like [Borg](https://www.borgbackup.org/) for long term backups.

To automatically run this script every day at 10am add  
`0 10 * * * /home/botuser/PhantomBotUpdate.sh`  
to your crontab (crontab -e)

## Variables

There are 3 variables you can change:

- The absolute path of the folder containing the update script  
  scriptPath='/home/botuser'

- Absolute path of your PhantomBot  
  botPath="$scriptPath/phantombot"

- Path to the upstream PhantomBot repository  
  repoPath="https://api.github.com/repos/PhantomBot/PhantomBot/releases/latest"
  
## Files created by the script
  
The following files/folders will be created/overwritten by this script:
- **version.id** File to keep track of the currently installed bot version; inside the defined PhantomBot folder 
- **bot-backup** Backup folder for your previously running version; inside the script folder
- **update.log** Logfile to keep track of when the script ran, and if there was an update; inside the script folder
