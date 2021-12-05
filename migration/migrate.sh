#!/bin/bash

ssh ubuntu@163.43.120.164 <<EOC
source /home/ubuntu/.bashrc
cd /storage/mattermost/
sudo gsutil cp -r ./* gs://mitou-jr/mattermost-storage/
EOC