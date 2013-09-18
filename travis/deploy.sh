#!/bin/sh
set -e

export LC_ALL="en_US.UTF-8"

bundle exec rake deploy
travis-artifacts upload --path Resilience/Build/Products/Release-iphoneos/*.ipa --path Resilience/Build/Products/Release-iphoneos/*.dSYM.zip