# easyclone
This is just a bash script which aims to ease the process of cloning , moving and syncing and other rclone operations.
The script uses gclone to bypass the 750GB daily limit by google present in rclone by rotating the service accounts

# Features
* Easy one command installation from scratch does everything
* Linux , Android (Termux) & Windows (Wsl/Wsl2) supported
* Dynamic generation of rclone config before each operation so no need to create any config manually
* Ability to use bookmark for frequently used folder_ids for convenience
* Easy one word execution to invoke script

# How to install / update
```bash
curl -sL http://tiny.cc/easyclone | bash
```

Installation is as easy as just running the above command . It will setup everything from scratch . Accordingly run it at a later stage to update script and binaries as and when needed.
Proceeding installation, just enter ```clone``` whenever you need to execute the script henceforth 

# Pre Requisites
* Generate the service accounts and have them downloaded in a folder named accounts. Follow steps from [here](https://github.com/smartass08/Service-Accounts-to-Google-groups/blob/master/README.md) if you don't have service accounts yet.
* Create a new repository named accounts in your github account and upload all the service accounts json files directly in that repo 

# Credits
* [rclone](https://github.com/rclone/rclone)
* [gclone](https://github.com/donwa/gclone)
* [l3v11](https://github.com/l3v11)
