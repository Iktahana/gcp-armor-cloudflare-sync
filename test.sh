#!/bin/bash

docker build -t armor-updater .

docker run -rm \
  -v ~/.config/gcloud:/root/.config/gcloud \
  armor-updater