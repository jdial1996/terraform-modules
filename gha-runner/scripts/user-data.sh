#!/bin/bash

# Instsll jq to extract the runner token
sudo apt-get update && sudo apt-get install jq curl -y

# Create and move to the working directory 
cd /home/ubuntu 

mkdir actions-runner 

curl -o actions-runner-linux-x64-2.299.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.299.1/actions-runner-linux-x64-2.299.1.tar.gz

tar xzf ./actions-runner-linux-x64-2.299.1.tar.gz

    # PAT needs admin permissions for this to work 
curl --request POST 'https://api.github.com/repos/${github_user}/${github_repo}/actions/runners/registration-token' --header "Authorization: token ${personal_access_token}" > output.txt 

runner_token=$(jq -r '.token' output.txt) # command does not work properly, find alternative - cannot access output.txt due to permissions

./config.sh --url https://github.com/${github_user}/${github_repo} --token $runner_token --name "Github EC2 Runner" --unattended --labels self-hosted,gpu


./run.sh