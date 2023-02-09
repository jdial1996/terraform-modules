#!/bin/bash

set -x 

sudo apt-get update && sudo apt-get install jq curl uuid-runtime -y 

cd /home/ubuntu 

curl -o actions-runner-linux-x64-2.301.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.301.1/actions-runner-linux-x64-2.301.1.tar.gz

tar xzf ./actions-runner-linux-x64-2.301.1.tar.gz

curl --request POST 'https://api.github.com/repos/${github_user}/${github_repo}/actions/runners/registration-token' --header "Authorization: token ${personal_access_token}" > output.txt 

sudo chown -R ubuntu:ubuntu .

runner_token=$(jq -r '.token' output.txt)

runner_id = $(uuidgen)

RUNNER_ALLOW_RUNASROOT="1" ./config.sh --url https://github.com/${github_user}/${github_repo} --token $runner_token --name runner-$runner_id --unattended --labels self-hosted,gpu 

sudo chown -R ubuntu:ubuntu

RUNNER_ALLOW_RUNASROOT="1" ./run.sh