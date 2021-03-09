# easyclone
This is just a bash script which aims to ease the process of cloning , moving and syncing and other rclone operations.
The script uses [sasync](https://github.com/88lex/sasync) to bypass the 750GB daily limit by google present in rclone by rotating the service accounts

# Features
* Easy one command installation from scratch does everything
* Linux along with termux supported
* Dynamic generation of rclone config before each operation so no need to create any config manually
* Easy one word execution to invoke script

# How to install / update
* ```bash <(curl -L http://tiny.cc/easyclone)```

Installation is as easy as just running the above command . It will setup everything from scratch . Accordingly run it at a later stage to update script and binaries as and when needed.
Proceeding installation, just enter ```clone``` whenever you need to execute the script henceforth 

# Pre Requisites
* Generate the service accounts and have them downloaded in a folder named accounts. Follow steps from [here](https://github.com/smartass08/Service-Accounts-to-Google-groups/blob/master/README.md) if you don't have service accounts yet.
* Rename all those json files in numerical order using this [python script](https://del.dog/raw/saRename) & Create a new repository named accounts in your github account and upload all the service accounts json files directly in that repo 

# Credits
* [rclone](https://github.com/rclone/rclone)
* [88lex](https://github.com/88lex/sasync)    
