# clone
This is just a bash script which aims to ease the process of cloning , moving and syncing and other rclone operations.
The script utilises the rclone modded binary also known as [fclone](https://github.com/mawaya/rclone) which helps us to bypass the 750GB daily limit by google while also getting comparatively higher speeds than rclone

# Pre Requisites
* Firstly , you should have generated the service accounts and have them downloaded in a folder named accounts. Follow steps from [here](https://github.com/smartass08/Service-Accounts-to-Google-groups/blob/master/README.md) if you don't have service accounts yet.
* Secondly , you need to make a new repository named accounts in your github account and upload all the service accounts in that repo.

# How to install / update
* bash <(curl https://raw.githubusercontent.com/xd003/easyclone/main/setup.sh)
 
                    OR

* bash <(curl -L http://tiny.cc/easyclone)
