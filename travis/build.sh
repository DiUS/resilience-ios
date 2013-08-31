#!/bin/bash

export LC_ALL="en_US.UTF-8"

bundle exec rake build
bundle exec rake test
