#!/bin/sh
set -e

export LC_ALL="en_US.UTF-8"
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
bundle exec rake setup
gem install travis-artifacts
