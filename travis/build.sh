#!/bin/bash

export LC_ALL="en_US.UTF-8"

bundle exec rake debug:build
bundle exec rake debug:test
