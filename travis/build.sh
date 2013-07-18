#!/bin/sh
set -e

bundle exec rake debug:build
bundle exec rake debug:test