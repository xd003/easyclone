# easyclone
This is just a bash script which aims to ease the process of cloning , moving and syncing and other rclone operations.
The script utilises the rclone modded binary also known as [fclone](https://github.com/mawaya/rclone) which helps us to bypass the 750GB daily limit by google while also getting comparatively higher speeds than rclone

# Pre Requisites
* Firstly , you should have generated the service accounts and have them downloaded in a folder named accounts. Follow steps from [here](https://github.com/smartass08/Service-Accounts-to-Google-groups/blob/master/README.md) if you don't have service accounts yet. Also rename any of the json file as 1.json inside accounts folder
* Secondly , you need to make a new repository named accounts in your github account and upload all the service accounts json files directly in that repo.
* Lastly , you need to generate your own client id & secret from [here](https://developers.google.com/drive/api/v3/quickstart/python). It will have to be entered during config creation

# How to install / update
* ```bash <(curl -L http://tiny.cc/easyclone)```

The above setup script will automatically install or update the fclone binary ,easyclone script & all the dependencies .It will prompt for github authentication for downloading service accounts. Lastly it will automatically create the fclone config based on input entered. Just enter ```clone``` whenever you need to execute the script henceforth

![sample_pic](https://i.ibb.co/H4qHh1h/Screenshot-20210128-211947-2.jpg)
